<%@ Page Title="Admin Pedidos" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminPedidos.aspx.cs" Inherits="Web.AdminPedidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upPedidos" runat="server">
        <ContentTemplate>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                <h1 class="h3 m-0 me-auto">Pedidos</h1>
            </div>
            <%-- barra de filtros, cada columna es un filtro y los botones van al final --%>
            <div class="card card-admin mb-3">
                <div class="card-body">
                    <div class="row g-2 align-items-end">
                        <div class="col-md-3">
                            <div class="dato-titulo">Estado</div>
                            <%-- el value de cada estado es su id en la bd, todos va vacio para que no filtre --%>
                            <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="form-select input-admin">
                                <asp:ListItem Text="Todos" Value="" />
                                <asp:ListItem Text="Pendiente de pago" Value="1" />
                                <asp:ListItem Text="Pagado" Value="2" />
                                <asp:ListItem Text="En preparación" Value="3" />
                                <asp:ListItem Text="Enviado" Value="4" />
                                <asp:ListItem Text="Entregado" Value="5" />
                                <asp:ListItem Text="Cancelado" Value="6" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <%-- textmode date muestra un calendario asi no escriben la fecha en cualquier formato --%>
                            <div class="dato-titulo">Desde</div>
                            <asp:TextBox ID="txtDesde" runat="server" TextMode="Date" CssClass="form-control input-admin" />
                        </div>
                        <div class="col-md-2">
                            <div class="dato-titulo">Hasta</div>
                            <asp:TextBox ID="txtHasta" runat="server" TextMode="Date" CssClass="form-control input-admin" />
                        </div>
                        <div class="col-md-3">
                            <div class="dato-titulo">Cliente</div>
                            <%-- maxlength 100 porque el parametro del sp acepta hasta 100 --%>
                            <asp:TextBox ID="txtCliente" runat="server" CssClass="form-control input-admin" placeholder="Nombre, apellido o email" MaxLength="100" />
                        </div>
                        <div class="col-md-auto d-flex gap-2">
                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btn btn-ecommerce-primario" ValidationGroup="filtros" OnClick="btnBuscar_Click" />
                            <%-- causesvalidation apaga los validadores de asp y formnovalidate los del navegador, asi limpiar anda siempre --%>
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-admin-secundario" CausesValidation="false" OnClick="btnLimpiar_Click" formnovalidate="formnovalidate" />
                        </div>
                    </div>
                    <div class="mt-2">
                        <%-- controltocompare compara la fecha hasta contra la desde --%>
                        <div>
                            <asp:CompareValidator ID="cvFechas" runat="server" ControlToValidate="txtHasta" ControlToCompare="txtDesde" Operator="GreaterThanEqual" Type="Date" ErrorMessage="La fecha hasta no puede ser anterior a la desde" ValidationGroup="filtros" Display="Dynamic" CssClass="text-danger small" />
                        </div>
                        <div>
                            <%-- estos dos comparan contra la fecha de hoy que se carga en el page_load --%>
                            <asp:CompareValidator ID="cvDesdeHoy" runat="server" ControlToValidate="txtDesde" Operator="LessThanEqual" Type="Date" ErrorMessage="La fecha desde no puede ser posterior a hoy" ValidationGroup="filtros" Display="Dynamic" CssClass="text-danger small" />
                        </div>
                        <div>
                            <asp:CompareValidator ID="cvHastaHoy" runat="server" ControlToValidate="txtHasta" Operator="LessThanEqual" Type="Date" ErrorMessage="La fecha hasta no puede ser posterior a hoy" ValidationGroup="filtros" Display="Dynamic" CssClass="text-danger small" />
                        </div>
                        <div>
                            <%-- pide 2 letras o mas sin contar espacios de los costados, si queda vacio no se queja porque el filtro es opcional --%>
                            <asp:RegularExpressionValidator ID="revCliente" runat="server" ControlToValidate="txtCliente" ValidationExpression="^\s*\S.*\S\s*$" ErrorMessage="Para buscar por cliente escribí 2 letras o más" ValidationGroup="filtros" Display="Dynamic" CssClass="text-danger small" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="table-responsive">
                <%-- guarda el id de cada fila para saber que pedido eligieron --%>
                <asp:GridView ID="dgvPedidos" DataKeyNames="Id" OnSelectedIndexChanged="dgvPedidos_SelectedIndexChanged" runat="server" CssClass="table table-striped table-bordered align-middle tabla-admin" AutoGenerateColumns="false" EmptyDataText="No hay pedidos con esos filtros" AllowPaging="true" PageSize="10" OnPageIndexChanging="dgvPedidos_PageIndexChanging" PagerStyle-CssClass="paginado-admin">
                    <Columns>
                        <asp:BoundField HeaderText="Id" DataField="Id" />
                        <asp:BoundField HeaderText="Fecha de creacion" DataField="FechaCreacion" />
                        <%-- templatefield con eval para entrar a datos que estan adentro de otro objeto, el boundfield no llega --%>
                        <asp:TemplateField HeaderText="Cliente">
                            <ItemTemplate>
                                <%# Eval("Cliente.Nombre") %>
                                <%# Eval("Cliente.Apellido") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Forma de pago">
                            <ItemTemplate>
                                <%# Eval("FormaPago.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Forma de entrega">
                            <ItemTemplate>
                                <%# Eval("FormaEntrega.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Estado">
                            <ItemTemplate>
                                <%# Eval("Estado.Descripcion") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField HeaderText="Total" DataField="Total" DataFormatString="{0:C}" />
                        <asp:BoundField HeaderText="Codigo de seguimiento" DataField="CodigoSeguimiento" />
                        <asp:BoundField HeaderText="Estado del comprobante" DataField="EstadoComprobante" />
                        <asp:CommandField HeaderText="Accion" ShowSelectButton="true" ButtonType="Button" ControlStyle-CssClass="btn btn-sm btn-ecommerce-primario" SelectText="Ver detalles" />
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
