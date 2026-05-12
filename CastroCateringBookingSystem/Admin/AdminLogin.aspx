<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="CastroCateringBookingSystem.Admin.AdminLogin" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Login — Castro Catering</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Lato:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
        --gold:      #c2934a;
        --gold-glow: #f4d589;
        --gold-dark: #a07535;
        --gold-deep: #7a5520;
        --text-muted:#756e64;
        --success:   #2d8a53;
        --destructive:#d92626;
        --trans:     all 0.5s cubic-bezier(0.77,0,0.175,1);
    }

    body {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        font-family: 'Lato', sans-serif;
        overflow: hidden;
        background: #1a1410;
    }

    body::before {
        content: '';
        position: fixed;
        inset: 0;
        background:
            radial-gradient(ellipse 700px 500px at 30% 50%, rgba(194,147,74,0.13) 0%, transparent 70%),
            radial-gradient(ellipse 500px 400px at 75% 50%, rgba(244,213,137,0.08) 0%, transparent 70%);
        pointer-events: none;
        z-index: 0;
    }

    /* Floating particles */
    @keyframes floatUp {
        0%   { opacity:0; transform:translateY(0) scale(0.5); }
        20%  { opacity:0.55; }
        80%  { opacity:0.25; }
        100% { opacity:0; transform:translateY(-120px) scale(1.2); }
    }
    .particle {
        position:fixed; width:3px; height:3px;
        border-radius:50%; background:var(--gold);
        pointer-events:none;
        animation: floatUp linear infinite;
        z-index: 0;
    }
    .p1{left:12%;bottom:8%; animation-duration:6s;   animation-delay:0s;}
    .p2{left:32%;bottom:5%; animation-duration:8s;   animation-delay:1.5s; width:2px;height:2px;}
    .p3{left:54%;bottom:9%; animation-duration:7s;   animation-delay:3s;}
    .p4{left:74%;bottom:12%;animation-duration:9s;   animation-delay:0.8s; width:2px;height:2px;}
    .p5{left:88%;bottom:6%; animation-duration:6.5s; animation-delay:2s;}

    /* Scanline */
    @keyframes scanline {
        0%   { transform: translateY(-100%); }
        100% { transform: translateY(100vh); }
    }
    .scanline {
        position: fixed; left:0; top:0;
        width:100%; height:2px;
        background: linear-gradient(transparent, rgba(194,147,74,0.07), transparent);
        animation: scanline 8s linear infinite;
        pointer-events: none;
        z-index: 9999;
    }

    /* CARD */
    .login-card {
        position: relative;
        z-index: 10;
        width: 420px;
        background: #ffffff;
        border-radius: 0;
        border: 1.5px solid rgba(194,147,74,0.38);
        box-shadow:
            0 0 40px rgba(194,147,74,0.18),
            0 0 90px rgba(194,147,74,0.07);
        overflow: hidden;
    }

    /* Gold top bar */
    .card-top {
        background: linear-gradient(145deg, #a07535 0%, #c2934a 50%, #f4d589 100%);
        padding: 2rem 2.5rem 1.75rem;
        text-align: center;
    }

    .admin-badge {
        display: inline-flex;
        align-items: center;
        gap: 0.4rem;
        background: rgba(33,28,24,0.25);
        color: rgba(33,28,24,0.85);
        font-size: 0.68rem;
        font-weight: 700;
        letter-spacing: 2px;
        text-transform: uppercase;
        padding: 0.3rem 0.85rem;
        border-radius: 99px;
        margin-bottom: 0.85rem;
    }

    .card-top h1 {
        font-family: 'Playfair Display', serif;
        font-size: 1.6rem;
        font-weight: 700;
        color: #211c18;
        line-height: 1.2;
        margin-bottom: 0.3rem;
    }

    .card-top p {
        font-size: 0.8rem;
        color: rgba(33,28,24,0.75);
    }

    /* Form body */
    .card-body {
        padding: 2rem 2.5rem 2.5rem;
    }

    .input-group {
        width: 100%;
        margin-bottom: 1.1rem;
        position: relative;
    }

    .input-group label {
        display: block;
        font-size: 0.67rem;
        color: var(--text-muted);
        letter-spacing: 1.8px;
        text-transform: uppercase;
        margin-bottom: 5px;
        font-weight: 600;
    }

    .input-group input {
        width: 100%;
        padding: 10px 38px 10px 14px;
        background: #fcfbf9;
        border: 1px solid #e0ddd5;
        color: #211c18;
        font-family: 'Lato', sans-serif;
        font-size: 0.92rem;
        outline: none;
        border-radius: 2px;
        transition: border-color 0.3s, box-shadow 0.3s;
    }

    .input-group input::placeholder { color: rgba(117,110,100,0.45); }

    .input-group input:focus {
        border-color: var(--gold);
        box-shadow: 0 0 0 3px rgba(194,147,74,0.14);
        background: rgba(194,147,74,0.05);
    }

    .input-group .icon {
        position: absolute;
        right: 12px; bottom: 10px;
        width: 15px; height: 15px;
        opacity: 0.4;
    }

    .btn-login {
        width: 100%;
        padding: 11px;
        border: none;
        cursor: pointer;
        font-family: 'Lato', sans-serif;
        font-size: 0.73rem;
        font-weight: 700;
        letter-spacing: 2.5px;
        text-transform: uppercase;
        border-radius: 2px;
        margin-top: 0.5rem;
        background: linear-gradient(90deg, var(--gold-dark), var(--gold), var(--gold-glow));
        color: #211c18;
        box-shadow: 0 2px 16px rgba(194,147,74,0.35);
        transition: var(--trans);
    }

    .btn-login:hover {
        box-shadow: 0 4px 28px rgba(194,147,74,0.6);
        transform: translateY(-1px);
    }

    .val-msg {
        font-size: 0.72rem;
        display: block;
        min-height: 16px;
        margin-top: 0.75rem;
        padding: 0.45rem 0.75rem;
        border-radius: 4px;
        text-align: center;
    }

    .status-err {
        color: var(--destructive);
        background: #fff0f0;
        border: 1px solid #f5c0c0;
    }

    .back-link {
        display: block;
        text-align: center;
        margin-top: 1.25rem;
        font-size: 0.78rem;
        color: var(--text-muted);
        text-decoration: none;
        transition: color 0.2s;
    }

    .back-link:hover { color: var(--gold); }

    .security-note {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-top: 1.5rem;
        padding: 0.65rem 0.9rem;
        background: #fdfcf8;
        border: 1px solid #e8dfd0;
        border-radius: 6px;
        font-size: 0.72rem;
        color: var(--text-muted);
    }
    </style>
</head>
<body>
    <div class="scanline"></div>
    <div class="particle p1"></div>
    <div class="particle p2"></div>
    <div class="particle p3"></div>
    <div class="particle p4"></div>
    <div class="particle p5"></div>

    <form id="adminLoginForm" runat="server">
        <div class="login-card">

            <div class="card-top">
                <div class="admin-badge">🔐 Admin Portal</div>
                <h1>Castro Catering</h1>
                <p>Administration Panel — Authorized Access Only</p>
            </div>

            <div class="card-body">

                <div class="input-group">
                    <label for="txtAdminUsername">Username</label>
                    <asp:TextBox ID="txtAdminUsername" runat="server" placeholder="Admin username" />
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#c2934a" stroke-width="2">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                    </svg>
                </div>

                <div class="input-group">
                    <label for="txtAdminPassword">Password</label>
                    <asp:TextBox ID="txtAdminPassword" runat="server" TextMode="Password" placeholder="Admin password" />
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#c2934a" stroke-width="2">
                        <rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                    </svg>
                </div>

                <asp:Label ID="lblStatus" runat="server" CssClass="val-msg" Visible="false" />

                <asp:Button ID="btnAdminLogin" runat="server" Text="Sign In to Admin Panel"
                            CssClass="btn-login" OnClick="btnAdminLogin_Click" />

                <div class="security-note">
                    🔒 This portal is restricted to authorized administrators only.
                    Unauthorized access attempts are logged.
                </div>

                <a href="../Pages/Home.aspx" class="back-link">← Back to Client Site</a>

            </div>
        </div>
    </form>
</body>
</html>
