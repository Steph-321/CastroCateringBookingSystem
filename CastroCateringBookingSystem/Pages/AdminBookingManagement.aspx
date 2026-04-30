<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminBookingManagement.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.AdminBookingManagement" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Management - Castro Admin</title>

    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-gold: #c2934a;
            --light-gold: #f4d589;
            --bg-cream: #f9f6f2;
            --bg-white: #ffffff;
            --bg-beige: #f0ebe4;
            --text-dark: #2e211b;
            --text-brown: #493a2f;
            --text-gray: #756e64;
            --border-light: #e5dcd0;
            --success: #2d8a53;
            --warning: #f5af35;
            --danger: #d92626;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-cream);
            color: var(--text-dark);
            display: flex;
            min-height: 100vh;
        }

        h1, h2, h3 {
            font-family: 'Playfair Display', serif;
        }
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

        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: start;
        }

        .page-header h1 {
            font-size: 2rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: var(--text-gray);
        }

        .header-actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .search-box {
            position: relative;
        }

        .search-box input {
            padding: 0.75rem 1rem 0.75rem 2.5rem;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.9rem;
            background: var(--bg-white);
            width: 300px;
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--primary-gold);
        }

        .search-icon {
            position: absolute;
            left: 0.875rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-gray);
        }

        .filter-select {
            padding: 0.75rem 2.5rem 0.75rem 1rem;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            font-size: 0.9rem;
            background: var(--bg-white);
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23756e64' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
        }

        .table-section {
            background: var(--bg-white);
            border-radius: 12px;
            padding: 1.75rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead {
            background: var(--bg-cream);
        }

        .data-table th {
            padding: 0.875rem 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--text-brown);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid var(--border-light);
        }

        .data-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-light);
            font-size: 0.9rem;
        }

        .data-table tbody tr:hover {
            background: var(--bg-cream);
        }

        .admin-table {
            width: 100%;
            border-collapse: collapse;
            background: var(--bg-white);
            border-radius: 12px;
            overflow: hidden;
        }

        .admin-header th {
            padding: 0.875rem 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--text-brown);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: var(--bg-cream);
            border-bottom: 2px solid var(--border-light);
        }

        .admin-row td,
        .admin-alt-row td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-light);
            font-size: 0.9rem;
        }

        .admin-row:hover,
        .admin-alt-row:hover {
            background: var(--bg-cream);
        }

        .status-upcoming {
            background: #fff3cd;
            color: #856404;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .btn-view,
        .btn-edit,
        .btn-delete {
            padding: 6px 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 12px;
            margin-right: 4px;
            transition: 0.3s;
        }

        .btn-view,
        .btn-edit {
            background: var(--bg-beige);
            color: var(--primary-gold);
        }

        .btn-view:hover,
        .btn-edit:hover {
            background: var(--primary-gold);
            color: white;
        }

        .btn-delete {
            background: #fff3cd;
            color: var(--danger);
        }

        .btn-delete:hover {
            background: var(--danger);
            color: white;
        }

        @media (max-width: 1024px) {
            .sidebar {
                transform: translateX(-100%);
                z-index: 1000;
            }

            .main-content {
                margin-left: 0;
            }
        }

        @media (max-width: 1200px) {
            .data-table th,
            .data-table td {
                padding: 0.75rem 0.5rem;
            }
        }
                .status-Pending {
            background: #fff3cd;
            color: #856404;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-Approved {
            background: #d4edda;
            color: #155724;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-Done {
            background: #d1ecf1;
            color: #0c5460;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }


    </style>
</head>
<body>
    <form id="form1" runat="server">
       
       <asp:GridView ID="GridViewBookings" runat="server"
    AutoGenerateColumns="False"
    CssClass="admin-table"
    GridLines="None"
    DataKeyNames="BookingID"
    OnRowDeleting="GridViewBookings_RowDeleting"
    OnRowCommand="GridViewBookings_RowCommand">

    <Columns>

        <asp:BoundField DataField="BookingID" HeaderText="ID" />
        <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
        <asp:BoundField DataField="EventType" HeaderText="Event" />
        <asp:BoundField DataField="EventDate" HeaderText="Date" />
        <asp:BoundField DataField="NoOfGuests" HeaderText="Guests" />

        <asp:TemplateField HeaderText="Status">
            <ItemTemplate>
                <span class='<%# Eval("Status") %>'>
                    <%# Eval("Status") %>
                </span>
            </ItemTemplate>
        </asp:TemplateField>

        <asp:TemplateField HeaderText="Actions">
            <ItemTemplate>

                <asp:Button ID="btnApprove" runat="server"
                    Text="Approve"
                    CommandName="Approve"
                    CommandArgument='<%# Eval("BookingID") %>'
                    CssClass="btn-edit" />

                <asp:Button ID="btnDone" runat="server"
                    Text="Done"
                    CommandName="Done"
                    CommandArgument='<%# Eval("BookingID") %>'
                    CssClass="btn-view" />

                <asp:Button ID="btnDelete" runat="server"
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
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                
                <span class="logo-text">Castro Admin</span>
            </div>
            <div class="logo-subtext">Management Panel</div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminDashboard.aspx" class="nav-item">
                <span class="nav-icon">📊</span>
                Dashboard
            </a>
            <a href="AdminBookingManagement.aspx" class="nav-item active">
                <span class="nav-icon">📋</span>
                Booking Management
            </a>
        </nav>

        <div class="sidebar-footer">
            <a href="Home.aspx" class="btn-back">
                <span>←</span> Back to User Site
            </a>
            <button class="btn-signout" onclick="logout()">
                <span>→</span> Sign out
            </button>
        </div>
    </aside>

    <!-- Main Content -->
    <form id="form2" runat="server">

<main class="main-content">

    <div class="page-header">
        <div>
            <h1>Booking Management</h1>
            <p>View, edit, and manage all bookings in the system.</p>
        </div>

        <div class="header-actions">
            <div class="search-box">
                <span class="search-icon">🔍</span>
                <input type="text" placeholder="Search by client, ID, event..."
                    id="searchInput" onkeyup="searchBookings()">
            </div>

            <select class="filter-select" id="statusFilter" onchange="filterBookings()">
                <option value="All">All statuses</option>
                <option value="Pending">Pending</option>
                <option value="Approved">Approved</option>
                <option value="Done">Done</option>
            </select>
        </div>
    </div>

    <div class="table-section">

        <!-- GRIDVIEW ONLY (NO HTML TABLE) -->
        <asp:GridView ID="GridView1" runat="server"
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

                        <asp:Button ID="btnApprove" runat="server"
                            Text="Approve"
                            CommandName="Approve"
                            CommandArgument='<%# Eval("BookingID") %>'
                            CssClass="btn-edit" />

                        <asp:Button ID="btnDone" runat="server"
                            Text="Done"
                            CommandName="Done"
                            CommandArgument='<%# Eval("BookingID") %>'
                            CssClass="btn-view" />

                        <asp:Button ID="btnDelete" runat="server"
                            Text="Delete"
                            CommandName="Delete"
                            CommandArgument='<%# Eval("BookingID") %>'
                            CssClass="btn-delete" />

                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>

        </asp:GridView>

        <!-- PACKAGE STATS -->
        <div style="margin-top:20px;">
            <h3>Package Statistics</h3>
            <asp:Label ID="lblPackageStats" runat="server"></asp:Label>
        </div>

    </div>

</main>

</form>


    <script>
        function searchBookings() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const rows = document.querySelectorAll('#bookingsTable tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            });
        }

        function filterBookings() {
            const status = document.getElementById('statusFilter').value;
            const rows = document.querySelectorAll('#bookingsTable tr');
            
            rows.forEach(row => {
                if (status === 'All') {
                    row.style.display = '';
                } else {
                    const statusBadge = row.querySelector('.status-badge');
                    const rowStatus = statusBadge.textContent.trim();
                    row.style.display = rowStatus === status ? '' : 'none';
                }
            });
        }

        function viewBooking(id) {
            alert(`Viewing booking details for ${id}`);
        }

        function editBooking(id) {
            alert(`Editing booking ${id}`);
        }

        function deleteBooking(id) {
            if (confirm(`Are you sure you want to delete booking ${id}?`)) {
                alert(`Booking ${id} has been deleted.`);
                // In real implementation, this would remove the row
            }
        }

        function logout() {
            localStorage.removeItem('adminUser');
            window.location.href = 'LoginSignup.aspx';
        }
    </script>
</form>
</body>
</html>