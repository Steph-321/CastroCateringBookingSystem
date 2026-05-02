<%@ Page Language="C#" AutoEventWireup="true"
CodeBehind="AdminDashboard.aspx.cs"
Inherits="CastroCateringBookingSystem.Pages.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Castro Admin</title>

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

    /* SIDEBAR (SAME AS BOOKING MANAGEMENT) */
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

    .logo-text {
        font-family: 'Playfair Display', serif;
        font-size: 1.2rem;
        font-weight: 600;
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

    .sidebar-footer {
        padding: 1.5rem;
        border-top: 1px solid var(--border-light);
    }

    .btn-back {
        display: flex;
        align-items: center;
        padding: 0.75rem 1rem;
        background: var(--bg-cream);
        border: 1px solid var(--border-light);
        border-radius: 8px;
        text-decoration: none;
        color: var(--text-brown);
        margin-bottom: 1rem;
    }

    .btn-back:hover {
        background: var(--bg-beige);
    }

    .btn-signout {
        display: flex;
        align-items: center;
        padding: 0.75rem 1rem;
        border: none;
        background: transparent;
        color: #d92626;
        cursor: pointer;
    }

    /* MAIN CONTENT */
    .main-content {
        margin-left: 260px;
        padding: 2rem;
        width: 100%;
    }

    /* DASHBOARD STATS (ADDED FOR YOUR PAGE) */
    .stats-wrapper {
        display: flex;
        gap: 15px;
        padding: 20px 0;
        flex-wrap: wrap;
    }

    .stat-box {
        flex: 1;
        min-width: 180px;
        background: var(--bg-white);
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        text-align: center;
    }

    .stat-title {
        font-size: 14px;
        color: var(--text-gray);
    }

    .stat-value {
        font-size: 28px;
        font-weight: bold;
        color: var(--primary-gold);
        display: block;
        margin-top: 8px;
    }

    /* TABLE (same system) */
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

    /* PACKAGE STATS */
    .package-stats {
        margin-top: 20px;
        padding: 15px;
        background: var(--bg-white);
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    }
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

            <div class="sidebar-nav">

                <a href="AdminDashboard.aspx" class="nav-item active">📊 Dashboard</a>

                <a href="AdminBookingManagement.aspx" class="nav-item">📋 Booking Management</a>

            </div>

            <div class="sidebar-footer">
                <a href="Home.aspx" class="btn-back">← Back to User Site</a>
                <a href="Logout.aspx" class="btn-signout">→ Sign out</a>
            </div>

        </aside>

    <div class="main-content">
    <asp:ScriptManager ID="ScriptManager1" runat="server" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>

            <h1>Admin Dashboard</h1>

            <!-- REAL-TIME STATS -->
            <div class="stats-wrapper">

                <div class="stat-box">
                    <div class="stat-title">Total Bookings</div>
                    <asp:Label ID="lblTotalBookings" runat="server" CssClass="stat-value" />
                </div>

                <div class="stat-box">
                    <div class="stat-title">Upcoming</div>
                    <asp:Label ID="lblUpcoming" runat="server" CssClass="stat-value" />
                </div>

                <div class="stat-box">
                    <div class="stat-title">Completed</div>
                    <asp:Label ID="lblCompleted" runat="server" CssClass="stat-value" />
                </div>

                <div class="stat-box">
                    <div class="stat-title">Total Guests</div>
                    <asp:Label ID="lblGuests" runat="server" CssClass="stat-value" />
                </div>

            </div>

            <!-- RECENT BOOKINGS -->
            <h2>Recent Bookings</h2>

            <asp:GridView ID="GridViewRecent" runat="server"
                AutoGenerateColumns="False"
                CssClass="data-table">

                <Columns>
                    <asp:BoundField DataField="BookingID" HeaderText="ID" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Client" />
                    <asp:BoundField DataField="EventType" HeaderText="Event" />
                    <asp:BoundField DataField="EventDate" HeaderText="Date" />
                    <asp:BoundField DataField="PackageID" HeaderText="Package" />
                    <asp:BoundField DataField="Total" HeaderText="Total" />
                    <asp:BoundField DataField="Status" HeaderText="Status" />
                </Columns>

            </asp:GridView>

            <!-- PACKAGE STATS (FIXED MISSING LABEL ERROR) -->
            <div class="package-stats">
                <h3>Package Statistics</h3>
                <asp:Label ID="lblPackageStats" runat="server" />
            </div>

            <!-- REAL-TIME TIMER -->
            <asp:Timer ID="Timer1" runat="server"
                Interval="5000"
                OnTick="Timer1_Tick" />

        </ContentTemplate>
    </asp:UpdatePanel>

</form>

</body>
</html>
