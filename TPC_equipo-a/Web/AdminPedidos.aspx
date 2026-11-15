<%@ Page Title="Admin Pedidos" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminPedidos.aspx.cs" Inherits="Web.AdminPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upPedidos" runat="server">
        <ContentTemplate>
            <asp:GridView ID="dgvPedidos" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false">
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
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
