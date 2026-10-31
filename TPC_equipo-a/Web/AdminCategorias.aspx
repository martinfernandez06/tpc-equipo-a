<%@ Page Title="" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminCategorias.aspx.cs" Inherits="TPC_equipo_a.AdminCategorias" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
    <div class="col-md-8">
        <asp:GridView ID="dgvCategorias" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="true">
        </asp:GridView>
    </div>
</div>
</asp:Content>
