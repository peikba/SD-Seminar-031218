table 50133 "CSD Seminar Register"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 1
    //     - Created new table

    Caption = 'Seminar Register';

    fields
    {
        field(1;"No.";Integer)
        {
            Caption = 'No.';
        }
        field(2;"From Entry No.";Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "CSD Seminar Ledger Entry";
        }
        field(3;"To Entry No.";Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "CSD Seminar Ledger Entry";
        }
        field(4;"Creation Date";Date)
        {
            Caption = 'Creation Date';
        }
        field(5;"Source Code";Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(6;"User ID";Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup();
            var
                UserMgt : Codeunit "User Management";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }

        field(7;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;"Creation Date")
        {
        }
        key(Key3;"Source Code","Creation Date")
        {
        }
    }

    fieldgroups
    {
    }
}

