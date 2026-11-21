<%@ Page Title="Detalle Pedido" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="DetallePedido.aspx.cs" Inherits="Web.DetallePedido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upDetalle" runat="server">
        <ContentTemplate>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                <h1 class="h3 m-0 me-auto">Detalle del pedido</h1>
                <a href="AdminPedidos.aspx" class="btn btn-sm btn-admin-secundario"><i class="bi bi-arrow-left"></i>Volver</a>
            </div>

            <%-- datos generales en grilla, el titulo chico es fijo y el label se llena al cargar el pedido --%>
            <div class="card card-admin mb-4">
                <div class="card-header d-flex align-items-center gap-2">
                    <span>Pedido #<asp:Label ID="lblNumero" runat="server"></asp:Label></span>
                    <asp:Label ID="lblEstado" runat="server"></asp:Label>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Fecha</div>
                            <asp:Label ID="lblFecha" runat="server"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Cliente</div>
                            <asp:Label ID="lblCliente" runat="server"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Email</div>
                            <asp:Label ID="lblEmail" runat="server"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Telefono</div>
                            <asp:Label ID="lblTelefono" runat="server"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Total</div>
                            <asp:Label ID="lblTotal" runat="server" CssClass="fw-bold"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Forma de pago</div>
                            <asp:Label ID="lblFormaPago" runat="server"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Forma de entrega</div>
                            <asp:Label ID="lblFormaEntrega" runat="server"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Direccion de envio</div>
                            <asp:Label ID="lblDireccion" runat="server"></asp:Label>
                        </div>
                        <div class="col-sm-6 col-lg-4">
                            <div class="dato-titulo">Envio</div>
                            <asp:Label ID="lblEmpresaEnvio" runat="server"></asp:Label>
                            <asp:Label ID="lblCodigoSeguimiento" CssClass="d-block" runat="server"></asp:Label>
                            <asp:HyperLink ID="hlSeguimiento" Text="Ver seguimiento" Target="_blank" runat="server" Visible="false"></asp:HyperLink>
                        </div>
                    </div>
                </div>
            </div>

            <%-- el panel envuelve la card para ocultarla entera cuando el pedido esta entregado o cancelado --%>
            <asp:Panel ID="pnlAcciones" runat="server">
                <div class="card card-admin mb-4">
                    <div class="card-header">Acciones</div>
                    <asp:Panel ID="pnlBotones" runat="server" CssClass="card-body d-flex flex-wrap align-items-center gap-2">
                        <%-- reemplaza al desplegable cuando el pedido es por transferencia y sigue sin pagar --%>
                        <asp:Panel ID="pnlAvisoComprobante" runat="server" Visible="false" CssClass="text-secondary">
                            <i class="bi bi-info-circle me-1"></i>Este pedido se paga con transferencia, pasa a Pagado aceptando el comprobante en la
                            <a runat="server" href="~/AdminComprobantes">bandeja de comprobantes</a>.
                        </asp:Panel>
                        <%-- las opciones se cargan segun el estado actual del pedido --%>
                        <asp:DropDownList ID="ddlEstado" AutoPostBack="true" runat="server" CssClass="form-select input-admin w-auto" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged"></asp:DropDownList>
                        <%-- solo aparece cuando eligen enviado, con quien se manda es obligatorio y el codigo no --%>
                        <asp:Panel ID="pnlEnvio" runat="server" Visible="false" CssClass="d-flex flex-wrap align-items-center gap-2">
                            <asp:DropDownList ID="ddlEmpresaEnvio" runat="server" CssClass="form-select input-admin w-auto">
                                <asp:ListItem Text="Elegí con quién se envía" Value=""></asp:ListItem>
                                <asp:ListItem Text="Correo Argentino" Value="Correo Argentino"></asp:ListItem>
                                <asp:ListItem Text="Andreani" Value="Andreani"></asp:ListItem>
                                <asp:ListItem Text="Moto o Uber" Value="Moto o Uber"></asp:ListItem>
                                <asp:ListItem Text="Envío propio" Value="Envío propio"></asp:ListItem>
                                <asp:ListItem Text="Otro" Value="Otro"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtCodigoSeguimiento" runat="server" CssClass="form-control input-admin w-auto" MaxLength="255" placeholder="Código o link de seguimiento (opcional)"></asp:TextBox>
                            <div>
                                <asp:RequiredFieldValidator ID="rfvEmpresaEnvio" runat="server" ControlToValidate="ddlEmpresaEnvio" InitialValue="" ErrorMessage="Elegí con quién se envía" Display="Dynamic" CssClass="text-danger" ValidationGroup="estado" />
                            </div>
                            <div>
                                <asp:RegularExpressionValidator ID="revCodigoSeguimiento" runat="server" ControlToValidate="txtCodigoSeguimiento" ValidationExpression="^\s*\S+\s*$" ErrorMessage="El codigo no puede tener espacios en el medio" Display="Dynamic" CssClass="text-danger" ValidationGroup="estado" />
                            </div>
                        </asp:Panel>
                        <asp:Button ID="btnCambiarEstado" runat="server" Text="Cambiar estado" CssClass="btn btn-ecommerce-primario" ValidationGroup="estado" OnClick="btnCambiarEstado_Click" />
                        <div>
                            <asp:RequiredFieldValidator ID="rfvEstado" runat="server" ControlToValidate="ddlEstado" InitialValue="" ErrorMessage="Elegí el nuevo estado" Display="Dynamic" CssClass="text-danger" ValidationGroup="estado" />
                        </div>
                        <asp:Button ID="btnCancelar" runat="server" Text="Cancelar pedido" CssClass="btn btn-admin-peligro ms-auto" ValidationGroup="cancelar" OnClick="btnCancelar_Click" />
                    </asp:Panel>
                    <%-- solo aparece con el pedido enviado, para corregir con quien se mando o cargar el codigo despues --%>
                    <asp:Panel ID="pnlSeguimiento" runat="server" Visible="false" CssClass="card-body border-top">
                        <div class="dato-titulo mb-2">Seguimiento del envio</div>
                        <div class="d-flex flex-wrap align-items-center gap-2">
                            <asp:DropDownList ID="ddlEditarEmpresa" runat="server" CssClass="form-select input-admin w-auto">
                                <asp:ListItem Text="Elegí con quién se envía" Value=""></asp:ListItem>
                                <asp:ListItem Text="Correo Argentino" Value="Correo Argentino"></asp:ListItem>
                                <asp:ListItem Text="Andreani" Value="Andreani"></asp:ListItem>
                                <asp:ListItem Text="Moto o Uber" Value="Moto o Uber"></asp:ListItem>
                                <asp:ListItem Text="Envío propio" Value="Envío propio"></asp:ListItem>
                                <asp:ListItem Text="Otro" Value="Otro"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtEditarCodigo" runat="server" CssClass="form-control input-admin w-auto" MaxLength="255" placeholder="Código o link de seguimiento (opcional)"></asp:TextBox>
                            <asp:Button ID="btnGuardarSeguimiento" runat="server" Text="Guardar seguimiento" CssClass="btn btn-ecommerce-primario" ValidationGroup="seguimiento" OnClick="btnGuardarSeguimiento_Click" />
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvEditarEmpresa" runat="server" ControlToValidate="ddlEditarEmpresa" InitialValue="" ErrorMessage="Elegí con quién se envía" Display="Dynamic" CssClass="text-danger" ValidationGroup="seguimiento" />
                        </div>
                        <div>
                            <asp:RegularExpressionValidator ID="revEditarCodigo" runat="server" ControlToValidate="txtEditarCodigo" ValidationExpression="^\s*\S+\s*$" ErrorMessage="El codigo no puede tener espacios en el medio" Display="Dynamic" CssClass="text-danger" ValidationGroup="seguimiento" />
                        </div>
                    </asp:Panel>
                    <%-- aparece antes de marcarlo entregado, porque despues no se puede volver atras --%>
                    <asp:Panel ID="pnlConfirmarEntregado" runat="server" Visible="false" CssClass="card-body border-top border-danger">
                        <p class="mb-2">¿Seguro que querés marcar el pedido como entregado? Después no se puede cambiar.</p>
                        <asp:Button ID="btnSiEntregado" runat="server" Text="Sí, marcar entregado" CssClass="btn btn-admin-peligro" CausesValidation="false" OnClick="btnSiEntregado_Click" />
                        <asp:Button ID="btnNoEntregado" runat="server" Text="No, volver" CssClass="btn btn-admin-secundario" CausesValidation="false" OnClick="btnNoConfirmar_Click" />
                    </asp:Panel>
                    <%-- aparece antes de cancelar, el texto cambia si el pedido ya estaba pagado --%>
                    <asp:Panel ID="pnlConfirmarCancelar" runat="server" Visible="false" CssClass="card-body border-top border-danger">
                        <asp:Label ID="lblConfirmarCancelar" runat="server" CssClass="d-block mb-2"></asp:Label>
                        <asp:Button ID="btnSiCancelar" runat="server" Text="Sí, cancelar pedido" CssClass="btn btn-admin-peligro" CausesValidation="false" OnClick="btnSiCancelar_Click" />
                        <asp:Button ID="btnNoCancelar" runat="server" Text="No, volver" CssClass="btn btn-admin-secundario" CausesValidation="false" OnClick="btnNoConfirmar_Click" />
                    </asp:Panel>
                </div>
            </asp:Panel>
            <%-- el mensaje va afuera del panel para que se siga viendo cuando la card se oculta --%>
            <asp:Label ID="lblMensaje" runat="server" CssClass="d-block my-2"></asp:Label>

            <h5>Productos</h5>
            <asp:GridView ID="dgvItems" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle tabla-admin">
                <Columns>
                    <asp:TemplateField HeaderText="Nombre">
                        <ItemTemplate>
                            <%-- el src va con comillas simples porque adentro el eval usa dobles, si el link de la foto esta roto muestra la imagen generica --%>
                            <img src='<%# Eval("Producto.ImagenUrl") %>' alt="" class="me-2 rounded" style="width: 50px; height: 50px; object-fit: cover;" onerror="this.onerror=null; this.src='<%# ResolveUrl("~/Imagenes/sin-imagen.svg") %>';" />
                            <%# Eval("Producto.Nombre") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Cantidad" DataField="Cantidad" />
                    <asp:BoundField HeaderText="Precio unitario" DataField="PrecioUnitario" DataFormatString="{0:C}" />
                    <asp:BoundField HeaderText="Subtotal" DataField="Subtotal" DataFormatString="{0:C}" />
                </Columns>
            </asp:GridView>

            <h5>Historial de estados</h5>
            <asp:GridView ID="dgvHistorial" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle tabla-admin">
                <Columns>
                    <asp:BoundField HeaderText="Fecha" DataField="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <%-- claseestado devuelve el color del badge segun el estado --%>
                            <span class='<%# ClaseEstado(Eval("Estado.Descripcion")) %>'><%# Eval("Estado.Descripcion") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Usuario">
                        <ItemTemplate>
                            <%# Eval("Usuario.Nombre") %>
                            <%# Eval("Usuario.Apellido") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <h5>Observaciones</h5>
            <asp:GridView ID="dgvObservaciones" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle tabla-admin" EmptyDataText="Todavia no hay observaciones">
                <Columns>
                    <asp:BoundField HeaderText="Fecha" DataField="Fecha" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                    <asp:TemplateField HeaderText="Usuario">
                        <ItemTemplate>
                            <%# Eval("Usuario.Nombre") %>
                            <%# Eval("Usuario.Apellido") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField HeaderText="Observacion" DataField="Observacion" />
                </Columns>
            </asp:GridView>

            <div class="card card-admin mb-4">
                <div class="card-header">Agregar observacion</div>
                <div class="card-body">
                    <asp:TextBox ID="txtObservacion" runat="server" CssClass="form-control input-admin" TextMode="MultiLine" Rows="3" placeholder="Ej: el cliente pidio que lo dejen en porteria"></asp:TextBox>
                    <%-- los validadores y el boton van en el mismo grupo para que no se mezclen con los otros botones de la pagina --%>
                    <div>
                        <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ControlToValidate="txtObservacion" ErrorMessage="Escribi una observacion" Display="Dynamic" CssClass="text-danger" ValidationGroup="observacion" />
                    </div>
                    <div>
                        <asp:RegularExpressionValidator ID="revObservacion" runat="server" ControlToValidate="txtObservacion" ValidationExpression="^[\s\S]{5,500}$" ErrorMessage="La observacion debe tener entre 5 y 500 caracteres" Display="Dynamic" CssClass="text-danger" ValidationGroup="observacion" />
                    </div>
                    <div class="d-flex justify-content-end mt-2">
                        <asp:Button ID="btnAgregarObservacion" runat="server" Text="Agregar observacion" CssClass="btn btn-ecommerce-primario" ValidationGroup="observacion" OnClick="btnAgregarObservacion_Click" />
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
