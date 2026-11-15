<%@ Page Title="Admin Pedidos" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminPedidos.aspx.cs" Inherits="Web.AdminPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upPedidos" runat="server">
        <ContentTemplate>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                <h1 class="h3 m-0 me-auto">Pedidos</h1>
            </div>
            <div class="table-responsive">
              <%-- guarda el id de cada fila para saber que pedido eligieron --%>
                <asp:GridView ID="dgvPedidos" DataKeyNames="Id" OnSelectedIndexChanged="dgvPedidos_SelectedIndexChanged" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField HeaderText="Id" DataField="Id" />
                        <asp:BoundField HeaderText="Fecha de creacion" DataField="FechaCreacion" />
                        <asp:TemplateField HeaderText="Cliente">
                            <ItemTemplate>
                                <%# Eval("Cliente.Id") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Forma de pago">
                            <ItemTemplate>
                                <%# Eval("FormaPago.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Forma de entrega">
                            <ItemTemplate>
                                <%# Eval("FormaEntrega.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# Eval("Estado.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Total" DataField="Total" DataFormatString="{0:C}" />
                        <asp:BoundField HeaderText="Codigo de seguimiento" DataField="CodigoSeguimiento" />
                        <asp:BoundField HeaderText="Estado del comprobante" DataField="EstadoComprobante" />
                        <asp:CommandField HeaderText="Accion" ShowSelectButton="true" ButtonType="Button" ControlStyle-CssClass="btn btn-sm btn-primary" SelectText="Ver detalles" />
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
