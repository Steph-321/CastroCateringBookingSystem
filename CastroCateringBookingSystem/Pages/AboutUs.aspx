<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AboutUs.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.AboutUs" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About Us - Castro Catering</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-gold: #C9A961;
            --dark-brown: #4A3F35;
            --light-beige: #F5F1E8;
            --cream: #FAF8F3;
            --text-dark: #2C2420;
            --text-light: #6B5B4F;
            --white: #FFFFFF;
        }

        body {
            font-family: 'Inter', sans-serif;
            color: var(--text-dark);
            background-color: var(--cream);
            line-height: 1.6;
        }

        h1, h2, h3, h4 {
            font-family: 'Playfair Display', serif;
        }

        /* Navigation */
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 100px 5% 0;
        }

        /* ── Hero ── */
        .page-hero {
            text-align: center;
            padding: 3.5rem 0 3rem;
            border-bottom: 1px solid var(--border-light);
            margin-bottom: 3rem;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }
        .page-hero h1 {
            font-size: 2.6rem;
            color: var(--dark-brown);
            margin-bottom: 0.75rem;
            line-height: 1.2;
        }
        .page-hero p {
            font-size: 1rem;
            color: var(--text-light);
            max-width: 560px;
            margin: 0 auto;
            line-height: 1.75;
        }
        .gold-divider {
            width: 48px;
            height: 3px;
            background: var(--primary-gold);
            margin: 1.25rem auto;
            border-radius: 2px;
        }

        /* ── Story row ── */
        .story-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
            align-items: center;
            margin-bottom: 2.5rem;
        }
        .story-image {
            border-radius: 14px;
            overflow: hidden;
            aspect-ratio: 4/3;
            position: relative;
        }
        .story-image img {
            position: absolute;
            inset: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        @media (max-width: 768px) { .story-row { grid-template-columns: 1fr; } }

        /* ── Sections ── */
        .about-section {
            margin-bottom: 2.5rem;
        }
        .about-section h2 {
            font-size: 1.5rem;
            color: var(--dark-brown);
            margin-bottom: 0.85rem;
        }
        .about-section p {
            color: var(--text-light);
            font-size: 0.95rem;
            line-height: 1.85;
            margin-bottom: 0.85rem;
            max-width: 700px;
        }

        /* ── Values grid ── */
        .values-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.25rem;
            margin-top: 1.5rem;
        }
        @media (max-width: 968px) { .values-grid { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 560px)  { .values-grid { grid-template-columns: 1fr; } }
        .value-card {
            background: var(--bg-white);
            border: 1px solid var(--border-light);
            border-radius: 12px;
            padding: 1.5rem 1.25rem;
            text-align: center;
            transition: box-shadow 0.2s;
        }
        .value-card:hover { box-shadow: 0 4px 16px rgba(0,0,0,0.07); }
        .value-icon { font-size: 1.75rem; margin-bottom: 0.6rem; }
        .value-card h3 { font-size: 0.95rem; color: var(--dark-brown); margin-bottom: 0.4rem; }
        .value-card p { font-size: 0.83rem; color: var(--text-muted); line-height: 1.6; }

        /* ── Developers ── */
        .dev-section {
            text-align: center;
            margin-bottom: 4rem;
        }
        .dev-section h2 {
            font-size: 1.75rem;
            color: var(--dark-brown);
            margin-bottom: 0.5rem;
        }
        .dev-section .section-sub {
            font-size: 0.95rem;
            color: var(--text-light);
            margin-bottom: 2.5rem;
        }
        .dev-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
            max-width: 860px;
            margin: 0 auto;
        }
        @media (max-width: 640px) { .dev-grid { grid-template-columns: 1fr; } }
        .dev-card {
            background: var(--bg-white);
            border: 1.5px solid var(--border-light);
            border-top: 4px solid var(--primary-gold);
            border-radius: 16px;
            padding: 2rem 1.5rem 1.5rem;
            text-align: center;
            transition: box-shadow 0.25s, transform 0.25s;
            box-shadow: 0 4px 16px rgba(0,0,0,0.06);
        }
        .dev-card:hover {
            box-shadow: 0 12px 32px rgba(201,169,97,0.18);
            transform: translateY(-4px);
            border-top-color: var(--dark-brown);
        }
        .dev-photo {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 1rem;
            display: block;
            border: 4px solid var(--primary-gold);
            outline: 3px solid var(--light-beige);
            background: var(--light-beige);
        }
        .dev-photo-placeholder {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 0 auto 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.2rem;
            background: linear-gradient(135deg, var(--primary-gold), var(--light-gold));
            border: 4px solid var(--primary-gold);
            outline: 3px solid var(--light-beige);
            color: white;
            font-weight: 700;
        }
        .dev-name { font-family: 'Playfair Display', serif; font-size: 1.05rem; font-weight: 600; color: var(--dark-brown); margin-bottom: 0.25rem; }
        .dev-role { font-size: 0.8rem; color: var(--primary-gold); font-weight: 600; text-transform: uppercase; letter-spacing: 0.8px; margin-bottom: 0.6rem; }
        .dev-desc { font-size: 0.83rem; color: var(--text-light); line-height: 1.6; }
        .cta-section {
            background: linear-gradient(135deg, var(--primary-gold), var(--light-gold));
            border-radius: 16px;
            padding: 2.5rem 2rem;
            text-align: center;
            margin-bottom: 4rem;
        }
        .cta-section h2 { color: var(--text-dark); font-size: 1.75rem; margin-bottom: 0.6rem; }
        .cta-section p  { color: rgba(44,36,32,0.8); font-size: 0.95rem; margin-bottom: 1.25rem; }
        .btn-cta {
            background: var(--dark-brown);
            color: white;
            padding: 0.75rem 2.25rem;
            border: none;
            border-radius: 30px;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: transform 0.25s, box-shadow 0.25s;
        }
        .btn-cta:hover { transform: translateY(-2px); box-shadow: 0 6px 18px rgba(0,0,0,0.2); }

        /* ── Footer ── */
        footer {
            background: #f0ebe4;
            padding: 3rem 5% 0;
            border-top: 1px solid var(--border-light);
        }
        .footer-inner {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 2fr 1fr 1.2fr 1fr;
            gap: 3rem;
            padding-bottom: 2.5rem;
        }
        .footer-brand-name { font-family: 'Playfair Display', serif; font-size: 1.2rem; font-weight: 700; color: #2e211b; margin-bottom: 0.75rem; }
        .footer-brand-desc { color: #756e64; font-size: 0.88rem; line-height: 1.7; }
        .footer-col h4 { font-family: 'Playfair Display', serif; font-size: 1rem; font-weight: 600; color: #2e211b; margin-bottom: 1rem; }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 0.6rem; }
        .footer-col ul li a { color: #756e64; text-decoration: none; font-size: 0.88rem; transition: color 0.2s; }
        .footer-col ul li a:hover { color: var(--primary-gold); }
        .footer-contact-item { display: flex; align-items: flex-start; gap: 0.6rem; margin-bottom: 0.65rem; color: #756e64; font-size: 0.88rem; }
        .footer-social { display: flex; gap: 0.75rem; margin-top: 0.25rem; }
        .footer-social a { width: 36px; height: 36px; border-radius: 50%; background: #e5dcd0; display: flex; align-items: center; justify-content: center; color: #493a2f; text-decoration: none; transition: background 0.2s, color 0.2s; }
        .footer-social a:hover { background: var(--primary-gold); color: #fff; }
        .footer-bottom { max-width: 1400px; margin: 0 auto; padding: 1.25rem 0; border-top: 1px solid #e5dcd0; text-align: center; color: #9e9189; font-size: 0.82rem; }

        @media (max-width: 968px) { .footer-inner { grid-template-columns: 1fr 1fr; gap: 2rem; } }
        @media (max-width: 560px) { .footer-inner { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <form id="form1" runat="server">

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
                <li><a href="Calendar.aspx">Calendar</a></li>
                <li><a href="SmartPicker.aspx">Smart Pick</a></li>
                <li><a href="Reviews.aspx">Reviews</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="AboutUs.aspx" class="active">About Us</a></li>
            </ul>

            <div class="nav-icons">
                <button class="btn-login" type="button" onclick="logout()">Log Out</button>
                <button class="btn-login" type="button" onclick="showAdminLogin()" style="margin-left:0.5rem;">Admin</button>
                <button class="mobile-menu" type="button" aria-label="Open navigation menu" aria-controls="primaryNav" aria-expanded="false">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
        </div>
    </nav>

    <!-- Page Content -->
    <div class="page-wrapper">

        <div class="page-hero">
            <h1>About Castro Catering</h1>
            <div class="gold-divider"></div>
            <p>For over 15 years, we've been crafting elegant moments for families, couples, and organizations across the Philippines — one dish at a time.</p>
        </div>

        <div class="about-inner">
            <div class="story-row">
                <div class="about-section">
                    <h2>Our Story</h2>
                    <p>Castro Catering was founded with a simple belief: that great food, served with care, transforms any gathering into an unforgettable experience. What started as a small family kitchen has grown into one of the region's most trusted catering services.</p>
                    <p>From intimate private dinners to grand wedding receptions, we bring the same passion and attention to detail to every event we serve — ensuring every detail, from the menu to the presentation, exceeds expectations.</p>
                </div>
                <div class="story-image">
                    <img src="../Assests/cover2.jpg" alt="Castro Catering" />
                </div>
            </div>

            <div class="about-section">
                <h2>Our Values</h2>
                <div class="values-grid">
                    <div class="value-card">
                        <div class="value-icon">🍽️</div>
                        <h3>Quality First</h3>
                        <p>We source only the freshest ingredients and prepare every dish with precision and care.</p>
                    </div>
                    <div class="value-card">
                        <div class="value-icon">🤝</div>
                        <h3>Client Partnership</h3>
                        <p>We listen, collaborate, and customize every event to reflect your unique vision.</p>
                    </div>
                    <div class="value-card">
                        <div class="value-icon">✨</div>
                        <h3>Elegant Execution</h3>
                        <p>From setup to service, every detail is handled with professionalism and grace.</p>
                    </div>
                    <div class="value-card">
                        <div class="value-icon">💛</div>
                        <h3>Heartfelt Service</h3>
                        <p>We treat every event as if it were our own — with warmth, dedication, and pride.</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="cta-section">
            <h2>Ready to create something special?</h2>
            <p>Let's talk about your event and build the perfect experience together.</p>
            <a href="Booking.aspx" class="btn-cta">Book an Event</a>
        </div>

        <!-- ── Meet the Developers ── -->
        <div class="dev-section">
            <h2>Meet the Developers</h2>
            <div class="gold-divider"></div>
            <p class="section-sub">The team behind the Castro Catering Booking System</p>

            <div class="dev-grid">

                <div class="dev-card">
                    <img src="../Assests/stephanie.jpg" alt="stephanie" class="dev-photo" />
                    <div class="dev-name">STEPHANIE ONG</div>
                    <div class="dev-role">Full Stack Developer</div>
                    <p class="dev-desc">Responsible for system architecture, database design, and back-end development.</p>
                </div>

                <div class="dev-card">
                    <img src="../Assests/alyssa.jpg" alt="alyssa" class="dev-photo" /> 
                    <div class="dev-name">ALYSSA TEO</div>
                    <div class="dev-role">Database Administrator</div>
                    <p class="dev-desc">Managed the SQL Server database, queries, and data integrity for the booking system.</p>
                </div>

                <div class="dev-card">
                    <img src="../Assests/erilyn.jpg" alt="erilyn" class="dev-photo" />
                    <div class="dev-name">ERILYN KATE ABREGANA</div>
                    <div class="dev-role">UI/UX Designer</div>
                    <p class="dev-desc">Designed the user interface and ensured a seamless, elegant experience across all pages.</p>
                </div>

            </div>
        </div>

    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-inner">
            <div>
                <div class="footer-brand-name">Castro Catering</div>
                <p class="footer-brand-desc">We are a home-based caterer focused on making celebrations accessible to everyone. Affordable, delicious food packages for every special occasion.</p>
            </div>
            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="Packages.aspx">Our Packages</a></li>
                    <li><a href="Booking.aspx">Book an Event</a></li>
                    <li><a href="SmartPicker.aspx">Smart Pick</a></li>
                    <li><a href="AboutUs.aspx">About Us</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Contact</h4>
                <div class="footer-contact-item"><span>📞</span><span>0967 539 3045</span></div>
                <div class="footer-contact-item"><span>📍</span><span>Argao, Cebu</span></div>
            </div>
            <div class="footer-col">
                <h4>Follow Us</h4>
                <div class="footer-social">
                    <a href="#" aria-label="Facebook">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg>
                    </a>
                    <a href="#" aria-label="Instagram">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg>
                    </a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 Castro Catering Services. All rights reserved.</p>
        </div>
    </footer>

    </form>

    <script>
        function logout() {
            localStorage.removeItem('currentUser');
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
                    style="width:100%;padding:0.65rem 0.9rem;border:1px solid #e5dcd0;border-radius:8px;font-family:'Inter',sans-serif;font-size:0.9rem;color:#2C2420;background:#fcfbf9;outline:none;box-sizing:border-box;transition:border-color 0.25s;"
                    onfocus="this.style.borderColor='#C9A961';this.style.boxShadow='0 0 0 3px rgba(201,169,97,0.15)'"
                    onblur="this.style.borderColor='#e5dcd0';this.style.boxShadow='none'" />
            </div>
            <div style="margin-bottom:1.25rem;">
                <label style="display:block;font-size:0.72rem;font-weight:600;color:#8a8177;letter-spacing:1.2px;text-transform:uppercase;margin-bottom:0.4rem;">Password</label>
                <input id="adminPassword" type="password" placeholder="••••••••" onkeydown="if(event.key==='Enter')submitAdminLogin()"
                    style="width:100%;padding:0.65rem 0.9rem;border:1px solid #e5dcd0;border-radius:8px;font-family:'Inter',sans-serif;font-size:0.9rem;color:#2C2420;background:#fcfbf9;outline:none;box-sizing:border-box;transition:border-color 0.25s;"
                    onfocus="this.style.borderColor='#C9A961';this.style.boxShadow='0 0 0 3px rgba(201,169,97,0.15)'"
                    onblur="this.style.borderColor='#e5dcd0';this.style.boxShadow='none'" />
            </div>
            <div id="adminError" style="display:none;background:#fff0f0;border:1px solid #f5c0c0;border-radius:8px;padding:0.6rem 0.9rem;font-size:0.83rem;color:#c40000;margin-bottom:1rem;text-align:center;">
                Invalid username or password.
            </div>
            <button onclick="submitAdminLogin()"
                style="width:100%;padding:0.75rem;background:#C9A961;border:none;border-radius:8px;font-family:'Inter',sans-serif;font-weight:700;font-size:0.9rem;color:#2C2420;cursor:pointer;transition:all 0.3s;box-shadow:0 2px 12px rgba(201,169,97,0.3);"
                onmouseover="this.style.background='#a07535';this.style.color='white'"
                onmouseout="this.style.background='#C9A961';this.style.color='#2C2420'">
                Sign In to Admin
            </button>
        </div>
    </div>
</body>
</html>
