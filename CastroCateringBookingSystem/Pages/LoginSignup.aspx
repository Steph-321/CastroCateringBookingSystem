<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginSignup.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.LoginSignup" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login / Sign Up</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@500;600;700&family=Lato:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
        --gold:           #c2934a;
        --gold-glow:      #f4d589;
        --gold-dark:      #a07535;
        --gold-deep:      #7a5520;
        --dark-bg:        #211c18;
        --dark-fg:        #f5f0e8;
        --dark-card:      #221c19;
        --dark-primary:   #e6c068;
        --dark-secondary: #332b26;
        --dark-border:    #332b26;
        --text-muted:     #756e64;
        --success:        #2d8a53;
        --destructive:    #d92626;
        --trans:          all 0.7s cubic-bezier(0.77,0,0.175,1);
    }

    body {
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: url('image/catering.jpg') no-repeat center center fixed; /* your image path */
        background-size: cover; /* make it fill the screen */
        font-family: 'Lato', sans-serif;
        overflow: hidden;
    }


    /* Diamond tile BG */
   

    /* Ambient blobs */
    body::after {
        content: '';
        position: fixed; inset: 0;
        background:
            radial-gradient(ellipse 600px 400px at 20% 50%, rgba(194,147,74,0.09) 0%, transparent 70%),
            radial-gradient(ellipse 500px 350px at 80% 50%, rgba(244,213,137,0.07) 0%, transparent 70%);
        pointer-events: none;
    }

    body::before {
        content: '';
        position: fixed;
        inset: 0;
        background: inherit;
        filter: blur(3px);
        transform: scale(1.05); /* prevents white edges from blur */
        z-index: -1;
    }

    /* WRAPPER 750 × 560 — taller to fit 5-field signup form */
    .wrapper {
        position: relative;
        display: flex;
        width: 750px;
        height: 560px;
        overflow: hidden;
        border: 1.5px solid rgba(194,147,74,0.38);
        box-shadow:
            0 0 40px rgba(194,147,74,0.18),
            0 0 90px rgba(194,147,74,0.07),
            inset 0 0 60px rgba(194,147,74,0.03);
        backdrop-filter: blur(8px);
        -webkit-backdrop-filter: blur(8px);
    }

    .wrapper::before, .wrapper::after {
        content: '';
        position: absolute;
        width: 22px; height: 22px;
        border-color: var(--gold);
        border-style: solid;
        z-index: 200;
    }
    .wrapper::before { 
      
        content: '';
        position: absolute;
        top: 0;
        bottom: 0;
        left: 50%;
        width: 2px;
        background: var(--gold);
        transform: skew(-20deg); /* tilt to create slash */
        z-index: 100;
    }

    .wrapper::after  { bottom:-1px; right:-1px; border-width: 0 2px 2px 0; }

    .screens {
        display: flex;
        width: 200%;
        height: 100%;
        transition: var(--trans);
    }
    .wrapper.signup-active .screens {
        transform: translateX(-50%);
    }

    .screen {
        width: 750px;
        height: 100%;
        display: flex;
        flex-shrink: 0;
    }

   .screen-form {
        width: 50%;
        flex-shrink: 0;
        height: 100%;
        background: #ffffff;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 50px;
        position: relative;
       
        z-index: 2;  /* form above panel */
    }

    .screen-panel {
        width: calc(50% + 50px);
        flex-shrink: 0;
        height: 100%;
        position: relative;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        justify-content: center;
        overflow: hidden;
        z-index: 1;
    }
    /* LOGIN screen — Panel on RIGHT */
    .login-screen .screen-panel {
        background: linear-gradient(145deg, #a07535 0%, #c2934a 50%, #f4d589 100%);
        margin-left: -30px;
        clip-path: polygon(30px 0, 100% 0, 100% 100%, 0% 100%);
        padding: 44px 38px 44px 60px;
    }

    /* SIGNUP — panel on LEFT, slash goes top-right to bottom-left */
    .signup-screen .screen-form { order: 2; }
    .signup-screen .screen-panel {
        order: 1;
        background: linear-gradient(145deg, #7a5520 0%, #b07e38 50%, #e6c068 100%);
        margin-right: -30px;
        clip-path: polygon(0 0, calc(100% - 30px) 0, 100% 100%, 0 100%);
        padding: 44px 60px 44px 38px;
    }

    /* Panel text styling */
    .screen-panel h2 {
        font-family: 'Playfair Display', serif;
        font-size: 1.65rem;
        font-weight: 700;
        color: var(--dark-bg);
        margin-bottom: 10px;
        line-height: 1.25;
        text-shadow: 0 1px 3px rgba(255,255,255,0.2);
        position: relative;
        z-index: 10;
    }
    .screen-panel h2::after {
        content: '';
        display: block;
        width: 38px; height: 2px;
        background: rgba(33,28,24,0.3);
        margin-top: 10px;
    }
    .screen-panel p {
        font-size: 0.83rem;
        line-height: 1.72;
        color: rgba(33,28,24,0.85);
        max-width: 190px;
        margin-top: 4px;
        position: relative;
        z-index: 10;
    }

    /* decorative circles */
    .deco {
        position: absolute;
        border-radius: 50%;
        border: 1px solid rgba(255,255,255,0.18);
    }
    .login-screen .deco-1 { width:170px; height:170px; bottom:-55px; left:-55px; }
    .login-screen .deco-2 { width:85px;  height:85px;  top:16px;    left:22px; opacity:.4; }
    .signup-screen .deco-1 { width:170px; height:170px; top:-55px;   right:-55px; }
    .signup-screen .deco-2 { width:85px;  height:85px;  bottom:16px; right:22px; opacity:.4; }

    /* Form headings */
    .screen-form h1 {
        font-family: 'Playfair Display', serif;
        font-size: 1.35rem;
        font-weight: 600;
        color: var(--gold-dark);
        margin-bottom: 20px;
        letter-spacing: 1.2px;
    }
    .screen-form h1::after {
        content: '';
        display: block;
        width: 28px; height: 1.5px;
        background: var(--gold);
        margin: 8px auto 0;
    }

    /* Input groups */
    .input-group {
        width: 100%;
        margin-bottom: 10px;
        position: relative;
    }

    /* Signup has more fields — tighten spacing inside that form */
    .signup-screen .screen-form {
        padding: 32px 44px;
        justify-content: center;
    }
    .signup-screen .screen-form h1 {
        margin-bottom: 12px;
    }
    .signup-screen .input-group {
        margin-bottom: 8px;
    }
    .signup-screen .btn {
        margin-top: 4px;
    }
    .signup-screen .switch-link {
        margin-top: 8px;
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
        background: #fcfbf9; /* Very light off-white */
        border: 1px solid #e0ddd5; /* Subtle grey-gold border */
        color: #211c18; /* Dark text for readability */
        font-family: 'Lato', sans-serif;
        font-size: 0.92rem;
        outline: none;
        border-radius: 2px;
        transition: border-color 0.3s, box-shadow 0.3s, background 0.3s;
    }
    .input-group input::placeholder { color: rgba(117,110,100,0.45); }
    .input-group input:focus {
        border-color: var(--gold);
        box-shadow: 0 0 0 3px rgba(194,147,74,0.14);
        background: rgba(194,147,74,0.08);
    }
    .signup-screen .input-group input:focus {
        border-color: var(--dark-primary);
        box-shadow: 0 0 0 3px rgba(230,192,104,0.14);
        background: rgba(230,192,104,0.07);
    }
    .input-group .icon {
        position: absolute;
        right: 12px; bottom: 10px;
        width: 15px; height: 15px;
        opacity: 0.4;
    }

    /* Buttons */
    .btn {
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
        position: relative;
        overflow: hidden;
        margin-top: 6px;
        transition: var(--trans);
    }
    .btn-gold {
        background: linear-gradient(90deg, var(--gold-dark), var(--gold), var(--gold-glow));
        color: var(--dark-bg);
        box-shadow: 0 2px 16px rgba(194,147,74,0.35);
    }
    .btn-gold:hover {
        box-shadow: 0 4px 28px rgba(194,147,74,0.6);
        transform: translateY(-1px);
    }
    .btn-gold2 {
        background: linear-gradient(90deg, var(--gold-deep), var(--gold), var(--dark-primary));
        color: var(--dark-bg);
        box-shadow: 0 2px 16px rgba(194,147,74,0.35);
    }
    .btn-gold2:hover {
        box-shadow: 0 4px 28px rgba(230,192,104,0.6);
        transform: translateY(-1px);
    }
    .btn::after {
        content: '';
        position: absolute; inset: 0;
        background: rgba(255,255,255,0);
        transition: background 0.25s;
    }
    .btn:active::after { background: rgba(255,255,255,0.10); }

    /* Switch link */
    .switch-link {
        margin-top: 13px;
        font-size: 0.75rem;
        color: #55504a;
        text-align: center;
    }
    .switch-link a {
        color: var(--gold);
        text-decoration: none;
        font-weight: 700;
        cursor: pointer;
        transition: color 0.2s, text-shadow 0.2s;
    }
    .switch-link a:hover {
        color: var(--gold-glow);
        text-shadow: 0 0 8px rgba(244,213,137,0.5);
    }
    .signup-screen .switch-link a { color: var(--dark-primary); }
    .signup-screen .switch-link a:hover { text-shadow: 0 0 8px rgba(230,192,104,0.5); }

    /* Status labels */
    .val-msg {
        font-size: 0.69rem;
        color: var(--destructive);
        letter-spacing: 0.4px;
        display: block;
        min-height: 14px;
        margin-top: 2px;
    }
    .status-ok  { color: var(--success)     !important; }
    .status-err { color: var(--destructive)  !important; }

    /* Scanline effect */
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
    }
    .p1{left:12%;bottom:8%; animation-duration:6s;   animation-delay:0s;}
    .p2{left:32%;bottom:5%; animation-duration:8s;   animation-delay:1.5s; width:2px;height:2px;}
    .p3{left:54%;bottom:9%; animation-duration:7s;   animation-delay:3s;}
    .p4{left:74%;bottom:12%;animation-duration:9s;   animation-delay:0.8s; width:2px;height:2px;}
    .p5{left:88%;bottom:6%; animation-duration:6.5s; animation-delay:2s;}

    @media(max-width:800px){
        .wrapper{ width:96vw; height:auto; min-height:440px; }
        .screens { width:200vw; }
        .screen  { width:96vw; }
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

    <form id="mainForm" runat="server">
        <div class="wrapper" id="wrapper">
            <div class="screens" id="screens">

                <div class="screen login-screen">

                    <div class="screen-form">
                        <h1>Login</h1>

                        <div class="input-group">
                            <label for="txtLoginUsername">Username</label>
                            <asp:TextBox ID="txtLoginUsername" runat="server" placeholder="Enter username" />
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#c2934a" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>

                        <div class="input-group">
                            <label for="txtLoginPassword">Password</label>
                            <asp:TextBox ID="txtLoginPassword" runat="server" TextMode="Password" placeholder="Enter password" />
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#c2934a" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                        </div>

                        <asp:Label ID="lblLoginStatus" runat="server" CssClass="val-msg" />

                        <asp:Button ID="btnLogin" runat="server" Text="Login"
                                    CssClass="btn btn-gold" OnClick="btnLogin_Click" />

                        <div class="switch-link">
                            Don't have an account? <a onclick="showSignUp()">Sign Up</a>
                        </div>
                    </div>

                    <div class="screen-panel">
                        <div class="deco deco-1"></div>
                        <div class="deco deco-2"></div>
                        <h2>WELCOME<br/>BACK!</h2>
                        <p>We're happy to have you with us. Log in again — we're here to help.</p>
                    </div>
                </div>


                <div class="screen signup-screen">

                    <div class="screen-panel">
                        <div class="deco deco-1"></div>
                        <div class="deco deco-2"></div>
                        <h2>CREATE<br/>ACCOUNT</h2>
                        <p>Fill in your details to get started. We'll have you set up in no time.</p>
                    </div>

                    <div class="screen-form">
                        <h1>Sign Up</h1>

                        <div class="input-group">
                            <label for="txtRegUsername">Username</label>
                            <asp:TextBox ID="txtRegUsername" runat="server" placeholder="Choose username" />
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#e6c068" stroke-width="2">
                                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </div>

                        <div class="input-group">
                            <label for="txtRegEmail">Email</label>
                            <asp:TextBox ID="txtRegEmail" runat="server" placeholder="Enter email" />
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#e6c068" stroke-width="2">
                                <rect x="2" y="4" width="20" height="16" rx="2"/><polyline points="2,4 12,13 22,4"/>
                            </svg>
                        </div>

                        <div class="input-group">
                            <label for="txtRegPassword">Password</label>
                            <asp:TextBox ID="txtRegPassword" runat="server" TextMode="Password" placeholder="Create password" />
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#e6c068" stroke-width="2">
                                <rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                        </div>

                        <div class="input-group">
                            <label for="txtRegPhone">Phone Number</label>
                            <asp:TextBox ID="txtRegPhone" runat="server" placeholder="e.g. 09171234567" />
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#e6c068" stroke-width="2">
                                <path d="M22 16.92v3a2 2 0 0 1-2.18 2A19.86 19.86 0 0 1 3.09 4.18 2 2 0 0 1 5.07 2h3a2 2 0 0 1 2 1.72c.13.96.36 1.9.7 2.81a2 2 0 0 1-.45 2.11L9.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.9.34 1.85.57 2.81.7A2 2 0 0 1 22 16.92z"/>
                            </svg>
                        </div>

                        <div class="input-group">
                            <label for="txtRegAddress">Address</label>
                            <asp:TextBox ID="txtRegAddress" runat="server" placeholder="Street, City, Province" />
                            <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="#e6c068" stroke-width="2">
                                <path d="M21 10c0 7-9 13-9 13S3 17 3 10a9 9 0 0 1 18 0z"/><circle cx="12" cy="10" r="3"/>
                            </svg>
                        </div>

                        <asp:Label ID="lblRegStatus" runat="server" CssClass="val-msg" />

                        <asp:Button ID="btnRegister" runat="server" Text="Sign Up"
                                    CssClass="btn btn-gold2" OnClick="btnRegister_Click" />

                        <div class="switch-link">
                            Already have an account? <a onclick="showLogin()">Login</a>
                        </div>
                    </div>
                </div>
                <!-- /signup-screen -->

            </div><!-- /screens -->
        </div><!-- /wrapper -->

        <asp:HiddenField ID="hfActivePanel" runat="server" Value="login" />
    </form>

    <script>
        var wrapper = document.getElementById('wrapper');
        var hf = document.getElementById('<%= hfActivePanel.ClientID %>');

        function showSignUp() {
            wrapper.classList.add('signup-active');
            hf.value = 'signup';
        }
        function showLogin() {
            wrapper.classList.remove('signup-active');
            hf.value = 'login';
        }

        window.onload = function () {
            if (hf.value === 'signup') wrapper.classList.add('signup-active');
        };
    </script>
</body>
</html>