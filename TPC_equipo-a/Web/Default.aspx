<%@ Page Title="Catalogo Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <%-- filtro pegado a la navbar, el fondo lila llega a los bordes y los campos quedan alineados con las tarjetas --%>
    <div class="filtro-catalogo">
        <div class="row g-2 align-items-end">
            <div class="col-md-5">
                <div class="titulo-campo">Buscar</div>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-search"></i></span>
                    <asp:TextBox ID="txtBuscar" runat="server" CssClass="form-control input-tienda" placeholder="Nombre o código, ej: ROP-0012"></asp:TextBox>
                </div>
            </div>
            <div class="col-md-4">
                <div class="titulo-campo">Categoría</div>
                <asp:DropDownList ID="ddlCategorias" runat="server" CssClass="form-select input-tienda"></asp:DropDownList>
            </div>
            <div class="col-md-3 col-lg-auto d-flex gap-2">
                <%-- buscar sigue siendo button y no linkbutton, asi el enter en la caja de texto sigue buscando --%>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-ecommerce-primario flex-grow-1" OnClick="btnBuscar_Click" />
                <%-- en el celular queda solo la x para que entre al lado de buscar --%>
                <asp:LinkButton ID="btnLimpiar" runat="server" CssClass="btn btn-tienda-secundario text-nowrap" OnClick="btnLimpiar_Click" ToolTip="Limpiar filtro"><i class="bi bi-x-lg"></i><span class="d-none d-lg-inline ms-1">Limpiar</span></asp:LinkButton>
            </div>
        </div>
    </div>
    <%-- fila con lo que de verdad se esta filtrando y cuantos productos quedaron, la x de cada chip saca solo ese filtro --%>
    <div class="d-flex flex-wrap align-items-center gap-2 my-3">
        <asp:Panel ID="pnlFiltrando" runat="server" Visible="false" CssClass="d-flex flex-wrap align-items-center gap-2">
            <span class="small text-secondary">Filtrando por</span>
            <asp:LinkButton ID="btnQuitarTexto" OnClick="btnQuitarTexto_Click" runat="server" CssClass="chip-filtro" ToolTip="Quitar este filtro"></asp:LinkButton>
            <asp:LinkButton ID="btnQuitarCategoria" OnClick="btnQuitarCategoria_Click" runat="server" CssClass="chip-filtro" ToolTip="Quitar este filtro"></asp:LinkButton>
        </asp:Panel>
        <asp:Label ID="lblCantidad" runat="server" CssClass="ms-auto small text-secondary"></asp:Label>
    </div>
    <!-- Aviso de confirmación o error de stock al agregar desde el catálogo -->
    <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

    <%-- 2 por fila en el celular hasta 6 en pantallas grandes, el mb-5 deja espacio con el footer --%>
    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 row-cols-xl-5 row-cols-xxl-6 g-3 mb-5">
        <asp:Repeater runat="server" ID="repProductos">
            <ItemTemplate>
                <div class="col">
                    <%-- position-relative hace que el link del nombre cubra toda la tarjeta --%>
                    <div class='card-tienda h-100 d-flex flex-column position-relative <%# ClaseStock(Eval("Stock")) %>'>
                        <%-- si el link de la foto esta roto el navegador muestra la imagen generica, el onerror null es para que no se quede probando para siempre --%>
                        <img class="img-card-producto" src='<%# Eval("ImagenUrl") %>' alt='<%# Eval("Nombre") %>' onerror="this.onerror=null; this.src='<%# ResolveUrl("~/Imagenes/sin-imagen.svg") %>';" />
                        <div class="p-3 d-flex flex-column flex-grow-1">
                            <div>
                                <span class="codigo-producto"><%# Eval("Codigo") ?? "N/A" %></span>
                            </div>
                            <a href='DetalleProducto.aspx?id=<%# Eval("Id") %>' class="stretched-link text-decoration-none">
                                <h6 class="titulo-card-producto mt-2 mb-1"><%# Eval("Nombre") %></h6>
                            </a>
                            <div class="precio-card"><%# Eval("PrecioVenta", "{0:C}") %></div>
                            <div class='texto-stock <%# ClaseStock(Eval("Stock")) %>'><%# TextoStock(Eval("Stock")) %></div>
                            <%-- el z-index deja el boton por encima del link de la tarjeta, si no el clic iria al detalle --%>
                            <div class="mt-auto pt-3 position-relative" style="z-index: 2;">
                                <asp:LinkButton ID="btnAgregarCarrito" runat="server" CssClass="btn btn-ecommerce-primario w-100 text-nowrap" CommandArgument='<%# Eval("Id") %>' Enabled='<%# HayStock(Eval("Stock")) %>' OnClick="btnAgregarCarrito_Click"><i class="bi bi-cart-plus me-1"></i>Agregar</asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:Label ID="lblSinProductos" runat="server" CssClass="d-block mt-4 text-secondary" Visible="false">No hay productos disponibles por el momento.</asp:Label>
</asp:Content>
