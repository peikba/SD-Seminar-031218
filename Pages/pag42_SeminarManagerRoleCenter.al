page 50142 "CSD Seminar Manager RoleCenter"
// CSD1.00 - 2018-01-01 - D. E. Veloper
//   Chapter 10 - Lab 1 - 5
//     - Created new page
{
    PageType = RoleCenter;
    Caption='Seminar Manager RoleCenter';

    layout
    {
        area(RoleCenter)
        {
            group(Column1)
            {
                part(Activities;"CSD Seminar Manager Activities")
                {
                }
                part(MySeminars;"My Seminars")
                {
                }
            }
            group(Column2)
            {
                part(MyCustomers;"My Customers")
                {
                }
                systempart(MyNotifications;MyNotes)
                {
                }
                part(ReportInbox;"Report Inbox Part")
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action(SeminarRegistrations)
            {
                Caption = 'Seminar Registrations';
                Image = List;
                RunObject = Page  "CSD Posted Seminar Reg. List";
                ToolTip = 'Create seminar registrations';
            }
            action(Seminars)
            {
                Caption = 'Seminars';
                Image = List;
                RunObject = page "CSD Seminar List";
                ToolTip = 'View all seminars';
            }
            action(Instructors)
            {
                Caption = 'Instructors';
                RunObject = Page "Resource List";
                RunPageView = WHERE(Type = const(Person));
                ToolTip = 'View all resources registeres as persons';
            }
            action(Rooms)
            {
                Caption = 'Room';
                RunObject = Page "Resource List";
                RunPageView = WHERE(Type = const(Machine));
                ToolTip = 'View all resources registeres as machines';
            }
            action("Sales Invoices")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Invoices';
                Image = Invoice;
                RunObject = Page "Sales Invoice List";
                ToolTip = 'Register your sales to customers and invite them to pay according to the delivery and payment terms by sending them a sales invoice document. Posting a sales invoice registers shipment and records an open receivable entry on the customer''s account, which will be closed when payment is received. To manage the shipment process, use sales orders, in which sales invoicing is integrated.';
            }
            action("Sales Credit Memos")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sales Credit Memos';
                RunObject = Page "Sales Credit Memos";
                ToolTip = 'Revert the financial transactions involved when your customers want to cancel a purchase or return incorrect or damaged items that you sent to them and received payment for. To include the correct information, you can create the sales credit memo from the related posted sales invoice or you can create a new sales credit memo with copied invoice information. If you need more control of the sales return process, such as warehouse documents for the physical handling, use sales return orders, in which sales credit memos are integrated. Note: If an erroneous sale has not been paid yet, you can simply cancel the posted sales invoice to automatically revert the financial transaction.';
            }
            action(Customers)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Customers';
                Image = Customer;
                RunObject = Page 22;
                ToolTip = 'View or edit detailed information for the customers that you trade with. From each customer card, you can open related information, such as sales statistics and ongoing orders, and you can define special prices and line discounts that you grant if certain conditions are met.';
            }
        }
        area(Sections)
        {
             group("Posted Documents")
            {
                Caption = 'Posted Documents';
                Image = FiledPosted;
                ToolTip = 'View history for sales, shipments, and inventory.';
                action("Posted Seminar Registrations")
                {
                    Caption = 'Posted Seminar Registrations';
                    Image = Timesheet;
                    RunObject = Page  "CSD Posted Seminar Reg. List";
                    ToolTip = 'Open the list of posted Registrations.';
                }
                action("Posted Sales Invoices")
                {
                    Caption = 'Posted Sales Invoices';
                    Image = PostedOrder;
                    RunObject = Page  "Posted Sales Invoices";
                    ToolTip = 'Open the list of posted sales invoices.';
                }
                action("Posted Sales Credit Memos")
                {
                    Caption = 'Posted Sales Credit Memos';
                    Image = PostedOrder;
                    RunObject = Page 144;
                    ToolTip = 'Open the list of posted sales credit memos.';
                }
                action("Registers")
                {
                    Caption = 'Seminar Registers';
                    Image = PostedShipment;
                    RunObject = page "CSD Seminar Registers";
                    ToolTip = 'Open the list of Seminar Registers.';
                } 
            }
        }
        area(Creation)
        {
            action(NewSeminarRegistration)
            {
                Caption='Seminar Registration';
                Image=NewTimesheet;
                RunObject= page "CSD Seminar Registration";
                RunPageMode=Create; 
            }
            action(NewSalesInvoice)
            {
                Caption='Sales Invoice';
                Image=NewSalesInvoice;
                RunObject= page "Sales Invoice";
                RunPageMode=Create; 
            }
        }

        area(Processing)
        {
            action(CreateInvoices)
            {
                Caption='Create Invoices';
                Image=CreateJobSalesInvoice;
                RunObject= report "Create Seminar Invoices";
            }
            action(Navigate)
            {
                Caption='Navigate';
                Image=Navigate;
                RunObject= page Navigate;
                RunPageMode=Edit; 
            }            
        }
    }
}