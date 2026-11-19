<%@ Page Title="Catalogo Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Catalogo de Productos</h2>
    <div class="row mb-4 bg-light p-3 rounded border align-items-end">
        <div class="col-md-5 mb-2">
            <label class="form-label fw-bold">Buscar producto:</label>
            <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control" placeholder="Nombre o código (Ej: ROP-0012)"></asp:TextBox>
        </div>
        <div class="col-md-4 mb-2">
            <label class="form-label fw-bold">Categoría:</label>
            <asp:DropDownList ID="ddlCategorias" runat="server" CssClass="form-select">
            </asp:DropDownList>
        </div>
        <div class="col-md-3 mb-2">
            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-primary w-100" OnClick="btnBuscar_Click" />
        </div>
    </div>

    <!-- Aviso de confirmación o error de stock al agregar desde el catálogo -->
    <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 row-cols-xl-5 g-3">
        <asp:Repeater runat="server" ID="repProductos">
            <ItemTemplate>
                <div class="col">
                    <div class="card h-100 card-producto d-flex flex-column"> 
                        <img class="card-img-top img-card-producto" src='<%# Eval("ImagenUrl") %>' alt='<%# Eval("Nombre") %>' />
                        
                        <div class="card-body d-flex flex-column">
                            
                            <!-- Código del producto  --> 
                            <div class="mb-2">
                                <span class="badge bg-secondary"><%# Eval("Codigo") ?? "N/A" %></span>
                            </div>

                            <a href='DetalleProducto.aspx?id=<%# Eval("Id") %>' class="stretched-link text-decoration-none">
                                <h6 class="card-title titulo-card-producto"><%# Eval("Nombre") %> </h6>
                            </a>
                            <p class="fs-5 fw-bold mb-3"><%# Eval("PrecioVenta", "{0:C}") %></p> 
                            
                            <!-- Botón Agregar al Carrito --> 
                            <div class="mt-auto position-relative" style="z-index: 2;">
                                <asp:LinkButton ID="btnAgregarCarrito" runat="server" 
                                    CssClass="btn btn-outline-success w-100" 
                                    CommandArgument='<%# Eval("Id") %>' 
                                    OnClick="btnAgregarCarrito_Click">
                                    <i class="bi bi-cart-plus"></i> Al Carrito
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:Label ID="lblSinProductos" runat="server" CssClass="d-block mt-4 text-secondary" Visible="false">No hay productos disponibles por el momento.</asp:Label>
</asp:Content>