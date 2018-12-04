page 50121 "CSD Seminar Ledger Entries"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-9
//   Chapter 8 - Lab 2 - 4
//   Added Action Navigate
{
    Caption='Seminar Ledger Entries';
    PageType = List;
    SourceTable = "CSD Seminar Ledger Entry";
    Editable=false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date";"Posting Date")
                {
                }
                field("Document No.";"Document No.")
                {
                }
                field("Document Date";"Document Date")
                {
                    Visible=false;
                }
                field("Entry Type";"Entry Type")
                {
                }
                field("Seminar No.";"Seminar No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                }
                field("Charge Type";"Charge Type")
                {
                }
                field(Type;Type)
                {
                }
                field(Quantity;Quantity)
                {
                }
                field("Unit Price";"Unit Price")
                {
                }
                field("Total Price";"Total Price")
                {
                }
                field(Chargeable;Chargeable)
                {
                }
                field("Participant Contact No.";"Participant Contact No.")
                {
                }
                field("Participant Name";"Participant Name")
                {
                }
                field("Instructor Resource No.";"Instructor Resource No.")
                {
                }
                field("Room Resource No.";"Room Resource No.")
                {
                }
                field("Starting Date";"Starting Date")
                {
                }
                field("Seminar Registration No.";"Seminar Registration No.")
                {
                }
                field("Entry No.";"Entry No.")
                {     
                }
            }
        }
        area(factboxes)
        {
            systempart("Notes";Notes)
            {
            }
            systempart("links";Links)
            {
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("&Navigate")
            {
                Caption='&Navigate';
                Image=Navigate;
                Promoted=true;
                PromotedCategory=Process;

                trigger OnAction();
                var
                    Navigate : page Navigate;
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.RUN;
                end;
            }
        }
    }
}
