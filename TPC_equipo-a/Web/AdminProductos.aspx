<%@ Page Title="Administración de Productos" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminProductos.aspx.cs" Inherits="Web.AdminProductos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- titulo a la izquierda y nuevo a la derecha --%>
    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
        <h1 class="h3 m-0 me-auto">Productos</h1>
        <a href="FormularioProducto.aspx" class="btn btn-ecommerce-primario">
            <i class="bi bi-plus-lg me-1"></i>Nuevo
        </a>
    </div>

    <%-- barra de filtros --%>
    <div class="card card-admin mb-3 filtro-reporte">
        <div class="card-body">
            <div class="encabezado-filtro mb-2"><i class="bi bi-funnel me-1"></i>Filtrar productos</div>
            <div class="row g-2 align-items-end">
                <div class="col-sm-6 col-md-2">
                    <div class="dato-titulo">Código</div>
                    <asp:TextBox ID="txtFiltroCodigo" runat="server" CssClass="form-control input-admin" placeholder="Ej: ROP-0012"></asp:TextBox>
                </div>

                <div class="col-sm-6 col-md-3">
                    <div class="dato-titulo">Nombre</div>
                    <asp:TextBox ID="txtFiltroNombre" runat="server" CssClass="form-control input-admin" placeholder="Buscar por nombre"></asp:TextBox>
                </div>

                <div class="col-sm-6 col-md-2">
                    <div class="dato-titulo">Categoría</div>
                    <asp:DropDownList ID="ddlFiltroCategoria" runat="server" CssClass="form-select input-admin"></asp:DropDownList>
                </div>

                <div class="col-sm-6 col-md-2">
                    <div class="dato-titulo">Estado</div>
                    <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="form-select input-admin">
                        <asp:ListItem Text="Todos" Value="-1" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Activos" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Inactivos" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col-md-auto d-flex gap-2">
                    <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-ecommerce-primario" OnClick="btnFiltrar_Click" />
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-admin-secundario" OnClick="btnLimpiar_Click" />
                </div>
            </div>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-striped table-bordered align-middle tabla-admin">
            <thead>
                <tr>
                    <th style="width: 105px;">Código</th>
                    <th style="width: 64px;">Imagen</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th style="width: 125px;">Precio</th>
                    <th style="width: 75px;" class="text-center">Stock</th>
                    <th>Categoría</th>
                    <th style="width: 100px;">Estado</th>
                    <th style="width: 95px;">Acción</th>
                </tr>
            </thead>
            <tbody>
                <asp:Repeater ID="repProductos" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td>
                                <span class="badge bg-secondary text-nowrap"><%# Eval("Codigo") ?? "N/A" %></span>
                            </td>
                            <td class="text-center">
                                <img src='<%# Eval("ImagenUrl") %>' alt="Imagen" class="mini-producto" onerror="this.src='https://via.placeholder.com/50';" />
                            </td>
                            <td><%# Eval("Nombre") %></td>
                            <td><%# Eval("Descripcion") %></td>
                            <td class="text-nowrap">$ <%# Eval("PrecioVenta", "{0:N2}") %></td>
                            <td class="text-center"><%# Eval("Stock") %></td>
                            <td><%# Eval("Categoria.Nombre") %></td>
                            <td>
                                <span class='<%# (bool)Eval("Activo") ? "badge bg-success" : "badge bg-secondary" %>'>
                                    <%# (bool)Eval("Activo") ? "Activo" : "Inactivo" %>
                                </span>
                            </td>
                            <td>
                                <a href='FormularioProducto.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-ecommerce-primario">Editar</a>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        <tr runat="server" visible='<%# repProductos.Items.Count == 0 %>'>
                            <td colspan="9" class="text-center text-muted py-4">No se encontraron productos</td>
                        </tr>
                    </FooterTemplate>
                </asp:Repeater>
            </tbody>
        </table>
    </div>

</asp:Content>