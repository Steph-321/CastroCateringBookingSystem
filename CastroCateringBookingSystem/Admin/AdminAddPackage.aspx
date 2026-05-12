<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminAddPackage.aspx.cs" Inherits="CastroCateringBookingSystem.Admin.AdminAddPackage" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Admin - Castro Catering</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>

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


            body {
                margin: 0;
                padding: 0;
                background-color: var(--cream);
                font-family: 'Inter', sans-serif; 
                color: var(--text-dark);
                line-height: 1.6;
            }


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
                font-family: 'Inter', sans-serif;
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
                padding: 1.25rem 1rem;
                border-top: 1px solid var(--border);
                display: flex;
                flex-direction: column;
                gap: 0.4rem;
            }

            .btn-signout {
                display: flex; align-items: center; gap: 0.5rem;
                padding: 0.6rem 0.875rem;
                background: transparent;
                border: none;
                border-radius: 10px;
                text-decoration: none;
                color: #b83232;
                font-size: 0.82rem;
                font-weight: 500;
                cursor: pointer;
                transition: background 0.2s;
            }
            .btn-signout:hover { background: #fff0f0; }
           
            .main-content {
                margin-left: var(--sidebar-w);
                padding: 30px;
                box-sizing: border-box;
                min-height: 100vh;
            }

           
            h1 {
                color: var(--text-dark);
                margin-bottom: 20px;
                 font-family: 'Playfair Display', serif;
            }
            

            h2 {
                color: var(--text-dark);
                margin-bottom: 15px;
                 font-family: 'Playfair Display', serif;
            }
            

           
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
                text-align: center;
                padding: 12px 15px;
                border-bottom: 1px solid #f0e6da;
                color: var(--text-dark);
            }

            th {
                background: var(--cream);
                font-weight: 600;
            }

            /* DELETE BUTTON */
          
            .actions {
                display: flex;
                gap: 0.75rem;
                justify-content: center;
            }

            .btn-act {
                padding: 0.3rem 0.8rem;
                border-radius: 8px;
                font-size: 0.75rem;
                font-weight: 600;
                cursor: pointer;
                border: 1px solid transparent;
                transition: opacity 0.2s, transform 0.15s;
                white-space: nowrap;
                font-family: 'Inter', sans-serif;
            }

            .btn-act:hover {
                opacity: 0.8;
                transform: translateY(-1px);
            }

            .btn-edit {
                background: #EBF4FD;
                color: #1558A0;
                border-color: #90CAF9;
            }

            .btn-delete {
                background: #FDE8E8;
                color: #9B1C1C;
                border-color: #F5A0A0;
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
              <a href="AdminDatabaseBackup.aspx" class="nav-link">🗄️ Database Backup</a>
            </div>

            <div class="sidebar-footer">
                <a href="AdminLogin.aspx?signout=1" class="btn-signout">→ Sign out</a>
            </div>

        </aside>

<div class="main-content">

    <h1> Add New Packages</h1>

    <div class="container">


        <div class="form-group">
            <label>Package Name</label>
            <asp:TextBox ID="txtPackageName" runat="server" />
        </div>

        <div class="form-group">
            <label>Description *</label>
            <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" />
        </div>

        <div class="form-group">
            <label>Rate Per Guest *</label>
            <asp:TextBox ID="txtRatePerGuest" runat="server" />
        </div>

        <div class="form-group">
            <label>Minimum Guests</label>
            <asp:TextBox ID="txtMinGuests" runat="server" TextMode="Number" />
        </div>

        <div class="form-group">
            <label>Maximum Guests</label>
            <asp:TextBox ID="txtMaxGuests" runat="server" TextMode="Number" />
        </div>

        <div class="form-group">
            <label>Category</label>
            <asp:DropDownList ID="ddlCategory" runat="server">
                <asp:ListItem Text="Select Category" Value="" />
                <asp:ListItem Text="Wedding" Value="Wedding" />
                <asp:ListItem Text="Birthday" Value="Birthday" />
                <asp:ListItem Text="Corporate" Value="Corporate" />
                <asp:ListItem Text="Christening" Value="Christening" />
                <asp:ListItem Text="Anniversary" Value="Anniversary" />
                <asp:ListItem Text="Family Gathering" Value="Gathering" />
                <asp:ListItem Text="Others" Value="Others" />
            </asp:DropDownList>
        </div>

        <div class="form-group">
            <label>Inclusions</label>
            <asp:TextBox ID="txtInclusions" runat="server" TextMode="MultiLine" Rows="4" />
        </div>

               <div class="form-group">
            <label>Package Image</label>
            <asp:FileUpload ID="fuImage" runat="server" />
        </div>

        <asp:Button ID="btnAdd" runat="server"
            Text="Add Package"
            CssClass="btn-confirm"
            OnClick="btnAdd_Click" />

        <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

    </div>

<div class="form-section">
        <h2>  Existing Packages</h2>

        <div class="table-container">
            <asp:GridView ID="gvPackages" runat="server"
                AutoGenerateColumns="False"
                DataKeyNames="PackageID"
                CssClass="grid-table"
                OnRowCommand="gvPackages_RowCommand">

                <Columns>
                    <asp:BoundField DataField="PackageID" HeaderText="ID" />
                    <asp:BoundField DataField="PackageName" HeaderText="Package Name" />
                    <asp:BoundField DataField="RatePerGuest" HeaderText="Rate / Guest" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />

                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                          <div class="actions">

                        <asp:Button runat="server"
                            Text="Edit"
                            CommandName="EditPackage"
                            CommandArgument='<%# Eval("PackageID") %>'
                            CssClass="btn-act btn-edit" />


                        <asp:Button runat="server"
                            Text="Delete"
                            CommandName="DeletePackage"
                            CommandArgument='<%# Eval("PackageID") %>'
                            CssClass="btn-act btn-delete"
                            OnClientClick="return confirm('Delete this package?');" />

</div>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>
        </div>
    </div>

</div>


      

</form>
</body>
</html>
