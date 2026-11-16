<%@ Page Title="Detalle Pedido" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="DetallePedido.aspx.cs" Inherits="Web.DetallePedido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
        <h1 class="h3 m-0 me-auto">Detalle del pedido</h1>
        <a href="AdminPedidos.aspx" class="btn btn-sm btn-admin-secundario"><i class="bi bi-arrow-left"></i>Volver</a>
    </div>

    <%-- datos generales en grilla, el titulo chico es fijo y el label lo llena el code behind --%>
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
                    <div class="dato-titulo">Codigo de seguimiento</div>
                    <asp:Label ID="lblCodigoSeguimiento" runat="server"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <%-- el panel envuelve la card para ocultarla entera cuando el pedido esta entregado o cancelado --%>
    <asp:Panel ID="pnlAcciones" runat="server">
        <div class="card card-admin mb-4">
            <div class="card-header">Acciones</div>
            <div class="card-body d-flex flex-wrap align-items-center gap-2">
                <%-- las opciones se cargan desde el code behind segun el estado actual --%>
                <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select input-admin w-auto"></asp:DropDownList>
                <asp:Button ID="btnCambiarEstado" runat="server" Text="Cambiar estado" CssClass="btn btn-ecommerce-primario" ValidationGroup="estado" OnClick="btnCambiarEstado_Click" />
                <%-- el confirm pide confirmacion en el navegador antes de cancelar --%>
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar pedido" CssClass="btn btn-admin-peligro ms-auto" ValidationGroup="cancelar" OnClientClick="return confirm('Seguro que queres cancelar el pedido? Las unidades vuelven al stock');" OnClick="btnCancelar_Click" />
            </div>
        </div>
    </asp:Panel>
    <%-- el mensaje va afuera del panel para que se siga viendo cuando la card se oculta --%>
    <asp:Label ID="lblMensaje" runat="server" CssClass="d-block my-2"></asp:Label>

    <h5>Productos</h5>
    <asp:GridView ID="dgvItems" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle tabla-admin">
        <Columns>
            <asp:TemplateField HeaderText="Nombre">
                <ItemTemplate>
                    <%-- el src va con comillas simples porque adentro el eval usa dobles --%>
                    <img src='<%# Eval("Producto.ImagenUrl") %>' alt="" class="me-2 rounded" style="width: 50px; height: 50px; object-fit: cover;" />
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
                    <%# Eval("Usuario.Id") %>
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
                    <%# Eval("Usuario.Id") %>
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
</asp:Content>
