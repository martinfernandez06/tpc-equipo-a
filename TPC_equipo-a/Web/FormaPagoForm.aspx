<%@ Page Title="Formulario - Forma de Pago" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormaPagoForm.aspx.cs" Inherits="Web.FormaPagoForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
        <asp:Label ID="lblTitulo" CssClass="h3 m-0" runat="server" Text=""></asp:Label>
        <asp:Label ID="lblEstado" runat="server" Text=""></asp:Label>
        <a href="AdminFormasPago.aspx" class="btn btn-sm btn-admin-secundario ms-auto">
            <i class="bi bi-arrow-left me-1"></i>Volver
        </a>
    </div>

    <div class="row">
        <div class="col-lg-6">
            <div class="card card-admin">
                <div class="card-header">Datos de la forma de pago</div>
                <div class="card-body">
                    <asp:UpdatePanel ID="upFormulario" runat="server">
                        <ContentTemplate>

                            <div class="mb-3">
                                <asp:Label ID="lblDescripcion" CssClass="dato-titulo d-block" runat="server" Text="Descripción"></asp:Label>
                                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control input-admin" MaxLength="100" placeholder="Ej: Transferencia bancaria"></asp:TextBox>
                                <div>
                                    <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion"
                                        ErrorMessage="La descripción es obligatoria." CssClass="text-danger small" Display="Dynamic" EnableClientScript="false" />
                                </div>
                                <div>
                                    <asp:Label ID="lblError" runat="server" CssClass="text-danger small" Visible="false"></asp:Label>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="d-flex align-items-center gap-2">
                                    <input type="checkbox" id="chkRequiereComprobante" runat="server" class="form-check-input m-0" />
                                    <label for="<%= chkRequiereComprobante.ClientID %>" class="form-check-label mb-0">
                                        Requiere subir comprobante de pago
       
                                    </label>
                                </div>
                                <div class="form-text small">
                                    Activalo si el cliente debe adjuntar un comprobante para que el admin valide el pago (por ejemplo, Transferencia).
   
                                </div>
                            </div>

                            <asp:Panel ID="pnlBotones" runat="server" CssClass="d-flex flex-wrap gap-2">
                                <asp:Button ID="btnGuardar" runat="server" Text="Crear" CssClass="btn btn-ecommerce-primario" OnClick="btnGuardar_Click" />
                                <a href="AdminFormasPago.aspx" class="btn btn-admin-secundario">Cancelar</a>
                                <asp:Button ID="btnEstado" runat="server" Text="Desactivar" CssClass="btn btn-admin-peligro ms-auto" OnClick="btnEstado_Click" CausesValidation="false" />
                            </asp:Panel>

                            <asp:Panel ID="pnlConfirmar" runat="server" Visible="false" CssClass="border border-danger p-3 mt-3">
                                <div class="fw-bold text-danger">¿Desactivar esta forma de pago?</div>
                                <div class="small mb-3">Va a dejar de mostrarse como opción en el checkout para nuevos pedidos.</div>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnSiDesactivar" runat="server" Text="Sí, desactivar" CssClass="btn btn-danger rounded-0" CausesValidation="false" OnClick="btnSiDesactivar_Click" />
                                    <asp:Button ID="btnNoDesactivar" runat="server" Text="No" CssClass="btn btn-admin-secundario" CausesValidation="false" OnClick="btnNoDesactivar_Click" />
                                </div>
                            </asp:Panel>

                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
