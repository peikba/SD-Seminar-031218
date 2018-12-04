report 50101 "CSD Seminar Reg. Part. List"
{
    Caption = 'Seminar Reg. Participants List';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Layouts/SeminarRegParticipantList.rdl';

    dataset
    {
        dataitem("CSD Seminar Reg. Header"; "CSD Seminar Reg. Header")
        {
            RequestFilterFields = "No.", "Seminar No.";
            column(No_; "No.")
            {
                IncludeCaption = true;
            }
            column(Seminar_No_; "Seminar No.")
            {
                IncludeCaption = true;
            }
            column(Seminar_Name; "Seminar Name")
            {
                IncludeCaption = true;
            }
            column(Instructor_Name; "Instructor Name")
            {
                IncludeCaption = true;
            }
            column(Room_Name; "Room Name")
            {
                IncludeCaption = true;
            }
            column(Duration; Duration)
            {
                IncludeCaption = true;
            }
            column(Seminar_Price; "Seminar Price")
            {
                IncludeCaption = true;
            }
            dataitem("CSD Seminar Registration Line"; "CSD Seminar Registration Line")
            {
                DataItemTableView = sorting ("Document No.");
                DataItemLink = "Document No." = field ("No.");

                column(Bill_to_Customer_No_; "Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(Participant_Contact_No_; "Participant Contact No.")
                {
                    IncludeCaption = true;
                }
                column(Participant_Name; "Participant Name")
                {
                    IncludeCaption = true;
                }
            }
        }
        dataitem("Company Information"; "Company Information")
        {
            DataItemTableView = sorting ("Primary Key");
            column(Picture; Picture)
            {

            }
            column(CompanyName; CompanyName())
            {

            }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = All;

                    }
                }
            }
        }


    }

    var
        ShowDetails: Boolean;
}