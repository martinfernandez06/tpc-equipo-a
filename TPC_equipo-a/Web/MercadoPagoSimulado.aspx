<%@ Page Title="Pago con Mercado Pago" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MercadoPagoSimulado.aspx.cs" Inherits="Web.MercadoPagoSimulado" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5" style="max-width: 680px;">

        <!-- Panel de error (pedido inexistente, ajeno, otra forma de pago o estado inválido) -->
        <asp:Panel ID="pnlError" runat="server" Visible="false">
            <div class="card shadow-sm border-danger">
                <div class="card-body text-center py-5">
                    <i class="bi bi-exclamation-triangle-fill text-danger" style="font-size: 3rem;"></i>
                    <h4 class="mt-3">No se puede procesar el pago</h4>
                    <p class="text-muted mb-4">
                        <asp:Label ID="lblError" runat="server"></asp:Label>
                    </p>
                    <div class="d-flex justify-content-center gap-2">
                        <a href="MisCompras.aspx" class="btn btn-primary">Ir a Mis compras</a>
                        <a href="Default.aspx" class="btn btn-outline-secondary">Volver al catálogo</a>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel principal de simulación de Mercado Pago -->
        <asp:Panel ID="pnlPago" runat="server" Visible="false">
            <div class="card shadow">
                <div class="card-header text-white py-3 d-flex justify-content-between align-items-center" style="background-color: #009ee3;">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-wallet2 fs-4"></i>
                        <h4 class="mb-0">Mercado Pago</h4>
                    </div>
                    <span class="badge bg-light text-dark">Simulación de prueba</span>
                </div>

                <div class="card-body p-4">
                    <div class="alert alert-info py-2 small mb-4">
                        <i class="bi bi-info-circle me-1"></i>
                        Esta es una pantalla de pago simulado. No se realiza ningún cobro real ni se conecta con servicios externos.
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-3 pb-3 border-bottom">
                        <div>
                            <small class="text-muted d-block">Pedido</small>
                            <span class="fs-5 fw-bold">#<asp:Label ID="lblPedidoId" runat="server"></asp:Label></span>
                        </div>
                        <div class="text-end">
                            <small class="text-muted d-block">Estado actual</small>
                            <span class="badge bg-warning text-dark">Pendiente de pago</span>
                        </div>
                    </div>

                    <p class="mb-3">
                        <strong>Cliente:</strong> <asp:Label ID="lblCliente" runat="server"></asp:Label>
                    </p>

                    <!-- Detalle de productos del pedido -->
                    <div class="table-responsive mb-3">
                        <table class="table table-sm align-middle mb-0">
                            <thead class="table-light">
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
                                            <td class="text-end">
                                                <%# string.Format("{0:C}", Convert.ToInt32(Eval("Cantidad")) * Convert.ToDecimal(Eval("PrecioUnitario"))) %>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded border mb-4">
                        <span class="fs-5 fw-semibold">Total a pagar</span>
                        <span class="fs-3 fw-bold text-primary">
                            <asp:Label ID="lblTotal" runat="server"></asp:Label>
                        </span>
                    </div>

                    <div class="d-grid gap-2">
                        <asp:Button ID="btnPagar" runat="server"
                            Text="Pagar"
                            CssClass="btn btn-lg text-white fw-semibold"
                            Style="background-color: #009ee3;"
                            OnClick="btnPagar_Click" />

                        <asp:Button ID="btnCancelar" runat="server"
                            Text="Cancelar"
                            CssClass="btn btn-outline-secondary"
                            OnClick="btnCancelar_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel de pago aprobado -->
        <asp:Panel ID="pnlPagado" runat="server" Visible="false">
            <div class="card shadow-sm border-success">
                <div class="card-body text-center py-5">
                    <i class="bi bi-check-circle-fill text-success" style="font-size: 3.5rem;"></i>
                    <h3 class="mt-3">¡Pago acreditado!</h3>
                    <p class="fs-5 mb-2">
                        Pedido <strong>#<asp:Label ID="lblPedidoPagadoId" runat="server"></asp:Label></strong>
                    </p>
                    <p class="mb-2">
                        Estado actual: <span class="badge bg-success">Pagado</span>
                    </p>
                    <p class="text-muted mb-4">
                        Importe abonado: <strong><asp:Label ID="lblTotalPagado" runat="server"></asp:Label></strong> (Mercado Pago simulado)
                    </p>
                    <div class="d-flex justify-content-center gap-2">
                        <a href="MisCompras.aspx" class="btn btn-primary">Ver mis compras</a>
                        <a href="Default.aspx" class="btn btn-outline-secondary">Volver al catálogo</a>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel de pago cancelado (el pedido queda en Pendiente de pago) -->
        <asp:Panel ID="pnlCancelado" runat="server" Visible="false">
            <div class="card shadow-sm border-warning">
                <div class="card-body text-center py-5">
                    <i class="bi bi-clock-history text-warning" style="font-size: 3.5rem;"></i>
                    <h3 class="mt-3">Pago cancelado</h3>
                    <p class="fs-5 mb-2">
                        Tu pedido <strong>#<asp:Label ID="lblPedidoCanceladoId" runat="server"></asp:Label></strong> no se abonó.
                    </p>
                    <p class="mb-2">
                        Estado actual: <span class="badge bg-warning text-dark">Pendiente de pago</span>
                    </p>
                    <p class="text-muted mb-4">
                        El pedido quedó registrado y sigue pendiente de pago. Podés reintentar ahora o retomarlo más tarde desde Mis compras.
                    </p>
                    <div class="d-flex justify-content-center gap-2 flex-wrap">
                        <asp:HyperLink ID="lnkReintentarPago" runat="server" CssClass="btn btn-primary">Reintentar pago</asp:HyperLink>
                        <a href="MisCompras.aspx" class="btn btn-outline-primary">Ir a Mis compras</a>
                        <a href="Default.aspx" class="btn btn-outline-secondary">Volver al catálogo</a>
                    </div>
                </div>
            </div>
        </asp:Panel>

    </div>

</asp:Content>