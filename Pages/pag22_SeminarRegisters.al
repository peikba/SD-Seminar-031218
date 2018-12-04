page 50122 "CSD Seminar Registers"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-11
{
    PageType = List;
    SourceTable = "CSD Seminar Register";
    Caption='Seminar Registers';
    Editable=false;
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field("Creation Date";"Creation Date")
                {
                }
                field("User ID";"User ID")
                {
                }
                field("Source Code";"Source Code")
                {
                }
                field("Journal Batch Name";"Journal Batch Name")
                {
                }
                field("From Entry No.";"From Entry No.")
                {
                }
                field("To Entry No.";"To Entry No.")
                {
                }
            }
        }
        area(factboxes)
        {
        }
    }

    actions
    {
        area(Navigation)
        {
            action("Seminar Ledgers")
            {
                Image=WarrantyLedger;
                RunObject=codeunit "CSD SeminarRegShowLedger";
            }
        }
    }
}
