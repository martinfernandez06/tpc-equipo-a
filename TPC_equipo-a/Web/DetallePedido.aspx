<%@ Page Title="Detalle Pedido" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="DetallePedido.aspx.cs" Inherits="Web.DetallePedido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
        <h1 class="h3 m-0 me-auto">Detalle del pedido</h1>
        <a href="AdminPedidos.aspx" class="btn btn-sm btn-outline-secondary">Volver</a>
    </div>

    <%-- datos generales, el texto en negrita es fijo --%>
    <div class="card mb-4">
        <div class="card-body">
            <p>
                <strong>Numero de pedido:</strong>
                <asp:Label ID="lblNumero" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Fecha:</strong>
                <asp:Label ID="lblFecha" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Cliente:</strong>
                <asp:Label ID="lblCliente" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Estado:</strong>
                <asp:Label ID="lblEstado" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Forma de pago:</strong>
                <asp:Label ID="lblFormaPago" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Forma de entrega:</strong>
                <asp:Label ID="lblFormaEntrega" runat="server"></asp:Label>
            </p>
            <p>
                <strong>Codigo de seguimiento:</strong>
                <asp:Label ID="lblCodigoSeguimiento" runat="server"></asp:Label>
            </p>
            <p class="mb-0">
                <strong>Total:</strong>
                <asp:Label ID="lblTotal" runat="server"></asp:Label>
            </p>
        </div>
    </div>
    <div class="card mb-4">
        <div class="card-body">
            <h5>Acciones</h5>
            <asp:DropDownList ID="ddlEstado" CssClass="form-select" runat="server">
                <asp:ListItem Text="Pagado" Value="2"></asp:ListItem>
                <asp:ListItem Text="En preparación" Value="3"></asp:ListItem>
                <asp:ListItem Text="Enviado" Value="4"></asp:ListItem>
                <asp:ListItem Text="Entregado" Value="5"></asp:ListItem>
            </asp:DropDownList>
            <asp:Button ID="btnCambiarEstado" runat="server" Text="Cambiar estado" CssClass="btn btn-primary mt-2" ValidationGroup="estado" OnClick="btnCambiarEstado_Click" />
            <asp:Label ID="lblMensaje" runat="server" Text="" CssClass="d-block mt-2"></asp:Label>
        </div>
    </div>
        <h5>Productos</h5>
    <asp:GridView ID="dgvItems" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle">
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
    <asp:GridView ID="dgvHistorial" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle">
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
    <asp:GridView ID="dgvObservaciones" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle" EmptyDataText="Todavia no hay observaciones">
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

    <asp:TextBox ID="txtObservacion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
    <%-- los validadores y el boton van en el mismo grupo para que no se mezclen con los otros botones de la pagina --%>
    <div>
        <asp:RequiredFieldValidator ID="rfvObservacion" runat="server" ControlToValidate="txtObservacion" ErrorMessage="Escribi una observacion" Display="Dynamic" CssClass="text-danger" ValidationGroup="observacion" />
    </div>
    <div>
        <asp:RegularExpressionValidator ID="revObservacion" runat="server" ControlToValidate="txtObservacion" ValidationExpression="^[\s\S]{5,500}$" ErrorMessage="La observacion debe tener entre 5 y 500 caracteres" Display="Dynamic" CssClass="text-danger" ValidationGroup="observacion" />
    </div>
    <asp:Button ID="btnAgregarObservacion" runat="server" Text="Agregar observacion" CssClass="btn btn-primary mt-2" ValidationGroup="observacion" OnClick="btnAgregarObservacion_Click" />
</asp:Content>
