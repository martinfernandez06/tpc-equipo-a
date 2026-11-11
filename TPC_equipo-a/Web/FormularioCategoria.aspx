<%@ Page Title="Formulario - Categoria" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormularioCategoria.aspx.cs" Inherits="Web.FormularioCategoria" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblTitulo" CssClass="h1" runat="server" Text=""></asp:Label>
    <div class="row">
        <div class="col-6">
            <div class="mb-3">
                <asp:Label ID="lblNombre" CssClass="form-label" runat="server" Text="Nombre:"></asp:Label>
                <asp:TextBox ID="txtNombre" MaxLength="50" CssClass="form-control" runat="server"></asp:TextBox>
                <%-- avisa si el nombre esta vacio, se valida en el servidor --%>
                <asp:RequiredFieldValidator ErrorMessage="El nombre es requerido" ControlToValidate="txtNombre" CssClass="text-danger" runat="server" EnableClientScript="false" />
                <%-- aviso de nombre repetido, se carga desde el code behind --%>
                <asp:Label ID="lblNombreRepetido" runat="server" Text="" CssClass="text-danger"></asp:Label>
            </div>
            <div class="mb-3">
                <asp:Label ID="lblDescripcion" CssClass="form-label" runat="server" Text="Descripcion:"></asp:Label>
                <asp:TextBox ID="txtDescripcion" MaxLength="255" CssClass="form-control" Rows="3" TextMode="MultiLine" runat="server"></asp:TextBox>
            </div>
            <asp:Button ID="btnAceptar" CssClass="btn btn-primary" runat="server" Text="cargar" OnClick="btnAceptar_Click" />
            <%-- causesvalidation en false para que desactivar no pida el nombre --%>
            <asp:Button ID="btnEstado" runat="server" CssClass="btn btn-warning" Text="Desactivar" OnClick="btnEstado_Click" CausesValidation="false"/>
            <a href="~/AdminCategorias" runat="server" class="btn btn-secondary">cancelar</a>
        </div>
    </div>
</asp:Content>
