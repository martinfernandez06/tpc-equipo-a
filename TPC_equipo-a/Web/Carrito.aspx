
<%@ Page Title="Carrito de Compras" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Carrito.aspx.cs" Inherits="Web.Carrito" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">
        <h2 class="mb-4"><i class="bi bi-cart3"></i> Carrito de Compras</h2>

        <!-- Actualizacion parcial del carrito -->
        <asp:UpdatePanel ID="updCarrito" runat="server">
            <ContentTemplate>

                <div class="row">

                    <!-- Columna de productos -->
                    <div class="col-lg-8">

                        <!-- Mensaje de error de stock -->
                        <asp:Label ID="lblError" runat="server"
                            CssClass="alert alert-danger d-block mb-3"
                            Visible="false">
                        </asp:Label>

                        <!-- Mensaje de carrito vacio -->
                        <asp:Label ID="lblVacio" runat="server"
                            CssClass="alert alert-info d-block mb-3"
                            Visible="false">
                            Tu carrito está vacío. ¡Agregá productos desde el catálogo!
                        </asp:Label>

                        <!-- Tabla dinamica del carrito -->
                        <div class="card shadow-sm mb-4"
                            id="divTablaCarrito" runat="server">

                            <div class="card-body p-0">
                                <div class="table-responsive">

                                    <table class="table table-hover align-middle mb-0">

                                        <thead class="table-light">
                                            <tr>
                                                <th scope="col" style="width: 45%;">Producto</th>
                                                <th scope="col" style="width: 15%;">Precio</th>
                                                <th scope="col" style="width: 20%;">Cantidad</th>
                                                <th scope="col" style="width: 15%;">Subtotal</th>
                                                <th scope="col" style="width: 5%;"></th>
                                            </tr>
                                        </thead>

                                        <tbody>

                                            <asp:Repeater ID="rptCarrito" runat="server"
                                                OnItemCommand="rptCarrito_ItemCommand">

                                                <ItemTemplate>
                                                    <tr>

                                                        <td>
                                                            <div class="d-flex align-items-center">

                                                                <img src='<%# Eval("Producto.ImagenUrl") %>'
                                                                    class="img-thumbnail me-3"
                                                                    alt='<%# Eval("Producto.Nombre") %>'
                                                                    style="width: 60px; height: 60px; object-fit: cover;">

                                                                <div>
                                                                    <h6 class="mb-0">
                                                                        <%# Eval("Producto.Nombre") %>
                                                                    </h6>

                                                                    <small class="text-muted">
                                                                        Categoría: <%# Eval("Producto.Categoria.Nombre") %>
                                                                    </small>
                                                                </div>

                                                            </div>
                                                        </td>

                                                        <td>
                                                            <%# Eval("Producto.PrecioVenta", "{0:C}") %>
                                                        </td>

                                                        <td>
                                                            <div class="input-group input-group-sm"
                                                                style="width: 100px;">

                                                                <!-- Restar cantidad -->
                                                                <asp:LinkButton ID="btnRestar"
                                                                    runat="server"
                                                                    CssClass='<%# Convert.ToInt32(Eval("Cantidad")) <= 1 ? "btn btn-outline-secondary disabled" : "btn btn-outline-secondary" %>'
                                                                    Enabled='<%# Convert.ToInt32(Eval("Cantidad")) > 1 %>'
                                                                    CommandName="Restar"
                                                                    CommandArgument='<%# Eval("Producto.Id") %>'>
                                                                    -
                                                                </asp:LinkButton>

                                                                <!-- Cantidad actual -->
                                                                <asp:TextBox ID="txtCantidad"
                                                                    runat="server"
                                                                    CssClass="form-control text-center"
                                                                    Text='<%# Eval("Cantidad") %>'
                                                                    ReadOnly="true">
                                                                </asp:TextBox>

                                                                <!-- Sumar cantidad -->
                                                                <asp:LinkButton ID="btnSumar"
                                                                    runat="server"
                                                                    CssClass='<%# Convert.ToInt32(Eval("Cantidad")) >= Convert.ToInt32(Eval("Producto.Stock")) ? "btn btn-outline-secondary disabled" : "btn btn-outline-secondary" %>'
                                                                    Enabled='<%# Convert.ToInt32(Eval("Cantidad")) < Convert.ToInt32(Eval("Producto.Stock")) %>'
                                                                    CommandName="Sumar"
                                                                    CommandArgument='<%# Eval("Producto.Id") %>'>
                                                                    +
                                                                </asp:LinkButton>

                                                            </div>
                                                        </td>

                                                        <td class="fw-bold">
                                                            <%# Eval("Subtotal", "{0:C}") %>
                                                        </td>

                                                        <td>
                                                            <!-- Eliminar producto -->
                                                            <asp:LinkButton ID="btnEliminar"
                                                                runat="server"
                                                                CssClass="btn btn-outline-danger btn-sm"
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
                        </div>

                        <!-- Continuar comprando -->
                        <div class="mb-3">
                            <a href="Default.aspx" class="btn btn-outline-primary">
                                ← Continuar Comprando
                            </a>
                        </div>

                    </div>

                    <!-- Resumen del pedido -->
                    <div class="col-lg-4">

                        <div class="card shadow-sm">

                            <div class="card-header bg-primary text-white">
                                <h5 class="card-title mb-0">
                                    Resumen del Pedido
                                </h5>
                            </div>

                            <div class="card-body">

                                <ul class="list-group list-group-flush mb-3">

                                    <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pb-0">
                                        Subtotal de productos

                                        <span>
                                            <asp:Label ID="lblSubtotalResumen"
                                                runat="server"
                                                Text="$0,00">
                                            </asp:Label>
                                        </span>
                                    </li>

                                    <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-3">
                                        Envío

                                        <span class="text-success">
                                            A calcular en checkout
                                        </span>
                                    </li>

                                    <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pt-3 border-top fw-bold fs-5">
                                        Total

                                        <span>
                                            <asp:Label ID="lblTotalResumen"
                                                runat="server"
                                                Text="$0,00">
                                            </asp:Label>
                                        </span>
                                    </li>

                                </ul>

                                <!-- Iniciar compra -->
                                <div class="d-grid gap-2">

                                    <asp:Button ID="btnCheckout"
                                        runat="server"
                                        CssClass="btn btn-success btn-lg"
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
