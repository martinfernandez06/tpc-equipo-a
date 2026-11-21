<%@ Page Title="Mis Compras" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MisCompras.aspx.cs" Inherits="Web.MisCompras" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%-- el updatepanel recarga solo esta parte al filtrar --%>
    <asp:UpdatePanel ID="upMisCompras" runat="server">
        <ContentTemplate>
            <%-- misma franja lila que el filtro del catalogo --%>
            <div class="filtro-catalogo">
                <div class="d-flex flex-wrap align-items-start justify-content-between gap-2 mb-3">
                    <div>
                        <h1 class="titulo-detalle mb-1">Mis compras</h1>
                        <p class="small text-secondary mb-0">Todos tus pedidos en un solo lugar. Podés filtrarlos por fecha o por estado.</p>
                    </div>
                    <a href="Default.aspx" class="btn btn-tienda-secundario text-nowrap d-none d-md-inline-block"><i class="bi bi-bag me-1"></i>Seguir comprando</a>
                </div>
                <div class="row g-2 align-items-end">
                    <div class="col-6 col-md-3">
                        <div class="titulo-campo">Desde</div>
                        <asp:TextBox ID="txtDesde" runat="server" TextMode="Date" CssClass="form-control input-tienda" />
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="titulo-campo">Hasta</div>
                        <asp:TextBox ID="txtHasta" runat="server" TextMode="Date" CssClass="form-control input-tienda" />
                    </div>
                    <div class="col-12 col-md-auto d-flex gap-2">
                        <asp:Button ID="btnFiltrar" OnClick="btnFiltrar_Click" runat="server" Text="Filtrar" CssClass="btn btn-ecommerce-primario flex-grow-1 mw-100" ValidationGroup="fechas" />
                        <%-- causesvalidation false asi limpiar anda aunque las fechas esten mal --%>
                        <asp:LinkButton ID="btnLimpiar" OnClick="btnLimpiar_Click" runat="server" CssClass="btn btn-tienda-secundario text-nowrap" CausesValidation="false" ToolTip="Limpiar filtro"><i class="bi bi-x-lg"></i><span class="d-none d-lg-inline ms-1">Limpiar</span></asp:LinkButton>
                    </div>
                </div>
                <div class="mt-2">
                    <asp:CompareValidator ID="cvFechas" runat="server" ControlToValidate="txtHasta" ControlToCompare="txtDesde" Operator="GreaterThanEqual" Type="Date" ErrorMessage="La fecha hasta no puede ser anterior a la desde" ValidationGroup="fechas" Display="Dynamic" CssClass="text-danger small" />
                    <%-- comparan contra la fecha de hoy que se carga en el page_load --%>
                    <asp:CompareValidator ID="cvDesdeHoy" runat="server" ControlToValidate="txtDesde" Operator="LessThanEqual" Type="Date" ErrorMessage="La fecha desde no puede ser posterior a hoy" ValidationGroup="fechas" Display="Dynamic" CssClass="text-danger small" />
                    <asp:CompareValidator ID="cvHastaHoy" runat="server" ControlToValidate="txtHasta" Operator="LessThanEqual" Type="Date" ErrorMessage="La fecha hasta no puede ser posterior a hoy" ValidationGroup="fechas" Display="Dynamic" CssClass="text-danger small" />
                </div>
            </div>
            <%-- pestañas por estado, el numero respeta el filtro de fechas --%>
            <div class="pestanas-compras">
                <asp:LinkButton ID="btnTodos" runat="server" CommandArgument="todos" OnClick="btnPestana_Click" ValidationGroup="fechas" />
                <asp:LinkButton ID="btnEnCurso" runat="server" CommandArgument="encurso" OnClick="btnPestana_Click" ValidationGroup="fechas" />
                <asp:LinkButton ID="btnEntregados" runat="server" CommandArgument="entregados" OnClick="btnPestana_Click" ValidationGroup="fechas" />
                <asp:LinkButton ID="btnCancelados" runat="server" CommandArgument="cancelados" OnClick="btnPestana_Click" ValidationGroup="fechas" />
            </div>

            <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

            <%-- titulos de las columnas, solo en la compu --%>
            <div class="encabezado-pedidos d-none d-lg-block">
                <div class="row g-2">
                    <div class="col-lg-2">Pedido</div>
                    <div class="col-lg-3">Productos</div>
                    <div class="col-lg-2">Entrega y pago</div>
                    <div class="col-lg-2 text-end">Total</div>
                    <div class="col-lg-2 ps-lg-4">Estado</div>
                </div>
            </div>

            <%-- en el celu cada pedido es una card, en la compu una fila con columnas --%>
            <asp:Repeater ID="rptPedidos" runat="server">
                <ItemTemplate>
                    <div class='pedido-compra estado-<%# Eval("Estado.Id") %>'>
                        <a class="fila-pedido" data-bs-toggle="collapse" href='#pedido-<%# Eval("Id") %>'>
                            <div class="row g-2 align-items-center">
                                <div class="col-6 col-lg-2 order-lg-1">
                                    <div class="numero-pedido">Pedido #<%# Eval("Id") %></div>
                                    <div class="dato-chico"><%# Eval("FechaCreacion", "{0:dd/MM/yyyy}") %></div>
                                </div>
                                <div class="col-6 col-lg-2 order-lg-5 text-end text-lg-start ps-lg-4">
                                    <span class='<%# ClaseEstado(Eval("Estado.Id")) %>'><%# Eval("Estado.Descripcion") %></span>
                                </div>
                                <div class="col-12 col-lg-3 order-lg-2 d-flex align-items-center gap-2">
                                    <%-- repeater adentro del otro, hasta 3 fotitos por pedido --%>
                                    <asp:Repeater ID="rptMiniaturas" runat="server" DataSource='<%# Miniaturas(Eval("Items")) %>'>
                                        <ItemTemplate>
                                            <img class="mini-producto" src='<%# ImagenProducto(Eval("Producto.ImagenUrl")) %>' alt='<%# Eval("Producto.Nombre") %>' onerror="this.onerror=null; this.src='<%# ResolveUrl("~/Imagenes/sin-imagen.svg") %>';" />
                                        </ItemTemplate>
                                    </asp:Repeater>
                                    <span class="dato-chico text-truncate"><%# ResumenProductos(Eval("Items")) %></span>
                                </div>
                                <div class="col-7 col-lg-2 order-lg-3 dato-chico">
                                    <%# Eval("FormaEntrega.Descripcion") %><br />
                                    <%# Eval("FormaPago.Descripcion") %>
                                </div>
                                <div class="col-5 col-lg-2 order-lg-4 text-end">
                                    <span class="total-pedido"><%# Eval("Total", "{0:C}") %></span>
                                </div>
                                <div class="d-none d-lg-block col-lg-1 order-lg-last text-end">
                                    <i class="bi bi-chevron-down flecha-pedido"></i>
                                </div>
                            </div>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
