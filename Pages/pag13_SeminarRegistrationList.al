page 50113 "CSD Seminar Registration List"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 6 - Lab 3
    //     - Created new page
    //   Chapter 7 - Lab 5-8
    //     - Added Post Action 
    //   Chapter 9 - Lab 5-8
    //     - Added Post Acti

    Caption = 'Seminar Registration List';
    CardPageID = "CSD Seminar Registration";
    Editable = false;
    PageType = List;
    SourceTable = "CSD Seminar Reg. Header";
    UsageCategory = lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Starting Date"; "Starting Date")
                {
                }
                field("Seminar No."; "Seminar No.")
                {
                }
                field("Seminar Name"; "Seminar Name")
                {
                }
                field(Status; Status)
                {
                }
                field(Duration; Duration)
                {
                }
                field("Maximum Participants"; "Maximum Participants")
                {
                }
                field("Room Resource No."; "Room Resource No.")
                {
                }
            }
        }
        area(factboxes)
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
        area(navigation)
        {
            group("&Seminar Registration")
            {
                Caption = '&Seminar Registration';
                action("Co&mments")
                {
                    Caption = 'Co&mments';
                    Image = Comment;
                    RunObject = Page 50106;
                    RunPageLink = "No." = Field ("No.");
                    RunPageView = where ("Table Name" = const("Seminar Registration"));
                }
                action("&Charges")
                {
                    Caption = '&Charges';
                    Image = Costs;
                    RunObject = Page 50124;
                    RunPageLink = "Document No." = Field ("No.");
                }
                action("&Post")
                {
                    Caption = '&Post';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    ShortcutKey = F9;
                    RunObject = codeunit "CSD Seminar-Post (Yes/No)";
                }
                action("&Print")
                {
                    Caption = '&Print';
                    Image = Print;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction();
                    var
                        SeminarReportSelection: Record "CSD Seminar Report Selections";
                    begin
                        SeminarReportSelection.PrintReportSelection(SeminarReportSelection.Usage::Registration, Rec);
                    end;
                }
            }
        }
    }
}

