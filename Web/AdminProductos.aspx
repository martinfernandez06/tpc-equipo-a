<%@ Page Title="Administración de Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminProductos.aspx.cs" Inherits="Web.AdminProductos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2>Administración de Productos</h2>
        <hr />
        
        <div class="mb-3">

          <div class="mb-3">
            
              <asp:Button ID="btnAgregar" runat="server" Text="Agregar Nuevo Producto" CssClass="btn btn-primary" OnClick="btnAgregar_Click" />
        
          </div>

        </div>

        <div class="table-responsive">
            <table class="table table-striped table-hover table-bordered align-middle">
                <thead class="table-dark">
                    <tr>
                        <th>Id</th>
                        <th>Imagen</th>
                        <th>Nombre</th>
                        <th>Descripción</th>
                        <th>Precio</th>
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
                                    <img src='<%# Eval("ImagenUrl") %>' alt="Imagen" class="img-thumbnail" style="width: 50px; height: 50px; object-fit: cover;" />
                                </td>
                                <td><%# Eval("Nombre") %></td>
                                <td><%# Eval("Descripcion") %></td>
                                <td>$ <%# Eval("PrecioVenta") %></td>
                                <td><%# Eval("Stock") %></td>
                                <td><%# Eval("Categoria.Nombre") %></td>
                                <td>
                                    <asp:CheckBox ID="chkActivo" runat="server" Checked='<%# Eval("Activo") %>' Enabled="false" />
                                </td>
                                <td>
                                    <a href="#" class="btn btn-sm btn-warning">Editar</a>
                                    <a href="#" class="btn btn-sm btn-danger">Eliminar</a>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
        </div>
    </div>
</asp:Content>