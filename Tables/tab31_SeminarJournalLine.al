table 50131 "CSD Seminar Journal Line"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 1 - 2
    //     - Created new table

    Caption = 'Seminar Journal Line';

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate();
            begin
                Validate("Document Date", "Posting Date");
            end;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(6; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Registration,Cancelation';
            OptionMembers = Registration,Cancelation;
        }
        field(7; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(8; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = Customer;
        }
        field(11; "Charge Type"; Option)
        {
            Caption = 'Charge Type';
            OptionCaption = 'Instructor,Room,Participant,Charge';
            OptionMembers = Instructor,Room,Participant,Charge;
        }
        field(12; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Resource,G/L Account';
            OptionMembers = Resource,"G/L Account";
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(14; "Unit Price"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Price';
        }
        field(15; "Total Price"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total Price';
        }
        field(16; "Participant Contact No."; Code[20])
        {
            Caption = 'Participant Contact No.';
            TableRelation = Contact;
        }
        field(17; "Participant Name"; Text[50])
        {
            Caption = 'Participant Name';
        }
        field(18; Chargeable; Boolean)
        {
            Caption = 'Chargeable';
            InitValue = true;
        }
        field(19; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where (Type = const (Machine));
        }
        field(20; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            TableRelation = Resource where (Type = const (Person));
        }
        field(21; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(22; "Seminar Registration No."; Code[20])
        {
            Caption = 'Seminar Registration No.';
        }
        field(23; "Res. Ledger Entry No."; Integer)
        {
            Caption = 'Res. Ledger Entry No.';
            TableRelation = "Res. Ledger Entry";
        }
        field(30; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Seminar';
            OptionMembers = " ",Seminar;
        }
        field(31; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = if ("Source Type" = const (Seminar)) "CSD Seminar";
        }
        field(32; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(33; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            Editable = false;
            TableRelation = "Source Code";
        }
        field(34; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(35; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
        }
    }

    procedure EmptyLine(): Boolean;
    begin
        exit(("Seminar No." = '') and (Quantity = 0));
    end;
}

