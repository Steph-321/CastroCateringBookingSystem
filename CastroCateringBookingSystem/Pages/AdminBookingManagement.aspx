<%@ Page Language="C#" AutoEventWireup="true"
CodeBehind="AdminBookingManagement.aspx.cs"
Inherits="CastroCateringBookingSystem.Pages.AdminBookingManagement" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Management</title>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        /* ===== YOUR ORIGINAL CSS (KEEPED SHORT HERE FOR CLEAN OUTPUT) ===== */

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-gold: #c2934a;
            --bg-cream: #f9f6f2;
            --bg-white: #ffffff;
            --text-dark: #2e211b;
            --text-brown: #493a2f;
            --text-gray: #756e64;
            --border-light: #e5dcd0;
            --danger: #d92626;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-cream);
            display: flex;
        }

        h1 { font-family: 'Playfair Display', serif; }

        /* SIDEBAR */
        .sidebar {
            width: 260px;
            background: var(--bg-white);
            position: fixed;
            height: 100vh;
            border-right: 1px solid var(--border-light);
        }

        .main-content {
            margin-left: 260px;
            padding: 2rem;
            width: 100%;
        }

        /* TABLE */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--bg-white);
            border-radius: 12px;
            overflow: hidden;
        }

        .data-table th {
            background: var(--bg-cream);
            padding: 12px;
        }

        .data-table td {
            padding: 12px;
            border-bottom: 1px solid var(--border-light);
            text-align: center;
        }

        .data-table tr:hover {
            background: var(--bg-cream);
        }

        /* STATUS */
        .Pending { background: #fff3cd; padding:5px 10px; border-radius:20px; }
        .Approved { background: #d4edda; padding:5px 10px; border-radius:20px; }
        .Done { background: #d1ecf1; padding:5px 10px; border-radius:20px; }

        /* BUTTONS */
        .btn-edit { background: #f4d589; padding:5px 10px; border:none; cursor:pointer; }
        .btn-view { background: #c2934a; color:white; padding:5px 10px; border:none; cursor:pointer; }
        .btn-delete { background: #d92626; color:white; padding:5px 10px; border:none; cursor:pointer; }
    </style>
</head>

<body>

<form id="form1" runat="server">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <h2 style="padding:20px;">Castro Admin</h2>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="main-content">

        <h1>Booking Management</h1>

        <br />

        <!-- GRIDVIEW ONLY -->
        <asp:GridView ID="GridViewBookings" runat="server"
            AutoGenerateColumns="False"
            CssClass="data-table"
            GridLines="None"
            DataKeyNames="BookingID"
            OnRowDeleting="GridViewBookings_RowDeleting"
            OnRowCommand="GridViewBookings_RowCommand">

            <Columns>

                <asp:BoundField DataField="BookingID" HeaderText="ID" />
                <asp:BoundField DataField="CustomerName" HeaderText="CLIENT" />
                <asp:BoundField DataField="EventType" HeaderText="EVENT" />
                <asp:BoundField DataField="EventDate" HeaderText="DATE" />
                <asp:BoundField DataField="NoOfGuests" HeaderText="GUESTS" />
                <asp:BoundField DataField="PackageID" HeaderText="PACKAGE" />
                <asp:BoundField DataField="Amount" HeaderText="TOTAL" />

                <asp:TemplateField HeaderText="STATUS">
                    <ItemTemplate>
                        <span class='<%# Eval("Status") %>'>
                            <%# Eval("Status") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="ACTIONS">
                    <ItemTemplate>

                        <asp:Button runat="server"
                            Text="Approve"
                            CommandName="Approve"
                            CommandArgument='<%# Eval("BookingID") %>'
                            CssClass="btn-edit" />

                        <asp:Button runat="server"
                            Text="Done"
                            CommandName="Done"
                            CommandArgument='<%# Eval("BookingID") %>'
                            CssClass="btn-view" />

                        <asp:Button runat="server"
                            Text="Delete"
                            CommandName="Delete"
                            CommandArgument='<%# Eval("BookingID") %>'
                            CssClass="btn-delete" />

                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

        <br />

        <asp:Label ID="lblTotalBookings" runat="server" Font-Bold="true"></asp:Label>

        <br /><br />

        <h3>Package Statistics</h3>
        <asp:Label ID="lblPackageStats" runat="server"></asp:Label>

    </main>

</form>

</body>
</html>
