<%@ Page Title="Admin Comprobantes" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminComprobantes.aspx.cs" Inherits="Web.AdminComprobantes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upComprobantes" runat="server">
        <ContentTemplate>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                <h1 class="h3 m-0 me-auto">Comprobantes</h1>
            </div>
            <%-- guarda el pedido que eligieron mientras se confirma, no se ve en pantalla --%>
            <asp:HiddenField ID="hfIdPedido" runat="server" />

            <%-- aviso en verde o rojo despues de aceptar o rechazar --%>
            <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

            <%-- confirmacion antes de aceptar, se muestra al tocar aceptar en una fila --%>
            <asp:Panel ID="pnlConfirmarAceptar" runat="server" Visible="false" CssClass="alert alert-success d-flex flex-wrap align-items-center gap-2">
                <asp:Label ID="lblConfirmarAceptar" runat="server" CssClass="me-auto"></asp:Label>
                <asp:LinkButton ID="btnSiAceptar" OnClick="btnSiAceptar_Click" runat="server" CssClass="btn btn-sm btn-success"><i class="bi bi-check-lg me-1"></i>Sí, aceptar</asp:LinkButton>
                <asp:LinkButton ID="btnNoAceptar" OnClick="btnNoAceptar_Click" runat="server" CssClass="btn btn-sm btn-outline-secondary">Volver</asp:LinkButton>
            </asp:Panel>
            <div class="table-responsive">
                <%-- guarda el id de cada fila para saber que pedido aceptan o rechazan --%>
                <asp:GridView ID="dgvComprobantes" runat="server" DataKeyNames="Id" AutoGenerateColumns="false" CssClass="table table-bordered align-middle tabla-admin" EmptyDataText="No hay comprobantes esperando revisión">
                    <Columns>
                        <asp:BoundField HeaderText="Pedido" DataField="Id" DataFormatString="#{0}" />
                        <asp:BoundField HeaderText="Fecha" DataField="FechaCreacion" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                        <%-- el nombre y el mail estan adentro del objeto cliente, por eso va con eval --%>
                        <asp:TemplateField HeaderText="Cliente">
                            <ItemTemplate>
                                <%# Eval("Cliente.Nombre") %> <%# Eval("Cliente.Apellido") %>
                                <div class="small text-secondary"><%# Eval("Cliente.Email") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Forma de pago">
                            <ItemTemplate>
                                <%# Eval("FormaPago.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Total" DataField="Total" DataFormatString="{0:C}" />
                        <%-- el link abre el comprobante en otra pestaña, adentro va la miniatura o el icono segun sea imagen o pdf --%>
                        <asp:TemplateField HeaderText="Comprobante">
                            <ItemTemplate>
                                <asp:HyperLink ID="lnkComprobante" runat="server" NavigateUrl='<%# Eval("ComprobanteUrl") %>' Target="_blank" CssClass="text-decoration-none" ToolTip="Ver comprobante">
                                    <asp:Image ID="imgComprobante" runat="server" ImageUrl='<%# Eval("ComprobanteUrl") %>' CssClass="mini-comprobante" Visible='<%# EsImagen(Eval("ComprobanteUrl")) %>' />
                                    <asp:Panel ID="pnlPdf" runat="server" CssClass="pdf-comprobante" Visible='<%# EsPdf(Eval("ComprobanteUrl")) %>'>
                                        <i class="bi bi-file-earmark-pdf"></i>PDF
                                    </asp:Panel>
                                </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%-- cada boton lleva el id del pedido en el commandargument para saber cual tocaron --%>
                        <asp:TemplateField HeaderText="Acción">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnAceptar" OnClick="btnAceptar_Click" runat="server" CssClass="btn btn-sm btn-ecommerce-primario" CommandArgument='<%# Eval("Id") %>'><i class="bi bi-check-lg me-1"></i>Aceptar</asp:LinkButton>
                                <asp:LinkButton ID="btnRechazar" OnClick="btnRechazar_Click" runat="server" CssClass="btn btn-sm btn-admin-peligro" CommandArgument='<%# Eval("Id") %>'><i class="bi bi-x-lg me-1"></i>Rechazar</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
