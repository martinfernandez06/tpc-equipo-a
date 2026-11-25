<%@ Page Title="Pedido confirmado" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Exito.aspx.cs" Inherits="Web.Exito" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <%-- misma tarjeta que la de error pero en verde --%>
    <div class="mp-contenedor mx-auto my-5">
        <div class="card-tienda estado-mp-ok p-4 p-md-5 text-center">
            <div class="icono-estado-mp icono-mp-ok mb-3">
                <i class="bi bi-check-lg"></i>
            </div>
            <h1 class="h4 mb-1"><asp:Label ID="lblTitulo" runat="server"></asp:Label></h1>
            <p class="mb-3">Tu número de pedido es <strong>#<asp:Label ID="lblNumero" runat="server"></asp:Label></strong></p>

            <div class="datos-transferencia text-start mb-3">
                <div class="dato-cuenta"><span>Total</span><span class="fw-semibold"><asp:Label ID="lblTotal" runat="server"></asp:Label></span></div>
                <div class="dato-cuenta"><span>Entrega</span><span><asp:Label ID="lblEntrega" runat="server"></asp:Label></span></div>
                <div class="dato-cuenta"><span>Pago</span><span><asp:Label ID="lblPago" runat="server"></asp:Label></span></div>
                <div class="dato-cuenta"><span>Estado</span><span><asp:Label ID="lblEstado" runat="server"></asp:Label></span></div>
            </div>

            <p class="dato-chico mb-4"><asp:Label ID="lblSiguiente" runat="server"></asp:Label></p>

            <div class="d-flex justify-content-center gap-2 flex-wrap">
                <a runat="server" href="~/MisCompras" class="btn btn-ecommerce-primario">Ver mis compras</a>
                <a runat="server" href="~/Default" class="btn btn-tienda-secundario">Seguir comprando</a>
            </div>
        </div>
    </div>

</asp:Content>