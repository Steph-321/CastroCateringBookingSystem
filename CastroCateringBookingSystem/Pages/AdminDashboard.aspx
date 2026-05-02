<%@ Page Language="C#" AutoEventWireup="true"
CodeBehind="AdminDashboard.aspx.cs"
Inherits="CastroCateringBookingSystem.Pages.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Castro Admin</title>

    <style>
        .stat-value {
            font-size: 2rem;
            font-weight: bold;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th, .data-table td {
            padding: 10px;
            border-bottom: 1px solid #ddd;
        }
    </style>
</head>

<body>

<form id="form1" runat="server">

<asp:ScriptManager ID="ScriptManager1" runat="server" />

<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>

    <h1>Admin Dashboard</h1>

    <!-- REAL-TIME STATS -->
    <div>
        <div>Total Bookings:
            <asp:Label ID="lblTotalBookings" runat="server" CssClass="stat-value" />
        </div>

        <div>Upcoming:
            <asp:Label ID="lblUpcoming" runat="server" CssClass="stat-value" />
        </div>

        <div>Completed:
            <asp:Label ID="lblCompleted" runat="server" CssClass="stat-value" />
        </div>

        <div>Total Guests:
            <asp:Label ID="lblGuests" runat="server" CssClass="stat-value" />
        </div>
    </div>

    <br />

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

    <!-- REAL-TIME TIMER -->
    <asp:Timer ID="Timer1" runat="server"
        Interval="5000"
        OnTick="Timer1_Tick" />

</ContentTemplate>
</asp:UpdatePanel>

</form>

</body>
</html>
