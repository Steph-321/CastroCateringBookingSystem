<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Castro Catering - Crafting Elegant Moments</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
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

        /* Hero Section */
        .hero {
            margin-top: 64px;
            background: linear-gradient(135deg, var(--light-beige) 0%, var(--cream) 100%);
            padding: 5rem 5%;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 50%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="80" cy="20" r="40" fill="%23C9A961" opacity="0.1"/></svg>');
            background-size: cover;
        }

        .hero-content {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            align-items: center;
        }

        .hero-text h1 {
            font-size: 3.5rem;
            color: var(--dark-brown);
            line-height: 1.2;
            margin-bottom: 1.5rem;
        }

        .hero-text p {
            font-size: 1.1rem;
            color: var(--text-light);
            margin-bottom: 2rem;
            line-height: 1.8;
        }

        .hero-buttons {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
        }

        .btn-primary {
            background: var(--primary-gold);
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 600;
            transition: transform 0.3s, box-shadow 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(201, 169, 97, 0.3);
        }

        .btn-secondary {
            background: var(--dark-brown);
            color: white;
            padding: 1rem 2rem;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .btn-secondary:hover {
            background: var(--text-dark);
            transform: translateY(-2px);
        }

        .hero-image {
            position: relative;
            height: 400px;
            background: linear-gradient(135deg, #E8D5B5 0%, #D4C4A8 100%);
            border-radius: 20px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: var(--text-light);
        }

        .hero-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        /* Stats Section */
        .stats {
            padding: 3rem 5%;
            background: var(--white);
        }

        .stats-container {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 2rem;
        }

        .stat-box {
            background: var(--cream);
            padding: 2rem;
            border-radius: 15px;
            text-align: center;
            border: 1px solid var(--light-beige);
        }

        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-gold);
            font-family: 'Playfair Display', serif;
        }

        .stat-label {
            color: var(--text-light);
            margin-top: 0.5rem;
            font-size: 0.95rem;
        }

        /* About Section */
        .about {
            padding: 5rem 5%;
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
        }

        .about h2 {
            font-size: 2.5rem;
            color: var(--dark-brown);
            margin-bottom: 1.5rem;
        }

        .about p {
            color: var(--text-light);
            line-height: 1.8;
            font-size: 1.05rem;
        }

        /* Packages Section */
        .packages {
            padding: 4rem 5%;
            background: var(--white);
        }

        .packages-header {
            max-width: 1400px;
            margin: 0 auto 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }

        .packages-header h2 {
            font-size: 2rem;
            color: var(--dark-brown);
        }

        .view-all {
            color: var(--primary-gold);
            text-decoration: none;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* Featured carousel */
        .featured-carousel {
            max-width: 1400px;
            margin: 0 auto;
        }

        .carousel-controls {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .carousel-btn {
            width: 42px;
            height: 42px;
            border-radius: 999px;
            border: 1px solid var(--light-beige);
            background: var(--white);
            color: var(--dark-brown);
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: transform 0.2s, box-shadow 0.2s, opacity 0.2s;
            box-shadow: 0 6px 18px rgba(0,0,0,0.08);
        }

        .carousel-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 24px rgba(0,0,0,0.10);
        }

        .carousel-btn:disabled {
            opacity: 0.45;
            cursor: not-allowed;
            transform: none;
            box-shadow: 0 6px 18px rgba(0,0,0,0.06);
        }

        .carousel-viewport {
            overflow: hidden;
            border-radius: 18px;
        }

        .carousel-track {
            display: flex;
            overflow-x: auto;
            scroll-snap-type: x mandatory;
            scroll-behavior: smooth;
            padding: 0.25rem 0.25rem 1.25rem;
            -ms-overflow-style: none;
            scrollbar-width: none;
        }

        .carousel-track::-webkit-scrollbar {
            display: none;
        }

        .carousel-page {
            flex: 0 0 100%;
            scroll-snap-align: start;
            padding: 0 0.75rem;
        }

        .carousel-page-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 1.5rem;
        }

        @media (max-width: 968px) {
            .carousel-page-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 640px) {
            .carousel-page-grid {
                grid-template-columns: 1fr;
            }

            .carousel-page {
                padding: 0 0.25rem;
            }
        }

        .packages-grid {
            max-width: 1400px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }

        .package-card {
            background: var(--white);
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
            border: 1px solid var(--light-beige);
            display: flex;
            flex-direction: column;
        }

        .package-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0,0,0,0.12);
        }

        .package-image {
            height: 200px;
            background: linear-gradient(135deg, #E8D5B5 0%, #D4C4A8 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-light);
            font-size: 0.9rem;
            position: relative;
            overflow: hidden;
        }

        .package-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        /* "View all packages" card: blur background image slightly */
        .view-all-card .package-image img {
            filter: blur(2px) brightness(0.9);
            transform: scale(1.06);
        }

        .package-content {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            flex: 1;
            gap: 0.5rem;
        }

        .package-title {
            font-size: 1.25rem;
            color: var(--dark-brown);
            margin-bottom: 0.5rem;
        }

        .package-description {
            color: var(--text-light);
            font-size: 0.9rem;
            margin-bottom: 1rem;
            line-height: 1.6;
        }

        .package-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid var(--light-beige);
            margin-top: auto;
            gap: 1rem;
        }

        .package-price {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--primary-gold);
            font-family: 'Playfair Display', serif;
        }

        .package-price span {
            font-size: 0.9rem;
            color: var(--text-light);
            font-weight: 400;
        }

        .btn-book {
            background: transparent;
            border: 2px solid var(--primary-gold);
            color: var(--primary-gold);
            padding: 0.6rem 1.5rem;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s;
            white-space: nowrap;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-book:hover {
            background: var(--primary-gold);
            color: white;
        }

        /* Footer */
        footer {
            background: #f0ebe4;
            padding: 3rem 5% 0;
            margin-top: 5rem;
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

        /* Responsive */
        @media (max-width: 968px) {
            .nav-links {
                display: none;
                position: absolute;
                top: 70px;
                left: 0;
                right: 0;
                background: var(--white);
                flex-direction: column;
                padding: 1.25rem 5%;
                box-shadow: 0 10px 30px rgba(0,0,0,0.10);
                border-top: 1px solid var(--light-beige);
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

            .hero-content {
                grid-template-columns: 1fr;
            }

            .hero-text h1 {
                font-size: 2.5rem;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }

            .packages-header {
                flex-direction: column;
                gap: 1rem;
                text-align: center;
            }

            .footer-content {
                grid-template-columns: 1fr;
                gap: 2rem;
            }        }

        /* Animations */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .package-card {
            animation: fadeIn 0.6s ease-out;
        }
    </style>
</head>
<body>

    <nav>
        <div class="nav-container">
            <a href="Home.aspx" class="logo" aria-label="Castro Catering Home">
                <span class="logo-text">
                    <span class="logo-title">Castro Catering</span>
                    <span class="logo-subtitle">Crafting elegant moments</span>
                </span>
            </a>
            
            <ul class="nav-links" id="primaryNav">
                <li><a href="Home.aspx" class="active">Home</a></li>
                <li><a href="Packages.aspx">Packages</a></li>
                <li><a href="Booking.aspx">Book Now</a></li>
                <li><a href="Calendar.aspx">Calendar</a></li>
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

    <section class="hero" id="home">
        <div class="hero-content">
            <div class="hero-text">
                <p id="heroGreeting" style="font-size:1rem;color:var(--primary-gold);font-weight:600;margin-bottom:0.5rem;display:none;"></p>
                <h1>Crafting elegant moments, one dish at a time.</h1>
                <p>Castro Catering Services brings refined cuisine, attentive service, and seamless event coordination to your most important celebrations.</p>
                <div class="hero-buttons">
                    <a href="#" id="btnHeroBook" class="btn-primary" onclick="requireAuth(event,'Packages.aspx')">Book an Event</a>
                    <a href="#" id="btnHeroSmart" class="btn-secondary" onclick="requireAuth(event,'SmartPicker.aspx')">Get a Smart Recommendation</a>
                </div>
            </div>
            <div class="hero-image">
                <img src="../assests/cover1.jpg" alt="Castro Catering">
            </div>
        </div>
    </section>

    <section class="stats">
        <div class="stats-container">
            <div class="stat-box">
                <div class="stat-number">1,200+</div>
                <div class="stat-label">Events Catered</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">4.9 / 5</div>
                <div class="stat-label">Average Rating</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">15+</div>
                <div class="stat-label">Years of Excellence</div>
            </div>
        </div>
    </section>

    <!-- Packages Section -->
    <section class="packages" id="packages">
        <div class="packages-header">
            <h2>Featured Packages</h2>
            <div class="carousel-controls" aria-label="Featured packages controls">
                <button class="carousel-btn" type="button" id="featuredPrev" aria-label="Previous packages">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M15 18l-6-6 6-6"></path>
                    </svg>
                </button>
                <button class="carousel-btn" type="button" id="featuredNext" aria-label="Next packages">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M9 18l6-6-6-6"></path>
                    </svg>
                </button>
            </div>
        </div>
        
        <div class="featured-carousel" aria-label="Featured packages carousel">
            <div class="carousel-viewport">
                <div class="carousel-track" id="featuredTrack" tabindex="0" aria-label="Featured packages list">
                    <!-- Slide 1: three packages -->
                    <div class="carousel-page" aria-label="Slide 1 of 2">
                        <div class="carousel-page-grid">
                            <div class="package-card">
                                <div class="package-image">
                                    <img src="../assests/grandWedding.jpg" alt="Grand Wedding Feast" />
                                </div>
                                <div class="package-content">
                                    <h3 class="package-title">Grand Wedding Feast</h3>
                                    <p class="package-description">A timeless celebration with full-service elegance</p>
                                    <div class="package-footer">
                                        <div class="package-price">₱1,223<span>/guest</span></div>
                                        <button class="btn-book" onclick="requireAuth(event,'Booking.aspx')">Book this package</button>
                                    </div>
                                </div>
                            </div>

                            <div class="package-card">
                                <div class="package-image">
                                    <img src="../assests/bunyag.jpg" alt="Christening" />
                                </div>
                                <div class="package-content">
                                    <h3 class="package-title">Christening Celebration</h3>
                                    <p class="package-description">A warm, family-focused spread for your baby's special day</p>
                                    <div class="package-footer">
                                        <div class="package-price">₱750<span>/guest</span></div>
                                        <button class="btn-book" onclick="requireAuth(event,'Booking.aspx')">Book this package</button>
                                    </div>
                                </div>
                            </div>

                            <div class="package-card">
                                <div class="package-image">
                                    <img src="../assests/birthdayBliss.jpg" alt="Birthday Bliss" />
                                </div>
                                <div class="package-content">
                                    <h3 class="package-title">Birthday Bliss</h3>
                                    <p class="package-description">Joyful menus for milestone celebrations</p>
                                    <div class="package-footer">
                                        <div class="package-price">₱1,000<span>/guest</span></div>
                                        <button class="btn-book" onclick="requireAuth(event,'Booking.aspx')">Book this package</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="carousel-page" aria-label="Slide 2 of 2">
                        <div class="carousel-page-grid">
                            <div class="package-card">
                                <div class="package-image">
                                    <img src="../assests/initmatePrivateDining.jpg" alt="Intimate Private Dining" />
                                </div>
                                <div class="package-content">
                                    <h3 class="package-title">Intimate Private Dining</h3>
                                    <p class="package-description">Chef-curated tasting menus for small gatherings</p>
                                    <div class="package-footer">
                                        <div class="package-price">₱1,800<span>/guest</span></div>
                                        <button class="btn-book" onclick="requireAuth(event,'Booking.aspx')">Book this package</button>
                                    </div>
                                </div>
                            </div>

                            <div class="package-card">
                                <div class="package-image">
                                    <img src="../assests/classicWedding.jpg" alt="Classic Wedding Buffet" />
                                </div>
                                <div class="package-content">
                                    <h3 class="package-title">Classic Wedding Buffet</h3>
                                    <p class="package-description">A wedding essential with varied buffet options</p>
                                    <div class="package-footer">
                                        <div class="package-price">₱950<span>/guest</span></div>
                                        <button class="btn-book" onclick="requireAuth(event,'Booking.aspx')">Book this package</button>
                                    </div>
                                </div>
                            </div>

                            <div class="package-card view-all-card">
                                <div class="package-image">
                                    <img src="../assests/debut1.jpg" alt="Classic Wedding Buffet" />
                                </div>
                                <div class="package-content">
                                    <h3 class="package-title">Explore all packages</h3>
                                    <p class="package-description">See the full menu, compare packages, and find the perfect fit for your event.</p>
                                    <div class="package-footer">
                                        <div class="package-price">More<span> packages</span></div>
                                        <a class="btn-book" href="Packages.aspx">View all packages</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

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
                    <span class="icon">&#128222</span>
                    <span>0967 539 3045</span>
                </div>
                <div class="footer-contact-item">
                    <span class="icon">&#128205</span>
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
            <p>� 2026 Castro Catering Services. All rights reserved.</p>
        </div>
    </footer>

    <script>
        // Mobile Menu Toggle (class-based + accessible)
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

        if (mobileMenuBtn) {
            mobileMenuBtn.addEventListener('click', toggleMobileNav);
        }

        // Book Package Function
        function bookPackage(packageName) {
            alert(`Thank you for your interest in the "${packageName}" package! Our team will contact you shortly to discuss your event details.`);
        }

        // Close mobile nav after clicking any nav link
        document.querySelectorAll('#primaryNav a').forEach(a => {
            a.addEventListener('click', () => closeMobileNav());
        });

        // Add scroll effect to navbar
        window.addEventListener('scroll', function () {
            const nav = document.querySelector('nav');
            if (window.scrollY > 100) {
                nav.style.boxShadow = '0 2px 20px rgba(0,0,0,0.1)';
            } else {
                nav.style.boxShadow = '0 2px 10px rgba(0,0,0,0.05)';
            }
        });

        // Featured packages carousel (arrows + snap scrolling)
        const featuredTrack = document.getElementById('featuredTrack');
        const featuredPrev = document.getElementById('featuredPrev');
        const featuredNext = document.getElementById('featuredNext');

        function updateFeaturedButtons() {
            if (!featuredTrack || !featuredPrev || !featuredNext) return;
            const maxScrollLeft = featuredTrack.scrollWidth - featuredTrack.clientWidth;
            featuredPrev.disabled = featuredTrack.scrollLeft <= 2;
            featuredNext.disabled = featuredTrack.scrollLeft >= maxScrollLeft - 2;
        }

        function scrollFeaturedBy(direction) {
            if (!featuredTrack) return;
            const step = featuredTrack.clientWidth;
            featuredTrack.scrollBy({ left: step * direction, behavior: 'smooth' });
        }

        if (featuredPrev) featuredPrev.addEventListener('click', () => scrollFeaturedBy(-1));
        if (featuredNext) featuredNext.addEventListener('click', () => scrollFeaturedBy(1));
        if (featuredTrack) {
            featuredTrack.addEventListener('scroll', updateFeaturedButtons, { passive: true });
            window.addEventListener('resize', updateFeaturedButtons);
            updateFeaturedButtons();
        }

        // Animate stats on scroll
        const observerOptions = {
            threshold: 0.5
        };

        const observer = new IntersectionObserver(function (entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        document.querySelectorAll('.stat-box').forEach((box, index) => {
            box.style.opacity = '0';
            box.style.transform = 'translateY(20px)';
            box.style.transition = `all 0.6s ease-out ${index * 0.2}s`;
            observer.observe(box);
        });
    </script>

    <!-- Admin Login Modal -->
    <script>
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

        /* ── Auth helpers ── */
        function getUser() {
            try { return JSON.parse(localStorage.getItem('castroUser')); } catch(e) { return null; }
        }

        function requireAuth(e, dest) {
            if (e) e.preventDefault();
            var user = getUser();
            if (user && user.username) {
                window.location.href = dest;
            } else {
                window.location.href = 'LoginSignup.aspx';
            }
        }

        /* ── On load: personalise nav + hero ── */
        (function() {
            var user = getUser();
            var btnAuth = document.getElementById('btnNavAuth');
            if (user && user.username) {
                // Logged in — show Log Out
                btnAuth.textContent = 'Log Out';
                btnAuth.onclick = function() {
                    localStorage.removeItem('castroUser');
                    window.location.href = 'LoginSignup.aspx';
                };
                // Show greeting in hero
                var greeting = document.getElementById('heroGreeting');
                if (greeting) {
                    greeting.textContent = 'Hello, ' + user.username + '!';
                    greeting.style.display = 'block';
                }
            } else {
                // Not logged in — Log In button already set
                btnAuth.textContent = 'Log In';
                btnAuth.onclick = function() { window.location.href = 'LoginSignup.aspx'; };
            }
        })();
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
