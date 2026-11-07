<%@ Page Title="" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminFormasPago.aspx.cs" Inherits="Web.AdminFormasPago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Administración de Formas de Pago</h2>
    <hr />
    
    <div class="row mb-3">
        <div class="col-6">
            <asp:Button ID="btnAgregar" runat="server" Text="Agregar Nueva" CssClass="btn btn-primary" OnClick="btnAgregar_Click" />
        </div>
    </div>

    <asp:GridView ID="dgvFormasPago" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false" DataKeyNames="Id" OnSelectedIndexChanged="dgvFormasPago_SelectedIndexChanged">
        <Columns>
            <asp:BoundField DataField="Id" HeaderText="Id" />
            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
            <asp:CheckBoxField DataField="Activa" HeaderText="Activa" />
            <asp:CommandField ShowSelectButton="true" SelectText="Modificar" ControlStyle-CssClass="btn btn-warning btn-sm" />
        </Columns>
    </asp:GridView>
</asp:Content>