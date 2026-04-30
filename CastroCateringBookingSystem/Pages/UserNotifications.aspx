<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserNotifications.aspx.cs" Inherits="CastroCateringBookingSystem.Pages.UserNotifications" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
    <style>
   .modal {
    display:none;
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
}

    .modal-content {
    background:white;
    padding:20px;
    margin:15% auto;
    width:300px;
    border-radius:10px;
}

    </style>
   
<body>
    <form id="form1" runat="server">
        <asp:GridView ID="gvNotifications" runat="server"
    AutoGenerateColumns="False"
    CssClass="data-table">

    <Columns>
        <asp:BoundField DataField="Message" HeaderText="Notification" />
        <asp:BoundField DataField="CreatedAt" HeaderText="Date" />
    </Columns>

</asp:GridView>

        <div>
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
