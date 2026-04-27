<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reviews.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.Reviews" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reviews &amp; Recommendations | Castro Catering</title>
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

        /* ── Nav ── */
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

        /* ── Page ── */
        .page-wrapper { max-width: 1200px; margin: 0 auto; padding: 110px 5% 80px; }

        .page-header { text-align: center; margin-bottom: 3rem; }
        .page-header h1 { font-size: 2.5rem; color: var(--dark-brown); margin-bottom: 0.5rem; }
        .page-header p { color: var(--text-light); font-size: 1rem; }
        .gold-divider { width: 50px; height: 3px; background: var(--primary-gold); margin: 1rem auto; border-radius: 2px; }

        /* ── Two-column grid ── */
        .grid-layout { display: grid; grid-template-columns: 1fr 1.5fr; gap: 2rem; align-items: start; }
        @media (max-width: 860px) { .grid-layout { grid-template-columns: 1fr; } }

        /* ── Review cards ── */
        .reviews-list-container { display: flex; flex-direction: column; gap: 1rem; }

        .review-card {
            background: var(--bg-white);
            border: 1px solid var(--border-light);
            border-radius: 12px;
            padding: 1.25rem 1.5rem;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
            transition: box-shadow 0.2s;
        }
        .review-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.09); }
        .review-card.empty-state { border-style: dashed; text-align: center; padding: 2rem; color: var(--text-muted); }

        .card-left-group { display: flex; gap: 1rem; align-items: flex-start; }

        .review-avatar {
            width: 44px; height: 44px; border-radius: 50%; flex-shrink: 0;
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: 700; font-size: 1.1rem;
            background: linear-gradient(135deg, var(--gold-dark), var(--primary-gold));
        }

        .meta-text-block { flex: 1; }
        .client-name { font-weight: 700; font-size: 0.95rem; color: var(--text-dark); display: block; margin-bottom: 0.15rem; }
        .event-meta  { color: var(--text-muted); font-size: 0.8rem; display: block; margin-bottom: 0.5rem; }
        .review-quote-text { color: var(--text-light); font-size: 0.88rem; line-height: 1.65; }
        .review-card-stars-right { display: flex; gap: 2px; margin-top: 0.75rem; }
        .svg-gold-star { width: 16px; height: 16px; }

        /* ── Submit form ── */
        .submit-form-container {
            background: var(--bg-white);
            border: 1px solid var(--border-light);
            border-radius: 16px;
            padding: 2rem 2.5rem;
            box-shadow: 0 4px 24px rgba(0,0,0,0.07);
        }
        .submit-form-container h2 { font-size: 1.5rem; color: var(--dark-brown); margin-bottom: 1.5rem; }
        .form-group { margin-bottom: 1.25rem; }
        .form-label { display: block; font-size: 0.75rem; font-weight: 600; color: var(--text-muted); letter-spacing: 1.2px; text-transform: uppercase; margin-bottom: 0.4rem; }

        .input-text-field, .form-dropdown, .input-textarea-field {
            width: 100%; padding: 0.65rem 0.9rem;
            border: 1px solid var(--border-light); border-radius: 8px;
            font-family: 'Inter', sans-serif; font-size: 0.9rem;
            color: var(--text-dark); background: #fcfbf9; outline: none;
            transition: border-color 0.25s, box-shadow 0.25s; box-sizing: border-box;
        }
        .input-text-field:focus, .form-dropdown:focus, .input-textarea-field:focus {
            border-color: var(--primary-gold);
            box-shadow: 0 0 0 3px rgba(201,169,97,0.15);
            background: #fffdf7;
        }
        .input-textarea-field { resize: vertical; min-height: 100px; }

        /* ── Stars ── */
        .interactive-rating-stars { display: flex; flex-direction: row-reverse; justify-content: flex-end; gap: 4px; }
        .interactive-rating-stars input { display: none; }
        .interactive-rating-stars label svg { fill: #dbd3c9; cursor: pointer; width: 22px; height: 22px; transition: fill 0.15s; }
        .interactive-rating-stars input:checked ~ label svg,
        .interactive-rating-stars label:hover svg,
        .interactive-rating-stars label:hover ~ label svg { fill: var(--primary-gold); }

        /* ── Submit button ── */
        .btn-submit-review {
            width: 100%; padding: 0.75rem;
            background: var(--primary-gold); border: none; border-radius: 8px;
            color: var(--text-dark); font-family: 'Inter', sans-serif;
            font-weight: 700; font-size: 0.9rem; cursor: pointer;
            transition: all 0.3s; box-shadow: 0 2px 12px rgba(201,169,97,0.3);
        }
        .btn-submit-review:hover { background: var(--gold-dark); color: white; transform: translateY(-1px); box-shadow: 0 6px 20px rgba(201,169,97,0.4); }

        /* ── Footer ── */
        footer { background: #f0ebe4; padding: 3rem 5% 0; margin-top: 4rem; border-top: 1px solid var(--border-light); }
        .footer-inner { max-width: 1400px; margin: 0 auto; display: grid; grid-template-columns: 2fr 1fr 1.2fr 1fr; gap: 3rem; padding-bottom: 2.5rem; }
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
                <li><a href="Reviews.aspx" class="active">Reviews</a></li>
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
                <h1>Reviews &amp; Recommendations</h1>
                <p>Real stories from our clients — see what makes Castro Catering special.</p>
            </div>

            <div class="grid-layout">

                <!-- Left: review list -->
                <div class="reviews-list-container">
                    <asp:Repeater ID="rptReviews" runat="server">
                        <ItemTemplate>
                            <div class="review-card">
                                <div class="card-left-group">
                                    <div class="review-avatar"><%# Eval("Name").ToString().Substring(0,1).ToUpper() %></div>
                                    <div class="meta-text-block">
                                        <span class="client-name"><%# Eval("Name") %></span>
                                        <span class="event-meta"><%# Eval("EventType") %> &bull; <%# Eval("Date", "{0:M/d/yyyy}") %></span>
                                        <div class="review-quote-text"><%# Eval("ReviewText") %></div>
                                    </div>
                                </div>
                                <div class="review-card-stars-right">
                                    <%# RenderStars(Convert.ToInt32(Eval("Rating"))) %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:PlaceHolder ID="phEmpty" runat="server">
                        <div class="review-card empty-state">
                            <p>No reviews yet. Be the first to share your experience!</p>
                        </div>
                    </asp:PlaceHolder>
                </div>

                <!-- Right: submit form -->
                <div class="submit-form-container">
                    <h2>Share your experience</h2>

                    <div class="form-group">
                        <label class="form-label">Your Name</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="input-text-field" placeholder="Juan dela Cruz" />
                    </div>

                    <div class="form-group">
                        <label class="form-label">Event Type</label>
                        <asp:DropDownList ID="ddlEventType" runat="server" CssClass="form-dropdown">
                            <asp:ListItem Text="Select event type" Value="" />
                            <asp:ListItem Text="Wedding"     Value="Wedding" />
                            <asp:ListItem Text="Corporate"   Value="Corporate" />
                            <asp:ListItem Text="Debut"       Value="Debut" />
                            <asp:ListItem Text="Birthday"    Value="Birthday" />
                            <asp:ListItem Text="Christening" Value="Christening" />
                            <asp:ListItem Text="Other"       Value="Other" />
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Rating</label>
                        <div class="interactive-rating-stars">
                            <input type="radio" id="star5" name="StarRating" value="5" /><label for="star5"><svg viewBox="0 0 24 24"><path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6-4.8-6 4.8 2.4-7.2-6-4.8h7.6z"/></svg></label>
                            <input type="radio" id="star4" name="StarRating" value="4" /><label for="star4"><svg viewBox="0 0 24 24"><path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6-4.8-6 4.8 2.4-7.2-6-4.8h7.6z"/></svg></label>
                            <input type="radio" id="star3" name="StarRating" value="3" /><label for="star3"><svg viewBox="0 0 24 24"><path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6-4.8-6 4.8 2.4-7.2-6-4.8h7.6z"/></svg></label>
                            <input type="radio" id="star2" name="StarRating" value="2" /><label for="star2"><svg viewBox="0 0 24 24"><path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6-4.8-6 4.8 2.4-7.2-6-4.8h7.6z"/></svg></label>
                            <input type="radio" id="star1" name="StarRating" value="1" checked="checked" /><label for="star1"><svg viewBox="0 0 24 24"><path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6-4.8-6 4.8 2.4-7.2-6-4.8h7.6z"/></svg></label>
                            <asp:HiddenField ID="hfRating" runat="server" Value="1" />
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Your Review</label>
                        <asp:TextBox ID="txtReview" runat="server" TextMode="MultiLine" Rows="4" CssClass="input-textarea-field" placeholder="Tell us about your experience..." />
                    </div>

                    <asp:Button ID="btnSubmit" runat="server" Text="Submit Review" CssClass="btn-submit-review" OnClick="btnSubmit_Click" />
                    <asp:Label ID="lblStatus" runat="server" style="display:block; margin-top:0.75rem; font-size:0.88rem;"></asp:Label>
                </div>

            </div>
        </div>

        <svg style="display:none;">
            <symbol id="icon-star" viewBox="0 0 24 24">
                <path d="M12 2l2.4 7.2h7.6l-6 4.8 2.4 7.2-6-4.8-6 4.8 2.4-7.2-6-4.8h7.6z"/>
            </symbol>
        </svg>
    </form>

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
                <div class="footer-contact-item"><span>&#128222;</span><span>0967 539 3045</span></div>
                <div class="footer-contact-item"><span>&#128205;</span><span>Argao, Cebu</span></div>
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

    <script>
        // ── Auth guard ──
        (function() {
            var user = null;
            try { user = JSON.parse(localStorage.getItem('castroUser')); } catch(e) {}
            if (!user || !user.username) { window.location.href = 'LoginSignup.aspx'; }
        })();

        document.querySelectorAll('.interactive-rating-stars input[type=radio]').forEach(function(r) {
            r.addEventListener('change', function() {
                document.getElementById('<%= hfRating.ClientID %>').value = this.value;
            });
        });

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
