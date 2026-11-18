<%@ Page Title="Admin Reportes" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminReportes.aspx.cs" Inherits="Web.AdminReportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upReportes" runat="server">
        <ContentTemplate>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                <h1 class="h3 m-0 me-auto">Reportes</h1>
            </div>
            <%-- filtro por fecha, con el mismo violeta de la tarjeta de ventas --%>
            <div class="card filtro-reporte mb-3">
                <div class="card-body">
                    <div class="encabezado-filtro mb-2"><i class="bi bi-calendar-range me-2"></i>Período del reporte</div>
                    <div class="row g-2 align-items-end">
                        <div class="col-md-3">
                            <%-- textmode date muestra un calendario asi no escriben la fecha en cualquier formato --%>
                            <div class="dato-titulo">Desde</div>
                            <asp:TextBox ID="txtDesde" runat="server" TextMode="Date" CssClass="form-control input-admin" />
                        </div>
                        <div class="col-md-3">
                            <div class="dato-titulo">Hasta</div>
                            <asp:TextBox ID="txtHasta" runat="server" TextMode="Date" CssClass="form-control input-admin" />
                        </div>
                        <div class="col-md-auto d-flex gap-2">
                            <%-- linkbutton en vez de button para poder poner el icono adentro --%>
                            <asp:LinkButton ID="btnBuscar" runat="server" CssClass="btn btn-ecommerce-primario" ValidationGroup="filtros" OnClick="btnBuscar_Click"><i class="bi bi-search me-1"></i>Buscar</asp:LinkButton>
                            <asp:LinkButton ID="btnLimpiar" runat="server" CssClass="btn btn-admin-secundario" CausesValidation="false" OnClick="btnLimpiar_Click"><i class="bi bi-x-lg me-1"></i>Limpiar</asp:LinkButton>
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
                    </div>
                </div>
            </div>
            <%-- tres numeros arriba con su color e icono, se llenan al cargar los reportes --%>
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="card tarjeta-reporte tarjeta-ventas h-100">
                        <div class="card-body">
                            <div class="titulo-reporte">Total vendido</div>
                            <asp:Label ID="lblTotalVendido" runat="server" CssClass="numero-reporte"></asp:Label>
                        </div>
                        <i class="bi bi-cash-stack icono-reporte"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card tarjeta-reporte tarjeta-pedidos h-100">
                        <div class="card-body">
                            <div class="titulo-reporte">Pedidos cobrados</div>
                            <asp:Label ID="lblCantidadPedidos" runat="server" CssClass="numero-reporte"></asp:Label>
                        </div>
                        <i class="bi bi-bag-check icono-reporte"></i>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card tarjeta-reporte tarjeta-ticket h-100">
                        <div class="card-body">
                            <div class="titulo-reporte">Ticket promedio</div>
                            <asp:Label ID="lblTicketPromedio" runat="server" CssClass="numero-reporte"></asp:Label>
                        </div>
                        <i class="bi bi-receipt icono-reporte"></i>
                    </div>
                </div>
            </div>

            <div class="row g-4">
                <div class="col-lg-5">
                    <h5>Pedidos por estado</h5>
                    <asp:GridView ID="dgvEstados" ShowFooter="true" FooterStyle-CssClass="fw-bold fila-total" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle tabla-admin">
                        <Columns>
                            <asp:TemplateField HeaderText="Estado">
                                <ItemTemplate>
                                    <%-- el mismo badge de color que en el detalle del pedido --%>
                                    <span class='<%# ClaseEstado(Eval("Estado")) %>'><%# Eval("Estado") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Cantidad" DataField="Cantidad" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="col-lg-7">
                    <h5>Productos más vendidos</h5>
                    <asp:GridView ID="dgvProductos" runat="server" AutoGenerateColumns="false" CssClass="table table-striped table-bordered align-middle tabla-admin" EmptyDataText="Sin ventas en este período">
                        <Columns>
                            <asp:BoundField HeaderText="Código" DataField="Codigo" />
                            <asp:BoundField HeaderText="Producto" DataField="Nombre" />
                            <asp:BoundField HeaderText="Unidades" DataField="Unidades" />
                            <asp:BoundField HeaderText="Total" DataField="TotalVendido" DataFormatString="{0:C}" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
