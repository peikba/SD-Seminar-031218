tableextension 50104 "CSD ResJournalLineExt" extends "Res. Journal Line"
// CSD1.00 - 2018-01-01 - D. E. Veloper
// Chapter 7 - Lab 4-2
{
    fields
    {
        field(50100;"CSD Seminar No.";code[20])
        {
            Caption='Seminar No.';
            TableRelation = "CSD Seminar";
        }
        field(50101;"CSD Seminar Registration No.";code[20])
        {
            Caption='Seminar Registration No.';
            TableRelation = "CSD Seminar Reg. Header";
        }        
    }
}