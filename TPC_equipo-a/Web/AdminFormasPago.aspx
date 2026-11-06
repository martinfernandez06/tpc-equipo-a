<%@ Page Title="" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminFormasPago.aspx.cs" Inherits="Web.AdminFormasPago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Administración de Formas de Pago</h2>
    <hr />
    <asp:GridView ID="dgvFormasPago" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="true">
    </asp:GridView>
</asp:Content>