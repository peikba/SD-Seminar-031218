table 50111 "CSD Seminar Registration Line"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 6 - Lab 1-5
    //     - Created new table
    Caption='Seminar Registration Line';

    fields
    {
        field(1;"Document No.";Code[20])
        {
            Caption='Document No.';
            TableRelation = "CSD Seminar Reg. Header";
        }
        field(2;"Line No.";Integer)
        {
            Caption='Line No.';
        }
        field(3;"Bill-to Customer No.";Code[20])
        {
            TableRelation = Customer;
            Caption='Bill-to Customer No.';

            trigger OnValidate();
            begin
                if "Bill-to Customer No." <> xRec."Bill-to Customer No." then begin
                  if Registered then begin
                    ERROR(RegisteredErrorTxt,
                      FieldCaption("Bill-to Customer No."),
                      FieldCaption(Registered),
                      Registered);
                  end;
                end;
            end;
        }
        field(4;"Participant Contact No.";Code[20])
        {
            TableRelation = Contact;
            Caption='Participant Contact No.';

            trigger OnLookup();
            begin
                ContactBusinessRelation.Reset;
                ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
                ContactBusinessRelation.SetRange("No.","Bill-to Customer No.");
                if ContactBusinessRelation.FindFirst then begin
                  Contact.SetRange("Company No.",ContactBusinessRelation."Contact No.");
                  if page.RunModal(page::"Contact List",Contact) = "Action"::LookupOK then 
                    "Participant Contact No." := Contact."No.";
                end;

                CalcFields("Participant Name");
            end;

            trigger OnValidate();
            begin
                if ("Bill-to Customer No." <> '') and
                   ("Participant Contact No." <> '')
                then begin
                  Contact.Get("Participant Contact No.");
                  ContactBusinessRelation.Reset;
                  ContactBusinessRelation.SetCurrentKey("Link to Table","No.");
                  ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."Link to Table"::Customer);
                  ContactBusinessRelation.SetRange("No.","Bill-to Customer No.");
                  if ContactBusinessRelation.FindFirst then begin
                    if ContactBusinessRelation."Contact No." <> Contact."Company No." then begin
                      ERROR(WrongContactErrorTxt,Contact."No.",Contact.Name,"Bill-to Customer No.");
                    end;
                  end;
                end;
            end;
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

            trigger OnValidate();
            begin
                VALIDATE("Line Discount %");
            end;
        }
        field(11;"Line Discount %";Decimal)
        {
            Caption='Line Discount %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                if "Seminar Price" = 0 then begin
                  "Line Discount Amount" := 0;
                end else begin
                  GLSetup.Get;
                  "Line Discount Amount" := Round("Line Discount %" * "Seminar Price" * 0.01,GLSetup."Amount Rounding Precision");
                end;
                UpdateAmount;
            end;
        }
        field(12;"Line Discount Amount";Decimal)
        {
            Caption='Line Discount Amount';
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                if "Seminar Price" = 0 then begin
                  "Line Discount %" := 0;
                end else begin
                  GLSetup.Get;
                  "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100,GLSetup."Amount Rounding Precision");
                end;
                UpdateAmount;
            end;
        }
        field(13;Amount;Decimal)
        {
            Caption='Amount';
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                TestField("Bill-to Customer No.");
                TestField("Seminar Price");
                GLSetup.Get;
                Amount := Round(Amount,GLSetup."Amount Rounding Precision");
                "Line Discount Amount" := "Seminar Price" - Amount;
                if "Seminar Price" = 0 then begin
                  "Line Discount %" := 0;
                end else begin
                  "Line Discount %" := Round("Line Discount Amount" / "Seminar Price" * 100,GLSetup."Amount Rounding Precision");
                end;
            end;
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

    trigger OnDelete();
    begin
        TestField(Registered,false);
    end;

    trigger OnInsert();
    begin
        GetSeminarRegHeader;
        "Registration Date" := WorkDate;
        "Seminar Price" := SeminarRegHeader."Seminar Price";
        Amount := SeminarRegHeader."Seminar Price";
    end;

    var
        SeminarRegHeader : Record "CSD Seminar Reg. Header";
        SeminarRegLine : Record "CSD Seminar Registration Line";
        ContactBusinessRelation : Record "Contact Business Relation";
        Contact : Record Contact;
        GLSetup : Record "General Ledger Setup";
        SkipBillToContact : Boolean;
        RegisteredErrorTxt : Label 'You cannot change the %1, because %2 is %3.';
        WrongContactErrorTxt : Label 'Contact %1 %2 is related to a different company than customer %3.';

    local procedure GetSeminarRegHeader();
    begin
        if SeminarRegHeader."No." <> "Document No." then 
          SeminarRegHeader.Get("Document No.");
    end;

    local procedure CalculateAmount();
    begin
        Amount := Round(("Seminar Price" / 100) * (100 - "Line Discount %"));
    end;

    local procedure UpdateAmount();
    begin
        GLSetup.Get;
        Amount := Round("Seminar Price" - "Line Discount Amount",GLSetup."Amount Rounding Precision");
    end;
}

