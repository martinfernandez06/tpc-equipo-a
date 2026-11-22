<%@ Page Title="Pago con Mercado Pago" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MercadoPagoSimulado.aspx.cs" Inherits="Web.MercadoPagoSimulado" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5 mp-contenedor">

        <!-- Panel de error (pedido inexistente, ajeno, otra forma de pago o estado inválido) -->
        <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div class="card-tienda estado-mp-error p-4 p-md-5 text-center">
                <div class="icono-estado-mp icono-mp-error mb-3">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                </div>
                <h4 class="mb-2">No se puede procesar el pago</h4>
                <p class="dato-chico mb-4">
                    <asp:Label ID="lblError" runat="server"></asp:Label>
                </p>
                <div class="d-flex justify-content-center gap-2 flex-wrap">
                    <a href="MisCompras.aspx" class="btn btn-ecommerce-primario">Ir a Mis compras</a>
                    <a href="Default.aspx" class="btn btn-tienda-secundario">Volver al catálogo</a>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel principal de simulación de Mercado Pago -->
        <asp:Panel ID="pnlPago" runat="server" Visible="false">
            <div class="card-tienda">
                <div class="encabezado-mp d-flex justify-content-between align-items-center gap-2 flex-wrap">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-wallet2 fs-4"></i>
                        <h4 class="mb-0">Mercado Pago</h4>
                    </div>
                    <span class="badge-mp-prueba">Simulación de prueba</span>
                </div>

                <div class="p-4">
                    <div class="aviso-mp mb-4">
                        <i class="bi bi-info-circle me-1"></i>
                        Esta es una pantalla de pago simulado. No se realiza ningún cobro real ni se conecta con servicios externos.
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom">
                        <div>
                            <div class="titulo-campo">Pedido</div>
                            <span class="numero-pedido fs-5">#<asp:Label ID="lblPedidoId" runat="server"></asp:Label></span>
                        </div>
                        <div class="text-end">
                            <div class="titulo-campo">Estado actual</div>
                            <span class="badge-estado badge-pendiente">Pendiente de pago</span>
                        </div>
                    </div>

                    <p class="mb-3">
                        <span class="dato-chico">Cliente:</span>
                        <strong class="ms-1"><asp:Label ID="lblCliente" runat="server"></asp:Label></strong>
                    </p>

                    <!-- Detalle de productos del pedido -->
                    <div class="table-responsive mb-4">
                        <table class="table table-sm tabla-mp align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Producto</th>
                                    <th class="text-center">Cant.</th>
                                    <th class="text-end">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptItems" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><%# Eval("Producto.Nombre") %></td>
                                            <td class="text-center"><%# Eval("Cantidad") %></td>
                                            <td class="text-end mp-nowrap">
                                                <%# string.Format("{0:C}", Convert.ToInt32(Eval("Cantidad")) * Convert.ToDecimal(Eval("PrecioUnitario"))) %>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>

                    <div class="total-mp d-flex justify-content-between align-items-center mb-4">
                        <span class="fs-5 fw-semibold">Total a pagar</span>
                        <span class="total-pedido fs-3">
                            <asp:Label ID="lblTotal" runat="server"></asp:Label>
                        </span>
                    </div>

                    <div class="d-grid gap-2 mp-acciones">
                        <asp:Button ID="btnPagar" runat="server"
                            Text="Pagar"
                            CssClass="btn btn-mp-primario btn-lg fw-semibold"
                            OnClick="btnPagar_Click" />

                        <asp:Button ID="btnCancelar" runat="server"
                            Text="Cancelar"
                            CssClass="btn btn-mp-secundario"
                            OnClick="btnCancelar_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel de pago aprobado -->
        <asp:Panel ID="pnlPagado" runat="server" Visible="false">
            <div class="card-tienda estado-mp-ok p-4 p-md-5 text-center">
                <div class="icono-estado-mp icono-mp-ok mb-3">
                    <i class="bi bi-check-lg"></i>
                </div>
                <h3 class="mb-2">¡Pago acreditado!</h3>
                <p class="fs-5 mb-2">
                    Pedido <span class="numero-pedido">#<asp:Label ID="lblPedidoPagadoId" runat="server"></asp:Label></span>
                </p>
                <p class="mb-3">
                    <span class="dato-chico me-1">Estado actual:</span>
                    <span class="badge-estado badge-pagado">Pagado</span>
                </p>
                <p class="dato-chico mb-4">
                    Importe abonado:
                    <strong class="total-pedido"><asp:Label ID="lblTotalPagado" runat="server"></asp:Label></strong>
                    (Mercado Pago simulado)
                </p>
                <div class="d-flex justify-content-center gap-2 flex-wrap">
                    <a href="MisCompras.aspx" class="btn btn-ecommerce-primario">Ver mis compras</a>
                    <a href="Default.aspx" class="btn btn-tienda-secundario">Volver al catálogo</a>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel de pago cancelado (el pedido queda en Pendiente de pago) -->
        <asp:Panel ID="pnlCancelado" runat="server" Visible="false">
            <div class="card-tienda estado-mp-pendiente p-4 p-md-5 text-center">
                <div class="icono-estado-mp icono-mp-pendiente mb-3">
                    <i class="bi bi-clock-history"></i>
                </div>
                <h3 class="mb-2">Pago cancelado</h3>
                <p class="fs-5 mb-2">
                    Tu pedido <span class="numero-pedido">#<asp:Label ID="lblPedidoCanceladoId" runat="server"></asp:Label></span> no se abonó.
                </p>
                <p class="mb-3">
                    <span class="dato-chico me-1">Estado actual:</span>
                    <span class="badge-estado badge-pendiente">Pendiente de pago</span>
                </p>
                <p class="dato-chico mb-4">
                    El pedido quedó registrado y sigue pendiente de pago. Podés reintentar ahora o retomarlo más tarde desde Mis compras.
                </p>
                <div class="d-flex justify-content-center gap-2 flex-wrap">
                    <asp:HyperLink ID="lnkReintentarPago" runat="server" CssClass="btn btn-mp-primario">Reintentar pago</asp:HyperLink>
                    <a href="MisCompras.aspx" class="btn btn-ecommerce-primario">Ir a Mis compras</a>
                    <a href="Default.aspx" class="btn btn-tienda-secundario">Volver al catálogo</a>
                </div>
            </div>
        </asp:Panel>

    </div>

</asp:Content>