<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Calendar.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.CalendarPage" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Calendar | Castro Catering</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --primary-gold:  #C9A961;
            --gold-dark:     #a07535;
            --gold-glow:     #f4d589;
            --dark-brown:    #4A3F35;
            --cream:         #FAF8F3;
            --light-beige:   #F5F1E8;
            --bg-white:      #ffffff;
            --text-dark:     #2C2420;
            --text-light:    #6B5B4F;
            --text-muted:    #8a8177;
            --border-light:  #e5dcd0;
            --success:       #2d8a53;
            --danger:        #d92626;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--cream);
            color: var(--text-dark);
            line-height: 1.6;
        }

        h1, h2, h3, h4 { font-family: 'Playfair Display', serif; }

        /* ── Navigation ── */
        nav {
            background: var(--white);
            padding: 1rem 5%;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .nav-container {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }

        .logo {
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            min-width: 0;
        }

        .logo-text {
            display: flex;
            flex-direction: column;
            line-height: 1.1;
            min-width: 0;
        }

        .logo-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--dark-brown);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .logo-subtitle {
            font-size: 0.8rem;
            color: var(--text-light);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .nav-links {
            display: flex;
            gap: 1.75rem;
            list-style: none;
            align-items: center;
        }

        .nav-links a {
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 500;
            font-size: 0.9rem;
            transition: color 0.3s;
            padding: 0.35rem 0.2rem;
            position: relative;
        }

        .nav-links a:hover {
            color: var(--primary-gold);
        }

        .nav-links a.active {
            color: var(--primary-gold);
        }

        .nav-links a.active::after {
            content: '';
            position: absolute;
            left: 0;
            right: 0;
            bottom: -6px;
            height: 2px;
            border-radius: 2px;
            background: var(--primary-gold);
        }

        .nav-icons {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .btn-login {
            background: transparent;
            border: 1px solid var(--primary-gold);
            padding: 0.45rem 1.25rem;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            color: var(--text-dark);
        }

        .btn-login:hover {
            background: var(--primary-gold);
            color: white;
        }

        .mobile-menu {
            display: none;
            cursor: pointer;
            border: 1px solid var(--light-beige);
            background: var(--white);
            border-radius: 10px;
            padding: 0.5rem 0.6rem;
            line-height: 0;
        }

        .mobile-menu span {
            display: block;
            width: 22px;
            height: 2px;
            background: var(--dark-brown);
            transition: 0.3s;
            border-radius: 2px;
        }

        .mobile-menu span + span {
            margin-top: 5px;
        }

        .mobile-menu[aria-expanded="true"] span:nth-child(1) {
            transform: translateY(7px) rotate(45deg);
        }

        .mobile-menu[aria-expanded="true"] span:nth-child(2) {
            opacity: 0;
        }

        .mobile-menu[aria-expanded="true"] span:nth-child(3) {
            transform: translateY(-7px) rotate(-45deg);
        }

        /* ── Page layout ── */
        .page-wrapper {
            max-width: 820px;
            margin: 0 auto;
            padding: 110px 5% 80px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .page-header h1 {
            font-size: 2.5rem;
            color: var(--dark-brown);
            margin-bottom: 0.5rem;
        }
        .page-header p {
            color: var(--text-light);
            font-size: 1rem;
        }
        .gold-divider {
            width: 50px;
            height: 3px;
            background: var(--primary-gold);
            margin: 1rem auto;
            border-radius: 2px;
        }

        /* ── Calendar card ── */
        .calendar-box {
            background: var(--bg-white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            padding: 2rem 2.5rem;
            box-shadow: 0 4px 24px rgba(0,0,0,0.07);
            animation: fadeIn 0.6s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── Month nav ── */
        .nav-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .month-label {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--dark-brown);
        }
        .btn-nav {
            background: transparent;
            border: 1px solid var(--border-light);
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            cursor: pointer;
            transition: all 0.25s;
        }
        .btn-nav:hover {
            background: var(--primary-gold);
            border-color: var(--primary-gold);
            color: white;
        }

        /* ── Grid ── */
        .grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 8px;
        }
        .day-header {
            text-align: center;
            font-size: 0.72rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding-bottom: 0.5rem;
        }

        /* ── Day cells ── */
        .day-cell {
            aspect-ratio: 1;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            font-weight: 500;
            cursor: pointer;
            background: var(--light-beige);
            border: 1.5px solid transparent;
            color: var(--text-dark);
            transition: all 0.2s ease;
            text-decoration: none;
        }
        .day-cell:hover {
            border-color: var(--primary-gold);
            background: #fdf5e6;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(201,169,97,0.2);
        }
        .day-cell.empty { background: transparent; border-color: transparent; cursor: default; pointer-events: none; }
        .day-cell.available { border-color: var(--success); color: var(--success); background: #f0faf4; font-weight: 600; }
        .day-cell.booked   { background: #fff0f0; border-color: #f5c0c0; color: var(--danger); font-weight: 600; cursor: not-allowed; }
        .day-cell.past     { background: var(--light-beige); color: var(--text-muted); opacity: 0.55; cursor: not-allowed; }
        .day-cell.today    { border-color: var(--primary-gold); background: linear-gradient(135deg, #fff8e8, #fdf0cc); font-weight: 700; color: var(--dark-brown); }
        .day-cell.selected { border-color: var(--dark-brown) !important; background: var(--light-beige) !important; font-weight: 700; transform: scale(1.08); box-shadow: 0 4px 14px rgba(74,63,53,0.18); }

        .status-text { font-size: 0.52rem; margin-top: 2px; color: inherit; opacity: 0.75; text-transform: uppercase; letter-spacing: 0.3px; }

        /* ── Legend ── */
        .legend {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 1.25rem;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid var(--border-light);
        }
        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.82rem;
            color: var(--text-light);
        }
        .box {
            width: 14px;
            height: 14px;
            border-radius: 4px;
            border: 1.5px solid transparent;
        }
        .box.available { border-color: var(--success); background: #f0faf4; }
        .box.booked    { background: #fff0f0; border-color: #f5c0c0; }
        .box.past      { background: var(--light-beige); border-color: #d0ccc7; }

        /* ── Booking action panel ── */
        .booking-actions {
            margin-top: 1.5rem;
            text-align: center;
            padding: 1.25rem;
            background: var(--light-beige);
            border-radius: 10px;
            border: 1px solid var(--border-light);
        }
        .booking-actions label {
            font-size: 0.95rem;
            color: var(--text-light);
            display: block;
            margin-bottom: 0.75rem;
        }
        .btn-book {
            background: var(--primary-gold);
            color: var(--text-dark);
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 30px;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 2px 12px rgba(201,169,97,0.3);
        }
        .btn-book:hover {
            background: var(--gold-dark);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(201,169,97,0.4);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav>
        <div class="nav-container">
            <a href="Home.aspx" class="logo" aria-label="Castro Catering Home">
                <span class="logo-text">
                    <span class="logo-title">Castro Catering</span>
                    <span class="logo-subtitle">Crafting elegant moments</span>
                </span>
            </a>
        
            <ul class="nav-links" id="primaryNav">
                <li><a href="Home.aspx">Home</a></li>
                <li><a href="Packages.aspx">Packages</a></li>
                <li><a href="Booking.aspx">Book Now</a></li>
                <li><a href="Calendar.aspx" class="active">Calendar</a></li>
                <li><a href="SmartPicker.aspx">Smart Pick</a></li>
                <li><a href="Reviews.aspx">Reviews</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="AboutUs.aspx">About Us</a></li>
            </ul>

            <div class="nav-icons">
                <button class="btn-login" id="btnNavAuth" onclick="window.location='LoginSignup.aspx'">Log In</button>
                <button class="btn-login" onclick="showAdminLogin()" style="margin-left:0.5rem;">Admin</button>
                <button class="mobile-menu" type="button" aria-label="Open navigation menu" aria-controls="primaryNav" aria-expanded="false">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
        </div>
    </nav>

    <form id="form1" runat="server">
        <div class="page-wrapper">

            <div class="page-header">
                <h1>Booking Calendar</h1>
                <p>Check available dates before booking — we never double-book.</p>
            </div>

            <div class="calendar-box">
                <div class="nav-header">
                    <asp:LinkButton ID="btnPrev" runat="server" OnClick="btnPrev_Click" CssClass="btn-nav">&#8592; Prev</asp:LinkButton>
                    <asp:Label ID="lblMonthYear" runat="server" CssClass="month-label" />
                    <asp:LinkButton ID="btnNext" runat="server" OnClick="btnNext_Click" CssClass="btn-nav">Next &#8594;</asp:LinkButton>
                </div>

                <div class="grid">
                    <div class="day-header">Sun</div>
                    <div class="day-header">Mon</div>
                    <div class="day-header">Tue</div>
                    <div class="day-header">Wed</div>
                    <div class="day-header">Thu</div>
                    <div class="day-header">Fri</div>
                    <div class="day-header">Sat</div>

                    <asp:Repeater ID="rptCalendar" runat="server" OnItemCommand="rptCalendar_ItemCommand">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkDay" runat="server"
                                CommandName="SelectDay"
                                CommandArgument='<%# Eval("DayNumber") %>'
                                Enabled='<%# Eval("IsAvailable") %>'
                                CssClass='<%# Eval("CssClass") %>'>
                                <%# Eval("DayNumber") %>
                                <span class="status-text"><%# Eval("Status") %></span>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <div class="legend">
                    <div class="legend-item"><div class="box available"></div> Available</div>
                    <div class="legend-item"><div class="box booked"></div> Booked</div>
                    <div class="legend-item"><div class="box past"></div> Past</div>
                    <div class="legend-item"><div class="box" style="border:1.5px solid var(--primary-gold); background:#fff8e8;"></div> Today</div>
                </div>

                <asp:Panel ID="pnlBooking" runat="server" Visible="false" CssClass="booking-actions">
                    <asp:Label ID="lblSelection" runat="server" />
                    <div style="margin-top:0.75rem;">
                        <asp:Button ID="btnBook" runat="server" Text="Book This Date"
                            CssClass="btn-book" OnClick="btnBook_Click" />
                    </div>
                </asp:Panel>
            </div>

        </div>
    </form>

    <!-- Footer -->
    <footer style="background:#f0ebe4;padding:3rem 5% 0;margin-top:4rem;border-top:1px solid #e5dcd0;">
        <div style="max-width:1400px;margin:0 auto;display:grid;grid-template-columns:2fr 1fr 1.2fr 1fr;gap:3rem;padding-bottom:2.5rem;">
            <div>
                <div style="font-family:'Playfair Display',serif;font-size:1.2rem;font-weight:700;color:#2e211b;margin-bottom:0.75rem;">Castro Catering</div>
                <p style="color:#756e64;font-size:0.88rem;line-height:1.7;">We are a home-based caterer focused on making celebrations accessible to everyone. Affordable, delicious food packages for every special occasion.</p>
            </div>
            <div>
                <h4 style="font-family:'Playfair Display',serif;font-size:1rem;font-weight:600;color:#2e211b;margin-bottom:1rem;">Quick Links</h4>
                <ul style="list-style:none;">
                    <li style="margin-bottom:0.6rem;"><a href="Packages.aspx" style="color:#756e64;text-decoration:none;font-size:0.88rem;">Our Packages</a></li>
                    <li style="margin-bottom:0.6rem;"><a href="Booking.aspx" style="color:#756e64;text-decoration:none;font-size:0.88rem;">Book an Event</a></li>
                    <li style="margin-bottom:0.6rem;"><a href="SmartPicker.aspx" style="color:#756e64;text-decoration:none;font-size:0.88rem;">Smart Pick</a></li>
                    <li style="margin-bottom:0.6rem;"><a href="AboutUs.aspx" style="color:#756e64;text-decoration:none;font-size:0.88rem;">About Us</a></li>
                </ul>
            </div>
            <div>
                <h4 style="font-family:'Playfair Display',serif;font-size:1rem;font-weight:600;color:#2e211b;margin-bottom:1rem;">Contact</h4>
                <div style="display:flex;align-items:flex-start;gap:0.6rem;margin-bottom:0.65rem;color:#756e64;font-size:0.88rem;">
                    <span>📞</span><span>0967 539 3045</span>
                </div>
                <div style="display:flex;align-items:flex-start;gap:0.6rem;color:#756e64;font-size:0.88rem;">
                    <span>📍</span><span>Argao, Cebu</span>
                </div>
            </div>
            <div>
                <h4 style="font-family:'Playfair Display',serif;font-size:1rem;font-weight:600;color:#2e211b;margin-bottom:1rem;">Follow Us</h4>
                <div style="display:flex;gap:0.75rem;">
                    <a href="#" aria-label="Facebook" style="width:36px;height:36px;border-radius:50%;background:#e5dcd0;display:flex;align-items:center;justify-content:center;color:#493a2f;text-decoration:none;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                    </a>
                    <a href="#" aria-label="Instagram" style="width:36px;height:36px;border-radius:50%;background:#e5dcd0;display:flex;align-items:center;justify-content:center;color:#493a2f;text-decoration:none;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg>
                    </a>
                </div>
            </div>
        </div>
        <div style="max-width:1400px;margin:0 auto;padding:1.25rem 0;border-top:1px solid #e5dcd0;text-align:center;color:#9e9189;font-size:0.82rem;">
            <p>&copy; 2026 Castro Catering Services. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // ── Auth guard ──
        (function() {
            var user = null;
            try { user = JSON.parse(localStorage.getItem('castroUser')); } catch(e) {}
            if (!user || !user.username) { window.location.href = 'LoginSignup.aspx'; }
        })();

        function logout() {
            localStorage.removeItem('castroUser');
            window.location.href = 'LoginSignup.aspx';
        }

        /* ── Admin Login Modal ── */
        function showAdminLogin() {
            document.getElementById('adminLoginOverlay').style.display = 'flex';
            document.getElementById('adminUsername').value = '';
            document.getElementById('adminPassword').value = '';
            document.getElementById('adminError').style.display = 'none';
            setTimeout(function(){ document.getElementById('adminUsername').focus(); }, 100);
        }
        function closeAdminLogin() {
            document.getElementById('adminLoginOverlay').style.display = 'none';
        }
        function submitAdminLogin() {
            var u = document.getElementById('adminUsername').value.trim();
            var p = document.getElementById('adminPassword').value;
            if (u === 'admin' && p === 'admin123') {
                closeAdminLogin();
                window.location.href = 'AdminDashboard.aspx';
            } else {
                document.getElementById('adminError').style.display = 'block';
            }
        }
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') closeAdminLogin();
        });
    </script>
    <!-- Admin Login Modal -->
    <div id="adminLoginOverlay" style="display:none;position:fixed;inset:0;background:rgba(33,28,24,0.65);z-index:9999;align-items:center;justify-content:center;backdrop-filter:blur(4px);" onclick="if(event.target===this)closeAdminLogin()">
        <div style="background:#fff;border-radius:16px;padding:2.5rem 2rem;width:100%;max-width:380px;box-shadow:0 20px 60px rgba(0,0,0,0.3);position:relative;font-family:'Inter',sans-serif;">
            <button onclick="closeAdminLogin()" style="position:absolute;top:1rem;right:1rem;background:none;border:none;font-size:1.25rem;cursor:pointer;color:#756e64;line-height:1;">&times;</button>
            <div style="text-align:center;margin-bottom:1.5rem;">
                <div style="font-size:2rem;margin-bottom:0.5rem;">🔐</div>
                <h2 style="font-family:'Playfair Display',serif;font-size:1.4rem;color:#4A3F35;margin-bottom:0.25rem;">Admin Access</h2>
                <p style="font-size:0.85rem;color:#756e64;">Enter your admin credentials to continue.</p>
            </div>
            <div style="margin-bottom:1rem;">
                <label style="display:block;font-size:0.72rem;font-weight:600;color:#8a8177;letter-spacing:1.2px;text-transform:uppercase;margin-bottom:0.4rem;">Username</label>
                <input id="adminUsername" type="text" placeholder="admin" onkeydown="if(event.key==='Enter')submitAdminLogin()"
                    style="width:100%;padding:0.65rem 0.9rem;border:1px solid #e5dcd0;border-radius:8px;font-family:'Inter',sans-serif;font-size:0.9rem;color:#2C2420;background:#fcfbf9;outline:none;box-sizing:border-box;"
                    onfocus="this.style.borderColor='#C9A961';this.style.boxShadow='0 0 0 3px rgba(201,169,97,0.15)'"
                    onblur="this.style.borderColor='#e5dcd0';this.style.boxShadow='none'" />
            </div>
            <div style="margin-bottom:1.25rem;">
                <label style="display:block;font-size:0.72rem;font-weight:600;color:#8a8177;letter-spacing:1.2px;text-transform:uppercase;margin-bottom:0.4rem;">Password</label>
                <input id="adminPassword" type="password" placeholder="••••••••" onkeydown="if(event.key==='Enter')submitAdminLogin()"
                    style="width:100%;padding:0.65rem 0.9rem;border:1px solid #e5dcd0;border-radius:8px;font-family:'Inter',sans-serif;font-size:0.9rem;color:#2C2420;background:#fcfbf9;outline:none;box-sizing:border-box;"
                    onfocus="this.style.borderColor='#C9A961';this.style.boxShadow='0 0 0 3px rgba(201,169,97,0.15)'"
                    onblur="this.style.borderColor='#e5dcd0';this.style.boxShadow='none'" />
            </div>
            <div id="adminError" style="display:none;background:#fff0f0;border:1px solid #f5c0c0;border-radius:8px;padding:0.6rem 0.9rem;font-size:0.83rem;color:#c40000;margin-bottom:1rem;text-align:center;">
                Invalid username or password.
            </div>
            <button onclick="submitAdminLogin()"
                style="width:100%;padding:0.75rem;background:#C9A961;border:none;border-radius:8px;font-family:'Inter',sans-serif;font-weight:700;font-size:0.9rem;color:#2C2420;cursor:pointer;box-shadow:0 2px 12px rgba(201,169,97,0.3);"
                onmouseover="this.style.background='#a07535';this.style.color='white'"
                onmouseout="this.style.background='#C9A961';this.style.color='#2C2420'">
                Sign In to Admin
            </button>
        </div>
    </div>
</body>
</html>