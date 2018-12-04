table 50119  "CSD Posted Seminar Reg. Line"
{
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 3-3
    Caption='Posted Seminar Reg. Line';

    fields
    {
        field(1;"Document No.";Code[20])
        {
            Caption='Document No.';
            TableRelation =  "CSD Posted Seminar Reg. Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption='Line No.';
        }
        field(3;"Bill-to Customer No.";Code[20])
        {
            TableRelation = Customer;
            Caption='Bill-to Customer No.';
        }
        field(4;"Participant Contact No.";Code[20])
        {
            TableRelation = Contact;
            Caption='Participant Contact No.';
        }
        field(5;"Participant Name";Text[50])
        {
            Caption='Participant Name';
            CalcFormula = Lookup(Contact.Name where ("No."=Field("Participant Contact No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Registration Date";Date)
        {
            Caption='Registration Date';
            Editable = false;
        }
        field(7;"To Invoice";Boolean)
        {
            Caption='To Invoice';
            InitValue = true;
        }
        field(8;Participated;Boolean)
        {
            Caption='Participated';
        }
        field(9;"Confirmation Date";Date)
        {
            Caption='Confirmation Date';
            Editable = false;
        }
        field(10;"Seminar Price";Decimal)
        {
            Caption='Seminar Price';
            AutoFormatType = 2;
        }
        field(11;"Line Discount %";Decimal)
        {
            Caption='Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(12;"Line Discount Amount";Decimal)
        {
            Caption='Line Discount Amount';
            AutoFormatType = 1;
        }
        field(13;Amount;Decimal)
        {
            Caption='Amount';
            AutoFormatType = 1;
        }
        field(14;Registered;Boolean)
        {
            Caption='Registered';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
        }
    }
}

