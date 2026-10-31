<%@ Page Title="Formulario - Categoria" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormularioCategoria.aspx.cs" Inherits="Web.FormularioCategoria" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Nueva categoria</h1>
    <div class="row">
        <div class="col-6">
            <div class="mb-3">
                <asp:Label ID="lblNombre" CssClass="form-label" runat="server" Text="Nombre:"></asp:Label>
                <asp:TextBox ID="txtNombre" CssClass="form-control" runat="server"></asp:TextBox>
            </div>
            <div class="mb-3">
                <asp:Label ID="lblDescripcion" CssClass="form-label" runat="server" Text="Descripcion:"></asp:Label>
                <asp:TextBox ID="txtDescripcion" CssClass="form-control" Rows="3" TextMode="MultiLine" runat="server"></asp:TextBox>
            </div>
            <asp:Button ID="btnAceptar" CssClass="btn btn-primary" runat="server" Text="cargar" OnClick="btnAceptar_Click" />
            <a href="~/AdminCategorias" runat="server" class="btn btn-secondary">cancelar</a>
        </div>
    </div>
</asp:Content>
