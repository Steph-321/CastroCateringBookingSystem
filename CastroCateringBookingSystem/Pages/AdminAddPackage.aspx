<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminAddPackage.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.AdminAddPackage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Add Package - Admin</title>

    <style>
/* =========================
   ROOT VARIABLES
========================= */
:root {
    --sidebar-w: 260px;
    --cream: #FAF8F3;
    --white: #ffffff;
    --border: #e5dcd0;
    --text-dark: #4a3a2a;
    --text-light: #888;
    --gold: #c2934a;
    --beige: #f4e9dc;
    --danger: #b83232;
}

/* =========================
   GLOBAL
========================= */
body {
    margin: 0;
    padding: 0;
    background-color: var(--cream);
    font-family: Arial, sans-serif;
}

/* =========================
   SIDEBAR (MATCH DASHBOARD)
========================= */
.sidebar {
    width: var(--sidebar-w);
    position: fixed;
    top: 0;
    left: 0;
    height: 100vh;
    background: var(--white);
    border-right: 1px solid var(--border);
    display: flex;
    flex-direction: column;
    z-index: 1000;
}

/* HEADER */
.sidebar-header {
    padding: 1.75rem 1.5rem;
    border-bottom: 1px solid var(--border);
}

.logo-text {
    font-family: 'Playfair Display', serif;
    font-size: 1.2rem;
    font-weight: 700;
    color: var(--text-dark);
}

.logo-subtext {
    font-size: 0.7rem;
    color: var(--text-light);
    letter-spacing: 0.05em;
    text-transform: uppercase;
    margin-top: 3px;
}

/* NAV */
.sidebar-nav {
    padding: 1.5rem 1rem;
    flex: 1;
}

.nav-link {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.7rem 0.875rem;
    margin-bottom: 0.15rem;
    border-radius: 10px;
    text-decoration: none;
    color: var(--text-light);
    font-size: 0.875rem;
    font-weight: 500;
    transition: background 0.2s, color 0.2s;
}

.nav-link:hover {
    background: var(--beige);
    color: var(--dark-brown);
}

.nav-link.active {
    background: var(--beige);
    color: var(--gold);
    font-weight: 600;
}

/* FOOTER */
.sidebar-footer {
    padding: 1.5rem;
    border-top: 1px solid var(--border);
}

.btn-back {
    display: block;
    padding: 0.6rem;
    margin-bottom: 0.5rem;
    background: var(--beige);
    color: var(--text-dark);
    text-decoration: none;
    border-radius: 8px;
    font-size: 0.85rem;
}

.btn-signout {
    display: block;
    padding: 0.6rem;
    color: var(--danger);
    text-decoration: none;
    border-radius: 8px;
    font-size: 0.85rem;
}

/* =========================
   MAIN CONTENT (NO OVERLAP)
========================= */
.main-content {
    margin-left: var(--sidebar-w);
    padding: 30px;
    box-sizing: border-box;
    min-height: 100vh;
}

/* =========================
   HEADINGS
========================= */
h1 {
    color: var(--text-dark);
    margin-bottom: 20px;
}

h2 {
    color: var(--text-dark);
    margin-bottom: 15px;
}

/* =========================
   FORM CONTAINER
========================= */
.container {
    max-width: 700px;
    margin: 20px auto 40px auto;
}

.form-section {
    background: var(--white);
    border-radius: 16px;
    padding: 2rem;
    border: 1px solid var(--border);
}

/* FORM FIELDS */
.form-group {
    margin-bottom: 1rem;
}

.form-group label {
    font-weight: 600;
    font-size: 0.9rem;
    color: var(--text-dark);
}

.form-group input,
.form-group textarea,
.form-group select {
    width: 100%;
    padding: 0.65rem;
    border-radius: 10px;
    border: 1px solid var(--border);
    outline: none;
    box-sizing: border-box;
}

/* BUTTON */
.btn-confirm {
    background: var(--gold);
    color: white;
    padding: 0.8rem;
    border: none;
    border-radius: 10px;
    width: 100%;
    cursor: pointer;
    font-weight: 600;
    transition: 0.3s;
}

.btn-confirm:hover {
    background: #a87a38;
}

/* =========================
   TABLE SECTION (FIX OVERLAP)
========================= */
.table-container {
    width: 100%;
    overflow-x: auto;
    background: var(--white);
    border-radius: 12px;
    border: 1px solid var(--border);
}

/* GRIDVIEW TABLE */
table {
    width: 100%;
    border-collapse: collapse;
    min-width: 900px;
}

th, td {
    text-align: left;
    padding: 12px 15px;
    border-bottom: 1px solid #f0e6da;
    color: var(--text-dark);
}

th {
    background: var(--cream);
    font-weight: 600;
}

/* DELETE BUTTON */
.btn-delete {
    background: #f4e9dc;
    color: var(--text-dark);
    border: 1px solid var(--gold);
    padding: 6px 12px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    transition: 0.3s;
    text-decoration: none;
}

.btn-delete:hover {
    background: var(--gold);
    color: white;
}


    </style>
</head>

<body>
<form id="form1" runat="server">
        <!-- SIDEBAR -->
        <aside class="sidebar">

            <div class="sidebar-header">
                <div class="logo-text">Castro Admin</div>
                <div class="logo-subtext">Management Panel</div>
            </div>

            <div class="sidebar-nav">

              <a href="AdminDashboard.aspx" class="nav-link">📊 Dashboard</a>

              <a href="AdminBookingManagement.aspx" class="nav-link">📋 Booking Management</a>

              <a href="AdminAddPackage.aspx" class="nav-link active">➕ Add Package</a>
       </div>

            <div class="sidebar-footer">
                <a href="Home.aspx" class="btn-back">← Back to User Site</a>
                <a href="Logout.aspx" class="btn-signout">→ Sign out</a>
            </div>

        </aside>

<div class="main-content">

    <h1>➕ Add New Packages</h1>

    <div class="container">

            <h2>Add New Package</h2>

        <!-- Package Name -->
        <div class="form-group">
            <label>Package Name</label>
            <asp:TextBox ID="txtPackageName" runat="server" />
        </div>

        <!-- Description -->
        <div class="form-group">
            <label>Description *</label>
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" />
        </div>

        <!-- Rate -->
        <div class="form-group">
            <label>Rate Per Guest *</label>
            <asp:TextBox ID="txtRatePerGuest" runat="server" />
        </div>

        <!-- Guests -->
        <div class="form-group">
            <label>Minimum Guests</label>
            <asp:TextBox ID="txtMinGuests" runat="server" TextMode="Number" />
        </div>

        <div class="form-group">
            <label>Maximum Guests</label>
            <asp:TextBox ID="txtMaxGuests" runat="server" TextMode="Number" />
        </div>

        <!-- Category -->
        <div class="form-group">
            <label>Category</label>
            <asp:DropDownList ID="ddlCategory" runat="server">
                <asp:ListItem Text="Select Category" Value="" />
                <asp:ListItem Text="Wedding" Value="Wedding" />
                <asp:ListItem Text="Birthday" Value="Birthday" />
                <asp:ListItem Text="Corporate" Value="Corporate" />
                <asp:ListItem Text="Debut" Value="Debut" />
            </asp:DropDownList>
        </div>

        <!-- Inclusions -->
        <div class="form-group">
            <label>Inclusions</label>
            <asp:TextBox ID="txtInclusions" runat="server" TextMode="MultiLine" Rows="4" />
        </div>

        <!-- Image -->
               <div class="form-group">
            <label>Package Image</label>
            <asp:FileUpload ID="fuImage" runat="server" />
        </div>

        <!-- Button -->
        <asp:Button ID="btnAdd" runat="server"
            Text="Add Package"
            CssClass="btn-confirm"
            OnClick="btnAdd_Click" />

        <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

    </div>
</div>

    <div class="form-section">
        <h2>📦 Existing Packages</h2>
        <div class="table-container">
            <table>
                </table>
        </div>
<asp:GridView ID="gvPackages" runat="server"
    AutoGenerateColumns="False"
    DataKeyNames="PackageID"
    OnRowCommand="gvPackages_RowCommand">

    <Columns>

        <asp:BoundField DataField="PackageID" HeaderText="ID" />

        <asp:BoundField DataField="PackageName" HeaderText="Package Name" />

        <asp:BoundField DataField="Category" HeaderText="Category" />

        <asp:BoundField DataField="Description" HeaderText="Description" />

        <asp:BoundField DataField="RatePerGuest" HeaderText="Rate/Guest" />

        <asp:BoundField DataField="MinGuests" HeaderText="Min Guests" />

        <asp:BoundField DataField="MaxGuests" HeaderText="Max Guests" />

        <asp:BoundField DataField="Inclusions" HeaderText="Inclusions" />

      <asp:TemplateField>
    <ItemTemplate>
        <asp:LinkButton 
            ID="btnDelete"
            runat="server"
            Text="Delete"
            CommandName="DeletePackage"
            CommandArgument='<%# Eval("PackageID") %>' />
    </ItemTemplate>
</asp:TemplateField>


    </Columns>
</asp:GridView>




      

</form>
</body>
</html>
