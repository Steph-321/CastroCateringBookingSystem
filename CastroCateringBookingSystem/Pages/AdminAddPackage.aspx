<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminAddPackage.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.AdminAddPackage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Add Package - Admin</title>

    <style>
 body { 
    margin: 0;
    padding: 0;
    background-color: #fcf9f5;
    font-family: Arial, sans-serif;
}

/* =========================
   SIDEBAR (DASHBOARD STYLE)
========================= */
.sidebar {
    width: 260px;
    position: fixed;
    top: 0;
    left: 0;
    height: 100vh;
    z-index: 1000;
    background: #ffffff;
    border-right: 1px solid #e5dcd0;
    display: flex;
    flex-direction: column;
}

/* Sidebar Header */
.sidebar-header {
    padding: 1.5rem;
    border-bottom: 1px solid #e5dcd0;
}

.logo-text {
    font-family: 'Playfair Display', serif;
    font-size: 1.2rem;
    font-weight: 600;
    color: #4a3a2a;
}

.logo-subtext {
    font-size: 0.75rem;
    color: #888;
    margin-left: 3.2rem;
}

/* Sidebar Nav */
.sidebar-nav {
    padding: 1.5rem 1rem;
    flex: 1;
}

.nav-item {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 0.875rem 1rem;
    margin-bottom: 0.5rem;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s;
    text-decoration: none;
    color: #4a3a2a;
    font-weight: 500;
}

.nav-item:hover {
    background: #fdfaf7;
}

.nav-item.active {
    background: #f4e9dc;
    color: #c2934a;
}

/* Sidebar Footer */
.sidebar-footer {
    padding: 1.5rem;
    border-top: 1px solid #e5dcd0;
}

/* =========================
   MAIN CONTENT (FIXED OVERLAP)
========================= */
.main-content {
    margin-left: 260px;
    padding: 20px;
    width: calc(100% - 260px);
    min-height: 100vh;
    box-sizing: border-box;
    position: relative;
    z-index: 1;
}

/* =========================
   TABLE SECTION
========================= */
.table-section {
    width: 100%;
    margin-top: 40px;
    box-sizing: border-box;
}

.table-container {
    width: 100%;
    max-width: 100%;
    overflow-x: auto;
    background: #fff;
    border-radius: 12px;
    border: 1px solid #e5dcd0;
    box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    position: relative;
    z-index: 1;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 900px;
    table-layout: auto;
}

th, td {
    text-align: left;
    padding: 12px 15px;
    border-bottom: 1px solid #f0e6da;
    color: #4a3a2a;
    word-wrap: break-word;
}

th {
    background-color: #fcf9f5;
    color: #493a2f;
    font-weight: 600;
}

/* =========================
   FORM CONTAINER
========================= */
.container {
    width: 100%;
    max-width: 700px;
    margin: 40px auto;
}

.form-section {
    background: #fff;
    border-radius: 16px;
    padding: 2rem;
    border: 1px solid #e5dcd0;
}

/* =========================
   HEADINGS
========================= */
h2 {
    color: #493a2f;
    margin-bottom: 1.5rem;
}

/* =========================
   FORM INPUTS
========================= */
.form-group {
    margin-bottom: 1rem;
}

.form-group label {
    font-weight: 600;
    font-size: 0.9rem;
    color: #4a3a2a;
}

.form-group input,
.form-group textarea,
.form-group select {
    width: 100%;
    padding: 0.6rem;
    border-radius: 10px;
    border: 1px solid #e5dcd0;
    box-sizing: border-box;
    outline: none;
}

/* =========================
   BUTTONS
========================= */
.btn-confirm {
    background: #c2934a;
    color: #fff;
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

.btn-delete {
    background: #f4e9dc;
    color: #4a3a2a;
    border: 1px solid #c2934a;
    padding: 6px 14px;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s ease;
    text-decoration: none;
    display: inline-block;
}

.btn-delete:hover {
    background: #c2934a;
    color: #ffffff;
    border-color: #a87a38;
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

                <a href="AdminDashboard.aspx" class="nav-item active">📊 Dashboard</a>

                <a href="AdminBookingManagement.aspx" class="nav-item">📋 Booking Management</a>
                 <a href="AdminAddPackage.aspx" class="nav-item">
                    ➕ Add Package
                </a>
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
