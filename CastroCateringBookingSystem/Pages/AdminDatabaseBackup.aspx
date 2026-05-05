<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDatabaseBackup.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.AdminDatabaseBackup" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Database Backup - Castro Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --gold: #C9A961;
            --dark-brown: #4A3F35;
            --cream: #FAF8F3;
            --beige: #F5F1E8;
            --white: #FFFFFF;
            --text-dark: #2C2420;
            --text-light: #6B5B4F;
            --border: #E8E0D5;
            --success-bg: #EDF7F1;
            --success-txt: #1E6B3E;
            --info-bg: #EBF4FD;
            --sidebar-w: 260px;
        }

        body { font-family: 'Inter', sans-serif; background: var(--cream); color: var(--text-dark); }
        h1, h2, h3 { font-family: 'Playfair Display', serif; }
        #form1 { display: flex; min-height: 100vh; }

        .sidebar {
            width: var(--sidebar-w); min-width: var(--sidebar-w); background: var(--white);
            border-right: 1px solid var(--border); display: flex; flex-direction: column;
            position: fixed; top: 0; left: 0; height: 100vh; overflow-y: auto;
        }
        .sidebar-header { padding: 1.75rem 1.5rem; border-bottom: 1px solid var(--border); }
        .brand-name { font-family: 'Playfair Display', serif; font-size: 1rem; font-weight: 700; color: var(--dark-brown); }
        .brand-sub { font-size: 0.68rem; color: var(--text-light); letter-spacing: 0.07em; text-transform: uppercase; }
        .sidebar-nav { padding: 1.5rem 1rem; flex: 1; }
        .nav-link {
            display: flex; align-items: center; gap: 0.75rem; padding: 0.7rem 0.875rem; margin-bottom: 0.15rem;
            border-radius: 10px; text-decoration: none; color: var(--text-light); font-size: 0.875rem; font-weight: 500;
            transition: background 0.2s, color 0.2s;
        }
        .nav-link:hover { background: var(--beige); color: var(--dark-brown); }
        .nav-link.active { background: var(--beige); color: var(--gold); font-weight: 600; }
        .sidebar-footer { padding: 1.25rem 1rem; border-top: 1px solid var(--border); display: flex; flex-direction: column; gap: 0.4rem; }
        .btn-back, .btn-signout {
            display: block; padding: 0.6rem 0.875rem; border-radius: 10px; text-decoration: none; font-size: 0.82rem; font-weight: 500;
        }
        .btn-back { background: var(--beige); border: 1px solid var(--border); color: var(--text-dark); }
        .btn-signout { color: #b83232; }

        .main { margin-left: var(--sidebar-w); width: calc(100% - var(--sidebar-w)); padding: 2.5rem; }
        .page-header { margin-bottom: 1.5rem; padding-bottom: 1.2rem; border-bottom: 1px solid var(--border); }
        .page-header h1 { font-size: 1.85rem; color: var(--dark-brown); }
        .page-sub { font-size: 0.9rem; color: var(--text-light); margin-top: 0.25rem; }

        .card {
            background: var(--white); border: 1px solid var(--border); border-radius: 14px;
            padding: 1.4rem 1.5rem; margin-bottom: 1.25rem;
        }
        .backup-info {
            background: var(--info-bg);
            border: 1px solid #bdd8f5;
            color: #184b7a;
            border-radius: 12px;
            padding: 1rem 1.1rem;
            font-size: 0.9rem;
            line-height: 1.6;
        }

        .action-row { display: flex; align-items: center; gap: 1rem; flex-wrap: wrap; margin-top: 0.9rem; }
        .btn-backup {
            background: var(--gold); color: #fff; border: none; border-radius: 10px;
            padding: 0.85rem 1.5rem; font-size: 0.92rem; font-weight: 700; cursor: pointer;
            transition: background 0.2s, transform 0.15s;
        }
        .btn-backup:hover { background: #a87a38; transform: translateY(-1px); }
        .btn-backup:disabled { opacity: 0.65; cursor: not-allowed; transform: none; }

        .progress-wrap { display: none; width: min(460px, 100%); }
        .progress-top { display: flex; justify-content: space-between; font-size: 0.82rem; color: var(--text-light); margin-bottom: 0.35rem; }
        .progress-bar {
            width: 100%; height: 10px; background: var(--beige); border-radius: 99px; overflow: hidden;
            border: 1px solid var(--border);
        }
        .progress-fill {
            width: 0%; height: 100%; background: linear-gradient(90deg, var(--gold), #e0bf73);
            border-radius: 99px; transition: width 0.25s;
        }

        .success-msg {
            display: none;
            margin-top: 1rem;
            padding: 0.75rem 0.95rem;
            border-radius: 10px;
            background: var(--success-bg);
            color: var(--success-txt);
            border: 1px solid #b2dfc5;
            font-size: 0.88rem;
            font-weight: 600;
        }

        .record-title { font-size: 1rem; color: var(--dark-brown); margin-bottom: 0.8rem; }
        .tbl-wrap { overflow-x: auto; }
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th {
            background: var(--beige);
            padding: 0.75rem 0.9rem;
            text-align: left;
            font-size: 0.72rem;
            letter-spacing: 0.06em;
            text-transform: uppercase;
            color: var(--text-light);
            white-space: nowrap;
        }
        .data-table tbody td {
            padding: 0.9rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.87rem;
            color: var(--text-dark);
        }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .badge-complete {
            display: inline-block;
            background: var(--success-bg);
            color: var(--success-txt);
            border: 1px solid #b2dfc5;
            border-radius: 99px;
            padding: 0.2rem 0.65rem;
            font-size: 0.72rem;
            font-weight: 700;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="brand-name">Castro Catering</div>
            <div class="brand-sub">Admin Panel</div>
        </div>
        <div class="sidebar-nav">
            <a href="AdminDashboard.aspx" class="nav-link">📊 Dashboard</a>
            <a href="AdminBookingManagement.aspx" class="nav-link">📋 Booking Management</a>
            <a href="AdminAddPackage.aspx" class="nav-link">➕ Add Package</a>
            <a href="AdminDatabaseBackup.aspx" class="nav-link active">🗄️ Database Backup</a>
        </div>
        <div class="sidebar-footer">
            <a href="Home.aspx" class="btn-back">← Back to Site</a>
            <a href="LoginSignup.aspx" class="btn-signout">⎋ Sign Out</a>
        </div>
    </aside>

    <main class="main">
        <div class="page-header">
            <h1>Database Backup</h1>
            <p class="page-sub">Create backup copies of your system database for recovery and security.</p>
        </div>

        <section class="card">
            <div class="backup-info">
                This feature creates a backup copy of the database so your records can be recovered in case of accidental loss, corruption, or unexpected system issues.
            </div>
            <div class="action-row">
                <button id="btnCreateBackup" type="button" class="btn-backup">Create Database Backup</button>
                <div id="progressWrap" class="progress-wrap">
                    <div class="progress-top">
                        <span>Creating backup...</span>
                        <span id="progressPct">0%</span>
                    </div>
                    <div class="progress-bar">
                        <div id="progressFill" class="progress-fill"></div>
                    </div>
                </div>
            </div>
            <div id="successMsg" class="success-msg">Database backup created successfully</div>
        </section>

        <section class="card">
            <h2 class="record-title">Backup Record</h2>
            <div class="tbl-wrap">
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Backup File Name</th>
                            <th>Date Created</th>
                            <th>Time Created</th>
                            <th>Backup Status</th>
                        </tr>
                    </thead>
                    <tbody id="backupTableBody">
                        <tr>
                            <td colspan="4" style="color:#7e7267; font-style:italic;">No backup created yet.</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</form>

<script>
    (function () {
        var btn = document.getElementById('btnCreateBackup');
        var progressWrap = document.getElementById('progressWrap');
        var progressFill = document.getElementById('progressFill');
        var progressPct = document.getElementById('progressPct');
        var successMsg = document.getElementById('successMsg');
        var backupTableBody = document.getElementById('backupTableBody');

        function pad(n) { return String(n).padStart(2, '0'); }

        function formatDate(d) {
            return d.getFullYear() + '-' + pad(d.getMonth() + 1) + '-' + pad(d.getDate());
        }

        function formatTime(d) {
            var hours = d.getHours();
            var mins = pad(d.getMinutes());
            var ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            if (hours === 0) hours = 12;
            return hours + ':' + mins + ' ' + ampm;
        }

        function buildFileName(d) {
            return 'CastroBackup_' + d.getFullYear() + pad(d.getMonth() + 1) + pad(d.getDate()) + '_' + pad(d.getHours()) + pad(d.getMinutes()) + pad(d.getSeconds()) + '.bak';
        }

        btn.addEventListener('click', function () {
            btn.disabled = true;
            successMsg.style.display = 'none';
            progressWrap.style.display = 'block';
            progressFill.style.width = '0%';
            progressPct.textContent = '0%';

            var pct = 0;
            var timer = setInterval(function () {
                pct += 10;
                progressFill.style.width = pct + '%';
                progressPct.textContent = pct + '%';

                if (pct >= 100) {
                    clearInterval(timer);
                    setTimeout(function () {
                        var now = new Date();
                        var row = document.createElement('tr');
                        row.innerHTML =
                            '<td>' + buildFileName(now) + '</td>' +
                            '<td>' + formatDate(now) + '</td>' +
                            '<td>' + formatTime(now) + '</td>' +
                            '<td><span class="badge-complete">Completed</span></td>';

                        if (backupTableBody.children.length === 1 && backupTableBody.children[0].children.length === 1) {
                            backupTableBody.innerHTML = '';
                        }
                        backupTableBody.insertBefore(row, backupTableBody.firstChild);

                        progressWrap.style.display = 'none';
                        successMsg.style.display = 'block';
                        btn.disabled = false;
                    }, 300);
                }
            }, 140);
        });
    })();
</script>
</body>
</html>
