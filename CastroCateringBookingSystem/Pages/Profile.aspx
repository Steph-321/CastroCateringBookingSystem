<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.Profile" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Castro Catering</title>
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
            --warning: #f5af35;
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
            margin-bottom: 2rem;
        }

        .page-header h1 {
            font-size: 2.2rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .page-header p {
            color: var(--text-gray);
        }

        .profile-grid {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 2rem;
        }

        /* Profile Card */
        .profile-card {
            background: var(--bg-white);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
        }

        .profile-header {
            background: linear-gradient(135deg, var(--light-gold), var(--primary-gold));
            padding: 2rem;
            text-align: center;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            background: var(--bg-white);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-gold);
            margin: 0 auto 1rem;
        }

        .profile-name {
            font-size: 1.5rem;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .profile-email {
            color: var(--text-brown);
            font-size: 0.9rem;
        }

        .profile-body {
            padding: 2rem;
        }

        .info-group {
            margin-bottom: 1.5rem;
        }

        .info-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: var(--text-gray);
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 600;
        }

        .info-value {
            color: var(--text-dark);
            font-weight: 500;
            padding: 0.5rem 0;
        }

        /* ── Profile picture ── */
        .profile-pic-wrap {
            position: relative;
            width: 90px;
            height: 90px;
            margin: 0 auto 1rem;
        }
        .profile-pic-wrap img,
        .profile-avatar-circle {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.6);
        }
        .profile-avatar-circle {
            background: var(--bg-white);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-gold);
        }
        .pic-upload-btn {
            position: absolute;
            bottom: 0; right: 0;
            width: 28px; height: 28px;
            border-radius: 50%;
            background: var(--primary-gold);
            border: 2px solid #fff;
            cursor: pointer;
            display: flex; align-items: center; justify-content: center;
            font-size: 0.75rem;
            color: #fff;
        }

        /* ── Edit form ── */
        .edit-form { display: none; padding: 1.25rem 2rem 1.5rem; border-top: 1px solid var(--border-light); }
        .edit-form.open { display: block; }
        .edit-field { margin-bottom: 1rem; }
        .edit-field label { display: block; font-size: 0.72rem; font-weight: 600; color: var(--text-gray); letter-spacing: 1px; text-transform: uppercase; margin-bottom: 0.35rem; }
        .edit-field input {
            width: 100%; padding: 0.6rem 0.85rem;
            border: 1px solid var(--border-light); border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.9rem;
            color: var(--text-dark); background: #fcfbf9; outline: none;
            transition: border-color 0.25s, box-shadow 0.25s; box-sizing: border-box;
        }
        .edit-field input:focus { border-color: var(--primary-gold); box-shadow: 0 0 0 3px rgba(194,147,74,0.12); }
        .edit-actions { display: flex; gap: 0.75rem; margin-top: 1.25rem; }
        .btn-save-profile {
            flex: 1; padding: 0.65rem;
            background: var(--primary-gold); border: none; border-radius: 8px;
            color: var(--text-dark); font-family: 'Inter', sans-serif;
            font-weight: 700; font-size: 0.88rem; cursor: pointer;
            transition: all 0.3s;
        }
        .btn-save-profile:hover { background: #a07535; color: white; }
        .btn-cancel-edit {
            flex: 1; padding: 0.65rem;
            background: transparent; border: 1px solid var(--border-light); border-radius: 8px;
            color: var(--text-gray); font-family: 'Inter', sans-serif;
            font-weight: 600; font-size: 0.88rem; cursor: pointer;
            transition: all 0.3s;
        }
        .btn-cancel-edit:hover { border-color: var(--primary-gold); color: var(--text-dark); }
        .edit-status { font-size: 0.85rem; margin-top: 0.5rem; text-align: center; }

        /* Booking History */
        .booking-card {
            background: var(--bg-white);
            border-radius: 16px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            border: 1px solid var(--border-light);
            overflow: hidden;
        }

        .booking-header {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border-light);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .booking-header h2 {
            font-size: 1.3rem;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .booking-count {
            background: var(--bg-beige);
            padding: 0.4rem 1rem;
            border-radius: 20px;
            font-size: 0.85rem;
            color: var(--text-gray);
        }

        .booking-list {
            padding: 1rem 0;
        }

        .booking-item {
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border-light);
            transition: background 0.3s;
        }

        .booking-item:hover {
            background: var(--bg-cream);
        }

        .booking-item:last-child {
            border-bottom: none;
        }

        .booking-top {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 0.75rem;
        }

        .booking-package {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .booking-id {
            font-size: 0.85rem;
            color: var(--text-gray);
        }

        .booking-amount {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--primary-gold);
        }

        .booking-status {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            margin-left: 0.75rem;
        }

        .status-upcoming {
            background: #fff3cd;
            color: #856404;
        }

        .status-completed {
            background: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        .booking-details {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
            font-size: 0.9rem;
            color: var(--text-gray);
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .booking-actions {
            margin-top: 1rem;
            display: flex;
            gap: 1rem;
        }

        .btn-cancel {
            background: transparent;
            border: 1px solid var(--warning);
            color: var(--warning);
            padding: 0.5rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-cancel:hover:not(:disabled) {
            background: var(--warning);
            color: white;
        }

        .btn-cancel:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            border-color: var(--text-gray);
            color: var(--text-gray);
        }

        .cancellation-note {
            font-size: 0.8rem;
            color: var(--text-gray);
            margin-top: 0.5rem;
        }

        .policy-note {
            padding: 1rem 2rem;
            background: var(--bg-cream);
            font-size: 0.85rem;
            color: var(--text-gray);
            border-top: 1px solid var(--border-light);
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
            .profile-grid {
                grid-template-columns: 1fr;
            }
            
            .nav-links {
                display: none;
            }
        }

        /* ── Cancel booking button ── */
        .btn-cancel-booking {
            background: transparent;
            border: 1px solid #e5a0a0;
            color: #b83232;
            padding: 0.4rem 1rem;
            border-radius: 8px;
            font-size: 0.82rem;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-cancel-booking:hover {
            background: #fde8e8;
            border-color: #b83232;
        }

        /* ── Cancel confirmation modal ── */
        .cancel-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(33, 28, 24, 0.55);
            z-index: 2000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(2px);
        }
        .cancel-overlay.open { display: flex; }

        .cancel-modal {
            background: var(--bg-white);
            border-radius: 16px;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.18);
            overflow: hidden;
            animation: slideDown 0.2s ease;
        }

        .cancel-modal-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border-light);
        }
        .cancel-modal-head h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem;
            color: var(--text-dark);
        }

        .cancel-modal-body {
            padding: 2rem 1.5rem 1.5rem;
            text-align: center;
        }
        .cancel-icon { font-size: 2.5rem; margin-bottom: 0.75rem; }
        .cancel-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.15rem;
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }
        .cancel-sub {
            font-size: 0.875rem;
            color: var(--text-gray);
            line-height: 1.6;
            margin-bottom: 0.75rem;
        }
        .cancel-policy {
            font-size: 0.78rem;
            color: var(--text-gray);
            background: var(--bg-cream);
            border: 1px solid var(--border-light);
            border-radius: 8px;
            padding: 0.6rem 1rem;
        }

        .cancel-modal-foot {
            display: flex;
            gap: 0.75rem;
            padding: 1.25rem 1.5rem;
            border-top: 1px solid var(--border-light);
        }
        .btn-cancel-no {
            flex: 1;
            padding: 0.7rem;
            background: var(--bg-beige);
            border: 1px solid var(--border-light);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text-dark);
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-cancel-no:hover { background: #ede6db; }

        .btn-cancel-yes {
            flex: 1;
            padding: 0.7rem;
            background: #b83232;
            border: none;
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 700;
            color: #fff;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-cancel-yes:hover { background: #9b1c1c; }

        /* ── Notification bell ── */
        .btn-notif {
            position: relative;
            background: transparent;
            border: 1px solid var(--border-light);
            border-radius: 50%;
            width: 38px; height: 38px;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
            color: var(--text-dark);
            transition: background 0.2s, border-color 0.2s;
            flex-shrink: 0;
        }
        .btn-notif:hover {
            background: var(--bg-beige);
            border-color: var(--primary-gold);
            color: var(--primary-gold);
        }
        .notif-badge {
            position: absolute;
            top: -4px; right: -4px;
            min-width: 18px; height: 18px;
            padding: 0 4px;
            background: var(--primary-gold);
            color: #fff;
            border-radius: 99px;
            font-size: 0.65rem;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            display: flex; align-items: center; justify-content: center;
            border: 2px solid #fff;
            line-height: 1;
        }

        /* ── Notification modal ── */
        .notif-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(33, 28, 24, 0.55);
            z-index: 2000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(2px);
        }
        .notif-overlay.open { display: flex; }

        .notif-modal {
            background: var(--bg-white);
            border-radius: 16px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.18);
            display: flex;
            flex-direction: column;
            max-height: calc(100vh - 90px);
            overflow: hidden;
            animation: slideDown 0.2s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .notif-modal-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border-light);
        }
        .notif-modal-head h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem;
            color: var(--text-dark);
        }
        .notif-close {
            background: none;
            border: none;
            font-size: 1.4rem;
            cursor: pointer;
            color: var(--text-gray);
            line-height: 1;
            padding: 0 0.25rem;
            transition: color 0.2s;
        }
        .notif-close:hover { color: var(--text-dark); }

        .notif-modal-body {
            overflow-y: auto;
            flex: 1;
        }

        .notif-item {
            display: flex;
            align-items: flex-start;
            gap: 0.875rem;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border-light);
            transition: background 0.15s;
        }
        .notif-item:last-child { border-bottom: none; }
        .notif-item:hover { background: var(--bg-cream); }

        .notif-icon-wrap {
            width: 36px; height: 36px;
            border-radius: 50%;
            background: #fff8e8;
            border: 1px solid #f4d589;
            display: flex; align-items: center; justify-content: center;
            font-size: 1rem;
            flex-shrink: 0;
        }

        .notif-message {
            font-size: 0.875rem;
            color: var(--text-dark);
            font-weight: 500;
            line-height: 1.5;
            margin: 0 0 0.25rem;
        }
        .notif-meta {
            font-size: 0.75rem;
            color: var(--text-gray);
        }

        .notif-empty {
            text-align: center;
            padding: 2.5rem 1rem;
            color: var(--text-gray);
            font-size: 0.875rem;
        }

        .notif-modal-foot {
            padding: 0.75rem 1.5rem;
            border-top: 1px solid var(--border-light);
            font-size: 0.78rem;
            color: var(--text-gray);
            text-align: center;
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
                <li><a href="SmartPicker.aspx">Smart Pick</a></li>
                <li><a href="Reviews.aspx">Reviews</a></li>
                <li><a href="Profile.aspx" class="active">Profile</a></li>
                <li><a href="AboutUs.aspx">About Us</a></li>
            </ul>

            <div class="nav-icons">
                <!-- Bell notification icon -->
                <button class="btn-notif" type="button" onclick="openNotifModal()" title="Notifications" aria-label="Notifications">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
                        <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
                    </svg>
                    <asp:Label ID="lblNotifBadge" runat="server" CssClass="notif-badge" Visible="false" />
                </button>
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
    <form id="form1" runat="server">
    <div class="main-content">
        <div class="page-header">
            <h1>My Profile</h1>
            <p>Manage your information and review your bookings.</p>
        </div>

        <div class="profile-grid">
            <!-- Profile Card -->
            <div class="profile-card">
                <div class="profile-header">
                    <!-- Profile picture -->
                    <div class="profile-pic-wrap">
                        <asp:Image ID="imgProfilePic" runat="server" CssClass="profile-pic-img" style="display:none;" AlternateText="Profile" />
                        <div class="profile-avatar-circle" id="avatarCircle" runat="server">
                            <asp:Label ID="lblProfileAvatar" runat="server" Text="?" />
                        </div>
                        <label class="pic-upload-btn" title="Change photo">
                            ✎
                            <asp:FileUpload ID="fuProfilePic" runat="server" style="display:none;" accept="image/*" />
                        </label>
                    </div>
                    <h2 class="profile-name"><asp:Label ID="lblProfileName" runat="server" Text="—" /></h2>
                    <p class="profile-email"><asp:Label ID="lblProfileEmail" runat="server" Text="—" /></p>
                </div>

                <!-- View mode -->
                <div class="profile-body" id="viewMode">
                    <div class="info-group">
                        <div class="info-label">👤 Username</div>
                        <div class="info-value"><asp:Label ID="lblInfoUsername" runat="server" Text="—" /></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">✉️ Email</div>
                        <div class="info-value"><asp:Label ID="lblInfoEmail" runat="server" Text="—" /></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">📞 Phone</div>
                        <div class="info-value"><asp:Label ID="lblInfoPhone" runat="server" Text="—" /></div>
                    </div>
                    <div class="info-group">
                        <div class="info-label">📍 Address</div>
                        <div class="info-value"><asp:Label ID="lblInfoAddress" runat="server" Text="—" /></div>
                    </div>
                    <button type="button" class="btn-save-profile" style="margin-top:1rem;" onclick="toggleEdit(true)">Edit Profile</button>
                </div>

                <!-- Edit mode -->
                <div class="edit-form" id="editMode">
                    <div class="edit-field">
                        <label>Username</label>
                        <asp:TextBox ID="txtEditUsername" runat="server" placeholder="Choose a username" />
                    </div>
                    <div class="edit-field">
                        <label>Email</label>
                        <asp:TextBox ID="txtEditEmail" runat="server" TextMode="Email" placeholder="your@email.com" />
                    </div>
                    <div class="edit-field">
                        <label>Phone Number</label>
                        <asp:TextBox ID="txtEditPhone" runat="server" placeholder="09XXXXXXXXX" />
                    </div>
                    <div class="edit-field">
                        <label>Address</label>
                        <asp:TextBox ID="txtEditAddress" runat="server" placeholder="Street, City, Province" />
                    </div>
                    <div class="edit-actions">
                        <asp:Button ID="btnSaveProfile" runat="server" Text="Save Changes"
                            CssClass="btn-save-profile" OnClick="btnSaveProfile_Click" />
                        <button type="button" class="btn-cancel-edit" onclick="toggleEdit(false)">Cancel</button>
                    </div>
                    <asp:Label ID="lblEditStatus" runat="server" CssClass="edit-status" />
                </div>
            </div>

            <!-- Booking History -->
            <div class="booking-card">
                <div class="booking-header">
                    <h2>🕐 Booking History</h2>
                    <span class="booking-count"><asp:Label ID="lblBookingCount" runat="server" Text="0 bookings" /></span>
                </div>

                <div class="booking-list">
                    <asp:Repeater ID="rptBookings" runat="server">
                        <ItemTemplate>
                            <div class="booking-item">
                                <div class="booking-top">
                                    <div>
                                        <div class="booking-package">
                                            <%# Eval("PackageName") %>
                                            <span class="booking-status <%# GetStatusClass(Eval("Status").ToString()) %>">
                                                <%# Eval("Status") %>
                                            </span>
                                        </div>
                                        <div class="booking-id">
                                            #BK-<%# string.Format("{0:D6}", Eval("BookingID")) %> &middot;
                                            Booked <%# Eval("BookedAt", "{0:MMM d, yyyy}") %>
                                        </div>
                                    </div>
                                    <div class="booking-amount">&#8369;<%# string.Format("{0:N0}", Eval("Amount")) %></div>
                                </div>
                                <div class="booking-details">
                                    <div class="detail-item">📅 <%# Eval("EventDate", "{0:MMM d, yyyy}") %></div>
                                    <div class="detail-item"><%# Eval("EventType") %></div>
                                    <div class="detail-item"><%# Eval("NoOfGuests") %> guests</div>
                                    <div class="detail-item"><%# Eval("Payment") %></div>
                                </div>
                                <%# (Eval("Status").ToString() != "Cancelled" && Eval("Status").ToString() != "Completed")
                                    ? "<div class='booking-actions'><button type='button' class='btn-cancel-booking' onclick='openCancelModal(" + Eval("BookingID") + ")'>Cancel Booking</button></div>"
                                    : "" %>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:PlaceHolder ID="phNoBookings" runat="server" Visible="false">
                        <div style="padding:2rem;text-align:center;color:#756e64;">
                            No bookings yet. <a href="Booking.aspx">Book your first event!</a>
                        </div>
                    </asp:PlaceHolder>
                </div>

                <div class="policy-note">
                    Cancellation policy: contact us within <strong>12 hours</strong> of booking to cancel.
                </div>
            </div>

        </div>
    </div>

    <!-- CANCEL BOOKING MODAL -->
    <div id="cancelModalOverlay" class="cancel-overlay" onclick="if(event.target===this)closeCancelModal()">
        <div class="cancel-modal">
            <div class="cancel-modal-head">
                <h3>Cancel Booking</h3>
                <button class="notif-close" onclick="closeCancelModal()" aria-label="Close">&times;</button>
            </div>
            <div class="cancel-modal-body">
                <div class="cancel-icon">⚠️</div>
                <p class="cancel-title">Are you sure you want to cancel?</p>
                <p class="cancel-sub">This action cannot be undone. Your booking will be marked as <strong>Cancelled</strong>.</p>
                <p class="cancel-policy">Reminder: cancellations must be made within <strong>12 hours</strong> of booking.</p>
            </div>
            <div class="cancel-modal-foot">
                <button type="button" class="btn-cancel-no" onclick="closeCancelModal()">Keep Booking</button>
                <asp:Button ID="btnConfirmCancel" runat="server"
                    Text="Yes, Cancel It"
                    CssClass="btn-cancel-yes"
                    OnClick="btnConfirmCancel_Click" />
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hfCancelBookingID" runat="server" Value="0" />

    <!-- NOTIFICATIONS MODAL -->
    <div id="notifModalOverlay" class="notif-overlay" onclick="if(event.target===this)closeNotifModal()">
        <div class="notif-modal">
            <div class="notif-modal-head">
                <h3>Notifications</h3>
                <button class="notif-close" onclick="closeNotifModal()" aria-label="Close">&times;</button>
            </div>
            <div class="notif-modal-body">
                <asp:Repeater ID="rptNotifications" runat="server">
                    <ItemTemplate>
                        <div class="notif-item">
                            <div class="notif-icon-wrap">🔔</div>
                            <div class="notif-text">
                                <p class="notif-message"><%# Eval("Message") %></p>
                                <span class="notif-meta">
                                    <%# Eval("DateCreated", "{0:MMM d, yyyy · h:mm tt}") %>
                                    <%# !string.IsNullOrEmpty(Eval("EventType").ToString()) ? " &bull; " + Eval("EventType") : "" %>
                                </span>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:PlaceHolder ID="phNoNotifs" runat="server" Visible="false">
                    <div class="notif-empty">
                        <div style="font-size:2rem;margin-bottom:0.5rem;">🔕</div>
                        <p>No notifications yet.</p>
                        <p style="font-size:0.8rem;margin-top:0.25rem;">You'll be notified when your booking status changes.</p>
                    </div>
                </asp:PlaceHolder>
            </div>
            <div class="notif-modal-foot">
                <asp:Label ID="lblNotifCount" runat="server" Text="0" /> notification(s)
            </div>
        </div>
    </div>

    </form>

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
        // Sample booking data
        const sampleBookings = [
            {
                id: 'b-1001',
                package: 'Grand Wedding Feast',
                date: '2026-05-03',
                eventType: 'Wedding',
                guests: 120,
                payment: 'Bank Transfer',
                amount: 144000,
                status: 'upcoming',
                bookedAt: '2026-04-21T23:06:11',
                canCancel: false
            },
            {
                id: 'b-1002',
                package: 'Corporate Essentials',
                date: '2026-04-27',
                eventType: 'Corporate',
                guests: 60,
                payment: 'Credit Card',
                amount: 39000,
                status: 'upcoming',
                bookedAt: '2026-04-18T23:06:11',
                canCancel: false
            },
            {
                id: 'b-1003',
                package: 'Birthday Bliss',
                date: '2026-04-11',
                eventType: 'Birthday',
                guests: 40,
                payment: 'GCash',
                amount: 19200,
                status: 'completed',
                bookedAt: '2026-03-24T23:06:11',
                canCancel: false
            },
            {
                id: 'b-1004',
                package: 'Intimate Private Dining',
                date: '2026-03-24',
                eventType: 'Anniversary',
                guests: 18,
                payment: 'Cash',
                amount: 32400,
                status: 'completed',
                bookedAt: '2026-03-09T23:06:11',
                canCancel: false
            }
        ];

        document.addEventListener('DOMContentLoaded', function() {
            // ── Populate profile from localStorage ──
            var user = null;
            try { user = JSON.parse(localStorage.getItem('castroUser')); } catch(e) {}

            if (!user || !user.username) {
                // Not logged in — redirect to login
                window.location.href = 'LoginSignup.aspx';
                return;
            }

            var initial = user.username.charAt(0).toUpperCase();
            document.getElementById('profileAvatar').textContent  = initial;
            document.getElementById('profileName').textContent    = user.username;
            document.getElementById('profileEmail').textContent   = user.email    || '—';
            document.getElementById('infoUsername').textContent   = user.username;
            document.getElementById('infoEmail').textContent      = user.email    || '—';
            document.getElementById('infoPhone').textContent      = user.phone    || '—';
            document.getElementById('infoAddress').textContent    = user.address  || '—';

            // Also update nav Log Out button
            var logoutBtn = document.querySelector('.btn-login[onclick*="logout"]');
            if (logoutBtn) logoutBtn.textContent = 'Log Out';

            loadBookings();
        });

        function loadBookings() {
            const bookings = JSON.parse(localStorage.getItem('bookings') || '[]');
            const allBookings = [...bookings, ...sampleBookings];
            
            // Sort by booking date (newest first)
            allBookings.sort((a, b) => new Date(b.bookedAt) - new Date(a.bookedAt));
            
            // Check cancellation eligibility
            allBookings.forEach(booking => {
                const bookingTime = new Date(booking.bookedAt);
                const now = new Date();
                const hoursDiff = (now - bookingTime) / (1000 * 60 * 60);
                booking.canCancel = hoursDiff < 12 && booking.status === 'upcoming';
            });
            
            const bookingList = document.getElementById('bookingList');
            const bookingCount = document.getElementById('bookingCount');
            
            bookingCount.textContent = `${allBookings.length} bookings`;
            
            if (allBookings.length === 0) {
                bookingList.innerHTML = `
                    <div style="padding: 3rem; text-align: center; color: var(--text-gray);">
                        <p>No bookings yet. Start planning your event!</p>
                    </div>
                `;
                return;
            }
            
            bookingList.innerHTML = allBookings.map(booking => `
                <div class="booking-item">
                    <div class="booking-top">
                        <div>
                            <div class="booking-package">
                                ${booking.package}
                                <span class="booking-status status-${booking.status}">
                                    ${booking.status.charAt(0).toUpperCase() + booking.status.slice(1)}
                                </span>
                            </div>
                            <div class="booking-id">
                                #${booking.id} · Booked ${formatDate(booking.bookedAt)}
                            </div>
                        </div>
                        <div class="booking-amount">₱${booking.amount.toLocaleString()}</div>
                    </div>
                    
                    <div class="booking-details">
                        <div class="detail-item">📅 ${formatDate(booking.date)}</div>
                        <div class="detail-item">${booking.eventType}</div>
                        <div class="detail-item">${booking.guests} guests</div>
                        <div class="detail-item">${booking.payment}</div>
                    </div>
                    
                    ${booking.status === 'upcoming' ? `
                        <div class="booking-actions">
                            ${booking.canCancel ? `
                                <button class="btn-cancel" onclick="cancelBooking('${booking.id}')">
                                    Cancel Booking
                                </button>
                                <span class="cancellation-note">You can cancel within 12 hours of booking</span>
                            ` : `
                                <span class="cancellation-note" style="color: var(--text-gray);">
                                    Cancellation closed (booked more than 12 hours ago)
                                </span>
                            `}
                        </div>
                    ` : ''}
                </div>
            `).join('');
        }

        function formatDate(dateString) {
            const date = new Date(dateString);
            const options = { month: 'short', day: 'numeric', year: 'numeric', hour: '2-digit', minute: '2-digit' };
            return date.toLocaleDateString('en-US', options);
        }

        function cancelBooking(bookingId) {
            if (confirm('Are you sure you want to cancel this booking?')) {
                let bookings = JSON.parse(localStorage.getItem('bookings') || '[]');
                const bookingIndex = bookings.findIndex(b => b.id === bookingId);
                
                if (bookingIndex !== -1) {
                    bookings[bookingIndex].status = 'cancelled';
                    localStorage.setItem('bookings', JSON.stringify(bookings));
                    alert('Booking cancelled successfully.');
                    loadBookings();
                } else {
                    alert('This is a sample booking and cannot be cancelled in this demo.');
                }
            }
        }

        function editProfile() {
            alert('Profile editing feature would open a modal or redirect to an edit page.');
        }

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

        /* ── Cancel booking modal ── */
        function openCancelModal(bookingId) {
            document.getElementById('<%= hfCancelBookingID.ClientID %>').value = bookingId;
            document.getElementById('cancelModalOverlay').classList.add('open');
        }
        function closeCancelModal() {
            document.getElementById('cancelModalOverlay').classList.remove('open');
        }

        /* ── Notification modal ── */
        function openNotifModal() {
            document.getElementById('notifModalOverlay').classList.add('open');
        }
        function closeNotifModal() {
            document.getElementById('notifModalOverlay').classList.remove('open');
        }
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') { closeNotifModal(); closeCancelModal(); }
        });

        function logout() {
            localStorage.removeItem('currentUser');
            localStorage.removeItem('castroUser');
            window.location.href = 'LoginSignup.aspx';
        }

        /* ── Toggle edit / view mode ── */
        function toggleEdit(open) {
            document.getElementById('viewMode').style.display = open ? 'none' : '';
            var ef = document.getElementById('editMode');
            if (open) ef.classList.add('open'); else ef.classList.remove('open');
        }

        /* ── Profile picture preview before upload ── */
        var fu = document.querySelector('[id*="fuProfilePic"]');
        if (fu) {
            fu.addEventListener('change', function() {
                if (!this.files || !this.files[0]) return;
                var reader = new FileReader();
                reader.onload = function(e) {
                    var img = document.querySelector('[id*="imgProfilePic"]');
                    var circle = document.getElementById('avatarCircle');
                    if (img) { img.src = e.target.result; img.style.display = 'block'; }
                    if (circle) circle.style.display = 'none';
                };
                reader.readAsDataURL(this.files[0]);
                // Auto-submit to upload the picture
                document.querySelector('[id*="btnSaveProfile"]').click();
            });
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