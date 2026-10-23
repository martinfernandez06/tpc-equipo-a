<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminProductos.aspx.cs" Inherits="Web.AdminProductos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
    <h2>Administración de Productos</h2>
    <hr />
    
    <div class="mb-3">
        <a href="#" class="btn btn-primary">Agregar Nuevo Producto</a>
    </div>

    <table class="table table-striped table-hover table-bordered">
        <thead class="table-dark">
            <tr>
                <th>Id</th>
                <th>ImagenUrl</th>
                <th>Nombre</th>
                <th>Descripción</th>
                <th>PrecioActual</th>
                <th>Stock</th>
                <th>Categoría</th>
                <th>Activo</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1</td>
                <td><img src="https://via.placeholder.com/50" alt="Zapatillas" class="img-thumbnail" /></td>
                <td>Zapatillas Running</td>
                <td>Zapatillas deportivas ultra livianas</td>
                <td>$ 55000.00</td>
                <td>15</td>
                <td>Deportes</td>
                <td><input type="checkbox" checked disabled /></td>
                <td>
                    <a href="#" class="btn btn-sm btn-warning">Editar</a>
                    <a href="#" class="btn btn-sm btn-danger">Eliminar</a>
                </td>
            </tr>
            <tr>
                <td>2</td>
                <td><img src="https://via.placeholder.com/50" alt="Auriculares" class="img-thumbnail" /></td>
                <td>Auriculares Inalámbricos</td>
                <td>Auriculares con cancelación de ruido</td>
                <td>$ 32500.00</td>
                <td>8</td>
                <td>Electrónica</td>
                <td><input type="checkbox" checked disabled /></td>
                <td>
                    <a href="#" class="btn btn-sm btn-warning">Editar</a>
                    <a href="#" class="btn btn-sm btn-danger">Eliminar</a>
                </td>
            </tr>
        </tbody>
    </table>
</div>
</asp:Content>
