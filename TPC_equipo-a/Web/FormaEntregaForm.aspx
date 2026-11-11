<%@ Page Title="Formulario - Forma de Entrega" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormaEntregaForm.aspx.cs" Inherits="Web.FormaEntregaForm" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="mb-1">
        <asp:Label ID="lblTitulo" CssClass="h3 m-0" runat="server" Text=""></asp:Label>
    </div>
    <hr class="mb-4" />

    <div class="row">
        <div class="col-md-6">

            <div class="mb-3">
                <asp:Label ID="lblDescripcion" CssClass="form-label fw-bold" runat="server" Text="Descripción:"></asp:Label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>

                <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion"
                    ErrorMessage="La descripción es obligatoria" CssClass="text-danger mt-1 d-block" Display="Dynamic" EnableClientScript="false">
                </asp:RequiredFieldValidator>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger mt-1 d-block" Visible="false"></asp:Label>
            </div>

            <div class="mb-3 mt-2">
                <asp:CheckBox ID="chkRequiereDireccion" runat="server" Text=" Requiere que el cliente ingrese su dirección" />
            </div>

            <div class="mb-4 mt-1">
                <asp:CheckBox ID="chkActiva" runat="server" Text=" Activa (Visible para los clientes)" Checked="true" />
            </div>

            <div class="d-flex gap-2">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary" OnClick="btnGuardar_Click" />
                <a href="~/AdminFormasEntrega.aspx" runat="server" class="btn btn-secondary">Cancelar</a>
            </div>

        </div>
    </div>
</asp:Content>