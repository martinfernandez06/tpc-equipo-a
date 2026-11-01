<%@ Page Title="Administración de Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminProductos.aspx.cs" Inherits="Web.AdminProductos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Administración de Productos</h2>
        <hr />
        
        <!-- Filtros -->
        <div class="row mb-4 bg-light p-3 rounded border">
            <div class="col-md-4 mb-2">
                <label class="form-label fw-bold">Filtrar por nombre:</label>
                <asp:TextBox ID="txtFiltroNombre" runat="server" CssClass="form-control" placeholder="Ingrese nombre..."></asp:TextBox>
            </div>

            <div class="col-md-3 mb-2">
                <label class="form-label fw-bold">Categoría:</label>
                <asp:DropDownList ID="ddlFiltroCategoria" runat="server" CssClass="form-select">
                </asp:DropDownList>
            </div>

            <div class="col-md-3 mb-2">
                <label class="form-label fw-bold">Estado:</label>
                <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Todos" Value="-1" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Activos" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Inactivos" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="col-md-2 d-flex align-items-end mb-2">
                <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" CssClass="btn btn-primary w-100 me-1" OnClick="btnFiltrar_Click" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btn btn-secondary w-100" OnClick="btnLimpiar_Click" />
            </div>
        </div>

        <div class="mb-3">
            <asp:Button ID="btnAgregar" runat="server" Text="Agregar Nuevo Producto" CssClass="btn btn-primary" OnClick="btnAgregar_Click" />
        </div>

        <div class="table-responsive">
            <table class="table table-striped table-hover table-bordered align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Id</th>
                        <th>Imagen</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th style="width: 130px;">Precio</th>
                        <th>Stock</th>
                        <th>Categoría</th>
                        <th>Activo</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="repProductos" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("Id") %></td>
                                <td>
                                    <img src='<%# Eval("ImagenUrl") %>' alt="Imagen" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/50';" />
                                </td>
                                <td><%# Eval("Nombre") %></td>
                                <td><%# Eval("Descripcion") %></td>
                                <!-- text-nowrap para mantener el simbolo $ y el precio en una sola linea -->
                                <td class="text-nowrap">$ <%# Eval("PrecioVenta", "{0:N2}") %></td>
                                <td><%# Eval("Stock") %></td>
                                <td><%# Eval("Categoria.Nombre") %></td>
                                <td>
                                    <asp:CheckBox ID="chkActivo" runat="server" Checked='<%# Eval("Activo") %>' Enabled="false" />
                                </td>
                                <td>
                                    <!-- igualo ancho de botones -->

                                    <a href='FormularioProducto.aspx?id=<%# Eval("Id") %>' class="btn btn-sm btn-primary mb-1 w-100">
                                        <i class="bi bi-pencil-square"></i> Modificar
                                    </a>
                                    
                                  
                                    <asp:LinkButton ID="btnEliminar" runat="server" 
                                        Text='<%# (bool)Eval("Activo") ? "Desactivar" : "Activar" %>' 
                                        CssClass='<%# (bool)Eval("Activo") ? "btn btn-sm btn-danger w-100" : "btn btn-sm btn-success w-100" %>' 
                                        CommandName="EliminarId" 
                                        CommandArgument='<%# Eval("Id") %>' 
                                        OnClientClick="return confirm('¿Estás seguro de cambiar el estado de este producto?');" 
                                        OnClick="btnEliminar_Click" />
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>