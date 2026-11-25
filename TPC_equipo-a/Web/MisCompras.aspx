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
                        <asp:Label ID="lblBajada" runat="server" CssClass="small text-secondary d-block" Text="Todos tus pedidos en un solo lugar. Podés filtrarlos por fecha o por estado." />
                    </div>
                    <a href="Default.aspx" class="btn btn-tienda-secundario text-nowrap d-none d-md-inline-block"><i class="bi bi-bag me-1"></i>Seguir comprando</a>
                </div>
                <%-- sin compras no hay nada que filtrar, asi que se esconde --%>
                <asp:Panel ID="pnlFiltroFechas" runat="server">
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
                </asp:Panel>
            </div>
            <%-- pestañas por estado, el numero respeta el filtro de fechas --%>
            <asp:Panel ID="pnlPestanas" runat="server" CssClass="pestanas-compras">
                <asp:LinkButton ID="btnTodos" runat="server" CommandArgument="todos" OnClick="btnPestana_Click" ValidationGroup="fechas" />
                <asp:LinkButton ID="btnEnCurso" runat="server" CommandArgument="encurso" OnClick="btnPestana_Click" ValidationGroup="fechas" />
                <asp:LinkButton ID="btnEntregados" runat="server" CommandArgument="entregados" OnClick="btnPestana_Click" ValidationGroup="fechas" />
                <asp:LinkButton ID="btnCancelados" runat="server" CommandArgument="cancelados" OnClick="btnPestana_Click" ValidationGroup="fechas" />
            </asp:Panel>

            <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>

            <%-- titulos de las columnas, solo en la compu --%>
            <asp:Panel ID="pnlEncabezado" runat="server" CssClass="encabezado-pedidos d-none d-lg-block">
                <div class="row g-2">
                    <div class="col-lg-2">Pedido</div>
                    <div class="col-lg-3">Productos</div>
                    <div class="col-lg-2">Entrega y pago</div>
                    <div class="col-lg-2 text-end">Total</div>
                    <div class="col-lg-2 ps-lg-4">Estado</div>
                </div>
            </asp:Panel>

            <%-- en el celu cada pedido es una card, en la compu una fila con columnas --%>
            <asp:Repeater ID="rptPedidos" runat="server" OnItemCreated="rptPedidos_ItemCreated">
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
                                    <%-- avisa sin abrir el pedido que tiene que mandar el comprobante --%>
                                    <asp:Label ID="lblChipFalta" runat="server" CssClass="chip-comprobante" Text="Falta el comprobante" Visible='<%# CasoComprobante(Container.DataItem) == "pagar" %>' />
                                    <asp:Label ID="lblChipRechazado" runat="server" CssClass="chip-comprobante chip-rechazado" Text="Comprobante rechazado" Visible='<%# CasoComprobante(Container.DataItem) == "rechazado" %>' />
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
                                    <i class="bi bi-chevron-down flecha-pedido ms-2 d-lg-none"></i>
                                </div>
                                <div class="d-none d-lg-block col-lg-1 order-lg-last text-end">
                                    <i class="bi bi-chevron-down flecha-pedido"></i>
                                </div>
                            </div>
                        </a>
                        <%-- detalle que se abre al tocar la fila, el id es el mismo que el href del link --%>
                        <div class="collapse" id='pedido-<%# Eval("Id") %>'>
                            <div class="detalle-pedido">
                                <div class="row g-4">
                                    <div class="col-12 col-lg-7">
                                        <div class="titulo-campo">Productos</div>
                                        <asp:Repeater ID="rptItems" runat="server" DataSource='<%# Eval("Items") %>'>
                                            <ItemTemplate>
                                                <div class="item-detalle">
                                                    <img class="mini-producto" src='<%# ImagenProducto(Eval("Producto.ImagenUrl")) %>' alt='<%# Eval("Producto.Nombre") %>' onerror="this.onerror=null; this.src='<%# ResolveUrl("~/Imagenes/sin-imagen.svg") %>';" />
                                                    <div class="flex-grow-1">
                                                        <div class="nombre-item"><%# Eval("Producto.Nombre") %></div>
                                                        <div class="dato-chico"><%# Eval("Cantidad") %> x <%# Eval("PrecioUnitario", "{0:C}") %></div>
                                                    </div>
                                                    <div class="subtotal-item"><%# Subtotal(Eval("Cantidad"), Eval("PrecioUnitario")) %></div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                        <div class="total-detalle">
                                            <span>Total</span>
                                            <span class="total-pedido"><%# Eval("Total", "{0:C}") %></span>
                                        </div>
                                    </div>
                                    <div class="col-12 col-lg-5">
                                        <div class="titulo-campo">Entrega</div>
                                        <div><%# Eval("FormaEntrega.Descripcion") %></div>
                                        <div class="dato-chico"><%# TextoDireccion(Eval("Direccion")) %></div>
                                        <div class="titulo-campo mt-3">Pago</div>
                                        <div><%# Eval("FormaPago.Descripcion") %></div>
                                    </div>
                                    <%-- comprobante de la transferencia segun el caso que dice CasoComprobante --%>
                                    <asp:Panel ID="pnlComprobante" runat="server" CssClass="col-12" Visible='<%# CasoComprobante(Container.DataItem) != "" %>'>
                                        <div class="titulo-campo">Comprobante</div>

                                        <%-- se lo rechazaron y tiene que mandar otro --%>
                                        <asp:Panel ID="pnlRechazado" runat="server" CssClass="aviso-comprobante aviso-rechazado" Visible='<%# CasoComprobante(Container.DataItem) == "rechazado" %>'>
                                            <div class="fw-semibold">La tienda rechazó tu comprobante</div>
                                            <div>Motivo: <%#: Eval("MotivoRechazoComprobante") %></div>
                                            <div>Revisalo y mandá uno nuevo.</div>
                                        </asp:Panel>

                                        <%-- los datos para transferir y para subir el comprobante solo cuando todavia tiene que pagar --%>
                                        <%-- en la compu van uno al lado del otro y en el celu uno abajo del otro --%>
                                        <asp:Panel ID="pnlDatosTransferencia" runat="server" CssClass="row g-3" Visible='<%# CasoComprobante(Container.DataItem) == "pagar" || CasoComprobante(Container.DataItem) == "rechazado" %>'>
                                            <div class="col-12 col-md-6">
                                                <div class="datos-transferencia">
                                                    <div class="mb-2">Transferí <span class="fw-semibold"><%# Eval("Total", "{0:C}") %></span> a esta cuenta</div>
                                                    <div class="dato-cuenta"><span class="dato-chico">Alias</span><span class="fw-semibold"><%# DatoTransferencia("TransferenciaAlias") %></span></div>
                                                    <div class="dato-cuenta"><span class="dato-chico">CBU</span><span class="fw-semibold"><%# DatoTransferencia("TransferenciaCbu") %></span></div>
                                                    <div class="dato-cuenta"><span class="dato-chico">Titular</span><span><%# DatoTransferencia("TransferenciaTitular") %></span></div>
                                                    <div class="dato-cuenta"><span class="dato-chico">Banco</span><span><%# DatoTransferencia("TransferenciaBanco") %></span></div>
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-6">
                                                <%-- el archivo solo viaja al tocar enviar asi que si se equivoco elige otro y listo --%>
                                                <div class="subir-comprobante">
                                                    <div class="titulo-campo">Subí el comprobante</div>
                                                    <input type="file" id="fuComprobante" runat="server" accept=".jpg,.jpeg,.png,.pdf" class="form-control mw-100" />
                                                    <div class="dato-chico mt-1">JPG, PNG o PDF de hasta 5 MB</div>
                                                    <div class="dato-chico mt-2">Revisá que sea el comprobante correcto. Una vez enviado la tienda lo revisa y no lo vas a poder cambiar hasta que te respondan.</div>
                                                    <asp:Button ID="btnEnviarComprobante" runat="server" Text="Enviar comprobante" CssClass="btn btn-ecommerce-primario w-100 mw-100 mt-2" CommandArgument='<%# Eval("Id") %>' OnClick="btnEnviarComprobante_Click" />
                                                </div>
                                            </div>
                                        </asp:Panel>

                                        <%-- ya mando el comprobante y espera la respuesta de la tienda --%>
                                        <asp:Panel ID="pnlRevision" runat="server" CssClass="aviso-comprobante" Visible='<%# CasoComprobante(Container.DataItem) == "revision" %>'>
                                            <div class="fw-semibold">Recibimos tu comprobante</div>
                                            <div>La tienda lo está revisando. Cuando lo confirme tu pedido pasa a Pagado.</div>
                                            <asp:HyperLink ID="lnkVerRevision" runat="server" NavigateUrl='<%# Eval("ComprobanteUrl") %>' Target="_blank" CssClass="link-comprobante" Text="Ver el que mandaste" />
                                        </asp:Panel>

                                        <%-- ya pago y la tienda lo confirmo --%>
                                        <asp:Panel ID="pnlConfirmado" runat="server" CssClass="aviso-comprobante aviso-confirmado" Visible='<%# CasoComprobante(Container.DataItem) == "confirmado" %>'>
                                            <div class="fw-semibold">Pago confirmado</div>
                                            <asp:HyperLink ID="lnkVerConfirmado" runat="server" NavigateUrl='<%# Eval("ComprobanteUrl") %>' Target="_blank" CssClass="link-comprobante" Text="Ver comprobante" Visible='<%# Eval("ComprobanteUrl") != null %>' />
                                        </asp:Panel>

                                        <%-- se cancelo despues de que pago asi que le toca la devolucion --%>
                                        <asp:Panel ID="pnlDevolucion" runat="server" CssClass="aviso-comprobante" Visible='<%# CasoComprobante(Container.DataItem) == "devolucion" %>'>
                                            <div class="fw-semibold">Este pedido se canceló después de que pagaste</div>
                                            <div>La tienda se va a comunicar con vos para devolverte la plata.</div>
                                        </asp:Panel>
                                    </asp:Panel>
                                </div>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <%-- cuando el cliente todavia no compro nada --%>
            <asp:Panel ID="pnlSinCompras" runat="server" Visible="false" CssClass="sin-resultados text-center mb-5">
                <i class="bi bi-bag icono-sin-resultados"></i>
                <p class="titulo-sin-resultados mt-3 mb-1">Todavía no hiciste ninguna compra</p>
                <p class="small text-secondary mb-3">Cuando compres algo lo vas a ver acá con su estado</p>
                <a href="Default.aspx" class="btn btn-ecommerce-primario">Ir al catálogo</a>
            </asp:Panel>
            <%-- cuando el filtro o la pestaña no traen nada, limpiar usa el mismo evento que la x del filtro --%>
            <asp:Panel ID="pnlSinResultados" runat="server" Visible="false" CssClass="sin-resultados text-center mb-5">
                <i class="bi bi-search icono-sin-resultados"></i>
                <p class="titulo-sin-resultados mt-3 mb-3">
                    <asp:Label ID="lblSinResultados" runat="server" />
                </p>
                <asp:LinkButton ID="btnLimpiarSinResultados" runat="server" CssClass="btn btn-tienda-secundario" CausesValidation="false" OnClick="btnLimpiar_Click"><i class="bi bi-x-lg me-1"></i>Limpiar filtro</asp:LinkButton>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
