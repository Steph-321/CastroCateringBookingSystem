<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.AdminDashboard" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Castro Admin</title>
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

        /* Sidebar */
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

        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 2rem;
        }

        .page-header {
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 2rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: var(--text-gray);
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .stat-card {
            background: var(--bg-white);
            border-radius: 12px;
            padding: 1.75rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .stat-icon.gold {
            background: var(--bg-beige);
        }

        .stat-icon.orange {
            background: #fff3cd;
        }

        .stat-icon.green {
            background: #d4edda;
        }

        .stat-icon.blue {
            background: #d1ecf1;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
            font-family: 'Playfair Display', serif;
        }

        .stat-label {
            color: var(--text-gray);
            font-size: 0.9rem;
        }

        /* Recent Bookings Table */
        .table-section {
            background: var(--bg-white);
            border-radius: 12px;
            padding: 1.75rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .table-header h2 {
            font-size: 1.3rem;
            color: var(--text-dark);
        }

        .table-subtitle {
            color: var(--text-gray);
            font-size: 0.85rem;
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
            font-size: 0.85rem;
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

        .booking-id {
            font-family: monospace;
            color: var(--text-gray);
            font-size: 0.85rem;
        }

        .client-name {
            font-weight: 600;
            color: var(--text-dark);
        }

        .status-badge {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }

        .status-upcoming {
            background: #fff3cd;
            color: #856404;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .amount {
            font-weight: 600;
            color: var(--primary-gold);
        }

        @media (max-width: 1024px) {
            .sidebar {
                transform: translateX(-100%);
                z-index: 1000;
            }

            .main-content {
                margin-left: 0;
            }

            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }

            .data-table {
                font-size: 0.85rem;
            }

            .data-table th,
            .data-table td {
                padding: 0.75rem 0.5rem;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-header">
            <div class="sidebar-logo">
                <span class="logo-text">Castro Admin</span>
            </div>
            <div class="logo-subtext">Management Panel</div>
        </div>

        <nav class="sidebar-nav">
            <a href="AdminDashboard.aspx" class="nav-item active">
                <span class="nav-icon">📊</span>
                Dashboard
            </a>
            <a href="AdminBookingManagement.aspx" class="nav-item">
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
    <main class="main-content">
        <div class="page-header">
            <h1>Dashboard</h1>
            <p>Overview of bookings and operations.</p>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon gold">📋</div>
                <div class="stat-value">5</div>
                <div class="stat-label">Total Bookings</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon orange">🕐</div>
                <div class="stat-value">3</div>
                <div class="stat-label">Upcoming Events</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon green">✓</div>
                <div class="stat-value">2</div>
                <div class="stat-label">Completed Events</div>
            </div>

            <div class="stat-card">
                <div class="stat-icon blue">👥</div>
                <div class="stat-value">438</div>
                <div class="stat-label">Total Guests Served</div>
            </div>
        </div>

        <!-- Recent Bookings Table -->
        <div class="table-section">
            <div class="table-header">
                <div>
                    <h2>Recent Bookings</h2>
                    <div class="table-subtitle">Last 6 entries</div>
                </div>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>BOOKING ID</th>
                        <th>CLIENT</th>
                        <th>EVENT</th>
                        <th>DATE</th>
                        <th>PACKAGE</th>
                        <th>AMOUNT</th>
                        <th>STATUS</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="booking-id">#b-1005</td>
                        <td class="client-name">Noah Tan</td>
                        <td>Wedding</td>
                        <td>5/15/2026</td>
                        <td>Grand Wedding Feast</td>
                        <td class="amount">₱240,000</td>
                        <td><span class="status-badge status-upcoming">Upcoming</span></td>
                    </tr>
                    <tr>
                        <td class="booking-id">#b-1001</td>
                        <td class="client-name">Olivia Mendez</td>
                        <td>Wedding</td>
                        <td>5/3/2026</td>
                        <td>Grand Wedding Feast</td>
                        <td class="amount">₱144,000</td>
                        <td><span class="status-badge status-upcoming">Upcoming</span></td>
                    </tr>
                    <tr>
                        <td class="booking-id">#b-1002</td>
                        <td class="client-name">TechNova Inc.</td>
                        <td>Corporate</td>
                        <td>4/27/2026</td>
                        <td>Corporate Essentials</td>
                        <td class="amount">₱39,000</td>
                        <td><span class="status-badge status-upcoming">Upcoming</span></td>
                    </tr>
                    <tr>
                        <td class="booking-id">#b-1003</td>
                        <td class="client-name">Liam Garcia</td>
                        <td>Birthday</td>
                        <td>4/11/2026</td>
                        <td>Birthday Bliss</td>
                        <td class="amount">₱19,200</td>
                        <td><span class="status-badge status-completed">Completed</span></td>
                    </tr>
                    <tr>
                        <td class="booking-id">#b-1004</td>
                        <td class="client-name">Sofia Lim</td>
                        <td>Anniversary</td>
                        <td>3/24/2026</td>
                        <td>Intimate Private Dining</td>
                        <td class="amount">₱32,400</td>
                        <td><span class="status-badge status-completed">Completed</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </main>

    <script>
        function logout() {
            localStorage.removeItem('adminUser');
            window.location.href = 'LoginSignup.aspx';
        }
    </script>
</body>
</html>
