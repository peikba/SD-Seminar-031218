page 50101 "CSD Seminar Card"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 5 - Lab 2-4 & Lab 2-5
// Chapter 8 - Lab 1-2
// - Added Action
{
    PageType = Card;
    SourceTable = "CSD Seminar";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    AssistEdit=true;
                    trigger OnAssistEdit();
                    begin
                        if AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(Name; Name)
                {
                }
                field("Search Name"; "Search Name")
                {
                }
                field("Seminar Duration";"Seminar Duration")
                {
                }
                field("Minimum Participants"; "Minimum Participants")
                {
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
            }
            group(Invoicing)
            {
                field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
                {
                }
                field("VAT Prod. Posting Group"; "VAT Prod. Posting Group")
                {
                }
                field("Seminar Price"; "Seminar Price")
                {
                }
            }
        }
        area(FactBoxes)
        {
            systempart("Links"; Links)
            {
            }
            systempart("Notes"; Notes)
            {
            }
        }

    }

    actions
    {
        area(Navigation)
        {
            group("&Seminar")
            {
                action("Co&mments")
                {
                    Caption='Co&mments';
                    RunObject=page "CSD Seminar Comment Sheet";
                    RunPageLink = "Table Name"=const(Seminar),"No."=field("No.");
                    Image = Comment;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                }
                // >> Lab 8-2
                action("Ledger Entries")
                {
                    Caption='Ledger Entries';
                    RunObject=page "CSD Seminar Ledger Entries";
                    RunPageLink="Seminar No."=field("No.");
                    Promoted=true;
                    PromotedCategory=Process;
                    ShortcutKey="Ctrl+F7";
                    Image=WarrantyLedger;
                }
                // >> Lab 8-2
                action("&Registrations")
                {
                    Caption='&Registrations';
                    RunObject=page "CSD Seminar Registration List";
                    RunPageLink="Seminar No."=field("No.");
                    Image=Timesheet;
                    Promoted=true;
                    PromotedCategory=Process;
                }
                // << Lab 8-2
            }
        }
        // >> Lab 8-2
        area(Processing)
        {
            action("Seminar Registration")
            {
                Caption='Seminar Registration';
                RunObject= page "CSD Seminar Registration";
                RunPageLink="Seminar No."=field("No.");
                RunPageMode=Create;
                Image=NewTimesheet;
                Promoted=true;
                PromotedCategory=New;

            }
        }
        // << Lab 8-2
    }
}
