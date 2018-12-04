codeunit 50135 "Import FloatRate Rest"
{
    trigger OnRun();
    begin
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClient.Get('http://www.floatrates.com/daily/dkk.json', ResponseMessage) then
            Error('The call to the web service failed.');
        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\\' + 'Status code: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
        ResponseMessage.Content.ReadAs(JsonText);
        JsonText := '[' + JsonText + ']';
        if not JsonArray.ReadFrom(JsonText) then
            Error('Invalid response, expected an JSON array as root object');
        foreach jsonToken in JsonArray do
        begin
            JsonObject := JsonToken.AsObject;
            if Currency.findset then repeat
                InsertCurrencyRate(Currency.Code);
            until Currency.Next=0;
        end;
        page.run(0,CurrencyRate);
    end;

    local procedure InsertCurrencyRate(inCurrencyCode: Code[10]);
    var
        TokenName : Text[50];
        LowerCurrCode : Text[10];

    begin
        CurrencyRate.init;
        LowerCurrCode:=LowerCase(inCurrencyCode);
        if not JsonObject.Get(LowerCurrCode, JsonToken) then
            exit;
        TokenName:='$.' + LowerCurrCode + '.code';
        CurrencyRate."Currency Code" := format(SelectJsonToken(JsonObject,TokenName));
        CurrencyRate."Exchange Rate Amount" := 100;
        TokenName:='$.' + LowerCurrCode + '.inverseRate';
        evaluate(InvExchRate, format(SelectJsonToken(JsonObject, TokenName)));
        CurrencyRate."Relational Exch. Rate Amount" := InvExchRate;
        TokenName:='$.' + LowerCurrCode + '.date';
        CurrencyRate."Starting Date" := ConvertDate(format(SelectJsonToken(JsonObject, TokenName)));
        if CurrencyRate.Insert then;
    end;

    procedure SelectJsonToken(JsonObject: JsonObject; Path: text) JsonToken: JsonToken
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            Error('Could not find a token with path %1', Path);
    end;

    procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then
            Error('Could not find a token with key %1', TokenKey);
    end;

    local procedure ConvertDate(inDateTxt: Text[50]): Date;
    var
        DayTxt: Text[10];
        MonthTxt: Text[10];
        YearTxt: Text[10];
        DayNo: Integer;
        MonthNo: Integer;
        YearNo: Integer;
        DateTxt: Text[50];

    begin
        //date":"Thu, 27 Sep 2018 00:00:01
        DateTxt := copystr(inDateTxt, strpos(inDateTxt, ',') + 1);
        DateTxt := DelChr(DateTxt, '<', ' ');
        DayTxt := CopyStr(DateTxt, 1, StrPos(DateTxt, ' '));
        DateTxt := copystr(DateTxt, strpos(DateTxt, ' ') + 1);
        MonthTxt := CopyStr(DateTxt, 1, StrPos(DateTxt, ' '));
        DateTxt := copystr(DateTxt, strpos(DateTxt, ' ') + 1);
        YearTxt := CopyStr(DateTxt, 1, StrPos(DateTxt, ' '));
        evaluate(DayNo, DayTxt);
        evaluate(YearNo, YearTxt);
        case lowercase(delchr(MonthTxt, '=', ' ')) of
            'jan' : MonthNo := 1;
            'feb' : MonthNo := 2;
            'mar' : MonthNo := 3;
            'apr' : MonthNo := 4;
            'may' : MonthNo := 5;
            'jun' : MonthNo := 6;
            'jul' : MonthNo := 7;
            'aug' : MonthNo := 8;
            'sep' : MonthNo := 9;
            'oct' : MonthNo := 10;
            'nov' : MonthNo := 11;
            'dec' : MonthNo := 12;
        end;
        exit(DMY2Date(DayNo, MonthNo, YearNo));
    end;

    var
        HttpClient: HttpClient;
        ResponseMessage: HttpResponseMessage;
        JsonToken: JsonToken;
        JsonValue: JsonValue;
        JsonObject: JsonObject;
        JsonArray: JsonArray;
        JsonText: text;
        CurrencyRate: Record "Currency Exchange Rate" temporary;
        Currency : Record Currency;
        InvExchRate: Decimal;
}