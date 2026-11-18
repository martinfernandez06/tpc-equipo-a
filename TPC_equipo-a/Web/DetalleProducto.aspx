<%@ Page Title="Detalle de producto" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DetalleProducto.aspx.cs" Inherits="Web.DetalleProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="row mt-5 mb-5 align-items-center">
        
        <!-- Columna izquierda: Imagen centrada y con una sombra sutil -->
        <div class="col-md-6 text-center mb-4 mb-md-0">
            <img id="imgProducto" runat="server" src="https://via.placeholder.com/500" class="img-fluid rounded shadow-sm" alt="Imagen del producto" style="max-height: 500px; object-fit: contain;" />
        </div>
        
        <!-- Columna derecha: Detalles del producto -->
        <div class="col-md-6 ps-md-4">
            <h2 class="mb-3">
                <asp:Label ID="lblNombre" runat="server" Text="Cargando nombre..."></asp:Label>
            </h2>

            <div class="mb-4">
                <span class="badge bg-secondary fs-6">Código:
                    <asp:Label ID="lblCodigo" runat="server" Text="N/A"></asp:Label>
                </span>
                <span class="badge bg-info text-dark fs-6 ms-2">
                    <asp:Label ID="lblCategoria" runat="server" Text="Categoría"></asp:Label>
                </span>
            </div>

            <p class="fs-5 mb-4">
                <asp:Label ID="lblDescripcion" runat="server" Text="Cargando descripción..."></asp:Label>
            </p>
            
            <p class="fw-bold text-success mb-1" style="font-size: 2.5rem;">
                <asp:Label ID="lblPrecio" runat="server" Text="$0,00"></asp:Label>
            </p>
            
            <p class="text-muted fs-6 mb-4">Stock disponible:
                <asp:Label ID="lblStock" runat="server" Text="0"></asp:Label>
            </p>

            <!-- Campo de cantidad y botón real de servidor -->
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="input-group" style="width: 130px;">
                    <span class="input-group-text">Cant.</span>
                    <asp:TextBox ID="txtCantidad" runat="server" TextMode="Number" CssClass="form-control text-center" Text="1" min="1"></asp:TextBox>
                </div>

                <asp:Button ID="btnAgregarCarrito" runat="server" Text="Agregar al carrito" CssClass="btn btn-primary btn-lg" OnClick="btnAgregarCarrito_Click" />
            </div>

            <!-- Etiqueta oculta por si el cliente pide más cantidad de la que hay en stock -->
            <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mt-2 mb-4" Visible="false"></asp:Label>

            <div class="mt-4 border-top pt-4">
                <a class="btn btn-outline-secondary" runat="server" href="~/Default">
                    <i class="bi bi-arrow-left me-1"></i>Volver al catálogo
                </a>
            </div>
        </div>
    </div>

</asp:Content>