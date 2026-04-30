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
            border-right: 1px solid var(--border-light);
            display: flex;
            flex-direction: column;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-light);
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.5rem;
        }

        .logo-icon {
            width: 40px;
            height: 40px;
            background: var(--primary-gold);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }

        .logo-text {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--text-dark);
        }

        .logo-subtext {
            font-size: 0.75rem;
            color: var(--text-gray);
            margin-left: 3.2rem;
        }

        .sidebar-nav {
            padding: 1.5rem 1rem;
            flex: 1;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.875rem 1rem;
            margin-bottom: 0.5rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: var(--text-brown);
            font-weight: 500;
        }

        .nav-item:hover {
            background: var(--bg-cream);
        }

        .nav-item.active {
            background: var(--bg-beige);
            color: var(--primary-gold);
        }

        .nav-icon {
            font-size: 1.2rem;
            width: 24px;
            text-align: center;
        }

        .sidebar-footer {
            padding: 1.5rem;
            border-top: 1px solid var(--border-light);
        }

        .btn-back {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            background: var(--bg-cream);
            border: 1px solid var(--border-light);
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            color: var(--text-brown);
            transition: all 0.3s;
            text-decoration: none;
            margin-bottom: 1rem;
        }

        .btn-back:hover {
            background: var(--bg-beige);
        }

        .btn-signout {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1rem;
            background: transparent;
            border: none;
            cursor: pointer;
            font-weight: 500;
            color: #d92626;
            transition: all 0.3s;
        }

        .btn-signout:hover {
            background: #fff3cd;
            border-radius: 8px;
        }

        /* MAIN CONTENT */
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

        <div class="sidebar-header">
            <div class="logo-text">Castro Admin</div>
            <div class="logo-subtext">Management Panel</div>
        </div>

        <a href="AdminDashboard.aspx" class="nav-item">📊 Dashboard</a>
        <a href="AdminBookingManagement.aspx" class="nav-item active">📋 Booking Management</a>

        <div class="sidebar-footer">
            <a href="Home.aspx" class="btn-back">← Back to User Site</a>
            <a href="Logout.aspx" class="btn-signout">→ Sign out</a>
        </div>

    </aside>

    <!-- MAIN CONTENT -->
    <div class="main-content">

        <!-- GRIDVIEW -->
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
                <asp:BoundField DataField="Total" HeaderText="TOTAL" />

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

    </div>

</form>

</body>
</html>
