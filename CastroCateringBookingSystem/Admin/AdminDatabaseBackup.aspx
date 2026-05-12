<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="AdminDatabaseBackup.aspx.cs"
    Inherits="CastroCateringBookingSystem.Admin.AdminDatabaseBackup" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Castro Catering</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --gold:       #C9A961;
            --dark-brown: #4A3F35;
            --cream:      #FAF8F3;
            --beige:      #F5F1E8;
            --white:      #FFFFFF;
            --text-dark:  #2C2420;
            --text-light: #6B5B4F;
            --border:     #E8E0D5;
            --success-bg: #EDF7F1;
            --success-txt:#1E6B3E;
            --error-bg:   #FDE8E8;
            --error-txt:  #9B1C1C;
            --sidebar-w:  260px;
        }

        html, body { height: 100%; }
        body { font-family: 'Inter', sans-serif; background: var(--cream); color: var(--text-dark); line-height: 1.6; }
        h1, h2, h3, h4 { font-family: 'Playfair Display', serif; }

        /* ── LAYOUT ── */
        #form1 { display: flex; min-height: 100vh; }

        /* ── SIDEBAR ── */
        .sidebar {
            width: var(--sidebar-w); min-width: var(--sidebar-w);
            background: var(--white); border-right: 1px solid var(--border);
            display: flex; flex-direction: column;
            position: fixed; top: 0; left: 0; height: 100vh;
            overflow-y: auto; z-index: 100;
        }
        .sidebar-header { padding: 1.75rem 1.5rem; border-bottom: 1px solid var(--border); }
        .brand { display: flex; align-items: center; gap: 0.75rem; text-decoration: none; }
        .brand-name { font-family: 'Playfair Display', serif; font-size: 1rem; font-weight: 700; color: var(--dark-brown); line-height: 1.2; }
        .brand-sub  { font-size: 0.68rem; color: var(--text-light); letter-spacing: 0.07em; text-transform: uppercase; }
        .sidebar-nav { padding: 1.5rem 1rem; flex: 1; }
        .nav-link {
            display: flex; align-items: center; gap: 0.75rem;
            padding: 0.7rem 0.875rem; margin-bottom: 0.15rem;
            border-radius: 10px; text-decoration: none;
            color: var(--text-light); font-size: 0.875rem; font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }
        .nav-link:hover { background: var(--beige); color: var(--dark-brown); }
        .nav-link.active { background: var(--beige); color: var(--gold); font-weight: 600; }
        .sidebar-footer {
            padding: 1.25rem 1rem;
            border-top: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            gap: 0.4rem;
        }

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
        /* ── MAIN ── */
        .main { margin-left: var(--sidebar-w); width: calc(100% - var(--sidebar-w)); padding: 2rem 2.5rem; box-sizing: border-box; }

        .page-header { margin-bottom: 2rem; padding-bottom: 1.5rem; border-bottom: 1px solid var(--border); }
        .page-header h1 { font-size: 1.9rem; color: var(--dark-brown); }
        .page-sub { font-size: 0.875rem; color: var(--text-light); margin-top: 0.2rem; }

        /* ── STAT CARDS ── */
        .stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.25rem; margin-bottom: 2rem; }
        .stat-card {
            background: var(--white); border: 1px solid var(--border); border-radius: 14px;
            padding: 1.4rem 1.5rem; display: flex; align-items: center; gap: 1rem;
        }
        .stat-icon { width: 46px; height: 46px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; flex-shrink: 0; }
        .ic-gold  { background: #FDF5E4; }
        .ic-blue  { background: #EBF4FD; }
        .ic-green { background: #EDF7F1; }
        .ic-warm  { background: #FFF0E6; }
        .stat-label { font-size: 0.7rem; font-weight: 700; color: var(--text-light); text-transform: uppercase; letter-spacing: 0.07em; display: block; }
        .stat-val   { font-family: 'Playfair Display', serif; font-size: 1.4rem; font-weight: 700; color: var(--dark-brown); display: block; margin-top: 0.15rem; }

        /* ── BACKUP CARD ── */
        .card { background: var(--white); border: 1px solid var(--border); border-radius: 14px; overflow: hidden; margin-bottom: 2rem; }
        .card-head { display: flex; align-items: center; justify-content: space-between; padding: 1.1rem 1.5rem; border-bottom: 1px solid var(--border); }
        .card-head h2 { font-size: 1.05rem; color: var(--dark-brown); }
        .card-body { padding: 1.75rem 1.5rem; }

        /* ── BACKUP BUTTON ── */
        .backup-action { display: flex; align-items: center; gap: 1.5rem; flex-wrap: wrap; }
        .btn-backup {
            display: inline-flex; align-items: center; gap: 0.6rem;
            padding: 0.85rem 2rem;
            background: var(--gold); border: none; border-radius: 12px;
            font-family: 'Playfair Display', serif; font-size: 1rem; font-weight: 700;
            color: var(--dark-brown); cursor: pointer;
            transition: background 0.2s, transform 0.15s, box-shadow 0.2s;
            box-shadow: 0 4px 14px rgba(201,169,97,0.3);
        }
        .btn-backup:hover { background: #b8923f; color: #fff; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(201,169,97,0.4); }
        .btn-backup:active { transform: translateY(0); }
        .backup-note { font-size: 0.82rem; color: var(--text-light); line-height: 1.6; }
        .backup-note strong { color: var(--text-dark); }

        /* ── STATUS MESSAGE ── */
        .status-msg {
            display: block; margin-top: 1.25rem;
            padding: 0.85rem 1.1rem; border-radius: 10px;
            font-size: 0.875rem; font-weight: 600;
        }
        .status-msg.success { background: var(--success-bg); color: var(--success-txt); border: 1px solid #a5d6b7; }
        .status-msg.error   { background: var(--error-bg);   color: var(--error-txt);   border: 1px solid #f5a0a0; }

        /* ── HISTORY TABLE ── */
        .tbl-wrap { width: 100%; overflow-x: auto; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th {
            background: var(--beige); padding: 0.85rem 1.25rem;
            text-align: left; font-size: 0.7rem; font-weight: 700;
            color: var(--text-light); text-transform: uppercase; letter-spacing: 0.07em;
            white-space: nowrap;
        }
        .data-table tbody td {
            padding: 0.9rem 1.25rem; border-bottom: 1px solid var(--border);
            font-size: 0.875rem; color: var(--text-dark); vertical-align: middle;
        }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover td { background: var(--cream); }
        .file-path { font-family: monospace; font-size: 0.78rem; color: var(--text-light); word-break: break-all; }
        .size-badge { background: var(--beige); color: var(--text-light); padding: 0.2rem 0.6rem; border-radius: 6px; font-size: 0.75rem; font-weight: 600; }

        .empty-row { text-align: center; padding: 3rem 1rem; color: var(--text-light); font-size: 0.875rem; }
        .empty-icon { font-size: 2rem; margin-bottom: 0.5rem; }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <a href="../Pages/Home.aspx" class="brand">
                <div>
                    <div class="brand-name">Castro Catering</div>
                    <div class="brand-sub">Admin Panel</div>
                </div>
            </a>
        </div>
        <div class="sidebar-nav">
            <a href="AdminDashboard.aspx"        class="nav-link">📊 Dashboard</a>
            <a href="AdminBookingManagement.aspx" class="nav-link">📋 Booking Management</a>
            <a href="AdminAddPackage.aspx"        class="nav-link">➕ Add Package</a>
            <a href="AdminDatabaseBackup.aspx"    class="nav-link active">🗄️ Database Backup</a>
        </div>
        <div class="sidebar-footer">
            <a href="AdminLogin.aspx?signout=1" class="btn-signout">→ Sign out</a>
        </div>
    </aside>

    <!-- MAIN -->
    <div class="main">

        <div class="page-header">
            <h1>Database Backup</h1>
            <p class="page-sub">Create and manage full backups of the CastroCatering_DB database</p>
        </div>

        <!-- STAT CARDS -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-icon ic-gold">🗄️</div>
                <div>
                    <span class="stat-label">Database Size</span>
                    <asp:Label ID="lblDbSize" runat="server" CssClass="stat-val" Text="—" />
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon ic-blue">🕐</div>
                <div>
                    <span class="stat-label">Last Backup</span>
                    <asp:Label ID="lblLastBackup" runat="server" CssClass="stat-val" Text="—" />
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon ic-green">📋</div>
                <div>
                    <span class="stat-label">Total Records</span>
                    <asp:Label ID="lblTotalRecords" runat="server" CssClass="stat-val" Text="—" />
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon ic-warm">👥</div>
                <div>
                    <span class="stat-label">Registered Users</span>
                    <asp:Label ID="lblTotalUsers" runat="server" CssClass="stat-val" Text="—" />
                </div>
            </div>
        </div>

        <!-- BACKUP ACTION CARD -->
        <div class="card">
            <div class="card-head">
                <h2>🗄️ Create New Backup</h2>
            </div>
            <div class="card-body">
                <div class="backup-action">
                    <asp:Button ID="btnBackup" runat="server"
                        Text="💾  Back Up Now"
                        CssClass="btn-backup"
                        OnClick="btnBackup_Click" />
                    <div class="backup-note">
                        <strong>Full database backup</strong> — saves a complete snapshot of all tables,<br>
                        bookings, users, packages, and reviews.<br>
                        The <code>.bak</code> file will automatically download to your computer.<br>
                        <span style="color:#9B7A3A;">A copy is also kept in <code>App_Data/Backups/</code> on the server.</span>
                    </div>
                </div>
                <asp:Label ID="lblStatus" runat="server" Visible="false" />
            </div>
        </div>

        <!-- BACKUP HISTORY CARD -->
        <div class="card">
            <div class="card-head">
                <h2>📂 Backup History</h2>
                <span style="font-size:0.78rem;color:var(--text-light);">Last 20 full backups</span>
            </div>
            <div class="tbl-wrap">
                    <asp:GridView ID="gvBackupHistory" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="data-table"
                    GridLines="None">
                    <EmptyDataTemplate>
                        <div class="empty-row">
                            <div class="empty-icon">📭</div>
                            <p>No backups found. Click <strong>Back Up Now</strong> to create your first backup.</p>
                        </div>
                    </EmptyDataTemplate>
                    <Columns>
                        <asp:BoundField DataField="CreatedDate" HeaderText="Date &amp; Time" />
                        <asp:BoundField DataField="FileName"    HeaderText="File Name" />
                        <asp:TemplateField HeaderText="Saved To">
                            <ItemTemplate>
                                <span class="file-path"><%# Eval("FilePath") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Size">
                            <ItemTemplate>
                                <span class="size-badge"><%# Eval("SizeKB") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:PlaceHolder ID="phNoHistory" runat="server" Visible="false">
                    <div class="empty-row">
                        <div class="empty-icon">📭</div>
                        <p>No backup history available.</p>
                    </div>
                </asp:PlaceHolder>
            </div>
        </div>

    </div>
</form>
</body>
</html>
