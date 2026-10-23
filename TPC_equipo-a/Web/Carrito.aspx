<%@ Page Title="Carrito de Compras" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Carrito.aspx.cs" Inherits="Web.Carrito" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container my-5">
        <h2 class="mb-4"><i class="bi bi-cart3"></i> Carrito de Compras</h2>

        <div class="row">
          
            <div class="col-lg-8">
                <div class="card shadow-sm mb-4">
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
                                    <!-- item 1 Ejemplo-->
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://via.placeholder.com/60" class="img-thumbnail me-3" alt="Producto 1" style="width: 60px; height: 60px; object-fit: cover;">
                                                <div>
                                                    <h6 class="mb-0">Auriculares Inalámbricos Bluetooth</h6>
                                                    <small class="text-muted">Categoría: Electrónica</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>$15.500,00</td>
                                        <td>
                                            <div class="input-group input-group-sm" style="width: 100px;">
                                                <button class="btn btn-outline-secondary" type="button">-</button>
                                                <input type="text" class="form-control text-center" value="1" readonly>
                                                <button class="btn btn-outline-secondary" type="button">+</button>
                                            </div>
                                        </td>
                                        <td class="fw-bold">$15.500,00</td>
                                        <td>
                                            <button type="button" class="btn btn-outline-danger btn-sm" title="Eliminar">
                                                🗑️
                                            </button>
                                        </td>
                                    </tr>

                                    <!-- 2Ejemplo  -->
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="https://via.placeholder.com/60" class="img-thumbnail me-3" alt="Producto 2" style="width: 60px; height: 60px; object-fit: cover;">
                                                <div>
                                                    <h6 class="mb-0">Zapatillas Deportivas Running</h6>
                                                    <small class="text-muted">Categoría: Deportes</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>$45.000,00</td>
                                        <td>
                                            <div class="input-group input-group-sm" style="width: 100px;">
                                                <button class="btn btn-outline-secondary" type="button">-</button>
                                                <input type="text" class="form-control text-center" value="2" readonly>
                                                <button class="btn btn-outline-secondary" type="button">+</button>
                                            </div>
                                        </td>
                                        <td class="fw-bold">$90.000,00</td>
                                        <td>
                                            <button type="button" class="btn btn-outline-danger btn-sm" title="Eliminar">
                                                🗑️
                                            </button>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Seguir Comprando -->

                <div class="mb-3">
                    <a href="Default.aspx" class="btn btn-outline-primary">
                        ← Continuar Comprando
                    </a>
                </div>
            </div>

            <!-- Resumen  -->


            <div class="col-lg-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h5 class="card-title mb-0">Resumen del Pedido</h5>
                    </div>
                    <div class="card-body">
                        <ul class="list-group list-group-flush mb-3">
                            <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pb-0">
                                Subtotal de productos
                                <span>$105.500,00</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 mb-3">
                                Envío
                                <span class="text-success">A calcular en checkout</span>
                            </li>
                            <li class="list-group-item d-flex justify-content-between align-items-center border-0 px-0 pt-3 border-top fw-bold fs-5">
                                Total
                                <span>$105.500,00</span>
                            </li>
                        </ul>

                        <!-- Checkout -->

                        <div class="d-grid gap-2">
                            <a href="Checkout.aspx" class="btn btn-success btn-lg">
                                Iniciar Checkout / Iniciar Compra
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</asp:Content>