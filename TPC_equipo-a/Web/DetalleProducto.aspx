<%@ Page Title="Detalle de producto" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DetalleProducto.aspx.cs" Inherits="Web.DetalleProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row-4">
        <div class="col-md-6">

           
            <img id="imgProducto" runat="server" src="https://via.placeholder.com/500" class="img-fluid rounded" alt="Imagen del producto" />
        </div>
        <div class="col-md-6">

            <h2>
                <asp:Label ID="lblNombre" runat="server" Text="Cargando nombre..."></asp:Label></h2>

            <div class="mb-3">
                <span class="badge bg-secondary fs-6">Código:
                    <asp:Label ID="lblCodigo" runat="server" Text="N/A"></asp:Label>
                </span>
                <span class="badge bg-info text-dark fs-6 ms-2">
                    <asp:Label ID="lblCategoria" runat="server" Text="Categoría"></asp:Label>
                </span>
            </div>

            <p>
                <asp:Label ID="lblDescripcion" runat="server" Text="Cargando descripción..."></asp:Label></p>
            <p class="fw-bold fs-4 text-success">
                <asp:Label ID="lblPrecio" runat="server" Text="$0,00"></asp:Label></p>
            <p class="text-muted">Stock disponible:
                <asp:Label ID="lblStock" runat="server" Text="0"></asp:Label></p>

            <!-- Campo de cantidad y botón real de servidor -->
            <div class="d-flex align-items-center gap-3 mt-4 mb-3">
                <div class="input-group" style="width: 140px;">
                    <span class="input-group-text">Cant.</span>
                    <asp:TextBox ID="txtCantidad" runat="server" TextMode="Number" CssClass="form-control" Text="1" min="1"></asp:TextBox>
                </div>

                <asp:Button ID="btnAgregarCarrito" runat="server" Text="Agregar al carrito" CssClass="btn btn-primary" OnClick="btnAgregarCarrito_Click" />
            </div>

            <div>
                <a class="btn btn-outline-secondary" runat="server" href="~/Default">Volver al catálogo</a>
            </div>

            <!-- Etiqueta oculta por si el cliente pide más cantidad de la que hay en stock -->
            <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold mt-2 d-block" Visible="false"></asp:Label>
        </div>
    </div>
</asp:Content>
