<%@ Page Title="Formulario - Categoría" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormularioCategoria.aspx.cs" Inherits="Web.FormularioCategoria" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="mb-1">
        <asp:Label ID="lblTitulo" CssClass="h3 m-0" runat="server" Text=""></asp:Label>
    </div>
    <hr class="mb-4" />

    <div class="row">
        <div class="col-md-6">

            <div class="mb-3">
                <asp:Label ID="lblNombre" CssClass="form-label fw-bold" runat="server" Text="Nombre:"></asp:Label>
                <asp:TextBox ID="txtNombre" MaxLength="50" CssClass="form-control" runat="server"></asp:TextBox>

                <asp:RequiredFieldValidator ErrorMessage="El nombre es requerido" ControlToValidate="txtNombre" CssClass="text-danger mt-1 d-block" runat="server" EnableClientScript="false" Display="Dynamic" />
                <asp:Label ID="lblNombreRepetido" runat="server" Text="" CssClass="text-danger mt-1 d-block"></asp:Label>
            </div>
           
            <div class="mb-3">
                <asp:Label ID="lblDescripcion" CssClass="form-label fw-bold" runat="server" Text="Descripción:"></asp:Label>
                <asp:TextBox ID="txtDescripcion" MaxLength="255" CssClass="form-control" Rows="4" TextMode="MultiLine" runat="server"></asp:TextBox>
            </div>

            <div class="mb-4 mt-2">
                <asp:CheckBox ID="chkActiva" runat="server" Text=" Activa (Visible para los clientes)" Checked="true" />
            </div>

            <div class="d-flex gap-2">
                <asp:Button ID="btnAceptar" CssClass="btn btn-primary" runat="server" Text="Guardar" OnClick="btnAceptar_Click" />
                <a href="~/AdminCategorias" runat="server" class="btn btn-secondary">Cancelar</a>
            </div>

        </div>
    </div>
</asp:Content>