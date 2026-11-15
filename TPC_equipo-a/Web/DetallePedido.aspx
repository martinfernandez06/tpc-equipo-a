<%@ Page Title="Detalle Pedido" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="DetallePedido.aspx.cs" Inherits="Web.DetallePedido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
        <h1 class="h3 m-0 me-auto">Detalle del pedido</h1>
        <a href="AdminPedidos.aspx" class="btn btn-sm btn-outline-secondary">Volver</a>
    </div>

    <div class="card mb-4">
        <div class="card-body">
            <p>
                <strong>Numero de pedido:</strong>
                <asp:Label ID="lblNumero" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Fecha:</strong>
                <asp:Label ID="lblFecha" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Cliente:</strong>
                <asp:Label ID="lblCliente" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Estado:</strong>
                <asp:Label ID="lblEstado" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Forma de pago:</strong>
                <asp:Label ID="lblFormaPago" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Forma de entrega:</strong>
                <asp:Label ID="lblFormaEntrega" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Codigo de seguimiento:</strong>
                <asp:Label ID="lblCodigoSeguimiento" runat="server"></asp:Label>
            </p>
            <p class="mb-0">
                <strong>Total:</strong>
                <asp:Label ID="lblTotal" runat="server"></asp:Label>
            </p>
        </div>
    </div>
    <h5>Productos
    </h5>
    <asp:GridView ID="dgvItems" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle" runat="server">
        <Columns>
            <asp:TemplateField HeaderText="Nombre">
                <ItemTemplate>
                    <img src='<%# Eval("Producto.ImagenUrl") %>' alt="" class="me-2 rounded" style="width: 50px; height: 50px; object-fit: cover;" />
                    <%# Eval("Producto.Nombre") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField HeaderText="Cantidad" DataField="Cantidad" />
            <asp:BoundField HeaderText="Precio unitario" DataField="PrecioUnitario" DataFormatString="{0:C}" />
            <asp:BoundField HeaderText="Subtotal" DataField="Subtotal" DataFormatString="{0:C}" />
        </Columns>
    </asp:GridView>
    <h5>Historial de estados</h5>
    <asp:GridView ID="dgvHistorial" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle">
        <Columns>
            <asp:BoundField HeaderText="Fecha" DataField="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='<%# ClaseEstado(Eval("Estado.Descripcion")) %>'><%# Eval("Estado.Descripcion") %></span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Usuario">
                <ItemTemplate>
                    <%# Eval("Usuario.Id") %>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
</asp:Content>
