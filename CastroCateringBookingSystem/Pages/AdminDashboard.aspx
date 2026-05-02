<%@ Page Language="C#" AutoEventWireup="true"
CodeBehind="AdminDashboard.aspx.cs"
Inherits="CastroCateringBookingSystem.Pages.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard — Castro Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --gold:        #C9A961;
            --gold-light:  #e8c97a;
            --dark-brown:  #4A3F35;
            --cream:       #FAF8F3;
            --beige:       #F5F1E8;
            --white:       #FFFFFF;
            --text-dark:   #2C2420;
            --text-light:  #6B5B4F;
            --border:      #E8E0D5;
            --success-bg:  #EDF7F1;
            --success-txt: #1E6B3E;
            --warn-bg:     #FFF8E1;
            --warn-txt:    #8A6200;
            --info-bg:     #EBF4FD;
            --info-txt:    #1558A0;
            --sidebar-w:   260px;
        }

        html, body {
            height: 100%;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--cream);
            color: var(--text-dark);
            line-height: 1.6;
        }

        h1, h2, h3, h4 { font-family: 'Playfair Display', serif; }

        /* ── LAYOUT SHELL ── */
        #form1 {
            display: flex;
            min-height: 100vh;
        }

        /* ── SIDEBAR ── */
        .sidebar {
            width: var(--sidebar-w);
            min-width: var(--sidebar-w);
            background: var(--white);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0; left: 0;
            height: 100vh;
            overflow-y: auto;
            z-index: 100;
        }

        .sidebar-header {
            padding: 1.75rem 1.5rem;
            border-bottom: 1px solid var(--border);
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            text-decoration: none;
        }

        .brand-icon {
            width: 40px; height: 40px;
            background: var(--gold);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.2rem;
            flex-shrink: 0;
            color: var(--white);
        }

        .brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 700;
            color: var(--dark-brown);
            line-height: 1.2;
        }

        .brand-sub {
            font-size: 0.68rem;
            color: var(--text-light);
            letter-spacing: 0.07em;
            text-transform: uppercase;
        }

        .sidebar-nav {
            padding: 1.5rem 1rem;
            flex: 1;
        }

        .nav-label {
            font-size: 0.65rem;
            font-weight: 700;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.12em;
            padding: 0 0.5rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.7rem 0.875rem;
            margin-bottom: 0.15rem;
            border-radius: 10px;
            text-decoration: none;
            color: var(--text-light);
            font-size: 0.875rem;
            font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }

        .nav-link .icon { font-size: 1rem; width: 20px; text-align: center; flex-shrink: 0; }
        .nav-link:hover { background: var(--beige); color: var(--dark-brown); }
        .nav-link.active { background: var(--beige); color: var(--gold); font-weight: 600; }

        .sidebar-footer {
            padding: 1.25rem 1rem;
            border-top: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

        .btn-back {
            display: flex; align-items: center; gap: 0.5rem;
            padding: 0.6rem 0.875rem;
            background: var(--beige);
            border: 1px solid var(--border);
            border-radius: 10px;
            text-decoration: none;
            color: var(--text-dark);
            font-size: 0.82rem;
            font-weight: 500;
            transition: background 0.2s;
        }
        .btn-back:hover { background: #ede6db; }

        .btn-signout {
            display: flex; align-items: center; gap: 0.5rem;
            padding: 0.6rem 0.875rem;
            background: transparent;
            border: none;
            border-radius: 10px;
            text-decoration: none;
            color: #b83232;
            font-size: 0.82rem;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-signout:hover { background: #fff0f0; }

        /* ── MAIN CONTENT ── */
        .main {
            margin-left: var(--sidebar-w);
            flex: 1;
            padding: 2.5rem 2.5rem 3rem;
            min-width: 0;
        }

        /* ── PAGE HEADER ── */
        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--border);
        }

        .page-header h1 {
            font-size: 1.9rem;
            color: var(--dark-brown);
            line-height: 1.15;
        }

        .page-sub {
            font-size: 0.875rem;
            color: var(--text-light);
            margin-top: 0.2rem;
        }

        .live-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            background: var(--success-bg);
            color: var(--success-txt);
            border: 1px solid #b2dfc5;
            border-radius: 99px;
            padding: 0.35rem 0.9rem;
            font-size: 0.75rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .live-dot {
            width: 6px; height: 6px;
            background: var(--success-txt);
            border-radius: 50%;
            animation: blink 1.6s ease-in-out infinite;
        }

        @keyframes blink { 0%,100%{opacity:1} 50%{opacity:0.25} }

        /* ── STAT CARDS ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 1.5rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 1.1rem;
            transition: box-shadow 0.2s, transform 0.2s;
        }

        .stat-card:hover {
            box-shadow: 0 6px 20px rgba(0,0,0,0.07);
            transform: translateY(-2px);
        }

        .stat-icon {
            width: 50px; height: 50px;
            border-radius: 12px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }

        .ic-gold   { background: #FDF5E4; }
        .ic-blue   { background: var(--info-bg); }
        .ic-green  { background: var(--success-bg); }
        .ic-warm   { background: #FFF0E6; }

        .stat-label {
            font-size: 0.7rem;
            font-weight: 700;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.07em;
            display: block;
        }

        .stat-val {
            font-family: 'Playfair Display', serif;
            font-size: 2.1rem;
            font-weight: 700;
            color: var(--dark-brown);
            line-height: 1.1;
            display: block;
        }

        /* ── CARDS ── */
        .card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 1.5rem;
        }

        .card-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.1rem 1.5rem;
            border-bottom: 1px solid var(--border);
        }

        .card-head h2 { font-size: 1rem; color: var(--dark-brown); }

        .chip {
            background: var(--beige);
            color: var(--text-light);
            font-size: 0.7rem;
            font-weight: 700;
            padding: 0.2rem 0.65rem;
            border-radius: 99px;
        }

        /* ── TABLE ── */
        .tbl-wrap { overflow-x: auto; }

        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table thead th {
            background: var(--beige);
            padding: 0.85rem 1.25rem;
            text-align: left;
            font-size: 0.7rem;
            font-weight: 700;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.07em;
            white-space: nowrap;
        }

        .data-table tbody td {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.875rem;
            color: var(--text-dark);
            vertical-align: middle;
        }

        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: var(--cream); }

        /* ── BADGES ── */
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.25rem 0.75rem;
            border-radius: 99px;
            font-size: 0.72rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .badge-Pending   { background: var(--warn-bg);    color: var(--warn-txt);    border: 1px solid #FFD54F; }
        .badge-Approved  { background: var(--success-bg); color: var(--success-txt); border: 1px solid #A5D6B7; }
        .badge-Completed { background: var(--info-bg);    color: var(--info-txt);    border: 1px solid #90CAF9; }
        .badge-Cancelled { background: #FDE8E8;           color: #9B1C1C;            border: 1px solid #F5A0A0; }

        /* ── PACKAGE BARS ── */
        .pkg-list { padding: 0.75rem 1.5rem 1.5rem; }

        .pkg-row {
            display: flex;
            align-items: center;
            gap: 1.25rem;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border);
        }

        .pkg-row:last-child { border-bottom: none; }

        .pkg-name {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--dark-brown);
            min-width: 120px;
        }

        .bar-track {
            flex: 1;
            height: 8px;
            background: var(--beige);
            border-radius: 99px;
            overflow: hidden;
        }

        .bar-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--gold), var(--gold-light));
            border-radius: 99px;
        }

        .pkg-count {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--text-light);
            min-width: 80px;
            text-align: right;
        }

        /* ── EMPTY ── */
        .empty {
            text-align: center;
            padding: 4rem 1rem;
            color: var(--text-light);
        }

        .empty .empty-icon { font-size: 2.5rem; margin-bottom: 0.75rem; }
        .empty p { font-size: 0.875rem; }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="Home.aspx" class="brand">
                <div class="brand-icon">✦</div>
                <div>
                    <div class="brand-name">Castro Catering</div>
                    <div class="brand-sub">Admin Panel</div>
                </div>
            </a>
        </div>

        <nav class="sidebar-nav">
            <span class="nav-label">Menu</span>
            <a href="AdminDashboard.aspx" class="nav-link active">
                <span class="icon">📊</span> Dashboard
            </a>
            <a href="AdminBookingManagement.aspx" class="nav-link">
                <span class="icon">📋</span> Booking Management
            </a>
        </nav>

        <div class="sidebar-footer">
            <a href="Home.aspx" class="btn-back">← Back to Site</a>
            <a href="LoginSignup.aspx" class="btn-signout">⎋ Sign Out</a>
        </div>
    </aside>

    <!-- MAIN -->
    <div class="main">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>

                <div class="page-header">
                    <div>
                        <h1>Dashboard</h1>
                        <p class="page-sub">Live overview of all bookings and activity</p>
                    </div>
                    <div class="live-pill">
                        <span class="live-dot"></span> Live
                    </div>
                </div>

                <!-- Stat Cards -->
                <div class="stats-row">
                    <div class="stat-card">
                        <div class="stat-icon ic-gold">📅</div>
                        <div>
                            <span class="stat-label">Total Bookings</span>
                            <asp:Label ID="lblTotalBookings" runat="server" CssClass="stat-val" Text="—" />
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon ic-blue">🔔</div>
                        <div>
                            <span class="stat-label">Approved</span>
                            <asp:Label ID="lblUpcoming" runat="server" CssClass="stat-val" Text="—" />
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon ic-green">✅</div>
                        <div>
                            <span class="stat-label">Completed</span>
                            <asp:Label ID="lblCompleted" runat="server" CssClass="stat-val" Text="—" />
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon ic-warm">👥</div>
                        <div>
                            <span class="stat-label">Total Guests</span>
                            <asp:Label ID="lblGuests" runat="server" CssClass="stat-val" Text="—" />
                        </div>
                    </div>
                </div>

                <!-- Recent Bookings -->
                <div class="card">
                    <div class="card-head">
                        <h2>Recent Bookings</h2>
                        <span class="chip">Last 10</span>
                    </div>
                    <div class="tbl-wrap">
                        <asp:GridView ID="GridViewRecent" runat="server"
                            AutoGenerateColumns="False"
                            CssClass="data-table"
                            GridLines="None">
                            <EmptyDataTemplate>
                                <div class="empty">
                                    <div class="empty-icon">📭</div>
                                    <p>No bookings yet.</p>
                                </div>
                            </EmptyDataTemplate>
                            <Columns>
                                <asp:BoundField DataField="BookingID"    HeaderText="ID" />
                                <asp:BoundField DataField="CustomerName" HeaderText="Client" />
                                <asp:BoundField DataField="EventType"    HeaderText="Event" />
                                <asp:BoundField DataField="EventDate"    HeaderText="Date"
                                    DataFormatString="{0:MMM dd, yyyy}" HtmlEncode="false" />
                                <asp:BoundField DataField="PackageID"    HeaderText="Package" />
                                <asp:BoundField DataField="Total"        HeaderText="Total"
                                    DataFormatString="₱{0:N0}" HtmlEncode="false" />
                                <asp:TemplateField HeaderText="Status">
                                    <ItemTemplate>
                                        <span class='badge badge-<%# Eval("Status") %>'><%# Eval("Status") %></span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>

                <!-- Package Statistics -->
                <div class="card">
                    <div class="card-head">
                        <h2>Package Statistics</h2>
                    </div>
                    <div class="pkg-list">
                        <asp:Label ID="lblPackageStats" runat="server" />
                    </div>
                </div>

                <asp:Timer ID="Timer1" runat="server" Interval="5000" OnTick="Timer1_Tick" />

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</form>
</body>
</html>
