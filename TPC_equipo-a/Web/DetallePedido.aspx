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
            <p><strong>Numero de pedido:</strong> <asp:Label ID="lblNumero" runat="server"></asp:Label></p>
            <p><strong>Fecha:</strong> <asp:Label ID="lblFecha" runat="server"></asp:Label></p>
            <p><strong>Cliente:</strong> <asp:Label ID="lblCliente" runat="server"></asp:Label></p>
            <p><strong>Estado:</strong> <asp:Label ID="lblEstado" runat="server"></asp:Label></p>
            <p><strong>Forma de pago:</strong> <asp:Label ID="lblFormaPago" runat="server"></asp:Label></p>
            <p><strong>Forma de entrega:</strong> <asp:Label ID="lblFormaEntrega" runat="server"></asp:Label></p>
            <p><strong>Codigo de seguimiento:</strong> <asp:Label ID="lblCodigoSeguimiento" runat="server"></asp:Label></p>
            <p class="mb-0"><strong>Total:</strong> <asp:Label ID="lblTotal" runat="server"></asp:Label></p>
        </div>
    </div>
</asp:Content>