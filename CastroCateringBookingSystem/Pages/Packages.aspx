<!DOCTYPE html>
<script runat="server">

    Protected Sub Page_Load(sender As Object, e As EventArgs)

    End Sub
</script>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Packages - Castro Catering</title>
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
            --success: #2d8a53;
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

        .main-content {
            max-width: 1400px;
            margin: 0 auto;
            padding: 6.5rem 5% 4rem;
        }

        .page-header {
            margin-bottom: 2.5rem;
        }

        .page-header h1 {
            font-size: 2.5rem;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
        }

        .page-header p {
            color: var(--text-gray);
            font-size: 1.05rem;
            max-width: 800px;
        }

        .filters-section {
            background: var(--bg-white);
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            align-items: center;
        }

        .search-box {
            flex: 1;
            min-width: 300px;
            position: relative;
        }

        .search-box input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.8rem;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            background: var(--bg-cream);
            transition: all 0.3s;
        }

        .search-box input:focus {
            outline: none;
            border-color: var(--primary-gold);
            background: var(--bg-white);
            box-shadow: 0 0 0 3px rgba(194, 147, 74, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-gray);
        }

        .filter-group {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        .filter-select {
            padding: 0.75rem 2.5rem 0.75rem 1rem;
            border: 1px solid var(--border-light);
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            background: var(--bg-cream);
            cursor: pointer;
            transition: all 0.3s;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23756e64' d='M6 8L1 3h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
        }

        .filter-select:focus {
            outline: none;
            border-color: var(--primary-gold);
        }

        .package-count {
            color: var(--text-gray);
            font-weight: 500;
            white-space: nowrap;
        }

        .packages-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2rem;
        }

        .package-card {
            background: var(--bg-white);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
            transition: transform 0.3s, box-shadow 0.3s;
        }

        .package-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }

        .package-image {
            width: 100%;
            height: 240px;
            background: linear-gradient(135deg, var(--light-gold), var(--primary-gold));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            overflow: hidden;
        }

        .package-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .package-content {
            padding: 1.5rem;
        }

        .package-category {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            background: var(--bg-beige);
            color: var(--primary-gold);
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .package-categories {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-bottom: 0.75rem;
        }

        .package-name {
            font-size: 1.4rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
            font-weight: 600;
        }

        .package-description {
            color: var(--text-gray);
            font-size: 0.95rem;
            margin-bottom: 1rem;
            line-height: 1.6;
        }

        .package-features {
            list-style: none;
            margin-bottom: 1.5rem;
        }

        .package-features li {
            padding: 0.4rem 0;
            color: var(--text-brown);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .package-features li::before {
            content: "✓";
            color: var(--success);
            font-weight: 700;
            font-size: 1.1rem;
        }

        .package-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1.25rem;
            border-top: 1px solid var(--border-light);
        }

        .package-guests {
            color: var(--text-gray);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .package-price {
            text-align: right;
        }

        .price-label {
            font-size: 0.8rem;
            color: var(--text-gray);
            display: block;
        }

        .price-amount {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-gold);
        }

        .price-amount span {
            font-size: 0.9rem;
            font-weight: 400;
            color: var(--text-gray);
        }

        .btn-book-package {
            width: 100%;
            margin-top: 1rem;
            background: linear-gradient(135deg, var(--primary-gold), var(--light-gold));
            color: white;
            border: none;
            padding: 0.9rem;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-book-package:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(194, 147, 74, 0.3);
        }

        /* No Results */
        .no-results {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-gray);
            grid-column: 1 / -1;
        }

        .no-results-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
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

            .packages-grid {
                grid-template-columns: 1fr;
            }

            .filters-section {
                flex-direction: column;
            }

            .search-box {
                min-width: 100%;
            }

            .filter-group {
                width: 100%;
                justify-content: space-between;
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
                <li><a href="Packages.aspx" class="active">Packages</a></li>
                <li><a href="Booking.aspx">Book Now</a></li>
                <li><a href="Calendar.aspx">Calendar</a></li>
                <li><a href="SmartPicker.aspx">Smart Pick</a></li>
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
            <h1>Our Catering Packages</h1>
            <p>Browse our full menu of curated experiences — from intimate private dinners to grand weddings. Every package is fully customizable.</p>
        </div>

        <!-- Filters Section -->
        <div class="filters-section">
            <div class="search-box">
                <span class="search-icon">🔍</span>
                <input type="text" id="searchInput" placeholder="Search packages..." onkeyup="filterPackages()">
            </div>
            
            <div class="filter-group">
                <select id="categoryFilter" class="filter-select" onchange="filterPackages()">
                    <option value="All">All</option>
                    <option value="Wedding">Wedding</option>
                    <option value="Birthday">Birthday</option>
                    <option value="Christening">Christening</option>
                    <option value="Corporate">Corporate</option>
                    <option value="Anniversary">Anniversary</option>
                    <option value="Debut">Debut</option>
                    <option value="Family">Family</option>
                </select>

                <select id="sortFilter" class="filter-select" onchange="sortPackages()">
                    <option value="low-high">Price: Low to High</option>
                    <option value="high-low">Price: High to Low</option>
                    <option value="name">Name: A to Z</option>
                </select>

                <span class="package-count" id="packageCount">12 packages</span>
            </div>
        </div>

        <!-- Packages Grid -->
        <div class="packages-grid" id="packagesGrid">
            <!-- Packages will be dynamically inserted here -->
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
        // ── Auth guard: redirect to login if not logged in ──
        (function() {
            var user = null;
            try { user = JSON.parse(localStorage.getItem('castroUser')); } catch(e) {}
            if (!user || !user.username) { window.location.href = 'LoginSignup.aspx'; return; }
            // Update nav: show username greeting or just keep Log Out
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

        const packages = [
            {
                id: 1,
                name: 'Kids Birthday Fiesta',
                category: ['Birthday'],
                description: 'Colorful, fun-filled menus your little ones will love.',
                features: [
                    'Themed snack bar',
                    'Mini burger & pizza station',
                    'Candy buffet',
                    'Mascot host'
                ],
                guests: '10-100',
                price: 350,
                imageSrc: '../assests/KidsBirthdayFiesta.jpg',
                emoji: '🎈'
            },
            {
                id: 2,
                name: 'Corporate Lite Lunch',
                category: ['Corporate'],
                description: 'Quick, polished catering for workshops and trainings.',
                features: [
                    'Boxed gourmet lunch',
                    'Coffee & tea bar',
                    'Fresh fruit platter',
                    'Eco-friendly packaging'
                ],
                guests: '10-120',
                price: 380,
                imageSrc: '../assests/corporateLiteLunch.jpg',
                emoji: '💼'
            },
            {
                id: 3,
                name: 'Family Gathering Spread',
                category: ['Birthday', 'Anniversary', 'Family'],
                description: 'Hearty Filipino favorites for warm family reunions.',
                features: [
                    'Lechon centerpiece',
                    'Filipino buffet',
                    'Halo-halo bar',
                    'Tables & chairs setup'
                ],
                guests: '15-150',
                price: 420,
                imageSrc: '../assests/family gathering.jpg',
                emoji: '👨‍‍👧👦'
            },
            {
                id: 4,
                name: 'Christening Celebration',
                category: ['Christening', 'Family'],
                description: 'A warm, family-focused spread for your baby’s special day.',
                features: [
                    'Family-style buffet',
                    'Dessert & drinks station',
                    'Soft theme styling',
                    'Warm service staff'
                ],
                guests: '20-200',
                price: 750,
                imageSrc: '../assests/bunyag.jpg',
                emoji: '🕊️'
            },
            {
                id: 5,
                name: 'Cocktail Reception',
                category: ['Corporate', 'Anniversary'],
                description: 'Elegant canapés and signature drinks for stand-up events.',
                features: [
                    'Passed hors d\'oeuvres',
                    'Signature cocktails',
                    'Bartender service',
                    'Cocktail tables'
                ],
                guests: '30-150',
                price: 900,
                imageSrc: '../assests/cocktail.jpg',
                emoji: '🍸'
            },
            {
                id: 6,
                name: 'Classic Wedding Buffet',
                category: ['Wedding'],
                description: 'A timeless wedding essential with varied buffet options.',
                features: [
                    'Multi-cuisine buffet',
                    'Wedding cake service',
                    'Champagne toast',
                    'Elegant table settings'
                ],
                guests: '50-300',
                price: 950,
                imageSrc: '../assests/classicWedding.jpg',
                emoji: '👰'
            },
            {
                id: 7,
                name: 'Debut Soirée',
                category: ['Debut', 'Birthday'],
                description: 'An 18th birthday celebration done in grand style.',
                features: [
                    'Formal dinner service',
                    'Debut cake',
                    '18 candles setup',
                    'Premium beverages'
                ],
                guests: '50-200',
                price: 1050,
                imageSrc: '../assests/debut1.jpg',
                emoji: '👗'
            },
            {
                id: 8,
                name: 'Birthday Bliss',
                category: ['Birthday'],
                description: 'A festive catering package designed to bring joy to every birthday moment.',
                features: [
                    'Custom birthday cake',
                    'Party favorites',
                    'Decoration setup',
                    'Sound system'
                ],
                guests: '20-150',
                price: 850,
                imageSrc: '../assests/birthdayBliss.jpg',
                emoji: '🎂'
            },
            {
                id: 9,
                name: 'Anniversary Elegance',
                category: ['Anniversary', 'Wedding'],
                description: 'A romantic, refined dinner to honor your milestone.',
                features: [
                    'Fine dining experience',
                    'Wine pairing',
                    'Floral centerpieces',
                    'Personalized menu cards'
                ],
                guests: '20-100',
                price: 1400,
                imageSrc: '../assests/anniversaryElegance.jpg',
                emoji: '💍'
            },
            {
                id: 10,
                name: 'Grand Wedding Feast',
                category: ['Wedding'],
                description: 'A timeless celebration with full-service elegance.',
                features: [
                    'Premium multi-course menu',
                    'Grand wedding cake',
                    'Full bar service',
                    'Dedicated event coordinator'
                ],
                guests: '80-500',
                price: 1200,
                imageSrc: '../assests/grandWedding.jpg',
                emoji: '🥂'
            },
            {
                id: 11,
                name: 'Corporate Premium Gala',
                category: ['Corporate'],
                description: 'Black-tie catering for galas, awards, and launches.',
                features: [
                    'Gourmet plated dinner',
                    'Premium wine selection',
                    'Red carpet service',
                    'AV equipment setup'
                ],
                guests: '50-300',
                price: 1500,
                imageSrc: '../assests/corporatePremium.jpg',
                emoji: '🏆'
            },
            {
                id: 12,
                name: 'Intimate Private Dining',
                category: ['Anniversary', 'Wedding', 'Family'],
                description: 'Chef-curated tasting menus for small gatherings.',
                features: [
                    'Private chef service',
                    'Wine pairing',
                    'Customized menu',
                    'Intimate setting'
                ],
                guests: '10-30',
                price: 1800,
                imageSrc: '../assests/initmatePrivateDining.jpg',
                emoji: '🍷'
            }
        ];

        let currentPackages = [...packages];

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            renderPackages();
        });

        function renderPackages() {
            const grid = document.getElementById('packagesGrid');
            const count = document.getElementById('packageCount');
            
            grid.innerHTML = currentPackages.map(pkg => `
                <div class="package-card">
                    <div class="package-image">
                        ${pkg.imageSrc ? `<img src="${pkg.imageSrc}" alt="${pkg.name}">` : pkg.emoji}
                    </div>
                    <div class="package-content">
                        <div class="package-categories">
                            ${pkg.category.map(cat => `<span class="package-category">${cat}</span>`).join('')}
                        </div>
                        <h3 class="package-name">${pkg.name}</h3>
                        <p class="package-description">${pkg.description}</p>
                        <ul class="package-features">
                            ${pkg.features.map(feature => `<li>${feature}</li>`).join('')}
                        </ul>
                        <div class="package-footer">
                            <div class="package-guests">
                                <span>👥</span> ${pkg.guests}
                                <span style="margin-left: 1rem;">🍴 Per guest</span>
                            </div>
                            <div class="package-price">
                                <span class="price-amount">₱${pkg.price} <span>/ guest</span></span>
                            </div>
                        </div>
                        <button class="btn-book-package" onclick="bookPackage('${pkg.name}')">Book this package</button>
                    </div>
                </div>
            `).join('');
            
            count.textContent = `${currentPackages.length} package${currentPackages.length !== 1 ? 's' : ''}`;
        }

        function filterPackages() {
            const searchTerm = document.getElementById('searchInput').value.toLowerCase();
            const category = document.getElementById('categoryFilter').value;
            
            currentPackages = packages.filter(pkg => {
                const matchesSearch = pkg.name.toLowerCase().includes(searchTerm) || 
                                    pkg.description.toLowerCase().includes(searchTerm);
                const matchesCategory = category === 'All' || pkg.category.includes(category);
                
                return matchesSearch && matchesCategory;
            });
            
            sortPackages();
        }

        function sortPackages() {
            const sortBy = document.getElementById('sortFilter').value;
            
            switch(sortBy) {
                case 'low-high':
                    currentPackages.sort((a, b) => a.price - b.price);
                    break;
                case 'high-low':
                    currentPackages.sort((a, b) => b.price - a.price);
                    break;
                case 'name':
                    currentPackages.sort((a, b) => a.name.localeCompare(b.name));
                    break;
            }
            
            renderPackages();
        }

        function bookPackage(packageName) {
            window.location.href = 'Booking.aspx?package=' + encodeURIComponent(packageName);
        }

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