<%@ Page Title="Carrito de Compras" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Carrito.aspx.cs" Inherits="Web.Carrito" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">
        <h2 class="mb-4"><i class="bi bi-cart3 me-2" style="color: var(--color-boton-primario);"></i>Carrito de Compras</h2>

        <!-- Actualización parcial del carrito -->
        <asp:UpdatePanel ID="updCarrito" runat="server">
            <ContentTemplate>

                <div class="row g-4">

                    <!-- Columna de productos -->
                    <div class="col-lg-8">

                        <!-- Mensaje de error al sumar unidades -->
                        <asp:Label ID="lblError" runat="server"
                            CssClass="alert alert-danger alerta-tienda d-block mb-3"
                            Visible="false">
                        </asp:Label>

                        <asp:Label ID="lblVacio" runat="server"
                            CssClass="alert alerta-tienda-info d-block mb-3"
                            Visible="false">
                            <i class="bi bi-cart3 me-2"></i>Tu carrito está vacío. ¡Agregá productos desde el catálogo!
                        </asp:Label>

                        <!-- Tabla dinámica del carrito -->
                        <div class="card-tienda mb-4" id="divTablaCarrito" runat="server">
                            <div class="table-responsive">
                                <table class="table table-hover tabla-tienda align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th scope="col" style="width: 45%;">Producto</th>
                                            <th scope="col" class="text-end" style="width: 15%;">Precio</th>
                                            <th scope="col" class="text-center" style="width: 20%;">Cantidad</th>
                                            <th scope="col" class="text-end" style="width: 15%;">Subtotal</th>
                                            <th scope="col" style="width: 5%;"></th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <asp:Repeater ID="rptCarrito" runat="server" OnItemCommand="rptCarrito_ItemCommand">
                                            <ItemTemplate>
                                                <tr class='<%# (!Convert.ToBoolean(Eval("Producto.Activo")) || Convert.ToInt32(Eval("Producto.Stock")) <= 0) ? "fila-sin-stock" : "" %>'>

                                                    <td>
                                                        <div class="d-flex align-items-center gap-3">
                                                            <img src='<%# Eval("Producto.ImagenUrl") %>'
                                                                class="mini-producto-carrito"
                                                                alt='<%# Eval("Producto.Nombre") %>' />

                                                            <div>
                                                                <h6 class="mb-0 nombre-producto-carrito">
                                                                    <%# Eval("Producto.Nombre") %>
                                                                </h6>

                                                                <small class="dato-chico d-block">Categoría: <%# Eval("Producto.Categoria.Nombre") %>
                                                                </small>

                                                                <!-- Aviso de disponibilidad en tiempo real -->
                                                                <asp:PlaceHolder runat="server" Visible='<%# !Convert.ToBoolean(Eval("Producto.Activo")) %>'>
                                                                    <span class="texto-stock stock-sin d-block mt-1">
                                                                        <i class="bi bi-x-circle me-1"></i>No disponible — quitalo para continuar
                                                                    </span>
                                                                </asp:PlaceHolder>

                                                                <asp:PlaceHolder runat="server" Visible='<%# Convert.ToBoolean(Eval("Producto.Activo")) && Convert.ToInt32(Eval("Producto.Stock")) <= 0 %>'>
                                                                    <span class="texto-stock stock-sin d-block mt-1">
                                                                        <i class="bi bi-x-circle me-1"></i>Sin stock — quitalo del carrito para continuar
                                                                    </span>
                                                                </asp:PlaceHolder>

                                                                <asp:PlaceHolder runat="server" Visible='<%# Convert.ToBoolean(Eval("Producto.Activo")) && Convert.ToInt32(Eval("Producto.Stock")) > 0 && Convert.ToInt32(Eval("Cantidad")) > Convert.ToInt32(Eval("Producto.Stock")) %>'>
                                                                    <span class="texto-stock stock-pocos d-block mt-1">
                                                                        <i class="bi bi-exclamation-circle me-1"></i>Supera el stock disponible — bajá la cantidad o quitalo
                                                                    </span>
                                                                </asp:PlaceHolder>
                                                            </div>
                                                        </div>
                                                    </td>

                                                    <td class="text-end precio-nowrap">
                                                        <%# Eval("Producto.PrecioVenta", "{0:C}") %>
                                                    </td>

                                                    <td>
                                                        <div class="input-group input-group-sm mx-auto" style="width: 105px;">
                                                            <!-- Restar cantidad -->
                                                            <asp:LinkButton ID="btnRestar"
                                                                runat="server"
                                                                CssClass="btn btn-tienda-secundario"
                                                                Enabled='<%# Convert.ToBoolean(Eval("Producto.Activo")) && Convert.ToInt32(Eval("Producto.Stock")) > 0 && Convert.ToInt32(Eval("Cantidad")) > 1 %>'
                                                                CommandName="Restar"
                                                                CommandArgument='<%# Eval("Producto.Id") %>'>
                                                                -
                                                            </asp:LinkButton>

                                                            <!-- Cantidad actual -->
                                                            <asp:TextBox ID="txtCantidad"
                                                                runat="server"
                                                                CssClass="form-control input-tienda text-center"
                                                                Text='<%# Eval("Cantidad") %>'
                                                                ReadOnly="true">
                                                            </asp:TextBox>

                                                            <!-- Sumar cantidad -->
                                                            <asp:LinkButton ID="btnSumar"
                                                                runat="server"
                                                                CssClass="btn btn-tienda-secundario"
                                                                Enabled='<%# Convert.ToBoolean(Eval("Producto.Activo")) && Convert.ToInt32(Eval("Producto.Stock")) > 0 && Convert.ToInt32(Eval("Cantidad")) < Convert.ToInt32(Eval("Producto.Stock")) %>'
                                                                CommandName="Sumar"
                                                                CommandArgument='<%# Eval("Producto.Id") %>'>
                                                                +
                                                            </asp:LinkButton>
                                                        </div>
                                                    </td>

                                                    <td class="text-end fw-bold precio-nowrap">
                                                        <%# Eval("Subtotal", "{0:C}") %>
                                                    </td>

                                                    <td class="text-end">
                                                        <!-- Eliminar producto -->
                                                        <asp:LinkButton ID="btnEliminar"
                                                            runat="server"
                                                            CssClass="btn btn-outline-danger btn-sm rounded-0"
                                                            CommandName="Eliminar"
                                                            CommandArgument='<%# Eval("Producto.Id") %>'
                                                            title="Eliminar">
                                                            <i class="bi bi-trash"></i>
                                                        </asp:LinkButton>
                                                    </td>

                                                </tr>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Continuar comprando -->
                        <div class="mb-3">
                            <a href="Default.aspx" class="btn btn-tienda-secundario">
                                <i class="bi bi-arrow-left me-1"></i>Continuar comprando
                            </a>
                        </div>

                    </div>

                    <!-- Resumen del pedido -->
                    <div class="col-lg-4">
                        <div class="card-tienda">
                            <div class="encabezado-resumen">
                                <h5 class="mb-0">Resumen del pedido</h5>
                            </div>

                            <div class="p-3">
                                <ul class="list-group list-group-flush mb-3">
                                    <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pb-1">
                                        <span class="dato-chico">Subtotal de productos</span>
                                        <span class="precio-nowrap">
                                            <asp:Label ID="lblSubtotalResumen" runat="server" Text="$0,00"></asp:Label>
                                        </span>
                                    </li>

                                    <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-2">
                                        <span class="dato-chico">Envío</span>
                                        <span class="texto-stock stock-ok">Gratis</span>
                                    </li>

                                    <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pt-3 border-top fw-bold fs-5">
                                        <span>Total</span>
                                        <span class="total-pedido">
                                            <asp:Label ID="lblTotalResumen" runat="server" Text="$0,00"></asp:Label>
                                        </span>
                                    </li>
                                </ul>

                                <!-- Aviso cuando hay productos sin stock -->
                                <asp:Label ID="lblAvisoStock" runat="server"
                                    CssClass="alert alert-danger alerta-tienda small d-block mb-3 py-2"
                                    Visible="false">
                                </asp:Label>

                                <!-- Iniciar compra -->
                                <div class="d-grid gap-2">
                                    <asp:Button ID="btnCheckout"
                                        runat="server"
                                        CssClass="btn btn-ecommerce-primario btn-lg"
                                        Text="Iniciar Compra"
                                        OnClick="btnIniciarCompra_Click" />
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </ContentTemplate>
        </asp:UpdatePanel>

    </div>

</asp:Content>
