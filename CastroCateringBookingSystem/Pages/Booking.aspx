<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Booking.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.Booking" ResponseEncoding="UTF-8" EnableEventValidation="false" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book an Event - Castro Catering</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        :root {
            --primary-gold: #c2934a;
            --light-gold: #f4d589;
            --bg-cream: #f9f6f2;
            --bg-white: #ffffff;
            --bg-beige: #f0ebe4;
            --bg-sand: #f5ebd3;
            --text-dark: #2e211b;
            --text-brown: #493a2f;
            --text-gray: #756e64;
            --success: #2d8a53;
            --warning: #f5af35;
            --danger: #d92626;
            --border-light: #e5dcd0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-cream);
            color: var(--text-dark);
            line-height: 1.6;
        }

        h1, h2, h3, h4, h5 { font-family: 'Playfair Display', serif; }

        /* ── NAV ── */
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
        }
        .logo-text { display: flex; flex-direction: column; line-height: 1.1; }
        .logo-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--text-brown);
            white-space: nowrap;
        }
        .logo-subtitle { font-size: 0.8rem; color: var(--text-gray); white-space: nowrap; }
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
        .nav-links a:hover { color: var(--primary-gold); }
        .nav-links a.active { color: var(--primary-gold); }
        .nav-links a.active::after {
            content: '';
            position: absolute;
            left: 0; right: 0; bottom: -6px;
            height: 2px;
            border-radius: 2px;
            background: var(--primary-gold);
        }
        .nav-icons { display: flex; gap: 1rem; align-items: center; }
        .btn-nav-action {
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
        .btn-nav-action:hover { background: var(--primary-gold); color: #fff; }
        .mobile-menu {
            display: none;
            cursor: pointer;
            border: 1px solid var(--border-light);
            background: var(--bg-white);
            border-radius: 10px;
            padding: 0.5rem 0.6rem;
            flex-direction: column;
            gap: 5px;
        }
        .mobile-menu span {
            display: block;
            width: 22px;
            height: 2px;
            background: var(--text-brown);
            border-radius: 2px;
            transition: 0.3s;
        }
        .mobile-menu[aria-expanded="true"] span:nth-child(1) { transform: translateY(7px) rotate(45deg); }
        .mobile-menu[aria-expanded="true"] span:nth-child(2) { opacity: 0; }
        .mobile-menu[aria-expanded="true"] span:nth-child(3) { transform: translateY(-7px) rotate(-45deg); }

        /* ── PAGE LAYOUT ── */
        .page-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            padding: 6.5rem 5% 4rem;
        }
        .page-header { margin-bottom: 2.5rem; }
        .page-header h1 { font-size: 2.4rem; color: var(--text-brown); margin-bottom: 0.4rem; }
        .page-header p { color: var(--text-gray); font-size: 1rem; }

        .booking-layout {
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 2rem;
            align-items: start;
        }

        /* ── FORM SECTIONS ── */
        .form-section {
            background: var(--bg-white);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            border: 1px solid var(--border-light);
        }
        .form-section h2 {
            font-size: 1.25rem;
            color: var(--text-brown);
            margin-bottom: 1.5rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid var(--bg-sand);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .form-section h2 .section-num {
            width: 28px; height: 28px;
            background: var(--primary-gold);
            color: #fff;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            flex-shrink: 0;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.25rem;
        }
        .form-group { display: flex; flex-direction: column; gap: 0.4rem; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-brown);
        }
        .form-group label .req { color: var(--danger); margin-left: 2px; }
        .form-group input,
        .form-group select {
            padding: 0.65rem 0.9rem;
            border: 1.5px solid var(--border-light);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.92rem;
            color: var(--text-dark);
            background: var(--bg-white);
            transition: border-color 0.2s, box-shadow 0.2s;
            outline: none;
        }
        .form-group input:focus,
        .form-group select:focus {
            border-color: var(--primary-gold);
            box-shadow: 0 0 0 3px rgba(194,147,74,0.12);
        }
        .form-group input::placeholder { color: #b0a89e; }

        /* ── SERVICE STYLE CARDS ── */
        .service-cards {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
        }
        .service-label {
            display: block;
            cursor: pointer;
        }
        .service-label input[type="radio"] { display: none; }
        .service-card {
            border: 2px solid var(--border-light);
            border-radius: 14px;
            padding: 1.1rem 1.2rem;
            background: var(--bg-white);
            transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
            height: 100%;
        }
        .service-label.selected .service-card,
        .service-label:has(input:checked) .service-card {
            border-color: var(--primary-gold);
            background: var(--bg-sand);
            box-shadow: 0 0 0 3px rgba(194,147,74,0.15);
        }
        .service-card-name {
            font-weight: 700;
            font-size: 0.95rem;
            color: var(--text-brown);
            margin-bottom: 0.2rem;
        }
        .service-card-price {
            font-size: 0.82rem;
            font-weight: 600;
            color: var(--primary-gold);
            margin-bottom: 0.4rem;
        }
        .service-card-desc {
            font-size: 0.8rem;
            color: var(--text-gray);
            line-height: 1.5;
        }

        /* ── PACKAGE CARDS ── */
        .package-cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
        }
        .pkg-label {
            display: block;
            cursor: pointer;
        }
        .pkg-label input[type="radio"] { display: none; }
        .pkg-card {
            border: 2px solid var(--border-light);
            border-radius: 14px;
            padding: 1.1rem 1rem;
            background: var(--bg-white);
            text-align: center;
            transition: border-color 0.2s, background 0.2s, box-shadow 0.2s;
            height: 100%;
        }
        .pkg-label.selected .pkg-card,
        .pkg-label:has(input:checked) .pkg-card {
            border-color: var(--primary-gold);
            background: var(--bg-sand);
            box-shadow: 0 0 0 3px rgba(194,147,74,0.15);
        }
        .pkg-emoji { font-size: 1.8rem; margin-bottom: 0.4rem; }
        .pkg-name {
            font-weight: 700;
            font-size: 0.88rem;
            color: var(--text-brown);
            margin-bottom: 0.3rem;
            line-height: 1.3;
        }
        .pkg-price {
            font-size: 0.9rem;
            font-weight: 700;
            color: var(--primary-gold);
        }

        /* ── SUMMARY SIDEBAR ── */
        .summary-sidebar {
            position: sticky;
            top: 90px;
        }
        .summary-card {
            background: var(--bg-white);
            border-radius: 16px;
            border: 1px solid var(--border-light);
            overflow: hidden;
        }
        .summary-header {
            background: var(--text-brown);
            color: #fff;
            padding: 1.25rem 1.5rem;
        }
        .summary-header h3 {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.2rem;
        }
        .summary-header p { font-size: 0.8rem; opacity: 0.75; }
        .summary-body { padding: 1.25rem 1.5rem; }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 0.5rem;
            margin-bottom: 0.65rem;
            font-size: 0.85rem;
        }
        .summary-row .s-label { color: var(--text-gray); flex-shrink: 0; }
        .summary-row .s-value {
            color: var(--text-dark);
            font-weight: 500;
            text-align: right;
        }
        .summary-row .s-value.placeholder { color: #c0b8b0; font-style: italic; font-weight: 400; }

        .summary-divider {
            border: none;
            border-top: 1px solid var(--border-light);
            margin: 1rem 0;
        }

        .cost-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            margin-bottom: 0.5rem;
            color: var(--text-gray);
        }
        .cost-row .cost-val { color: var(--text-dark); font-weight: 500; }
        .cost-row.extra .cost-val { color: var(--warning); }
        .cost-row.hidden-row { display: none; }

        .notice-badge {
            background: #fff8e6;
            border: 1px solid #f5d87a;
            border-radius: 8px;
            padding: 0.5rem 0.75rem;
            font-size: 0.78rem;
            color: #7a5c00;
            margin-bottom: 0.75rem;
            display: none;
        }
        .notice-badge.show { display: block; }

        .total-box {
            background: var(--bg-sand);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1rem;
        }
        .total-label {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-brown);
        }
        .total-amount {
            font-family: 'Playfair Display', serif;
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--primary-gold);
        }

        .btn-confirm {
            width: 100%;
            margin-top: 1.25rem;
            padding: 0.9rem;
            background: var(--primary-gold);
            color: #fff;
            border: none;
            border-radius: 12px;
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.2s, box-shadow 0.2s;
        }
        .btn-confirm:hover {
            background: #a87a38;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(194,147,74,0.3);
        }

        /* ── MODAL ── */
         .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.5);
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .modal-overlay.open {
            display: flex;
        }


        .modal-box {
            background: var(--bg-white);
            border-radius: 20px;
            max-width: 560px;
            width: 100%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            animation: modalIn 0.3s ease;
        }
        @keyframes modalIn {
            from { opacity: 0; transform: scale(0.94) translateY(16px); }
            to   { opacity: 1; transform: scale(1) translateY(0); }
        }
        .modal-top {
            background: linear-gradient(135deg, var(--text-brown), #6b4c3b);
            color: #fff;
            padding: 2rem 2rem 1.5rem;
            text-align: center;
            border-radius: 20px 20px 0 0;
        }
        .modal-check {
            width: 56px; height: 56px;
            background: var(--success);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            font-size: 1.6rem;
        }
        .modal-top h2 { font-size: 1.5rem; margin-bottom: 0.3rem; }
        .modal-top .booking-id {
            font-size: 0.85rem;
            opacity: 0.8;
            font-family: 'Inter', sans-serif;
        }
        .modal-body { padding: 1.75rem 2rem; }
        .receipt-section { margin-bottom: 1.5rem; }
        .receipt-section h4 {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--primary-gold);
            margin-bottom: 0.75rem;
            font-family: 'Inter', sans-serif;
            font-weight: 700;
        }
        .receipt-row {
            display: flex;
            justify-content: space-between;
            font-size: 0.88rem;
            margin-bottom: 0.45rem;
            gap: 1rem;
        }
        .receipt-row .r-label { color: var(--text-gray); }
        .receipt-row .r-value { color: var(--text-dark); font-weight: 500; text-align: right; }
        .receipt-divider {
            border: none;
            border-top: 1px solid var(--border-light);
            margin: 1rem 0;
        }
        .receipt-total-box {
            background: var(--bg-sand);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }
        .receipt-total-label {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 700;
            color: var(--text-brown);
        }
        .receipt-total-amount {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--primary-gold);
        }
        .modal-actions {
            display: flex;
            gap: 0.75rem;
            padding: 0 2rem 2rem;
        }
        .btn-print {
            flex: 1;
            padding: 0.8rem;
            background: var(--bg-beige);
            border: 1.5px solid var(--border-light);
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-brown);
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-print:hover { background: var(--border-light); }
        .btn-done {
            flex: 1;
            padding: 0.8rem;
            background: var(--primary-gold);
            border: none;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            transition: background 0.2s;
        }
                /* WARNING MODAL STYLE */
        .warning-modal .warning-top {
            background: linear-gradient(135deg, #b07d2a, var(--primary-gold));
        }

        .warning-icon {
            background: var(--warning);
            font-size: 1.4rem;
        }
        #warningOverlay {
            display: none;
            align-items: center;
            justify-content: center;
        }

        #warningOverlay.open {
            display: flex;
        }


        .warning-text {
            font-size: 0.9rem;
            color: var(--text-brown);
            margin-bottom: 1rem;
        }

        .warning-list {
            font-size: 0.92rem;
            color: var(--text-dark);
            padding-left: 1.2rem;
            line-height: 2;
        }

        .warning-note {
            font-size: 0.82rem;
            color: var(--text-gray);
            margin-top: 1rem;
        }

        .btn-done:hover { background: #a87a38; }

        /* ── WARNING MODAL BUTTONS ── */
        .warning-modal .modal-actions {
            padding: 1rem 2rem 1.75rem;
            gap: 0.75rem;
        }
        .warning-modal .modal-actions .btn-done {
            flex: 1;
            margin-top: 0;
            width: auto;
            background: var(--bg-beige);
            border: 1.5px solid var(--border-light);
            color: var(--text-brown);
            font-weight: 600;
        }
        .warning-modal .modal-actions .btn-done:hover {
            background: var(--border-light);
        }
        .warning-modal .modal-actions .btn-confirm {
            flex: 1;
            margin-top: 0;
            width: auto;
            padding: 0.8rem;
            font-size: 0.9rem;
        }

        /* ── FOOTER ── */
        footer {
            background: var(--bg-beige);
            padding: 3rem 5% 0;
            margin-top: 5rem;
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
        .footer-brand-name {
            font-family: 'Playfair Display', serif;
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 0.75rem;
        }
        .footer-brand-desc { color: var(--text-gray); font-size: 0.88rem; line-height: 1.7; }
        .footer-col h4 {
            font-family: 'Playfair Display', serif;
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 1rem;
        }
        .footer-col ul { list-style: none; }
        .footer-col ul li { margin-bottom: 0.6rem; }
        .footer-col ul li a {
            color: var(--text-gray);
            text-decoration: none;
            font-size: 0.88rem;
            transition: color 0.2s;
        }
        .footer-col ul li a:hover { color: var(--primary-gold); }
        .footer-contact-item {
            display: flex;
            align-items: flex-start;
            gap: 0.6rem;
            margin-bottom: 0.65rem;
            color: var(--text-gray);
            font-size: 0.88rem;
        }
        .footer-contact-item span.icon { font-size: 0.95rem; margin-top: 1px; flex-shrink: 0; }
        .footer-social { display: flex; gap: 0.75rem; margin-top: 0.25rem; }
        .footer-social a {
            width: 36px; height: 36px;
            border-radius: 50%;
            background: var(--border-light);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-brown);
            text-decoration: none;
            transition: background 0.2s, color 0.2s;
        }
        .footer-social a:hover { background: var(--primary-gold); color: #fff; }
        .footer-bottom {
            max-width: 1400px;
            margin: 0 auto;
            padding: 1.25rem 0;
            border-top: 1px solid var(--border-light);
            text-align: center;
            color: #9e9189;
            font-size: 0.82rem;
        }

        /* ── DATE AVAILABILITY WARNING ── */
        .date-warning {
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
            margin-top: 0.5rem;
            padding: 0.65rem 0.875rem;
            background: #fff0f0;
            border: 1px solid #f5c0c0;
            border-radius: 8px;
            font-size: 0.82rem;
            color: #c40000;
            font-weight: 500;
            animation: fadeInDown 0.2s ease;
        }

        .date-warning-icon { font-size: 1rem; flex-shrink: 0; }

        .date-checking {
            margin-top: 0.4rem;
            font-size: 0.78rem;
            color: var(--text-gray);
        }

        @keyframes fadeInDown {
            from { opacity: 0; transform: translateY(-4px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        /* ── MOA SECTION ── */
        .moa-section { margin-top: 0; }

        .moa-intro {
            font-size: 0.875rem;
            color: var(--text-gray);
            margin-bottom: 1rem;
            line-height: 1.6;
        }

        .moa-scroll-box {
            border: 1px solid var(--border-light);
            border-radius: 12px;
            max-height: 320px;
            overflow-y: auto;
            background: #fdfcfa;
            margin-bottom: 1.25rem;
            scroll-behavior: smooth;
        }

        .moa-scroll-box::-webkit-scrollbar { width: 6px; }
        .moa-scroll-box::-webkit-scrollbar-track { background: var(--bg-beige); border-radius: 99px; }
        .moa-scroll-box::-webkit-scrollbar-thumb { background: var(--primary-gold); border-radius: 99px; }

        .moa-header {
            text-align: center;
            padding: 1.5rem 2rem 1rem;
            border-bottom: 2px solid var(--border-light);
            background: var(--bg-beige);
            border-radius: 12px 12px 0 0;
        }

        .moa-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--text-dark);
            letter-spacing: 0.05em;
        }

        .moa-subtitle {
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--text-brown);
            margin-top: 0.2rem;
        }

        .moa-tagline {
            font-size: 0.78rem;
            color: var(--text-gray);
            font-style: italic;
            margin-top: 0.15rem;
        }

        .moa-body {
            padding: 1.25rem 1.75rem 1.5rem;
            font-size: 0.82rem;
            color: var(--text-dark);
            line-height: 1.7;
        }

        .moa-body p { margin-bottom: 0.5rem; }

        .moa-clause-title {
            font-weight: 700;
            font-size: 0.8rem;
            color: var(--text-dark);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin: 1.1rem 0 0.4rem;
            padding-bottom: 0.25rem;
            border-bottom: 1px solid var(--border-light);
        }

        .moa-list {
            padding-left: 1.25rem;
            margin-bottom: 0.5rem;
        }

        .moa-list li {
            margin-bottom: 0.35rem;
            font-size: 0.82rem;
            color: var(--text-dark);
        }

        .moa-witness {
            margin-top: 1.25rem;
            font-size: 0.8rem;
            color: var(--text-gray);
            font-style: italic;
            text-align: center;
            padding-top: 0.75rem;
            border-top: 1px solid var(--border-light);
        }

        /* Physical notice */
        .moa-physical-notice {
            display: flex;
            align-items: flex-start;
            gap: 0.875rem;
            background: #fff8e8;
            border: 1px solid #f4d589;
            border-radius: 10px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.25rem;
            font-size: 0.82rem;
            color: var(--text-brown);
            line-height: 1.6;
        }

        .moa-notice-icon { font-size: 1.4rem; flex-shrink: 0; margin-top: 1px; }

        .moa-physical-notice strong {
            display: block;
            font-size: 0.875rem;
            color: var(--text-dark);
            margin-bottom: 0.25rem;
        }

        .moa-physical-notice p { margin: 0; }

        /* Checkbox */
        .moa-checkbox-label {
            display: flex;
            align-items: flex-start;
            gap: 0.75rem;
            cursor: pointer;
            padding: 1rem 1.25rem;
            border: 2px solid var(--border-light);
            border-radius: 10px;
            background: var(--bg-white);
            transition: border-color 0.2s, background 0.2s;
            font-size: 0.85rem;
            color: var(--text-dark);
            line-height: 1.6;
        }

        .moa-checkbox-label:hover { border-color: var(--primary-gold); background: #fffdf7; }

        .moa-checkbox-label.agreed {
            border-color: var(--success);
            background: #f0faf4;
        }

        .moa-checkbox-label input[type="checkbox"] {
            width: 18px;
            height: 18px;
            accent-color: var(--primary-gold);
            flex-shrink: 0;
            margin-top: 2px;
            cursor: pointer;
        }

        .moa-required-msg {
            font-size: 0.8rem;
            color: var(--danger);
            margin-top: 0.5rem;
            padding: 0.5rem 0.75rem;
            background: #fff0f0;
            border-radius: 6px;
            border: 1px solid #f5c0c0;
        }

        /* Confirm button disabled state */
        .btn-confirm:disabled {
            background: #c8b99a;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
            opacity: 0.7;
        }

        /* ── RESPONSIVE ── */
        @media (max-width: 1100px) {
            .booking-layout { grid-template-columns: 1fr; }
            .summary-sidebar { position: static; }
        }
        @media (max-width: 768px) {
            .form-grid { grid-template-columns: 1fr; }
            .service-cards { grid-template-columns: 1fr; }
            .package-cards { grid-template-columns: repeat(2, 1fr); }
            .footer-inner { grid-template-columns: 1fr 1fr; gap: 2rem; }
            .nav-links {
                display: none;
                position: absolute;
                top: 70px; left: 0; right: 0;
                background: var(--bg-white);
                flex-direction: column;
                padding: 1.25rem 5%;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                border-top: 1px solid var(--border-light);
                gap: 1rem;
                z-index: 1001;
            }
            .nav-links.open { display: flex; }
            .nav-links a.active::after { display: none; }
            .mobile-menu { display: flex; }
        }
        @media (max-width: 480px) {
            .package-cards { grid-template-columns: 1fr; }
            .footer-inner { grid-template-columns: 1fr; }
            .modal-body { padding: 1.25rem 1.25rem; }
            .modal-actions { padding: 0 1.25rem 1.5rem; }
        }
    </style>
</head>
<body>

    <!-- NAV -->
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
                <li><a href="Booking.aspx" class="active">Book Now</a></li>
                <li><a href="Calendar.aspx">Calendar</a></li>
                <li><a href="SmartPicker.aspx">Smart Pick</a></li>
                <li><a href="Reviews.aspx">Reviews</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="AboutUs.aspx">About Us</a></li>
            </ul>
            <div class="nav-icons">
                <button class="btn-nav-action" onclick="logout()">Log Out</button>
                <button class="btn-nav-action" onclick="showAdminLogin()" style="margin-left:0.5rem;">Admin</button>
                <button class="mobile-menu" type="button" id="mobileMenuBtn" aria-label="Open navigation menu" aria-controls="primaryNav" aria-expanded="false">
                    <span></span><span></span><span></span>
                </button>
            </div>
        </div>
    </nav>

    <!-- PAGE -->
    <form id="bookingForm" runat="server">
    <div class="page-wrapper">
        <div class="page-header">
            <h1>Book an Event</h1>
            <p>Fill in the details below and we will craft the perfect celebration for you.</p>
        </div>

        <div class="booking-layout">
            <!-- LEFT: FORM -->
            <div class="booking-form-col">
                <div>

                    <!-- SECTION 1: CLIENT INFO -->
                    <div class="form-section">
                        <h2><span class="section-num">1</span> Client Information</h2>
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="txtClientName">Client Name <span class="req">*</span></label>
                                <asp:TextBox ID="txtClientName" runat="server" CssClass="form-input" placeholder="Full name" />
                            </div>
                            <div class="form-group">
                                <label for="txtPhoneNumber">Phone Number <span class="req">*</span></label>
                                <asp:TextBox ID="txtPhoneNumber" runat="server" CssClass="form-input" placeholder="e.g. 09XX XXX XXXX" />
                            </div>
                            <div class="form-group">
                                <label for="ddlEventType">Event Type <span class="req">*</span></label>
                                <asp:DropDownList ID="ddlEventType" runat="server" CssClass="form-input">
                                    <asp:ListItem Text="Select event type" Value="" />
                                    <asp:ListItem Text="Wedding" Value="Wedding" />
                                    <asp:ListItem Text="Birthday" Value="Birthday" />
                                    <asp:ListItem Text="Christening" Value="Christening" />
                                    <asp:ListItem Text="Corporate Event" Value="Corporate Event" />
                                    <asp:ListItem Text="Anniversary" Value="Anniversary" />
                                    <asp:ListItem Text="Debut" Value="Debut" />
                                    <asp:ListItem Text="Family Gathering" Value="Family Gathering" />
                                    <asp:ListItem Text="Others" Value="Others" />
                                </asp:DropDownList>
                            </div>
                            <div class="form-group">
                                <label for="txtEventDate">Event Date <span class="req">*</span></label>
                                <asp:TextBox ID="txtEventDate" runat="server" CssClass="form-input" TextMode="Date" />
                                <div id="dateUnavailableWarning" class="date-warning" style="display:none;">
                                    <span class="date-warning-icon">🚫</span>
                                    <span id="dateWarningText">This date is already booked and unavailable. Please choose a different date.</span>
                                </div>
                                <div id="dateCheckingMsg" class="date-checking" style="display:none;">
                                    ⏳ Checking availability...
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="txtGuestCount">Number of Guests <span class="req">*</span></label>
                                <asp:TextBox ID="txtGuestCount" runat="server" CssClass="form-input" TextMode="Number" placeholder="Minimum 10" />
                            </div>
                            <div class="form-group">
                                <label for="ddlPaymentMode">Mode of Payment <span class="req">*</span></label>
                                <asp:DropDownList ID="ddlPaymentMode" runat="server" CssClass="form-input">
                                    <asp:ListItem Text="Select payment method" Value="" />
                                    <asp:ListItem Text="Bank Transfer" Value="Bank Transfer" />
                                    <asp:ListItem Text="Credit Card" Value="Credit Card" />
                                    <asp:ListItem Text="Debit Card" Value="Debit Card" />
                                    <asp:ListItem Text="E-Wallet (GCash/PayMaya)" Value="E-Wallet (GCash/PayMaya)" />
                                    <asp:ListItem Text="Cash" Value="Cash (Upon Event)" />
                                </asp:DropDownList>
                            </div>
                            <div class="form-group full">
                                <label for="txtVenue">Venue / Address <span class="req">*</span></label>
                                <asp:TextBox ID="txtVenue" runat="server" CssClass="form-input" placeholder="Full venue address" />
                            </div>
                            <div class="form-group full">
                                <label for="ddlVenueLocation">Is venue within Argao? <span class="req">*</span></label>
                                <asp:DropDownList ID="ddlVenueLocation" runat="server" CssClass="form-input">
                                    <asp:ListItem Text="Select location" Value="" />
                                    <asp:ListItem Text="Yes - within Argao (Free)" Value="within" />
                                    <asp:ListItem Text="No - outside Argao (+&#8369;2,500)" Value="outside" />
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>

                    <!-- SECTION 2: SERVICE STYLE -->
                    <div class="form-section">
                        <h2><span class="section-num">2</span> Service Style</h2>
                        <div class="service-cards" id="serviceCards">
                            <label class="service-label" data-service="Buffet (Standard)" data-fee="0" data-fee-type="flat">
                                <input type="radio" name="serviceStyle" value="Buffet (Standard)" required>
                                <div class="service-card">
                                    <div class="service-card-name">Buffet (Standard)</div>
                                    <div class="service-card-price">Free — Included</div>
                                    <div class="service-card-desc">Guests serve themselves at our styled buffet line</div>
                                </div>
                            </label>
                            <label class="service-label" data-service="Plated Service" data-fee="120" data-fee-type="per-guest">
                                <input type="radio" name="serviceStyle" value="Plated Service">
                                <div class="service-card">
                                    <div class="service-card-name">Plated Service</div>
                                    <div class="service-card-price">+&#8369;120/guest</div>
                                    <div class="service-card-desc">Formal table service with servers</div>
                                </div>
                            </label>
                            <label class="service-label" data-service="Live Food Stations" data-fee="150" data-fee-type="per-guest">
                                <input type="radio" name="serviceStyle" value="Live Food Stations">
                                <div class="service-card">
                                    <div class="service-card-name">Live Food Stations</div>
                                    <div class="service-card-price">+&#8369;150/guest</div>
                                    <div class="service-card-desc">Chef-attended live stations</div>
                                </div>
                            </label>
                            <label class="service-label" data-service="Cocktail Reception" data-fee="100" data-fee-type="per-guest">
                                <input type="radio" name="serviceStyle" value="Cocktail Reception">
                                <div class="service-card">
                                    <div class="service-card-name">Cocktail Reception</div>
                                    <div class="service-card-price">+&#8369;100/guest</div>
                                    <div class="service-card-desc">Roaming canapés &amp; drinks service</div>
                                </div>
                            </label>
                        </div>
                    </div>

                    <!-- SECTION 3: PACKAGE SELECTION -->
                    <div class="form-section">
                        <h2><span class="section-num">3</span> Package Selection</h2>
                        <div class="package-cards" id="packageCards">
                            <asp:Repeater ID="rptPackageCards" runat="server">
                                <ItemTemplate>
                                    <label class="pkg-label"
                                        data-pkg='<%# Eval("PackageName") %>'
                                        data-price='<%# Eval("RatePerGuest") %>'>
                                        <input type="radio" name="packageChoice" value='<%# Eval("PackageName") %>'>
                                        <div class="pkg-card">
                                            <div class="pkg-name"><%# Eval("PackageName") %></div>
                                            <div class="pkg-price">&#8369;<%# string.Format("{0:N0}", Eval("RatePerGuest")) %>/guest</div>
                                        </div>
                                    </label>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>

                    <%-- Hidden fields: JS writes calculated values here before postback --%>
                    <asp:HiddenField ID="hfServiceStyle"  runat="server" />
                    <asp:HiddenField ID="hfPackageName"   runat="server" />
                    <asp:HiddenField ID="hfPackagePrice"  runat="server" />
                    <asp:HiddenField ID="hfTotalAmount"   runat="server" />
                    <asp:HiddenField ID="hfMOAAccepted"   runat="server" Value="0" />

                    <%-- Receipt data: code-behind writes these after successful save --%>
                    <asp:HiddenField ID="hfShowReceipt"    runat="server" Value="0" />
                    <asp:HiddenField ID="hfReceiptRef"     runat="server" />
                    <asp:HiddenField ID="hfReceiptName"    runat="server" />
                    <asp:HiddenField ID="hfReceiptPhone"   runat="server" />
                    <asp:HiddenField ID="hfReceiptEvent"   runat="server" />
                    <asp:HiddenField ID="hfReceiptDate"    runat="server" />
                    <asp:HiddenField ID="hfReceiptVenue"   runat="server" />
                    <asp:HiddenField ID="hfReceiptGuests"  runat="server" />
                    <asp:HiddenField ID="hfReceiptPkg"     runat="server" />
                    <asp:HiddenField ID="hfReceiptPPG"     runat="server" />
                    <asp:HiddenField ID="hfReceiptService" runat="server" />
                    <asp:HiddenField ID="hfReceiptPayment" runat="server" />
                    <asp:HiddenField ID="hfReceiptTotal"   runat="server" />

                </div>

                    <!-- SECTION 4: MEMORANDUM OF AGREEMENT -->
                    <div class="form-section moa-section">
                        <h2><span class="section-num">4</span> Memorandum of Agreement</h2>
                        <p class="moa-intro">Please read the full agreement carefully before confirming your booking. You must agree to the terms below to proceed.</p>

                        <div class="moa-scroll-box">
                            <div class="moa-header">
                                <div class="moa-title">CASTRO CATERING SERVICE</div>
                                <div class="moa-subtitle">MEMORANDUM OF AGREEMENT</div>
                                <div class="moa-tagline">Event Booking and Catering Services</div>
                            </div>

                            <div class="moa-body">
                                <div class="moa-clause-title">PARTIES</div>
                                <p>This Agreement is entered into by:</p>
                                <p><strong>Service Provider:</strong> Castro Catering Service, Argao, Cebu</p>
                                <p><strong>Client/Organizer:</strong> As identified in the booking form submitted through this system.</p>

                                <div class="moa-clause-title">EVENT DETAILS</div>
                                <p>The event details (type, date, venue, number of guests, and package) are as specified in the booking form submitted by the Client through the Castro Catering online booking system.</p>

                                <div class="moa-clause-title">DAMAGES &amp; ADDITIONAL FEES</div>
                                <p>The Client is fully responsible for any damage to the venue, equipment, utensils, or any property of Castro Catering Service caused by the Client or their guests. Damage fees are separate from the booking amount.</p>
                                <ul class="moa-list">
                                    <li>Damages will be assessed within 24 hours after the event.</li>
                                    <li>The Client agrees to settle damage fees within 7 days of notification.</li>
                                    <li>Fees for broken/damaged equipment, utensils, linens, or furniture shall be charged at repair or replacement cost.</li>
                                </ul>

                                <div class="moa-clause-title">CANCELLATION POLICY</div>
                                <ul class="moa-list">
                                    <li><strong>30 days or more before event:</strong> Down payment may be applied to a rescheduled date within 6 months.</li>
                                    <li><strong>Less than 30 days before event:</strong> Down payment is fully forfeited.</li>
                                    <li><strong>Cancellation on event day:</strong> Full payment shall be due.</li>
                                    <li><strong>If cancelled by Castro Catering Service (force majeure):</strong> Full refund of down payment.</li>
                                </ul>

                                <div class="moa-clause-title">PAYMENT TERMS (if chosen Mode of payment is CASH)</div>
                                <ul class="moa-list">
                                    <li>The payment shall be made in <strong>CASH only</strong>.</li>
                                    <li>A <strong>50% down payment</strong> is required upon signing/booking confirmation.</li>
                                    <li>The remaining <strong>50% balance</strong> is due on or before the event day.</li>
                                    <li>The 50% down payment is <strong>non-refundable</strong> upon cancellation.</li>
                                    <li>Failure to pay the balance before the event may result in cancellation without refund of the down payment.</li>
                                </ul>

                                <div class="moa-clause-title">GENERAL RULES</div>
                                <ul class="moa-list">
                                    <li>The Client and guests must observe proper conduct and respect venue rules at all times.</li>
                                    <li>No unauthorized alterations or arrangements without prior written consent from Castro Catering Service.</li>
                                    <li>Castro Catering Service may terminate services without refund for disruptive or destructive behavior.</li>
                                    <li>Any amendments to this Agreement must be in writing and signed by both parties.</li>
                                    <li>This Agreement is governed by the laws of the Republic of the Philippines.</li>
                                </ul>

                                <div class="moa-witness">
                                    <em>IN WITNESS WHEREOF, both parties have read and agreed to the terms of this Agreement.</em>
                                </div>
                            </div>
                        </div>

                        <!-- Physical MOA notice -->
                        <div class="moa-physical-notice">
                            <span class="moa-notice-icon">📋</span>
                            <div>
                                <strong>Physical Agreement Required</strong>
                                <p>A printed copy of this Memorandum of Agreement will be presented for signing by both parties prior to your event date. Please bring a valid ID to the scheduled meet-up. Your digital acceptance below serves as your initial acknowledgment.</p>
                            </div>
                        </div>

                        <!-- Checkbox agreement -->
                        <label class="moa-checkbox-label" id="moaCheckLabel">
                            <input type="checkbox" id="chkMOA" onchange="onMOAChange()" />
                            <span>I have read and fully understood the Memorandum of Agreement above. I agree to all terms including the damages policy, cancellation policy, and payment terms. I acknowledge that a physical copy will also be signed before the event.</span>
                        </label>
                        <p class="moa-required-msg" id="moaRequiredMsg" style="display:none;">⚠ You must agree to the Memorandum of Agreement before confirming your booking.</p>
                    </div>

            </div><!-- end booking-form-col -->

            <!-- RIGHT: SUMMARY SIDEBAR -->
            <div class="summary-sidebar">
                <div class="summary-card">
                    <div class="summary-header">
                        <h3>Booking Summary</h3>
                    </div>
                    <div class="summary-body">
                        <div class="summary-row"><span class="s-label">Client Name</span><span class="s-value placeholder" id="sumName">—</span></div>
                        <div class="summary-row"><span class="s-label">Phone</span><span class="s-value placeholder" id="sumPhone">—</span></div>
                        <div class="summary-row"><span class="s-label">Event type</span><span class="s-value placeholder" id="sumEventType">—</span></div>
                        <div class="summary-row"><span class="s-label">Date</span><span class="s-value placeholder" id="sumDate">—</span></div>
                        <div class="summary-row"><span class="s-label">Venue</span><span class="s-value placeholder" id="sumVenue">—</span></div>
                        <div class="summary-row"><span class="s-label">Guests</span><span class="s-value placeholder" id="sumGuests">—</span></div>
                        <div class="summary-row"><span class="s-label">Payment</span><span class="s-value placeholder" id="sumPayment">—</span></div>
                        <div class="summary-row"><span class="s-label">Location</span><span class="s-value placeholder" id="sumLocation">—</span></div>
                        <div class="summary-row"><span class="s-label">Service style</span><span class="s-value placeholder" id="sumService">—</span></div>
                        <div class="summary-row"><span class="s-label">Package</span><span class="s-value placeholder" id="sumPackage">Not selected</span></div>
                        <div class="summary-row"><span class="s-label">Per guest</span><span class="s-value placeholder" id="sumPerGuest">—</span></div>

                        <hr class="summary-divider">

                        <div class="notice-badge" id="weekendNotice">
                        📅 You selected a weekend date. A &#8369;3,000 additional fee will be applied.
                        </div>

                        <div class="notice-badge" id="rushNotice">
                        ⚡ Your event is within 7 days. A &#8369;5,000 rush fee will be added.
                        </div>


                        <div class="cost-row"><span>Subtotal</span><span class="cost-val" id="costSubtotal">&#8369;0</span></div>
                        <div class="cost-row" id="rowServiceFee"><span>Service fee</span><span class="cost-val" id="costServiceFee">Free</span></div>
                        <div class="cost-row" id="rowLocationFee"><span>Location fee</span><span class="cost-val" id="costLocationFee">Free</span></div>
                        <div class="cost-row extra hidden-row" id="rowWeekendFee"><span>Weekend premium</span><span class="cost-val" id="costWeekendFee">+&#8369;3,000</span></div>
                        <div class="cost-row extra hidden-row" id="rowRushFee"><span>Rush fee</span><span class="cost-val" id="costRushFee">+&#8369;5,000</span></div>

                        <div class="total-box">
                            <span class="total-label">Total</span>
                            <span class="total-amount" id="totalAmount">&#8369;0</span>
                        </div>

                        <asp:Label ID="lblBookingError" runat="server" Visible="false"
                            style="display:block;margin-top:0.75rem;padding:0.65rem 0.9rem;background:#fff0f0;border:1px solid #f5c0c0;border-radius:8px;font-size:0.85rem;color:#c40000;font-weight:600;" />

                       <asp:Button ID="btnConfirm" runat="server"
                        Text="Confirm Booking"
                        CssClass="btn-confirm"
                        OnClick="btnConfirm_Click"
                        OnClientClick="return prepareBookingPostback();" />



                    </div>
                </div>
            </div><!-- end summary-sidebar -->

        </div><!-- end booking-layout -->
    </div><!-- end page-wrapper -->
    </form>

    <!-- WARNING MODAL -->
    <div class="modal-overlay" id="warningOverlay" onclick="if(event.target===this)closeWarningModal()">
        <div class="modal-box warning-modal">
            <div class="modal-top warning-top">
                <div class="modal-check warning-icon">⚠</div>
                <h2>Additional Charges Warning</h2>
                <div class="booking-id">Please review before continuing</div>
            </div>
            <div class="modal-body">
                <p class="warning-text">Your booking includes the following additional charges:</p>
                <ul id="warningList" class="warning-list"></ul>
                <p class="warning-note">Do you want to continue with this booking?</p>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-done" onclick="closeWarningModal()">Cancel</button>
                <button type="button" id="btnProceedBooking" class="btn-confirm" style="flex:1;">Yes, Continue</button>
            </div>
        </div>
    </div>






    <!-- RECEIPT MODAL -->
    <div class="modal-overlay" id="modalOverlay" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
        <div class="modal-box" id="modalBox">

            <div class="modal-top">
                <div class="modal-check">&#10003;</div>
                <h2 id="modalTitle">Booking Confirmed!</h2>
                <div class="booking-id" id="modalBookingId">BK-000000</div>
            </div>

            <div class="modal-body">
                <div class="receipt-section">
                    <h4>Client Information</h4>
                    <div class="receipt-row"><span class="r-label">Name</span><span class="r-value" id="rcptName">—</span></div>
                    <div class="receipt-row"><span class="r-label">Phone</span><span class="r-value" id="rcptPhone">—</span></div>
                </div>
                <hr class="receipt-divider">
                <div class="receipt-section">
                    <h4>Event Details</h4>
                    <div class="receipt-row"><span class="r-label">Event Type</span><span class="r-value" id="rcptEventType">—</span></div>
                    <div class="receipt-row"><span class="r-label">Date</span><span class="r-value" id="rcptDate">—</span></div>
                    <div class="receipt-row"><span class="r-label">Venue</span><span class="r-value" id="rcptVenue">—</span></div>
                    <div class="receipt-row"><span class="r-label">Guests</span><span class="r-value" id="rcptGuests">—</span></div>
                </div>
                <hr class="receipt-divider">
                <div class="receipt-section">
                    <h4>Package &amp; Service</h4>
                    <div class="receipt-row"><span class="r-label">Package</span><span class="r-value" id="rcptPackage">—</span></div>
                    <div class="receipt-row"><span class="r-label">Price/guest</span><span class="r-value" id="rcptPricePerGuest">—</span></div>
                    <div class="receipt-row"><span class="r-label">Service Style</span><span class="r-value" id="rcptService">—</span></div>
                    <div class="receipt-row"><span class="r-label">Payment</span><span class="r-value" id="rcptPayment">—</span></div>
                    <div class="receipt-row"><span class="r-label">Status</span><span class="r-value" id="rcptStatus" style="color:#b07d00;font-weight:700;">Pending Approval</span></div>
                    <div class="receipt-row"><span class="r-label">Submitted</span><span class="r-value" id="rcptTimestamp">—</span></div>
                </div>
                <hr class="receipt-divider">
                <div class="receipt-section">
                    <h4>Cost Breakdown</h4>
                    <div class="receipt-row"><span class="r-label">Subtotal</span><span class="r-value" id="rcptSubtotal">—</span></div>
                    <div class="receipt-row" id="rcptRowService"><span class="r-label">Service Fee</span><span class="r-value" id="rcptServiceFee">—</span></div>
                    <div class="receipt-row" id="rcptRowLocation"><span class="r-label">Location Fee</span><span class="r-value" id="rcptLocationFee">—</span></div>
                    <div class="receipt-row" id="rcptRowWeekend" style="display:none"><span class="r-label">Weekend Premium</span><span class="r-value" id="rcptWeekendFee">+&#8369;3,000</span></div>
                    <div class="receipt-row" id="rcptRowRush" style="display:none"><span class="r-label">Rush Fee</span><span class="r-value" id="rcptRushFee">+&#8369;5,000</span></div>
                </div>
                <div class="receipt-total-box">
                    <span class="receipt-total-label">Total Amount</span>
                    <span class="receipt-total-amount" id="rcptTotal">&#8369;0</span>
                </div>
            </div>

            <div class="modal-actions">
                <button class="btn-print" id="btnPrint">&#128424; Print Receipt</button>
                <button class="btn-done" id="btnDone">Done</button>
            </div>

        </div>
    </div>


    <!-- FOOTER -->
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
                <div class="footer-contact-item"><span class="icon">&#128222;</span><span>0967 539 3045</span></div>
                <div class="footer-contact-item"><span class="icon">&#128205;</span><span>Argao, Cebu</span></div>
            </div>
            <div class="footer-col">
                <h4>Follow Us</h4>
                <div class="footer-social">
                    <a href="#" aria-label="Facebook"><svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor"><path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/></svg></a>
                    <a href="#" aria-label="Instagram"><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="2" y="2" width="20" height="20" rx="5" ry="5"/><circle cx="12" cy="12" r="4"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor" stroke="none"/></svg></a>
                </div>
            </div>
        </div>
        <div class="footer-bottom"><p>&copy; 2026 Castro Catering Services. All rights reserved.</p></div>
    </footer>

    <script>
        (function () {
            'use strict';

            // Auth is handled server-side via ASP.NET Session in Page_Load.

            /* ── HELPERS ── */
            function fmt(n) {
                return '₱' + Number(n).toLocaleString('en-PH', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
            }
            function fmtDate(dateStr) {
                if (!dateStr) return '—';
                var d = new Date(dateStr + 'T00:00:00');
                return d.toLocaleDateString('en-PH', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
            }
            function genBookingId() {
                return 'BK-' + Math.floor(100000 + Math.random() * 900000);
            }
            function isWeekend(dateStr) {
                if (!dateStr) return false;
                var d = new Date(dateStr + 'T00:00:00');
                return d.getDay() === 0 || d.getDay() === 6;
            }
            function isRush(dateStr) {
                if (!dateStr) return false;
                var today = new Date(); today.setHours(0, 0, 0, 0);
                var ev = new Date(dateStr + 'T00:00:00');
                var diff = (ev - today) / (1000 * 60 * 60 * 24);
                return diff >= 0 && diff <= 7;
            }

            function formatDisplayDate(dateStr) {
                if (!dateStr) return '';
                var d = new Date(dateStr + 'T00:00:00');
                return d.toLocaleDateString('en-PH', { year: 'numeric', month: 'long', day: 'numeric' });
            }
            function byName(name) {
                return document.querySelector('[name$="' + name + '"]')
                    || document.getElementById(name);
            }

            function on(el, evt, fn) {
                if (el) el.addEventListener(evt, fn);
            }

            /* ── STATE ── */
            var state = {
                name: '', phone: '', eventType: '', date: '', venue: '',
                guests: 0, payment: '', location: '',
                serviceName: '', serviceFee: 0, serviceFeeType: 'flat',
                packageName: '', packagePrice: 0,
                locationFee: 0, weekendFee: 0, rushFee: 0,
                dateBlocked: false
            };
            var proceedAfterWarning = false;



            /* ── SUMMARY ELEMENT REFS ── */
            var S = {
                name: document.getElementById('sumName'),
                phone: document.getElementById('sumPhone'),
                eventType: document.getElementById('sumEventType'),
                date: document.getElementById('sumDate'),
                venue: document.getElementById('sumVenue'),
                guests: document.getElementById('sumGuests'),
                payment: document.getElementById('sumPayment'),
                location: document.getElementById('sumLocation'),
                service: document.getElementById('sumService'),
                package: document.getElementById('sumPackage'),
                perGuest: document.getElementById('sumPerGuest'),
                subtotal: document.getElementById('costSubtotal'),
                svcFee: document.getElementById('costServiceFee'),
                locFee: document.getElementById('costLocationFee'),
                rowWeekend: document.getElementById('rowWeekendFee'),
                rowRush: document.getElementById('rowRushFee'),
                wkNotice: document.getElementById('weekendNotice'),
                rushNotice: document.getElementById('rushNotice'),
                total: document.getElementById('totalAmount')
            };

            function sv(el, val) {
                if (!el) return;
                el.textContent = val || '—';
                if (!val || val === '—' || val === 'Not selected') {
                    el.classList.add('placeholder');
                } else {
                    el.classList.remove('placeholder');
                }
            }

            function updateSummary() {
                sv(S.name, state.name);
                sv(S.phone, state.phone);
                sv(S.eventType, state.eventType);
                sv(S.date, state.date ? fmtDate(state.date) : '');
                sv(S.venue, state.venue);
                sv(S.guests, state.guests > 0 ? state.guests + ' guests' : '');
                sv(S.payment, state.payment);
                sv(S.location, state.location === 'within' ? 'Within Argao'
                    : state.location === 'outside' ? 'Outside Argao (+₱2,500)'
                        : '');
                sv(S.service, state.serviceName);
                sv(S.package, state.packageName || 'Not selected');
                sv(S.perGuest, state.packagePrice > 0 ? fmt(state.packagePrice) + '/guest' : '');

                var guests = state.guests > 0 ? state.guests : 0;
                var subtotal = state.packagePrice * guests;
                var svcFee = state.serviceFeeType === 'per-guest' ? state.serviceFee * guests : 0;
                var locFee = state.locationFee;
                var wkFee = state.weekendFee;
                var rushFee = state.rushFee;
                var total = subtotal + svcFee + locFee + wkFee + rushFee;

                S.subtotal.textContent = fmt(subtotal);

                if (svcFee > 0) {
                    S.svcFee.textContent = '+' + fmt(svcFee);
                    S.svcFee.style.color = 'var(--warning)';
                } else {
                    S.svcFee.textContent = 'Free';
                    S.svcFee.style.color = 'var(--success)';
                }

                if (locFee > 0) {
                    S.locFee.textContent = '+' + fmt(locFee);
                    S.locFee.style.color = 'var(--warning)';
                } else {
                    S.locFee.textContent = 'Free';
                    S.locFee.style.color = 'var(--success)';
                }

                S.rowWeekend.classList.toggle('hidden-row', wkFee === 0);
                S.wkNotice.classList.toggle('show', wkFee > 0);
                S.rowRush.classList.toggle('hidden-row', rushFee === 0);
                S.rushNotice.classList.toggle('show', rushFee > 0);

                S.total.textContent = fmt(total);
            }

            /* ── FORM LISTENERS — use name selectors (reliable for ASP.NET controls) ── */
            function onEl(el, evt, fn) {
                if (el) el.addEventListener(evt, fn);
            }
            function byName(name) {
                return document.querySelector('[name$="' + name + '"]') ||
                    document.getElementById(name);
            }

            onEl(byName('txtClientName'), 'input', function () { state.name = this.value.trim(); updateSummary(); });
            onEl(byName('txtPhoneNumber'), 'input', function () { state.phone = this.value.trim(); updateSummary(); });
            onEl(byName('ddlEventType'), 'change', function () { state.eventType = this.value; updateSummary(); });
            onEl(byName('txtEventDate'), 'change', function () {
                var val = this.value;
                state.date        = val;
                state.dateBlocked = false;
                state.weekendFee  = isWeekend(val) ? 3000 : 0;
                state.rushFee     = isRush(val)    ? 5000 : 0;

                var warning   = document.getElementById('dateUnavailableWarning');
                var checking  = document.getElementById('dateCheckingMsg');

                if (!val) {
                    if (warning)  warning.style.display  = 'none';
                    if (checking) checking.style.display = 'none';
                    updateSummary();
                    return;
                }

                // Show checking indicator
                if (warning)  warning.style.display  = 'none';
                if (checking) checking.style.display = 'block';

                fetch('CheckBookedDate.ashx?date=' + encodeURIComponent(val))
                    .then(function(r) { return r.json(); })
                    .then(function(data) {
                        if (checking) checking.style.display = 'none';
                        if (data && data.booked) {
                            state.dateBlocked = true;
                            if (warning) {
                                document.getElementById('dateWarningText').textContent =
                                    'This date (' + formatDisplayDate(val) + ') is already booked and unavailable. Please choose a different date.';
                                warning.style.display = 'flex';
                            }
                        } else {
                            state.dateBlocked = false;
                            if (warning) warning.style.display = 'none';
                        }
                        updateSummary();
                    })
                    .catch(function() {
                        if (checking) checking.style.display = 'none';
                        state.dateBlocked = false;
                        updateSummary();
                    });
            });
            onEl(byName('txtGuestCount'), 'input', function () {
                var v = parseInt(this.value, 10);
                state.guests = isNaN(v) || v < 0 ? 0 : v;
                updateSummary();
            });
            onEl(byName('ddlPaymentMode'), 'change', function () { state.payment = this.value; updateSummary(); });
            onEl(byName('txtVenue'), 'input', function () { state.venue = this.value.trim(); updateSummary(); });
            onEl(byName('ddlVenueLocation'), 'change', function () {
                state.location = this.value;
                state.locationFee = this.value === 'outside' ? 2500 : 0;
                updateSummary();
            });

            /* ── Set min date on the date field ── */
            var dateInput = byName('txtEventDate');
            if (dateInput) {
                var today = new Date();
                dateInput.min = today.getFullYear() + '-'
                    + String(today.getMonth() + 1).padStart(2, '0') + '-'
                    + String(today.getDate()).padStart(2, '0');
            }

            /* ── SERVICE CARD CLICK ── */
            var serviceLabels = document.querySelectorAll('#serviceCards .service-label');
            serviceLabels.forEach(function (lbl) {
                lbl.addEventListener('click', function () {
                    serviceLabels.forEach(function (l) { l.classList.remove('selected'); });
                    lbl.classList.add('selected');
                    state.serviceName = lbl.dataset.service;
                    state.serviceFee = parseFloat(lbl.dataset.fee) || 0;
                    state.serviceFeeType = lbl.dataset.feeType;
                    updateSummary();
                });
            });

            /* ── PACKAGE CARD CLICK ── */
            var pkgLabels = document.querySelectorAll('#packageCards .pkg-label');
            pkgLabels.forEach(function (lbl) {
                lbl.addEventListener('click', function () {
                    pkgLabels.forEach(function (l) { l.classList.remove('selected'); });
                    lbl.classList.add('selected');
                    state.packageName = lbl.dataset.pkg;
                    state.packagePrice = parseFloat(lbl.dataset.price) || 0;
                    updateSummary();
                });
            });
            /* ── MODAL CLOSE ── */
            function closeModal() {
                document.getElementById('modalOverlay').classList.remove('open');
                document.body.style.overflow = '';
            }

            /* ── WARNING MODAL ── */
            function openWarningModal(warnings) {
                var list = document.getElementById('warningList');
                list.innerHTML = '';
                warnings.forEach(function (w) {
                    var li = document.createElement('li');
                    li.textContent = w;
                    li.style.marginBottom = '0.5rem';
                    list.appendChild(li);
                });
                document.getElementById('warningOverlay').classList.add('open');
                document.body.style.overflow = 'hidden';
            }

            function closeWarningModal() {
                document.getElementById('warningOverlay').classList.remove('open');
                document.body.style.overflow = '';
            }
            window.closeWarningModal = closeWarningModal;

            // "Yes, Continue" in the warning modal — write fields then submit form directly
            document.getElementById('btnProceedBooking').addEventListener('click', function () {
                closeWarningModal();

                if (state.dateBlocked) {
                    var w = document.getElementById('dateUnavailableWarning');
                    if (w) { w.style.display = 'flex'; w.scrollIntoView({ behavior: 'smooth', block: 'center' }); }
                    return;
                }

                _writeHiddenFields();
                _submitForm();
            });


            /* ── MOBILE NAV ── */
            var mobileBtn = document.getElementById('mobileMenuBtn');
            var primaryNav = document.getElementById('primaryNav');
            if (mobileBtn) {
                mobileBtn.addEventListener('click', function () {
                    var expanded = this.getAttribute('aria-expanded') === 'true';
                    this.setAttribute('aria-expanded', String(!expanded));
                    primaryNav.classList.toggle('open');
                });
            }

            /* ── LOGOUT ── */
            window.logout = function () {
                localStorage.removeItem('currentUser');
                localStorage.removeItem('castroUser');
                window.location.href = 'LoginSignup.aspx';
            };

            /* initial render */
            updateSummary();

            /* ── AUTO-SELECT PACKAGE FROM URL (?package=Name) ── */
            (function () {
                var params = new URLSearchParams(window.location.search);
                var pkg = params.get('package');
                if (!pkg) return;
                var found = false;
                pkgLabels.forEach(function (lbl) {
                    if (lbl.dataset.pkg === pkg) {
                        lbl.click();
                        found = true;
                        setTimeout(function () {
                            lbl.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        }, 300);
                    }
                });
            })();

            /* ── MOA CHECKBOX ── */
            window.onMOAChange = function() {
                var chk   = document.getElementById('chkMOA');
                var label = document.getElementById('moaCheckLabel');
                var msg   = document.getElementById('moaRequiredMsg');

                if (chk && chk.checked) {
                    document.getElementById('<%= hfMOAAccepted.ClientID %>').value = '1';
                    if (label) label.classList.add('agreed');
                    if (msg)   msg.style.display = 'none';
                } else {
                    document.getElementById('<%= hfMOAAccepted.ClientID %>').value = '0';
                    if (label) label.classList.remove('agreed');
                }
            };

            /* ── Shared helpers ── */
            function _writeHiddenFields() {
                var guests   = state.guests;
                var subtotal = state.packagePrice * guests;
                var svcFee   = state.serviceFeeType === 'per-guest' ? state.serviceFee * guests : 0;
                var total    = subtotal + svcFee + state.locationFee + state.weekendFee + state.rushFee;

                document.getElementById('<%= hfServiceStyle.ClientID %>').value = state.serviceName;
                document.getElementById('<%= hfPackageName.ClientID %>').value  = state.packageName;
                document.getElementById('<%= hfPackagePrice.ClientID %>').value = state.packagePrice;
                document.getElementById('<%= hfTotalAmount.ClientID %>').value  = total;
            }

            function _submitForm() {
                // Trigger server click reliably even when __doPostBack is unavailable.
                if (typeof __doPostBack === 'function') {
                    __doPostBack('<%= btnConfirm.UniqueID %>', '');
                    return;
                }

                var form = document.getElementById('<%= bookingForm.ClientID %>');
                if (!form) return;

                var eventTarget = form.querySelector('input[name="__EVENTTARGET"]');
                if (!eventTarget) {
                    eventTarget = document.createElement('input');
                    eventTarget.type = 'hidden';
                    eventTarget.name = '__EVENTTARGET';
                    form.appendChild(eventTarget);
                }

                var eventArgument = form.querySelector('input[name="__EVENTARGUMENT"]');
                if (!eventArgument) {
                    eventArgument = document.createElement('input');
                    eventArgument.type = 'hidden';
                    eventArgument.name = '__EVENTARGUMENT';
                    form.appendChild(eventArgument);
                }

                eventTarget.value = '<%= btnConfirm.UniqueID %>';
                eventArgument.value = '';
                form.submit();
            }

            /* ── prepareBookingPostback: called by OnClientClick on btnConfirm ──
               Only runs when the user clicks the button directly (not via warning modal). */
            window.prepareBookingPostback = function () {

                var missing = [];
                if (!state.name)        missing.push('Client Name');
                if (!state.phone)       missing.push('Phone Number');
                if (!state.eventType)   missing.push('Event Type');
                if (!state.date)        missing.push('Event Date');
                if (!state.guests)      missing.push('Number of Guests');
                if (!state.payment)     missing.push('Mode of Payment');
                if (!state.venue)       missing.push('Venue');
                if (!state.location)    missing.push('Venue Location');
                if (!state.serviceName) missing.push('Service Style');
                if (!state.packageName) missing.push('Package');

                if (missing.length > 0) {
                    alert('Please fill in:\n• ' + missing.join('\n• '));
                    return false;
                }

                // MOA must be accepted
                var moaAccepted = document.getElementById('<%= hfMOAAccepted.ClientID %>');
                if (!moaAccepted || moaAccepted.value !== '1') {
                    var msg = document.getElementById('moaRequiredMsg');
                    if (msg) { msg.style.display = 'block'; msg.scrollIntoView({ behavior: 'smooth', block: 'center' }); }
                    return false;
                }

                // Date must not be blocked
                if (state.dateBlocked) {
                    var w = document.getElementById('dateUnavailableWarning');
                    if (w) { w.style.display = 'flex'; w.scrollIntoView({ behavior: 'smooth', block: 'center' }); }
                    return false;
                }

                var warnings = [];
                if (state.weekendFee > 0) warnings.push('Weekend premium: ₱3,000');
                if (state.rushFee    > 0) warnings.push('Rush fee: ₱5,000');

                if (warnings.length > 0) {
                    openWarningModal(warnings);
                    return false; // stop — user must confirm in warning modal
                }

                // No warnings — write fields and allow postback
                _writeHiddenFields();
                return true;
            };



            function logout() {
                localStorage.removeItem('currentUser');
                window.location.href = 'LoginSignup.aspx';
            }

            /* ── Admin Login Modal ── */
            function showAdminLogin() {
                document.getElementById('adminLoginOverlay').style.display = 'flex';
                document.getElementById('adminUsername').value = '';
                document.getElementById('adminPassword').value = '';
                document.getElementById('adminError').style.display = 'none';
                setTimeout(function () { document.getElementById('adminUsername').focus(); }, 100);
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
            window.showAdminLogin = showAdminLogin;
            window.closeAdminLogin = closeAdminLogin;
            window.submitAdminLogin = submitAdminLogin;
            document.addEventListener('keydown', function (e) {
                if (e.key === 'Escape') closeAdminLogin();
            });

        })();
    </script>


    <script>
        /* ── Receipt modal utilities ── */
        function closeReceiptModal() {
            document.getElementById('modalOverlay').classList.remove('open');
            document.body.style.overflow = '';
        }

        (function openReceiptIfPosted() {
            var hfShow = document.getElementById('<%= hfShowReceipt.ClientID %>');
            if (!hfShow || hfShow.value !== '1') return;

            var val = function(id) {
                var el = document.getElementById(id);
                return el ? el.value : '';
            };
            var setText = function(id, text) {
                var el = document.getElementById(id);
                if (el) el.textContent = text || '—';
            };

            setText('modalBookingId', val('<%= hfReceiptRef.ClientID %>'));
            setText('rcptName', val('<%= hfReceiptName.ClientID %>'));
            setText('rcptPhone', val('<%= hfReceiptPhone.ClientID %>'));
            setText('rcptEventType', val('<%= hfReceiptEvent.ClientID %>'));
            setText('rcptDate', val('<%= hfReceiptDate.ClientID %>'));
            setText('rcptVenue', val('<%= hfReceiptVenue.ClientID %>'));
            setText('rcptGuests', val('<%= hfReceiptGuests.ClientID %>') + ' guests');
            setText('rcptPackage', val('<%= hfReceiptPkg.ClientID %>'));
            setText('rcptPricePerGuest', val('<%= hfReceiptPPG.ClientID %>'));
            setText('rcptService', val('<%= hfReceiptService.ClientID %>'));
            setText('rcptPayment', val('<%= hfReceiptPayment.ClientID %>'));
            setText('rcptStatus', 'Pending Approval');
            setText('rcptTimestamp', new Date().toLocaleString('en-PH'));
            setText('rcptSubtotal', val('<%= hfReceiptTotal.ClientID %>'));
            setText('rcptServiceFee', 'Included');
            setText('rcptLocationFee', 'Included');
            setText('rcptTotal', val('<%= hfReceiptTotal.ClientID %>'));

            var weekendRow = document.getElementById('rcptRowWeekend');
            var rushRow = document.getElementById('rcptRowRush');
            if (weekendRow) weekendRow.style.display = 'none';
            if (rushRow) rushRow.style.display = 'none';

            var overlay = document.getElementById('modalOverlay');
            if (overlay) overlay.classList.add('open');
            document.body.style.overflow = 'hidden';

            // Prevent modal reopening on manual refresh after successful postback.
            hfShow.value = '0';
        })();

        /* ── Done: close modal and reload for fresh form ── */
        document.getElementById('btnDone').addEventListener('click', function() {
            closeReceiptModal();
            window.location.href = 'Booking.aspx';
        });

        /* ── Print Receipt ── */
        document.getElementById('btnPrint').addEventListener('click', function() {
            var get = function(id) { var el = document.getElementById(id); return el ? el.textContent : ''; };

            var id      = document.getElementById('modalBookingId').textContent;
            var name    = get('rcptName');
            var phone   = get('rcptPhone');
            var evtType = get('rcptEventType');
            var date    = get('rcptDate');
            var venue   = get('rcptVenue');
            var guests  = get('rcptGuests');
            var pkg     = get('rcptPackage');
            var ppg     = get('rcptPricePerGuest');
            var svc     = get('rcptService');
            var payment = get('rcptPayment');
            var total   = get('rcptTotal');

            var html = '<!DOCTYPE html><html><head><meta charset="UTF-8">'
                + '<title>Booking Receipt ' + id + '</title>'
                + '<link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Inter:wght@400;600&display=swap" rel="stylesheet">'
                + '<style>'
                + 'body{font-family:Inter,sans-serif;max-width:620px;margin:40px auto;padding:0 20px;color:#2e211b;background:#fff;}'
                + '.header{text-align:center;border-bottom:3px solid #C9A961;padding-bottom:20px;margin-bottom:24px;}'
                + '.header h1{font-family:"Playfair Display",serif;font-size:1.8rem;color:#4A3F35;margin:0 0 4px;}'
                + '.bid{color:#C9A961;font-size:0.9rem;font-weight:600;}'
                + '.issued{font-size:0.8rem;color:#9e9189;margin-top:4px;}'
                + 'h2{font-size:0.72rem;text-transform:uppercase;letter-spacing:0.08em;color:#C9A961;font-weight:700;margin:20px 0 8px;border-bottom:1px solid #e5dcd0;padding-bottom:4px;}'
                + 'table{width:100%;border-collapse:collapse;font-size:0.9rem;margin-bottom:4px;}'
                + 'td{padding:5px 0;vertical-align:top;}'
                + 'td:first-child{color:#756e64;width:48%;}'
                + 'td:last-child{font-weight:600;text-align:right;}'
                + '.total-box{background:#f5ebd3;border-radius:10px;padding:14px 18px;display:flex;justify-content:space-between;align-items:center;margin-top:16px;}'
                + '.tl{font-family:"Playfair Display",serif;font-size:1rem;font-weight:700;color:#4A3F35;}'
                + '.ta{font-family:"Playfair Display",serif;font-size:1.6rem;font-weight:700;color:#C9A961;}'
                + '.footer{text-align:center;margin-top:28px;padding-top:16px;border-top:1px solid #e5dcd0;font-size:0.8rem;color:#9e9189;}'
                + '@media print{body{margin:20px auto;}}'
                + '</style></head><body>'
                + '<div class="header"><h1>Castro Catering</h1>'
                + '<div class="bid">Booking Receipt &mdash; ' + id + '</div>'
                + '<div class="issued">Issued: ' + new Date().toLocaleString('en-PH') + '</div></div>'
                + '<h2>Client Information</h2>'
                + '<table><tr><td>Name</td><td>' + name + '</td></tr><tr><td>Phone</td><td>' + phone + '</td></tr></table>'
                + '<h2>Event Details</h2>'
                + '<table><tr><td>Event Type</td><td>' + evtType + '</td></tr><tr><td>Date</td><td>' + date + '</td></tr>'
                + '<tr><td>Venue</td><td>' + venue + '</td></tr><tr><td>Guests</td><td>' + guests + '</td></tr></table>'
                + '<h2>Package &amp; Service</h2>'
                + '<table><tr><td>Package</td><td>' + pkg + '</td></tr><tr><td>Price/guest</td><td>' + ppg + '</td></tr>'
                + '<tr><td>Service Style</td><td>' + svc + '</td></tr><tr><td>Payment</td><td>' + payment + '</td></tr></table>'
                + '<div class="total-box"><span class="tl">Total Amount</span><span class="ta">' + total + '</span></div>'
                + '<div class="footer">Thank you for choosing Castro Catering &mdash; Crafting elegant moments.<br>Argao, Cebu &bull; 0967 539 3045</div>'
                + '</body></html>';

            var w = window.open('', '_blank');
            w.document.write(html);
            w.document.close();
            w.focus();
            setTimeout(function () { w.print(); }, 500);
        });

        /* Close modal when clicking outside */
        document.getElementById('modalOverlay').addEventListener('click', function (e) {
            if (e.target === this) closeReceiptModal();
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