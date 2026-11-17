<%@ Page Title="Formulario - Categoria" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormularioCategoria.aspx.cs" Inherits="Web.FormularioCategoria" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
        <asp:Label ID="lblTitulo" CssClass="h3 m-0" runat="server" Text=""></asp:Label>
        <asp:Label ID="lblEstado" runat="server" Text=""></asp:Label>
        <a href="~/AdminCategorias" runat="server" class="btn btn-sm btn-admin-secundario ms-auto"><i class="bi bi-arrow-left me-1"></i>Volver</a>
    </div>
    <div class="row">
        <div class="col-lg-6">
            <div class="card card-admin">
                <div class="card-header">Datos de la categoria</div>
                <div class="card-body">
                    <div class="mb-3">
                        <asp:Label ID="lblNombre" CssClass="dato-titulo d-block" runat="server" Text="Nombre"></asp:Label>
                        <asp:TextBox ID="txtNombre" MaxLength="50" CssClass="form-control input-admin" runat="server"></asp:TextBox>
                        <%-- avisa si el nombre esta vacio, se valida en el servidor --%>
                        <div>
                            <asp:RequiredFieldValidator ErrorMessage="El nombre es requerido" ControlToValidate="txtNombre" CssClass="text-danger small" runat="server" EnableClientScript="false" Display="Dynamic" />
                        </div>
                        <%-- aviso de nombre repetido, se carga desde el code behind --%>
                        <div>
                            <asp:Label ID="lblNombreRepetido" runat="server" Text="" CssClass="text-danger small"></asp:Label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <asp:Label ID="lblDescripcion" CssClass="dato-titulo d-block" runat="server" Text="Descripción"></asp:Label>
                        <asp:TextBox ID="txtDescripcion" MaxLength="255" CssClass="form-control input-admin" Rows="3" TextMode="MultiLine" runat="server"></asp:TextBox>
                    </div>
                    <asp:Panel ID="pnlBotones" runat="server" CssClass="d-flex flex-wrap gap-2">
                        <asp:Button ID="btnAceptar" CssClass="btn btn-ecommerce-primario" runat="server" Text="cargar" OnClick="btnAceptar_Click" />
                        <a href="~/AdminCategorias" runat="server" class="btn btn-admin-secundario">Cancelar</a>
                        <%-- causesvalidation en false para que desactivar no pida el nombre --%>
                        <asp:Button ID="btnEstado" runat="server" CssClass="btn btn-admin-peligro ms-auto" Text="Desactivar" OnClick="btnEstado_Click" CausesValidation="false" />
                    </asp:Panel>
                    <asp:Panel ID="pnlConfirmar" runat="server" Visible="false" CssClass="border border-danger p-3 mt-3">
                        <div class="fw-bold text-danger">¿Desactivar esta categoria?</div>
                        <div class="small mb-3">Va a dejar de verse en la tienda y no se va a poder elegir en los productos.</div>
                        <div class="d-flex gap-2">
                            <asp:Button ID="btnSiDesactivar" runat="server" Text="Sí, desactivar" CssClass="btn btn-danger rounded-0" CausesValidation="false" OnClick="btnSiDesactivar_Click" />
                            <asp:Button ID="btnNoDesactivar" runat="server" Text="No" CssClass="btn btn-admin-secundario" CausesValidation="false" OnClick="btnNoDesactivar_Click"/>
                        </div>
                    </asp:Panel>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
