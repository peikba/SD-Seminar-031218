table 50105 "CSD Seminar Report Selections"
{
    // CSD1.00 - 2018-01-01 - D. E. Veloper
    //   Chapter 9 - Lab 1
    //     - Created new table

    Caption = 'Seminar Report Selections';

    fields
    {
        field(1;Usage;Option)
        {
            Caption = 'Usage';
            OptionCaption = 'Registration';
            OptionMembers = Registration;
        }
        field(2;Sequence;Code[10])
        {
            Caption = 'Sequence';
            Numeric = true;
        }
        field(3;"Report ID";Integer)
        {
            Caption = 'Report ID';
            TableRelation = AllObjWithCaption."Object ID" where ("Object Type"=const(Report));

            trigger OnValidate();
            begin
                CalcFields("Report Name");
            end;
        }
        field(4;"Report Name";Text[80])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" where ("Object Type"=const(Report),
                                                                           "Object ID"=Field("Report ID")));
            Caption = 'Report Name';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;Usage,Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ReportSelection2 : Record "CSD Seminar Report Selections";

    procedure NewRecord();
    begin
        ReportSelection2.SetRange(Usage,Usage);
        if ReportSelection2.Find('+') and (ReportSelection2.Sequence <> '') then
          Sequence := IncStr(ReportSelection2.Sequence)
        else
          Sequence := '1';
    end;
    procedure PrintReportSelection(inUsage : Integer;SemRegHeader : Record "CSD Seminar Reg. Header");
    var
        SemReportSelection : Record "CSD Seminar Report Selections";
    begin
        SemReportSelection.SetRange(Usage,inUsage);
        if SemReportSelection.FindFirst then
          report.run(SemReportSelection."Report ID",true,false,SemRegHeader);
    end;
}

