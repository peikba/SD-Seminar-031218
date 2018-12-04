page 50141 "My Seminars"
// CSD1.00 - 2018-01-01 - D. E. Veloper
//   Chapter 10 - Lab 1 - 4
//     - Created new page
{
    PageType = Listpart;
    SourceTable = "My Seminars";
    Caption='My Seminars';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Seminar No.";"Seminar No.")
                {
                }
                field(Name;Seminar.Name)
                {
                }
                field(Duration;Seminar."Seminar Duration")
                {
                }
                field(Price;Seminar."Seminar Price")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                trigger OnAction();
                begin
                    OpenSeminarCard;
                end;
            }
        }
    }
    
    var
        Seminar : Record "CSD Seminar";

    trigger OnOpenPage();
    begin
        SetRange("User Id",UserId);
    end;

    trigger OnAfterGetRecord();
    begin
        if Seminar.get("Seminar No.") then;
    end;

    trigger OnNewRecord(BelowxRec : Boolean);
    begin
        Clear(Seminar);
    end;

    local procedure OpenSeminarCard();
    begin
        if Seminar."No."<>'' then
          Page.Run(Page::"CSD Seminar Card",Seminar );
    end;
}