codeunit 50100 "CSD Seminar-Post"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 7 - Lab 5-2
    //     - Created new codeunit

    TableNo = 50110;

    trigger OnRun();
    begin
        ClearAll;
        SeminarRegHeader := Rec;
        with SeminarRegHeader do begin
            TestField("Posting Date"); 
            TestField("Document Date"); 
            TestField("Seminar No.");
            TestField("Duration");
            TestField("Instructor Resource No.");
            TestField("Room Resource No."); 
            TestField(Status,Status::Closed);
            SeminarRegLine.Reset; 
            SeminarRegLine.SetRange("Document No.","No."); 
            if SeminarRegLine.IsEmpty then
                Error(NewText001);
            Window.Open( '#1#################################\\' + NewText002);
            Window.Update(1,StrSubstNo('%1 %2',NewText003,"No."));
            if SeminarRegHeader."Posting No." = '' then begin 
                TestField("Posting No. Series");
                "Posting No." := NoSeriesMgt.GetNextNo("Posting No. Series","Posting Date",true);
                Modify; 
                Commit;
            end;
            SeminarRegLine.LockTable;
            SourceCodeSetup.Get;
            SourceCode := SourceCodeSetup."CSD Seminar";
            PstdSeminarRegHeader.Init; 
            PstdSeminarRegHeader.TransferFields(SeminarRegHeader); 
            PstdSeminarRegHeader."No." := "Posting No."; 
            PstdSeminarRegHeader."No. Series" := "Posting No. Series"; 
            PstdSeminarRegHeader."Source Code" := SourceCode; 
            PstdSeminarRegHeader."User ID" := UserId;
            PstdSeminarRegHeader.Insert;

            Window.Update(1,StrSubstNo(NewText004,"No.",PstdSeminarRegHeader."No."));
            
            CopyCommentLines(SeminarCommentLine."Table Name"::"Seminar Registration", SeminarCommentLine."Table Name":: "Posted Seminar Registration", "No.",PstdSeminarRegHeader."No.");
            CopyCharges("No.",PstdSeminarRegHeader."No.");

            LineCount := 0; 
            SeminarRegLine.Reset;
            SeminarRegLine.SetRange("Document No.","No."); 
            if SeminarRegLine.FindSet then begin
                repeat
                    LineCount := LineCount + 1; 
                    Window.Update(2,LineCount);
                    SeminarRegLine.TestField("Bill-to Customer No."); 
                    SeminarRegLine.TestField("Participant Contact No.");
                    if not SeminarRegLine."To Invoice" then begin 
                        SeminarRegLine."Seminar Price" := 0; 
                        SeminarRegLine."Line Discount %" := 0; 
                        SeminarRegLine."Line Discount Amount" := 0; 
                        SeminarRegLine.Amount := 0;
                    end;

                    // Post seminar entry 
                    PostSeminarJnlLine(2); // Participant

                    // Insert posted seminar registration line 
                    PstdSeminarRegLine.Init; 
                    PstdSeminarRegLine.TransferFields(SeminarRegLine);
                    PstdSeminarRegLine."Document No." := PstdSeminarRegHeader."No.";
                    PstdSeminarRegLine.Insert;

                until SeminarRegLine.Next = 0; 

                // Post charges to seminar ledger 
                PostCharges;
                // Post instructor to seminar ledger 
                PostSeminarJnlLine(0); // Instructor
                // Post seminar room to seminar ledger 
                PostSeminarJnlLine(1); // Room
                
                Delete(true);
            end;

        end;
        Rec := SeminarRegHeader;
    end;

    var
        SeminarRegHeader: Record "CSD Seminar Reg. Header";
        SeminarRegLine: Record "CSD Seminar Registration Line";
        PstdSeminarRegHeader: Record "CSD Posted Seminar Reg. Header";
        PstdSeminarRegLine: Record "CSD Posted Seminar Reg. Line";
        SeminarCommentLine: Record "CSD Seminar Comment Line";
        SeminarCommentLine2: Record "CSD Seminar Comment Line";
        SeminarCharge: Record "CSD Seminar Charge";
        PstdSeminarCharge: Record "CSD Posted Seminar Charge";
        Room: Record Resource;
        Instructor: Record Resource;
        Customer: Record Customer;
        ResLedgEntry: Record "Res. Ledger Entry";
        SeminarJnlLine: Record "CSD Seminar Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        ResJnlLine: Record "Res. Journal Line";
        SeminarJnlPostLine: Codeunit "CSD Seminar Jnl.-Post Line";
        ResJnlPostLine: Codeunit "Res. Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        SourceCode: Code[10];
        LineCount: Integer;
        NewText001: Label 'There is no participant to post.';
        NewText002: Label 'Posting lines              #2######\';
        NewText003: Label 'Registration';
        NewText004: Label 'Registration %1  -> Posted Reg. %2';
        NewText005: Label 'The combination of dimensions used in %1 is blocked. %2';
        NewText006: Label 'The combination of dimensions used in %1,  line no. %2 is blocked. %3';
        NewText007: Label 'The dimensions used in %1 are invalid. %2';
        NewText008: Label 'The dimensions used in %1, line no. %2 are invalid. %3';

    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20]);
    begin
        SeminarCommentLine.Reset;
        SeminarCommentLine.SetRange("Table Name", FromDocumentType);
        SeminarCommentLine.SetRange("No.", FromNumber);
        if SeminarCommentLine.FindSet then repeat
            SeminarCommentLine2 := SeminarCommentLine;
            SeminarCommentLine2."Table Name" := ToDocumentType;
            SeminarCommentLine2."No." := ToNumber;
            SeminarCommentLine2.Insert;
            until SeminarCommentLine.Next = 0;
    end;

    local procedure CopyCharges(FromNumber: Code[20]; ToNumber: Code[20]);
    begin
        SeminarCharge.Reset;
        SeminarCharge.SetRange("Document No.", FromNumber);
        if SeminarCharge.FindSet then repeat
            PstdSeminarCharge.TransferFields(SeminarCharge);
            PstdSeminarCharge."Document No." := ToNumber;
            PstdSeminarCharge.Insert;
            until SeminarCharge.Next = 0;
    end;

    local procedure PostResJnlLine(Resource: Record Resource): Integer;
    begin
        with SeminarRegHeader do
        begin
            Resource.TestField("CSD Quantity Per Day");
            ResJnlLine.Init;
            ResJnlLine."Entry Type" := ResJnlLine."Entry Type"::Usage;
            ResJnlLine."Document No." := PstdSeminarRegHeader."No.";
            ResJnlLine."Resource No." := Resource."No.";
            ResJnlLine."Posting Date" := "Posting Date";
            ResJnlLine."Reason Code" := "Reason Code";
            ResJnlLine.Description := "Seminar Name";
            ResJnlLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
            ResJnlLine."Posting No. Series" := "Posting No. Series";
            ResJnlLine."Source Code" := SourceCode;
            ResJnlLine."Resource No." := Resource."No.";
            ResJnlLine."Unit of Measure Code" := Resource."Base Unit of Measure";
            ResJnlLine."Unit Cost" := Resource."Unit Cost";
            ResJnlLine."Qty. per Unit of Measure" := 1;
            ResJnlLine.Quantity := Duration * Resource."CSD Quantity Per Day";
            ResJnlLine."Total Cost" := ResJnlLine."Unit Cost" * ResJnlLine.Quantity;
            ResJnlLine."CSD Seminar No." := "Seminar No.";
            ResJnlLine."CSD Seminar Registration No." := PstdSeminarRegHeader."No.";
            ResJnlPostLine.RunWithCheck(ResJnlLine);
            ResLedgEntry.FindLast;
            exit(ResLedgEntry."Entry No.");
        end;
    end;

    local procedure PostSeminarJnlLine(ChargeType: Option Instructor, Room, Participant, Charge);
    begin
        with SeminarRegHeader do
        begin
            SeminarJnlLine.init;
            SeminarJnlLine."Seminar No." := "Seminar No.";
            SeminarJnlLine."Posting Date" := "Posting Date";
            SeminarJnlLine."Document Date" := "Document Date";
            SeminarJnlLine."Document No." := PstdSeminarRegHeader."No.";
            SeminarJnlLine."Charge Type" := ChargeType;
            SeminarJnlLine."Instructor Resource No." := "Instructor Resource No.";
            SeminarJnlLine."Starting Date" := "Starting Date";
            SeminarJnlLine."Seminar Registration No." := PstdSeminarRegHeader."No.";
            SeminarJnlLine."Room Resource No." := "Room Resource No.";
            SeminarJnlLine."Source Type" := SeminarJnlLine."Source Type"::Seminar;
            SeminarJnlLine."Source No." := "Seminar No.";
            SeminarJnlLine."Source Code" := SourceCode;
            SeminarJnlLine."Reason Code" := "Reason Code";
            SeminarJnlLine."Posting No. Series" := "Posting No. Series";
            case ChargeType of 
              ChargeType::Instructor :
                begin
                    Instructor.get("Instructor Resource No.");
                    SeminarJnlLine.Description := Instructor.Name;
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource; 
                    SeminarJnlLine.Chargeable := false; 
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Instructor);
                    SeminarJnlLine.Quantity := Duration;
                end;

              ChargeType::Room :
                begin
                    Room.GET("Room Resource No."); 
                    SeminarJnlLine.Description := Room.Name; 
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource; 
                    SeminarJnlLine.Chargeable := false; 
                    SeminarJnlLine.Quantity := Duration;
                    // Post to resource ledger
                    SeminarJnlLine."Res. Ledger Entry No." := PostResJnlLine(Room);
                end;

              ChargeType::Participant :
                begin
                    SeminarJnlLine."Bill-to Customer No." := SeminarRegLine."Bill-to Customer No.";
                    SeminarJnlLine."Participant Contact No." := SeminarRegLine."Participant Contact No.";
                    SeminarJnlLine."Participant Name" := SeminarRegLine."Participant Name"; 
                    SeminarJnlLine.Description := SeminarRegLine."Participant Name"; 
                    SeminarJnlLine.Type := SeminarJnlLine.Type::Resource; 
                    SeminarJnlLine.Chargeable := SeminarRegLine."To Invoice"; 
                    SeminarJnlLine.Quantity := 1;
                    SeminarJnlLine."Unit Price" := SeminarRegLine.Amount;
                    SeminarJnlLine."Total Price" := SeminarRegLine.Amount;
                end;

              ChargeType::Charge :
                begin
                    SeminarJnlLine.Description := SeminarCharge.Description;
                    SeminarJnlLine."Bill-to Customer No." := SeminarCharge."Bill-to Customer No."; 
                    SeminarJnlLine.Type := SeminarCharge.Type;
                    SeminarJnlLine.Quantity := SeminarCharge.Quantity;
                    SeminarJnlLine."Unit Price" := SeminarCharge."Unit Price"; 
                    SeminarJnlLine."Total Price" := SeminarCharge."Total Price";
                    SeminarJnlLine.Chargeable := SeminarCharge."To Invoice";
                end;

            end;
            SeminarJnlPostLine.RunWithCheck(SeminarJnlLine);
        end;
    end;

    local procedure PostCharges();
    begin
        SeminarCharge.reset;
        SeminarCharge.SetRange("Document No.",SeminarRegHeader."No."); 
        if SeminarCharge.FindSet(false,false) then repeat
          PostSeminarJnlLine(3); // Charge 
        until SeminarCharge.next = 0;
    end;
}

