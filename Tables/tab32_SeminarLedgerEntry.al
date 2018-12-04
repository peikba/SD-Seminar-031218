table 50132 "CSD Seminar Ledger Entry"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 1 - 3
    //     - Created new table

    Caption = 'Seminar Ledger Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";
        }
        field(3; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(4; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(5; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Registration,Cancelation';
            OptionMembers = Registration,Cancelation;
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(8; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(9; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionCaption = 'Instructor,Room,Participant,Charge';
            OptionMembers = Instructor,Room,Participant,Charge;
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,G/L Account';
            OptionMembers = Resource,"G/L Account";
        }
        field(11; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(12; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(13; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(14; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(15; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(16; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(17; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where (Type = const (Machine));
        }
        field(18; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            TableRelation = Resource where (Type = const (Person));
        }
        field(19; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(20; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(21; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            TableRelation = "Res. Ledger Entry";
        }
        field(22; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Seminar';
            OptionMembers = " ",Seminar;
        }
        field(23; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const (Seminar)) "CSD Seminar";
        }
        field(24; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(25; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(26; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(27; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(28; "User Id"; code[50])
        {
            TableRelation = user where ("User Name" = field ("User Id"));
            ValidateTableRelation = false;
            trigger OnLookup();
            var
                UserMgt: Codeunit "User Management";
            begin
                usermgt.LookupUserID("User Id");
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

