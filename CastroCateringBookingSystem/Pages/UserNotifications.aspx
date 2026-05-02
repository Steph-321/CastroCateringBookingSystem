<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserNotifications.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.UserNotifications" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Notifications</title>

    <style>
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th, .data-table td {
            padding: 10px;
            border: 1px solid #ddd;
        }

        /* MODAL BACKDROP */
        .modal {
            display: none;
            position: fixed;
            z-index: 999;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
        }

        /* MODAL BOX */
        .modal-content {
            background: white;
            padding: 20px;
            margin: 15% auto;
            width: 350px;
            border-radius: 10px;
            position: relative;
        }

        .close {
            position: absolute;
            right: 10px;
            top: 5px;
            font-size: 22px;
            cursor: pointer;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- GRIDVIEW -->
    <asp:GridView ID="gvNotifications" runat="server"
        AutoGenerateColumns="False"
        CssClass="data-table">

        <Columns>
            <asp:BoundField DataField="Message" HeaderText="Notification" />
            <asp:BoundField DataField="CreatedAt" HeaderText="Date" />
        </Columns>

    </asp:GridView>

    <!-- MODAL -->
    <div id="notifModal" class="modal">
        <div class="modal-content">
            <span onclick="closeModal()" class="close">&times;</span>
            <h3>New Notification</h3>
            <p id="notifText"></p>
        </div>
    </div>

</form>

<script>
    function showNotification(msg) {
        document.getElementById("notifText").innerText = msg;
        document.getElementById("notifModal").style.display = "block";
    }

    function closeModal() {
        document.getElementById("notifModal").style.display = "none";
    }
</script>

</body>
</html>
