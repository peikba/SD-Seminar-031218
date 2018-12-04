pageextension 50138 "CSD Extend Item Card" extends "Item Card"
{
    actions
    {
        addlast(Approval)
        {
            action(DownloadPicture)
            {
                Caption = 'Download Picture';
                Image = Picture;
                trigger OnAction()
                var
                    TempBlob: Record TempBlob temporary;
                    InStr: InStream;
                begin
                    DownloadPicture('http://ba-consult.dk/downloads/bicycle.jpg', TempBlob);
                    TempBlob.Blob.CreateInStream(InStr);
                    rec.Picture.ImportStream(InStr, 'Default image');
                    CurrPage.Update(true);
                end;
            }
            action("Test Soap")
            {
                Image = ImportCodes;
                RunObject = codeunit "Import FloatRate Soap";
            }
            action("Test Rest")
            {
                Image = ImportDatabase;
                RunObject = codeunit "Import FloatRate Rest";
            }
        }
    }

    procedure DownloadPicture(Url: Text; var TempBlob: Record TempBlob temporary)
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        InStr: InStream;
        OutStr: OutStream;
    begin
        Client.Get(Url, Response);
        Response.Content.ReadAs(InStr);
        TempBlob.Blob.CreateOutStream(OutStr);
        CopyStream(OutStr, InStr);
    end;
}
