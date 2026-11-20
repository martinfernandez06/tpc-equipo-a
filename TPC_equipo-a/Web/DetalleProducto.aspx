<%@ Page Title="Detalle de producto" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DetalleProducto.aspx.cs" Inherits="Web.DetalleProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- migas de pan arriba y volver a la derecha, la categoria lleva al catalogo ya filtrado --%>
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mt-3 mb-4">
        <nav class="migas-detalle">
            <a runat="server" href="~/Default">Catálogo</a>
            <i class="bi bi-chevron-right"></i>
            <asp:HyperLink ID="hlMigaCategoria" runat="server" NavigateUrl="~/Default">
                <asp:Label ID="lblCategoria" runat="server" Text="Categoría"></asp:Label>
            </asp:HyperLink>
        </nav>
        <a class="volver-detalle" runat="server" href="~/Default"><i class="bi bi-arrow-left me-1"></i>Volver al catálogo</a>
    </div>

    <div class="row g-4 g-lg-5 mb-5">
        <%-- imagen grande a la izquierda, en el celu queda arriba --%>
        <div class="col-md-6 col-lg-5">
            <div class="img-detalle-caja">
                <%-- si el link de la foto esta roto el navegador muestra la imagen generica --%>
                <img id="imgProducto" runat="server" src="~/Imagenes/sin-imagen.svg" class="img-detalle" alt="Imagen del producto" onerror="this.onerror=null; this.src='Imagenes/sin-imagen.svg';" />
            </div>
        </div>

        <div class="col-md-6 col-lg-7">
            <span class="codigo-producto">
                <asp:Label ID="lblCodigo" runat="server" Text="N/A"></asp:Label>
            </span>
            <h1 class="titulo-detalle mt-2 mb-3">
                <asp:Label ID="lblNombre" runat="server" Text="Cargando nombre..."></asp:Label>
            </h1>
            <div class="precio-detalle">
                <asp:Label ID="lblPrecio" runat="server" Text="$0,00"></asp:Label>
            </div>
            <%-- el numero del stock queda escondido porque el boton agregar lo lee, al cliente se le muestra en palabras --%>
            <span class="d-none">
                <asp:Label ID="lblStock" runat="server" Text="0"></asp:Label>
            </span>
            <asp:Label ID="lblTextoStock" runat="server" CssClass="texto-stock d-block mb-4"></asp:Label>
            <p class="descripcion-detalle mb-4">
                <asp:Label ID="lblDescripcion" runat="server" Text="Cargando descripción..."></asp:Label>
            </p>

            <%-- cantidad, boton y avisos adentro del updatepanel, asi el menos, el mas y agregar no recargan la pagina --%>
            <asp:UpdatePanel ID="upCompra" runat="server">
                <ContentTemplate>
                    <div class="d-flex gap-2 mb-3">
                        <%-- el menos y el mas no dejan bajar de 1 ni pasar del stock --%>
                        <div class="input-group cantidad-detalle">
                            <asp:LinkButton ID="btnMenos" runat="server" CssClass="btn btn-tienda-secundario" OnClick="btnMenos_Click" ToolTip="Restar uno"><i class="bi bi-dash"></i></asp:LinkButton>
                            <asp:TextBox ID="txtCantidad" runat="server" TextMode="Number" CssClass="form-control input-tienda text-center" Text="1" min="1"></asp:TextBox>
                            <asp:LinkButton ID="btnMas" runat="server" CssClass="btn btn-tienda-secundario" OnClick="btnMas_Click" ToolTip="Sumar uno"><i class="bi bi-plus"></i></asp:LinkButton>
                        </div>
                        <asp:Button ID="btnAgregarCarrito" runat="server" Text="Agregar al carrito" CssClass="btn btn-ecommerce-primario btn-lg flex-grow-1" OnClick="btnAgregarCarrito_Click" />
                    </div>

                    <!-- Etiqueta oculta por si el cliente pide más cantidad de la que hay en stock -->
                    <asp:Label ID="lblError" runat="server" CssClass="alert alert-danger d-block mt-2 mb-4" Visible="false"></asp:Label>
                    <!-- Etiqueta oculta para confirmar que el producto se sumó al carrito sin cambiar de página -->
                    <asp:Label ID="lblExito" runat="server" CssClass="alert alert-success d-block mt-2 mb-4" Visible="false"></asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>

</asp:Content>
