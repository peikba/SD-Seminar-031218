table 50121  "CSD Posted Seminar Charge"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 3-4
    //     - Created new table
    Caption='Seminar Charge';

    fields
    {
        field(1;"Document No.";Code[20])
        {
            Caption='Document No.';
            NotBlank = true;
            TableRelation =  "CSD Posted Seminar Reg. Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption='Line No.';
        }
        field(3;Type;Option)
        {
            Caption='Type';
            OptionCaption = 'Resource,G/L Account';
            OptionMembers = Resource,"G/L Account";
        }
        field(4;"No.";Code[20])
        {
            Caption='No.';
            TableRelation = if (Type=const(Resource)) Resource."No."
                            else if (Type=const("G/L Account")) "G/L Account"."No.";
        }
        field(5;Description;Text[50])
        {
            Caption='Description';
        }
        field(6;Quantity;Decimal)
        {
            Caption='Quantity';
            DecimalPlaces = 0:5;
        }
        field(7;"Unit Price";Decimal)
        {
            Caption='Unit Price';
            AutoFormatType = 2;
            MinValue = 0;
        }
        field(8;"Total Price";Decimal)
        {
            Caption='Total Price';
            AutoFormatType = 1;
            Editable = false;
        }
        field(9;"To Invoice";Boolean)
        {
            Caption='To Invoice';
            InitValue = true;
        }
        field(10;"Bill-to Customer No.";Code[20])
        {
            Caption='Bill-to Customer No.';
            TableRelation = Customer."No.";
        }
        field(11;"Unit of Measure Code";Code[10])
        {
            Caption='Unit of Measure Code';
            TableRelation = if (Type=const(Resource)) "Resource Unit of Measure".Code where ("Resource No."=Field("No."))
                            else "Unit of Measure".Code;
        }
        field(12;"Gen. Prod. Posting Group";Code[10])
        {
            Caption='Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(13;"VAT Prod. Posting Group";Code[10])
        {
            Caption='VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(14;"Qty. per Unit of Measure";Decimal)
        {
            Caption='Qty. per Unit of Measure';
        }
        field(15;Registered;Boolean)
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

    fieldgroups
    {
    }
}

