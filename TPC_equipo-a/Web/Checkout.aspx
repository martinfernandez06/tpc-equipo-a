<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="Web.Checkout" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">
        <h2 class="mb-4"><i class="bi bi-bag-check me-2" style="color: var(--color-boton-primario);"></i>Finalizar Compra</h2>

        <asp:UpdatePanel ID="updCheckout" runat="server">
            <ContentTemplate>

                <!-- Panel cuando el carrito está vacío -->
                <asp:Panel ID="pnlCarritoVacio" runat="server" Visible="false" CssClass="alert alert-info alerta-tienda">
                    <h5 class="alert-heading">Tu carrito está vacío</h5>
                    <p class="mb-3">Necesitás agregar al menos un producto antes de iniciar la compra.</p>
                    <a href="Default.aspx" class="btn btn-ecommerce-primario">Volver al catálogo</a>
                </asp:Panel>

                <!-- Panel principal del Checkout -->
                <asp:Panel ID="pnlCheckout" runat="server">
                    <div class="row g-4">

                        <!-- Columna izquierda: Datos del cliente, entrega, dirección y pago -->
                        <div class="col-lg-6 col-xl-7">

                            <!-- 1. Datos del cliente -->
                            <div class="card-tienda mb-4">
                                <div class="encabezado-bloque">
                                    <h5 class="mb-0"><i class="bi bi-person me-2"></i>1. Datos del cliente</h5>
                                </div>
                                <div class="p-3">
                                    <p class="mb-1"><strong>Cliente:</strong> <asp:Label ID="lblClienteNombre" runat="server"></asp:Label></p>
                                    <p class="mb-1"><strong>Email:</strong> <asp:Label ID="lblClienteEmail" runat="server"></asp:Label></p>
                                    <p class="mb-1"><strong>Teléfono:</strong> <asp:Label ID="lblClienteTelefono" runat="server"></asp:Label></p>
                                    <p class="mb-0"><strong>Dirección principal:</strong> <asp:Label ID="lblClienteDireccionPrincipal" runat="server"></asp:Label></p>
                                </div>
                            </div>

                            <!-- 2. Forma de entrega y dirección -->
                            <div class="card-tienda mb-4">
                                <div class="encabezado-bloque">
                                    <h5 class="mb-0"><i class="bi bi-truck me-2"></i>2. Forma de entrega</h5>
                                </div>
                                <div class="p-3">
                                    <asp:RadioButtonList ID="rblFormaEntrega" runat="server"
                                        RepeatLayout="Flow"
                                        CssClass="rbl-opciones"
                                        AutoPostBack="true"
                                        OnSelectedIndexChanged="rblFormaEntrega_SelectedIndexChanged">
                                    </asp:RadioButtonList>

                                    <!-- Bloque de direcciones (solo visible si la forma de entrega requiere dirección) -->
                                    <asp:Panel ID="pnlDirecciones" runat="server" Visible="false" CssClass="mt-3 pt-3 border-top">
                                        <div class="titulo-campo mb-2">Dirección de envío</div>

                                        <asp:Label ID="lblSinDirecciones" runat="server" CssClass="alert alert-warning alerta-tienda d-block py-2" Visible="false">
                                            No tenés direcciones guardadas. Cargá una dirección nueva para continuar con el envío.
                                        </asp:Label>

                                        <div class="mb-3" id="divSelectorDireccion" runat="server">
                                            <label class="form-label dato-chico">Elegí una dirección guardada:</label>
                                            <asp:DropDownList ID="ddlDirecciones" runat="server"
                                                CssClass="form-select input-tienda"
                                                AutoPostBack="true"
                                                OnSelectedIndexChanged="ddlDirecciones_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>

                                        <asp:Button ID="btnMostrarNuevaDireccion" runat="server"
                                            Text="+ Cargar nueva dirección"
                                            CssClass="btn btn-tienda-secundario btn-sm"
                                            OnClick="btnMostrarNuevaDireccion_Click" />

                                        <!-- Formulario desplegable para cargar una nueva dirección -->
                                        <asp:Panel ID="pnlNuevaDireccion" runat="server" Visible="false" CssClass="mt-3 panel-nueva-direccion">
                                            <div class="titulo-campo mb-3">Nueva dirección</div>

                                            <asp:Label ID="lblErrorDireccion" runat="server" CssClass="alert alert-danger alerta-tienda d-block py-2 mb-3" Visible="false"></asp:Label>

                                            <div class="row g-2">
                                                <div class="col-md-8">
                                                    <label class="form-label dato-chico mb-1">Calle *</label>
                                                    <asp:TextBox ID="txtCalle" runat="server" CssClass="form-control form-control-sm input-tienda" MaxLength="100"></asp:TextBox>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label dato-chico mb-1">Número *</label>
                                                    <asp:TextBox ID="txtNumero" runat="server" CssClass="form-control form-control-sm input-tienda" MaxLength="20"></asp:TextBox>
                                                </div>
                                                <div class="col-md-5">
                                                    <label class="form-label dato-chico mb-1">Localidad *</label>
                                                    <asp:TextBox ID="txtLocalidad" runat="server" CssClass="form-control form-control-sm input-tienda" MaxLength="100"></asp:TextBox>
                                                </div>
                                                <div class="col-md-4">
                                                    <label class="form-label dato-chico mb-1">Provincia *</label>
                                                    <asp:TextBox ID="txtProvincia" runat="server" CssClass="form-control form-control-sm input-tienda" MaxLength="100"></asp:TextBox>
                                                </div>
                                                <div class="col-md-3">
                                                    <label class="form-label dato-chico mb-1">Cód. Postal *</label>
                                                    <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control form-control-sm input-tienda" MaxLength="20"></asp:TextBox>
                                                </div>
                                                <div class="col-12">
                                                    <label class="form-label dato-chico mb-1">Observaciones (piso, depto, referencias)</label>
                                                    <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control form-control-sm input-tienda" MaxLength="255"></asp:TextBox>
                                                </div>
                                                <div class="col-12 mt-2">
                                                    <div class="form-check">
                                                        <asp:CheckBox ID="chkPrincipal" runat="server" CssClass="form-check-input" />
                                                        <label class="form-check-label" for="<%= chkPrincipal.ClientID %>">Guardar como dirección principal</label>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="mt-3 d-flex gap-2">
                                                <asp:Button ID="btnGuardarDireccion" runat="server" Text="Guardar dirección" CssClass="btn btn-ecommerce-primario btn-sm" OnClick="btnGuardarDireccion_Click" />
                                                <asp:Button ID="btnCancelarDireccion" runat="server" Text="Cancelar" CssClass="btn btn-tienda-secundario btn-sm" OnClick="btnCancelarDireccion_Click" />
                                            </div>
                                        </asp:Panel>
                                    </asp:Panel>
                                </div>
                            </div>

                            <!-- 3. Forma de pago -->
                            <div class="card-tienda mb-4">
                                <div class="encabezado-bloque">
                                    <h5 class="mb-0"><i class="bi bi-credit-card me-2"></i>3. Forma de pago</h5>
                                </div>
                                <div class="p-3">
                                    <asp:RadioButtonList ID="rblFormaPago" runat="server"
                                        RepeatLayout="Flow"
                                        CssClass="rbl-opciones"
                                        AutoPostBack="true"
                                        OnSelectedIndexChanged="rblFormaPago_SelectedIndexChanged">
                                    </asp:RadioButtonList>
                                </div>
                            </div>

                            <a href="Carrito.aspx" class="btn btn-tienda-secundario">
                                <i class="bi bi-arrow-left me-1"></i>Volver al carrito
                            </a>
                        </div>

                        <!-- Columna derecha: Resumen de la compra -->
                        <div class="col-lg-6 col-xl-5">
                            <div class="card-tienda">
                                <div class="encabezado-resumen">
                                    <h5 class="mb-0">Resumen de tu compra</h5>
                                </div>
                                <div class="p-3">

                                    <!-- Tabla de productos con miniatura y precios -->
                                    <div class="table-responsive mb-3">
                                        <table class="table table-sm align-middle mb-0">
                                            <thead>
                                                <tr class="titulo-campo">
                                                    <th>Producto</th>
                                                    <th class="text-center">Cant.</th>
                                                    <th class="text-end">Precio</th>
                                                    <th class="text-end">Subtotal</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <asp:Repeater ID="rptResumen" runat="server">
                                                    <ItemTemplate>
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center gap-2">
                                                                    <img src='<%# Eval("Producto.ImagenUrl") %>'
                                                                        alt='<%# Eval("Producto.Nombre") %>'
                                                                        class="mini-producto" />
                                                                    <span class="nombre-item small"><%# Eval("Producto.Nombre") %></span>
                                                                </div>
                                                            </td>
                                                            <td class="text-center"><%# Eval("Cantidad") %></td>
                                                            <td class="text-end precio-nowrap small"><%# Eval("Producto.PrecioVenta", "{0:C}") %></td>
                                                            <td class="text-end fw-semibold precio-nowrap small"><%# Eval("Subtotal", "{0:C}") %></td>
                                                        </tr>
                                                    </ItemTemplate>
                                                </asp:Repeater>
                                            </tbody>
                                        </table>
                                    </div>

                                    <!-- Datos seleccionados y costo de envío -->
                                    <ul class="list-group list-group-flush mb-3 border-top pt-2">
                                        <li class="list-group-item d-flex justify-content-between px-0 border-0 py-1">
                                            <span class="dato-chico">Subtotal:</span>
                                            <span class="fw-semibold precio-nowrap"><asp:Label ID="lblResumenSubtotal" runat="server" Text="$0,00"></asp:Label></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between px-0 border-0 py-1">
                                            <span class="dato-chico">Entrega:</span>
                                            <span class="fw-semibold text-end"><asp:Label ID="lblResumenEntrega" runat="server" Text="Sin seleccionar"></asp:Label></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between px-0 border-0 py-1">
                                            <span class="dato-chico">Envío:</span>
                                            <span class="texto-stock stock-ok text-end"><asp:Label ID="lblResumenEnvio" runat="server" Text="Gratis"></asp:Label></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between px-0 border-0 py-1" id="liResumenDireccion" runat="server">
                                            <span class="dato-chico me-2">Dirección:</span>
                                            <span class="fw-semibold text-end"><asp:Label ID="lblResumenDireccion" runat="server" Text="Sin seleccionar"></asp:Label></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between px-0 border-0 py-1">
                                            <span class="dato-chico">Forma de pago:</span>
                                            <span class="fw-semibold text-end"><asp:Label ID="lblResumenPago" runat="server" Text="Sin seleccionar"></asp:Label></span>
                                        </li>
                                        <li class="list-group-item d-flex justify-content-between px-0 pt-3 mt-2 border-top fw-bold fs-5">
                                            <span>Total:</span>
                                            <span class="total-pedido"><asp:Label ID="lblResumenTotal" runat="server" Text="$0,00"></asp:Label></span>
                                        </li>
                                    </ul>

                                    <!-- Cartel de error -->
                                    <asp:Label ID="lblError" runat="server"
                                        CssClass="alert alert-danger alerta-tienda small d-block mb-3 py-2"
                                        Visible="false">
                                    </asp:Label>

                                    <div class="d-grid">
                                        <asp:Button ID="btnConfirmarCompra" runat="server"
                                            Text="Confirmar compra"
                                            CssClass="btn btn-ecommerce-primario btn-lg"
                                            OnClick="btnConfirmarCompra_Click" />
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </asp:Panel>

                <!-- Panel de confirmación para formas de pago que no van a Mercado Pago (Efectivo / Transferencia) -->
                <asp:Panel ID="pnlConfirmacion" runat="server" Visible="false">
                    <div class="card-tienda">
                        <div class="text-center py-5 px-3">
                            <i class="bi bi-check-circle-fill" style="font-size: 3.5rem; color: var(--color-stock-ok);"></i>
                            <h3 class="mt-3">¡Pedido confirmado!</h3>
                            <p class="fs-5 mb-2">
                                Tu número de pedido es <strong>#<asp:Label ID="lblPedidoConfirmadoId" runat="server"></asp:Label></strong>
                            </p>
                            <p class="mb-2">
                                Estado actual: <span class="badge-estado badge-pendiente">Pendiente de pago</span>
                            </p>
                            <p class="dato-chico mb-4">
                                <asp:Label ID="lblDetallePagoConfirmado" runat="server"></asp:Label>
                            </p>
                            <div class="d-flex justify-content-center gap-2">
                                <a href="MisCompras.aspx" class="btn btn-ecommerce-primario">Ver mis compras</a>
                                <a href="Default.aspx" class="btn btn-tienda-secundario">Seguir comprando</a>
                            </div>
                        </div>
                    </div>
                </asp:Panel>

            </ContentTemplate>
        </asp:UpdatePanel>
    </div>

</asp:Content>