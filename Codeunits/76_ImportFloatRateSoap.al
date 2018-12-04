codeunit 50136 "Import FloatRate Soap"
{
    trigger OnRun();
    begin
        HttpClient.DefaultRequestHeaders.Add('User-Agent', 'Dynamics 365');
        if not HttpClient.Get('http://www.floatrates.com/daily/dkk.xml', ResponseMessage) then
            Error('The call to the web service failed.');
        if not ResponseMessage.IsSuccessStatusCode then
            error('The web service returned an error message:\\' + 'Status code: %1\' + 'Description: %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
        ResponseMessage.Content.ReadAs(XMLText);
        XMLoptions.PreserveWhitespace := true;
        XmlDocument.ReadFrom(xmlText, XMLoptions, XMLDoc);
        IF XmlDoc.SelectNodes('//channel/item', XmlNodeList) then begin
            foreach XmlNode in XmlNodeList do begin
                if XmlNode.SelectSingleNode('pubDate', XmlNode) then
                    CurrencyRate."Starting Date" := ConvertDate(XmlNode.AsXmlElement.InnerText);

                if XmlNode.SelectSingleNode('../targetCurrency', XmlNode) then
                    CurrencyRate."Currency Code" := XmlNode.AsXmlElement.InnerText;

                if XmlNode.SelectSingleNode('../inverseRate', XmlNode) then begin
                    evaluate(InvExchRate, XmlNode.AsXmlElement.InnerText);
                    CurrencyRate."Relational Exch. Rate Amount" := InvExchRate * 100;
                end;

                if (CurrencyRate."Relational Exch. Rate Amount" <> 0) and
                (CurrencyRate."Currency Code" <> '') and
                (CurrencyRate."Starting Date" <> 0D) and
                (CurrencyRate."Currency Code" <> OldCurrency) then begin
                    OldCurrency := CurrencyRate."Currency Code";
                    CurrencyRate."Exchange Rate Amount" := 100;
                    CurrencyRate.Insert;
                    CurrencyRate.init;
                end;
            end;
        end;
        page.run(0, CurrencyRate);
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
            'jan':
                MonthNo := 1;
            'feb':
                MonthNo := 2;
            'mar':
                MonthNo := 3;
            'apr':
                MonthNo := 4;
            'may':
                MonthNo := 5;
            'jun':
                MonthNo := 6;
            'jul':
                MonthNo := 7;
            'aug':
                MonthNo := 8;
            'sep':
                MonthNo := 9;
            'oct':
                MonthNo := 10;
            'nov':
                MonthNo := 11;
            'dec':
                MonthNo := 12;
        end;
        exit(DMY2Date(DayNo, MonthNo, YearNo));
    end;

    var
        HttpClient: HttpClient;
        Content: HttpContent;
        ResponseMessage: HttpResponseMessage;
        XMLText: text;
        XMLElement: XmlElement;
        XMLNode: XmlNode;
        XmlNodeList: XMLNodeList;
        XMLoptions: XmlReadOptions;
        CurrencyRate: Record "Currency Exchange Rate" temporary;
        Currency: Record Currency;
        InvExchRate: Decimal;
        XmlText2: XmlText;
        Result: Text;
        XMLDoc: XmlDocument;
        OldCurrency: Code[10];
}