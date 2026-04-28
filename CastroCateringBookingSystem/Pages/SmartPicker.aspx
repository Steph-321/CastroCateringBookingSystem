<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SmartPicker.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.SmartPicker" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Pick - Castro Catering</title>
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
            --off-white: #fbf9f5;
            --bg-cream: #f9f6f2;
            --bg-white: #ffffff;
            --bg-beige: #f0ebe4;
            --text-dark: #2e211b;
            --text-brown: #493a2f;
            --text-gray: #756e64;
            --border-light: #e5dcd0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-cream);
            color: var(--text-dark);
            line-height: 1.6;
        }

        h1, h2, h3 {
            font-family: 'Playfair Display', serif;
        }

        /* ── Navigation ── */
        nav {
            background: var(--bg-white);
            padding: 1rem 5%;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            box-sizing: border-box;
        }
        .nav-container { max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center; gap: 1rem; }
        .logo { text-decoration: none; display: flex; align-items: center; gap: 0.75rem; min-width: 0; }
        .logo-text { display: flex; flex-direction: column; line-height: 1.1; min-width: 0; }
        .logo-title { font-family: 'Playfair Display', serif; font-size: 1.15rem; font-weight: 700; color: var(--text-dark); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .logo-subtitle { font-size: 0.8rem; color: var(--text-gray); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .nav-links { display: flex; gap: 1.75rem; list-style: none; align-items: center; }
        .nav-links a { text-decoration: none; color: var(--text-dark); font-weight: 500; font-size: 0.9rem; transition: color 0.3s; padding: 0.35rem 0.2rem; position: relative; }
        .nav-links a:hover, .nav-links a.active { color: var(--primary-gold); }
        .nav-links a.active::after { content: ''; position: absolute; left: 0; right: 0; bottom: -6px; height: 2px; border-radius: 2px; background: var(--primary-gold); }
        .nav-icons { display: flex; gap: 1rem; align-items: center; }
        .btn-login, .btn-nav-action {
            background: transparent;
            border: 1px solid var(--primary-gold);
            color: var(--text-dark);
            padding: 0.45rem 1.25rem;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 500;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: all 0.3s;
        }
        .btn-login:hover, .btn-nav-action:hover { background: var(--primary-gold); color: white; }
        .mobile-menu { display: none; cursor: pointer; border: 1px solid var(--border-light); background: var(--bg-white); border-radius: 10px; padding: 0.5rem 0.6rem; line-height: 0; }
        .mobile-menu span { display: block; width: 22px; height: 2px; background: var(--text-dark); transition: 0.3s; border-radius: 2px; }
        .mobile-menu span + span { margin-top: 5px; }
        .mobile-menu[aria-expanded="true"] span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
        .mobile-menu[aria-expanded="true"] span:nth-child(2) { opacity: 0; }
        .mobile-menu[aria-expanded="true"] span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

        @media (max-width: 968px) {
            .nav-links {
                display: none;
                position: absolute;
                top: 70px;
                left: 0;
                right: 0;
                background: var(--bg-white);
                flex-direction: column;
                padding: 1.25rem 5%;
                box-shadow: 0 10px 30px rgba(0,0,0,0.10);
                border-top: 1px solid var(--border-light);
                gap: 1rem;
                z-index: 1001;
            }

            .nav-links.open {
                display: flex;
            }

            .nav-links a.active::after {
                display: none;
            }

            .mobile-menu {
                display: inline-flex;
                flex-direction: column;
                justify-content: center;
            }
        }

        /* Main Content */
        .main-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 6.5rem 5% 4rem;
        }

        .page-header {
            margin-bottom: 2.5rem;
        }

        .page-header h1 {
            font-size: 2.2rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: var(--text-gray);
            font-size: 1rem;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1.5fr;
            gap: 2rem;
        }

        /* Form Card */
        .form-card {
            background: var(--bg-white);
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
        }

        .form-section-title {
            font-size: 1.2rem;
            color: var(--text-dark);
            margin-bottom: 1.5rem;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: var(--text-brown);
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            background: var(--bg-cream);
            transition: all 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: var(--primary-gold);
            background: var(--bg-white);
            box-shadow: 0 0 0 3px rgba(194, 147, 74, 0.1);
        }

        .btn-recommend {
            width: 100%;
            background: linear-gradient(135deg, var(--primary-gold), var(--light-gold));
            color: white;
            border: none;
            padding: 1rem;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }

        .btn-recommend:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(194, 147, 74, 0.3);
        }

        /* Result Card */
        .result-card {
            background: var(--bg-white);
            border-radius: 16px;
            padding: 3rem;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            min-height: 400px;
        }

        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .empty-icon {
            width: 64px;
            height: 64px;
            background: var(--bg-beige);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-bottom: 1.5rem;
        }

        .empty-state h3 {
            font-size: 1.4rem;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
        }

        .empty-state p {
            color: var(--text-gray);
            max-width: 400px;
            line-height: 1.6;
        }

        .result-content {
            display: none;
            width: 100%;
        }

        .result-content.show {
            display: block;
        }

        .package-recommendation {
            background: linear-gradient(135deg, var(--bg-cream), var(--bg-beige));
            border-radius: 12px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            border: 2px solid var(--primary-gold);
        }

        .package-name {
            font-size: 1.8rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-family: 'Playfair Display', serif;
        }

        .package-price {
            font-size: 2rem;
            color: var(--primary-gold);
            font-weight: 700;
            margin-bottom: 1rem;
        }

        .package-details {
            text-align: left;
            margin-top: 1.5rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--border-light);
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .btn-book-now {
            background: var(--primary-gold);
            color: white;
            border: none;
            padding: 1rem 2rem;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 1rem;
        }

        .btn-book-now:hover {
            background: var(--text-brown);
            transform: translateY(-2px);
        }

        /* Footer */
        footer {
            background: #f0ebe4;
            padding: 3rem 5% 0;
            margin-top: 4rem;
            border-top: 1px solid #e5dcd0;
        }

        .footer-inner {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 2fr 1fr 1.2fr 1fr;
            gap: 3rem;
            padding-bottom: 2.5rem;
        }

        .footer-brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem;
            font-weight: 700;
            color: #2e211b;
            margin-bottom: 0.75rem;
        }

        .footer-brand-desc {
            color: #756e64;
            font-size: 0.88rem;
            line-height: 1.7;
        }

        .footer-col h4 {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 600;
            color: #2e211b;
            margin-bottom: 1rem;
        }

        .footer-col ul {
            list-style: none;
        }

        .footer-col ul li {
            margin-bottom: 0.6rem;
        }

        .footer-col ul li a {
            color: #756e64;
            text-decoration: none;
            font-size: 0.88rem;
            transition: color 0.2s;
        }

        .footer-col ul li a:hover {
            color: #c2934a;
        }

        .footer-contact-item {
            display: flex;
            align-items: flex-start;
            gap: 0.6rem;
            margin-bottom: 0.65rem;
            color: #756e64;
            font-size: 0.88rem;
        }

        .footer-contact-item span.icon {
            font-size: 0.95rem;
            margin-top: 1px;
            flex-shrink: 0;
        }

        .footer-social {
            display: flex;
            gap: 0.75rem;
            margin-top: 0.25rem;
        }

        .footer-social a {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #e5dcd0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #493a2f;
            text-decoration: none;
            font-size: 0.95rem;
            transition: background 0.2s, color 0.2s;
        }

        .footer-social a:hover {
            background: #c2934a;
            color: #fff;
        }

        .footer-bottom {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1.25rem 0;
            border-top: 1px solid #e5dcd0;
            text-align: center;
            color: #9e9189;
            font-size: 0.82rem;
        }

        @media (max-width: 968px) {
            .footer-inner {
                grid-template-columns: 1fr 1fr;
                gap: 2rem;
            }
        }

        @media (max-width: 560px) {
            .footer-inner {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 968px) {
            .content-grid {
                grid-template-columns: 1fr;
            }
            
            .nav-links {
                display: none;
            }
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
                <li><a href="Calendar.aspx">Calendar</a></li>
                <li><a href="SmartPicker.aspx" class="active">Smart Pick</a></li>
                <li><a href="Reviews.aspx">Reviews</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="AboutUs.aspx">About Us</a></li>
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

    <!-- Main Content -->
    <div class="main-content">
        <div class="page-header">
            <h1>Smart Package Recommendation</h1>
            <p>Tell us about your event and we'll suggest the best Castro package for you.</p>
        </div>

        <div class="content-grid">
            <!-- Form Section -->
            <div class="form-card">
                <h2 class="form-section-title">Your Event</h2>
                <form id="recommendationForm">
                    <div class="form-group">
                        <label for="budget">Total Budget (₱)</label>
                        <input type="number" id="budget" name="budget" placeholder="50000" required min="5000">
                    </div>

                    <div class="form-group">
                        <label for="guests">Number of Guests</label>
                        <input type="number" id="guests" name="guests" placeholder="60" required min="10">
                    </div>

                    <div class="form-group">
                        <label for="eventType">Event Type</label>
                        <select id="eventType" name="eventType" required>
                            <option value="wedding">Wedding</option>
                            <option value="birthday">Birthday</option>
                            <option value="corporate">Corporate Event</option>
                            <option value="anniversary">Anniversary</option>
                            <option value="debut">Debut</option>
                            <option value="family">Family Gathering</option>
                        </select>
                    </div>

                    <button type="submit" class="btn-recommend">
                        <span>✨</span> Get Recommendation
                    </button>
                </form>
            </div>

            <!-- Result Section -->
            <div class="result-card" id="resultCard">
                <div class="empty-state" id="emptyState">
                    <div class="empty-icon">✨</div>
                    <h3>Your suggestion will appear here</h3>
                    <p>Enter your budget and guest count and we'll match the best package from our catalog.</p>
                </div>

                <div class="result-content" id="resultContent">
                    <div class="package-recommendation">
                        <div class="package-name" id="recPackageName">Grand Wedding Feast</div>
                        <div class="package-price" id="recPackagePrice">₱1,200/guest</div>
                        <p id="recPackageDesc">Perfect for elegant weddings with full-service dining experience</p>
                        
                        <div class="package-details">
                            <div class="detail-row">
                                <span>Per Guest Cost:</span>
                                <strong id="recPerGuest">₱1,200</strong>
                            </div>
                            <div class="detail-row">
                                <span>Total for <span id="recGuests">60</span> guests:</span>
                                <strong id="recTotal">₱72,000</strong>
                            </div>
                            <div class="detail-row">
                                <span>Budget Remaining:</span>
                                <strong id="recRemaining" style="color: var(--success);">₱0</strong>
                            </div>
                        </div>
                    </div>
                    
                    <button class="btn-book-now" onclick="bookRecommended()">
                        Book This Package →
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer>
        <div class="footer-inner">
            <div>
                <div class="footer-brand-name">Castro Catering</div>
                <p class="footer-brand-desc">We are a home-based caterer focused on making celebrations accessible to everyone. We provide affordable, yet delicious, food packages for birthdays, christenings, anniversaries, and other special events.</p>
            </div>

            <div class="footer-col">
                <h4>Quick Links</h4>
                <ul>
                    <li><a href="packages.html">Our Packages</a></li>
                    <li><a href="booking.html">Book an Event</a></li>
                    <li><a href="smart-pick.html">Smart Pick</a></li>
                    <li><a href="aboutUs.html">About Us</a></li>
                </ul>
            </div>

            <div class="footer-col">
                <h4>Contact</h4>
                <div class="footer-contact-item">
                    <span class="icon">📞</span>
                    <span>0967 539 3045</span>
                </div>
                <div class="footer-contact-item">
                    <span class="icon">📍</span>
                    <span>Argao, Cebu</span>
                </div>
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
            <p>© 2026 Castro Catering Services. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Package database
        const packages = [
            { name: 'Kids Birthday Fiesta', price: 650, type: ['birthday'], desc: 'Colorful and fun menu perfect for children\'s parties' },
            { name: 'Corporate Lite Lunch', price: 550, type: ['corporate'], desc: 'Quick and efficient catering for business meetings' },
            { name: 'Family Gathering Spread', price: 800, type: ['family', 'birthday'], desc: 'Hearty Filipino favorites for family reunions' },
            { name: 'Birthday Bliss', price: 850, type: ['birthday', 'debut'], desc: 'Celebratory menu for milestone birthdays' },
            { name: 'Cocktail Reception', price: 900, type: ['corporate', 'anniversary'], desc: 'Elegant canapés and signature drinks' },
            { name: 'Classic Wedding Buffet', price: 950, type: ['wedding'], desc: 'Traditional wedding buffet with varied options' },
            { name: 'Debut Soirée', price: 1050, type: ['debut', 'birthday'], desc: 'Sophisticated menu for 18th birthday celebrations' },
            { name: 'Anniversary Elegance', price: 1100, type: ['anniversary', 'wedding'], desc: 'Romantic and refined dinner experience' },
            { name: 'Grand Wedding Feast', price: 1200, type: ['wedding'], desc: 'Premium wedding package with full-service elegance' },
            { name: 'Corporate Premium Gala', price: 1300, type: ['corporate'], desc: 'Black-tie catering for galas and awards' },
            { name: 'Intimate Private Dining', price: 1500, type: ['anniversary', 'wedding'], desc: 'Chef-curated tasting menus for small gatherings' }
        ];

        document.getElementById('recommendationForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const budget = parseFloat(document.getElementById('budget').value);
            const guests = parseInt(document.getElementById('guests').value);
            const eventType = document.getElementById('eventType').value;
            
            // Calculate max per guest budget
            const maxPerGuest = budget / guests;
            
            // Filter packages that match event type and are within budget
            const matchingPackages = packages.filter(pkg => {
                return pkg.type.includes(eventType) && pkg.price <= maxPerGuest;
            });
            
            // Sort by price (descending) to get the best package within budget
            matchingPackages.sort((a, b) => b.price - a.price);
            
            let recommended;
            
            if (matchingPackages.length > 0) {
                recommended = matchingPackages[0];
            } else {
                // If no exact match, find closest package
                recommended = packages
                    .filter(pkg => pkg.type.includes(eventType))
                    .sort((a, b) => Math.abs(a.price - maxPerGuest) - Math.abs(b.price - maxPerGuest))[0];
                
                if (!recommended) {
                    recommended = packages[0]; // Fallback
                }
            }
            
            // Display recommendation
            displayRecommendation(recommended, budget, guests);
        });

        function displayRecommendation(packageData, budget, guests) {
            const totalCost = packageData.price * guests;
            const remaining = budget - totalCost;
            
            document.getElementById('recPackageName').textContent = packageData.name;
            document.getElementById('recPackagePrice').textContent = `₱${packageData.price.toLocaleString()}/guest`;
            document.getElementById('recPackageDesc').textContent = packageData.desc;
            document.getElementById('recPerGuest').textContent = `₱${packageData.price.toLocaleString()}`;
            document.getElementById('recGuests').textContent = guests;
            document.getElementById('recTotal').textContent = `₱${totalCost.toLocaleString()}`;
            
            const remainingEl = document.getElementById('recRemaining');
            remainingEl.textContent = `₱${remaining.toLocaleString()}`;
            remainingEl.style.color = remaining >= 0 ? 'var(--success)' : 'var(--danger)';
            
            // Hide empty state, show result
            document.getElementById('emptyState').style.display = 'none';
            document.getElementById('resultContent').classList.add('show');
            
            // Store for booking
            sessionStorage.setItem('recommendedPackage', JSON.stringify({
                ...packageData,
                guests: guests,
                totalCost: totalCost
            }));
        }

        function bookRecommended() {
            const pkg = JSON.parse(sessionStorage.getItem('recommendedPackage'));
            if (pkg) {
                // Redirect to booking page with pre-filled data
                window.location.href = `booking.html?package=${encodeURIComponent(pkg.name)}&guests=${pkg.guests}`;
            }
        }

        // ── Auth guard: redirect to login if not logged in ──
        (function() {
            var user = null;
            try { user = JSON.parse(localStorage.getItem('castroUser')); } catch(e) {}
            if (!user || !user.username) { window.location.href = 'LoginSignup.aspx'; return; }
        })();

        // Mobile Menu Toggle (home-style)
        const mobileMenuBtn = document.querySelector('.mobile-menu');
        const primaryNav = document.getElementById('primaryNav');

        function closeMobileNav() {
            if (!primaryNav) return;
            primaryNav.classList.remove('open');
            if (mobileMenuBtn) mobileMenuBtn.setAttribute('aria-expanded', 'false');
        }

        function toggleMobileNav() {
            if (!primaryNav) return;
            const isOpen = primaryNav.classList.toggle('open');
            if (mobileMenuBtn) mobileMenuBtn.setAttribute('aria-expanded', String(isOpen));
        }

        if (mobileMenuBtn) mobileMenuBtn.addEventListener('click', toggleMobileNav);
        document.querySelectorAll('#primaryNav a').forEach(a => a.addEventListener('click', closeMobileNav));

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