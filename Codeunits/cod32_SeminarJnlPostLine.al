codeunit 50132 "CSD Seminar Jnl.-Post Line"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 2-2
{
    TableNo = "CSD Seminar Journal Line";

    trigger OnRun();
    begin
        RunWithCheck(Rec);
    end;

    var
        SeminarJnlLine: Record "CSD Seminar Journal Line";
        SeminarLedgerEntry: Record "CSD Seminar Ledger Entry";
        SeminarRegister: Record "CSD Seminar Register";
        SeminarJnlCheckLine: Codeunit "CSD Seminar Jnl.-Check Line";
        NextEntryNo: Integer;

    procedure RunWithCheck(var SeminarJnLine2: Record "CSD Seminar Journal Line");
    var
        myInt: Integer;
    begin
        with SeminarJnLine2 do
        begin
            SeminarJnlLine := SeminarJnLine2;
            Code();
            SeminarJnLine2 := SeminarJnlLine;
        end;
    end;

    local procedure Code();
    var
        myInt: Integer;
    begin
        with SeminarJnlLine do
        begin
            if EmptyLine then
                exit;

            SeminarJnlCheckLine.RunCheck(SeminarJnlLine);

            if NextEntryNo = 0 then begin
                SeminarLedgerEntry.LockTable;
                if SeminarLedgerEntry.FindLast then
                    NextEntryNo := SeminarLedgerEntry."Entry No.";
                NextEntryNo := NextEntryNo + 1;
            end;

            if "Document Date" = 0D then
                "Document Date" := "Posting Date";

            if SeminarRegister."No." = 0 then begin
                SeminarRegister.LOCKTable;
                if(not SeminarRegister.FINDLAST) or(SeminarRegister."To Entry No." <> 0) then begin
                    SeminarRegister.INIT;
                    SeminarRegister."No." := SeminarRegister."No." + 1;
                    SeminarRegister."From Entry No." := NextEntryNo;
                    SeminarRegister."To Entry No." := NextEntryNo;
                    SeminarRegister."Creation Date" := TODAY;
                    SeminarRegister."Source Code" := "Source Code";
                    SeminarRegister."Journal Batch Name" := "Journal Batch Name";
                    SeminarRegister."User ID" := USERID;
                    SeminarRegister.Insert;
                end;
            end;
            SeminarRegister."To Entry No." := NextEntryNo;
            SeminarRegister.Modify;

            SeminarLedgerEntry.INIT;
            SeminarLedgerEntry."Seminar No." := "Seminar No.";
            SeminarLedgerEntry."Posting Date" := "Posting Date";
            SeminarLedgerEntry."Document Date" := "Document Date";
            SeminarLedgerEntry."Entry Type" := "Entry Type";
            SeminarLedgerEntry."Document No." := "Document No.";
            SeminarLedgerEntry.Description := Description;
            SeminarLedgerEntry."Bill-to Customer No." := "Bill-to Customer No.";
            SeminarLedgerEntry."Charge Type" := "Charge Type";
            SeminarLedgerEntry.Type := Type;
            SeminarLedgerEntry.Quantity := Quantity;
            SeminarLedgerEntry."Unit Price" := "Unit Price";
            SeminarLedgerEntry."Total Price" := "Total Price";
            SeminarLedgerEntry."Participant Contact No." := "Participant Contact No.";
            SeminarLedgerEntry."Participant Name" := "Participant Name";
            SeminarLedgerEntry.Chargeable := Chargeable;
            SeminarLedgerEntry."Room Resource No." := "Room Resource No.";
            SeminarLedgerEntry."Instructor Resource No." := "Instructor Resource No.";
            SeminarLedgerEntry."Starting Date" := "Starting Date";
            SeminarLedgerEntry."Seminar Registration No." := "Seminar Registration No.";
            SeminarLedgerEntry."Res. Ledger Entry No." := "Res. Ledger Entry No.";
            SeminarLedgerEntry."Source Type" := "Source Type";
            SeminarLedgerEntry."Source No." := "Source No.";
            SeminarLedgerEntry."Journal Batch Name" := "Journal Batch Name";
            SeminarLedgerEntry."Source Code" := "Source Code";
            SeminarLedgerEntry."Reason Code" := "Reason Code";
            SeminarLedgerEntry."Posting No. Series" := "Posting No. Series";
            SeminarLedgerEntry."User ID" := USERID;
            SeminarLedgerEntry."Entry No." := NextEntryNo;
            SeminarLedgerEntry.insert;
            NextEntryNo := NextEntryNo + 1;
        end;
    end;
}
