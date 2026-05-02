<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserNotifications.aspx.cs"
    Inherits="CastroCateringBookingSystem.Pages.UserNotifications" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Notifications</title>

    <style>
        body {
            font-family: Arial;
            background: #f5f5f5;
        }

        .data-table {
            width: 80%;
            margin: 30px auto;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
        }

        .data-table th, .data-table td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }

        .data-table th {
            background: #c2934a;
            color: white;
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
            text-align: center;
        }

        .close {
            position: absolute;
            right: 12px;
            top: 8px;
            font-size: 22px;
            cursor: pointer;
        }

        h3 {
            margin-bottom: 10px;
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
            <span class="close" onclick="closeModal()">&times;</span>

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

    // click outside modal closes it
    window.onclick = function (event) {
        var modal = document.getElementById("notifModal");
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>
</html>
