table 50110 "CSD Seminar Reg. Header"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 6 - Lab 1-3 & Lab 1-4
    //     - Created new table
    //   Chapter 8 - Lab 2-3
    //     - Added LookupId and DrillDownPageId
    Caption = 'Seminar Registration Header';
    LookupPageId= "CSD Posted Seminar Reg. List";
    DrillDownPageId= "CSD Posted Seminar Reg. List";

    Fields
    {
        Field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.Get;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Registration Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        Field(2; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate();
            begin
                if "Starting Date" <> xRec."Starting Date" then
                    TestField(Status, Status::Planning);
            end;
        }
        Field(3; "Seminar No."; Code[20])
        {
            Caption = 'Seminar No.';
            TableRelation = "CSD Seminar";

            trigger OnValidate();
            begin
                if "Seminar No." <> xRec."Seminar No." then begin
                    SeminarRegLine.Reset;
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, true);
                    if not SeminarRegLine.IsEmpty then
                        ERROR(
                      Text002,
                      FieldCaption("Seminar No."),
                      SeminarRegLine.TableCaption,
                      SeminarRegLine.FieldCaption(Registered),
                      true);

                    Seminar.Get("Seminar No.");
                    Seminar.TestField(Blocked, false);
                    Seminar.TestField("Gen. Prod. Posting Group");
                    Seminar.TestField("VAT Prod. Posting Group");
                    "Seminar Name" := Seminar.Name;
                    "Duration" := Seminar."Seminar Duration";
                    "Seminar Price" := Seminar."Seminar Price";
                    "Gen. Prod. Posting Group" := Seminar."Gen. Prod. Posting Group";
                    "VAT Prod. Posting Group" := Seminar."VAT Prod. Posting Group";
                    "Minimum Participants" := Seminar."Minimum Participants";
                    "Maximum Participants" := Seminar."Maximum Participants";
                end;
            end;
        }
        Field(4; "Seminar Name"; Text[50])
        {
            Caption = 'Seminar Name';
        }
        Field(5; "Instructor Resource No."; Code[20])
        {
            Caption = 'Instructor Resource No.';
            TableRelation = Resource where (Type = const (Person));

            trigger OnValidate();
            begin
                CALCFieldS("Instructor Name");
            end;
        }
        Field(6; "Instructor Name"; Text[50])
        {
            Caption = 'Instructor Name';
            CalcFormula = Lookup (Resource.Name where ("No." = Field ("Instructor Resource No."),
                                                      Type = const (Person)));
            Editable = false;
            FieldClass = FlowField;
        }
        Field(7; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Planning,Registration,Closed,Canceled';
            OptionMembers = Planning, Registration, Closed, Canceled;
        }
        Field(8; Duration; Decimal)
        {
            Caption = 'Duration';
            DecimalPlaces = 0 : 1;
        }
        Field(9; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
        }
        Field(10; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
        }
        Field(11; "Room Resource No."; Code[20])
        {
            Caption = 'Room Resource No.';
            TableRelation = Resource where (Type = const (Machine));

            trigger OnValidate();
            begin
                if "Room Resource No." = '' then begin
                    "Room Name" := '';
                    "Room Address" := '';
                    "Room Address 2" := '';
                    "Room Post Code" := '';
                    "Room City" := '';
                    "Room County" := '';
                    "Room Country/Reg. Code" := '';
                end else begin
                    SeminarRoom.Get("Room Resource No.");
                    "Room Name" := SeminarRoom.Name;
                    "Room Address" := SeminarRoom.Address;
                    "Room Address 2" := SeminarRoom."Address 2";
                    "Room Post Code" := SeminarRoom."Post Code";
                    "Room City" := SeminarRoom.City;
                    "Room County" := SeminarRoom.County;
                    "Room Country/Reg. Code" := SeminarRoom."Country/Region Code";

                    if(CurrFieldNo <> 0) then begin
                        if(SeminarRoom."CSD Maximum Participants" <> 0) and
                           (SeminarRoom."CSD Maximum Participants" < "Maximum Participants")
                        then begin
                            if Confirm(Text004, true,
                               "Maximum Participants",
                               SeminarRoom."CSD Maximum Participants",
                               FieldCaption("Maximum Participants"),
                               "Maximum Participants",
                               SeminarRoom."CSD Maximum Participants")
                          then
                                "Maximum Participants" := SeminarRoom."CSD Maximum Participants";
                        end;
                    end;
                end;
            end;
        }
        Field(12; "Room Name"; Text[30])
        {
            Caption = 'Room Name';
        }
        Field(13; "Room Address"; Text[30])
        {
            Caption = 'Room Address';
        }
        Field(14; "Room Address 2"; Text[30])
        {
            Caption = 'Room Address 2';
        }
        Field(15; "Room Post Code"; Code[20])
        {
            Caption = 'Room Post Code';
            TableRelation = "Post Code".Code;
            ValidateTableRelation = false;

            trigger OnValidate();
            begin
                PostCode.ValidatePostCode("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        Field(16; "Room City"; Text[30])
        {
            Caption = 'Room City';

            trigger OnValidate();
            begin
                PostCode.ValidateCity("Room City", "Room Post Code", "Room County", "Room Country/Reg. Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        Field(17; "Room Country/Reg. Code"; Code[10])
        {
            Caption = 'Room Country/Reg. Code';
            TableRelation = "Country/Region";
        }
        Field(18; "Room County"; Text[30])
        {
            Caption = 'Room County';
        }
        Field(19; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;

            trigger OnValidate();
            begin
                if("Seminar Price" <> xRec."Seminar Price") and
                   (Status <> Status::Canceled)
                then begin
                    SeminarRegLine.Reset;
                    SeminarRegLine.SetRange("Document No.", "No.");
                    SeminarRegLine.SetRange(Registered, false);
                    if SeminarRegLine.FindSet(false, false) then
                        if Confirm(Text005, false,
                             FieldCaption("Seminar Price"),
                             SeminarRegLine.TableCaption)
                        then begin
                            repeat
                            SeminarRegLine.VALIDATE("Seminar Price", "Seminar Price");
                            SeminarRegLine.MODifY;
                            until SeminarRegLine.NEXT = 0;
                            MODifY;
                        end;
                end;
            end;
        }
        Field(20; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        Field(21; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        Field(22; Comment; Boolean)
        {
            Caption = 'Comment';
            CalcFormula = Exist ("CSD Seminar Comment Line" where ("Table Name" = const("Seminar Registration"),
                                                              "No." = Field ("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        Field(23; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        Field(24; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        Field(25; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code".Code;
        }
        Field(26; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series".Code;
        }
        Field(27; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series".Code;

            trigger OnLookup();
            begin
                with SeminarRegHeader do
                begin
                    SeminarRegHeader := Rec;
                    SeminarSetup.Get;
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    if NoSeriesMgt.LookupSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series")
                    then begin
                        VALIDATE("Posting No. Series");
                    end;
                    Rec := SeminarRegHeader;
                end;
            end;

            trigger OnValidate();
            begin
                if "Posting No. Series" <> '' then begin
                    SeminarSetup.Get;
                    SeminarSetup.TestField("Seminar Registration Nos.");
                    SeminarSetup.TestField("Posted Seminar Reg. Nos.");
                    NoSeriesMgt.TestSeries(SeminarSetup."Posted Seminar Reg. Nos.", "Posting No. Series");
                end;
                TestField("Posting No.", '');
            end;
        }
        Field(28; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
    }

    keys
    {
        key(PK; "No.")
        {
        }
        key(Key2; "Room Resource No.")
        {
            SumIndexFields = Duration;
        }
    }

    var
        PostCode: Record "Post Code";
        Seminar: Record "CSD Seminar";
        SeminarCommentLine: Record "CSD Seminar Comment Line";
        SeminarCharge: Record "CSD Seminar Charge";
        SeminarRegHeader: Record "CSD Seminar Reg. Header";
        SeminarRegLine: Record "CSD Seminar Registration Line";
        SeminarRoom: Record Resource;
        SeminarSetup: Record "CSD Seminar Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001 : Label 'You cannot delete the Seminar Registration, because there is at least one %1 where %2=%3.';
        Text002 : Label 'You cannot change the %1, because there is at least one %2 with %3=%4.';
        Text004: Label 'This Seminar is for %1 participants. \The selected Room has a maximum of %2 participants \Do you want to change %3 for the Seminar from %4 to %5?';
        Text005: Label 'Should the new %1 be copied to all %2 that are not yet invoiced?';
        Text006: Label 'You cannot delete the Seminar Registration, because there is at least one %1.';

    trigger OnDelete();
    begin
        if (CurrFieldNo>0) then 
          TestField(Status,Status::Canceled);
        SeminarRegLine.Reset;
        SeminarRegLine.SetRange("Document No.", "No.");
        SeminarRegLine.SetRange(Registered, true);
        if SeminarRegLine.Find('-') then
            ERROR(
            Text001,
            SeminarRegLine.TableCaption,
            SeminarRegLine.FieldCaption(Registered),
            true);
        SeminarRegLine.SetRange(Registered);
        SeminarRegLine.deleteALL(true);

        SeminarCharge.Reset;
        SeminarCharge.SetRange("Document No.", "No.");
        if not SeminarCharge.IsEmpty then
            ERROR(Text006, SeminarCharge.TableCaption);

        SeminarCommentLine.Reset;
        SeminarCommentLine.SetRange("Table Name", SeminarCommentLine."Table Name"::"Seminar Registration");
        SeminarCommentLine.SetRange("No.", "No.");
        SeminarCommentLine.deleteALL;
    end;

    trigger OnInsert();
    begin
        if "No." = '' then begin
            SeminarSetup.Get;
            SeminarSetup.TestField("Seminar Registration Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Registration Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        initrecord;
        // >> Lab 8-1
        if GetFilter("Seminar No.") <>'' then
            if GetRangeMin("Seminar No.") = GetRangeMax("Seminar No.") then
                Validate("Seminar No.",GetRangeMin("Seminar No."));
        // << Lab 8-1
    end;

    local procedure InitRecord();
    begin
        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;
        "Document Date" := WorkDate;
        SeminarSetup.Get;
        NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeminarSetup."Posted Seminar Reg. Nos.");
    end;

    procedure AssistEdit(OldSeminarRegHeader: Record "CSD Seminar Reg. Header"): Boolean;
    begin
        with SeminarRegHeader do
        begin
            SeminarRegHeader := Rec;
            SeminarSetup.Get;
            SeminarSetup.TestField("Seminar Registration Nos.");
            if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Registration Nos.", OldSeminarRegHeader."No. Series", "No. Series") then begin
                SeminarSetup.Get;
                SeminarSetup.TestField("Seminar Registration Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := SeminarRegHeader;
                exit(true);
            end;
        end;
    end;
}

