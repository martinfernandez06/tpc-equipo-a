<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminPedidos.aspx.cs" Inherits="Web.AdminPedidos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
    <h2>Administración de Pedidos</h2>
    <hr />
    
    <table class="table table-striped table-hover table-bordered">
        <thead class="table-dark">
            <tr>
                <th>Id</th>
                <th>Usuario</th>
                <th>FechaCreacion</th>
                <th>FormaPago</th>
                <th>FormaEntrega</th>
                <th>Total</th>
                <th>EstadoPedido</th>
                <th>IdPagoMercadoPago</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1045</td>
                <td>jperez</td>
                <td>2026-10-23 14:30</td>
                <td>Mercado Pago</td>
                <td>Envío a Domicilio</td>
                <td>$ 87500.00</td>
                <td><span class="badge bg-warning text-dark">Pagado</span></td>
                <td>1234567890</td>
                <td>
                    <a href="#" class="btn btn-sm btn-info">Ver Detalle</a>
                    <a href="#" class="btn btn-sm btn-success">Avanzar Estado</a>
                </td>
            </tr>
            <tr>
                <td>1044</td>
                <td>mgomez</td>
                <td>2026-10-22 09:15</td>
                <td>Transferencia</td>
                <td>Retiro en Local</td>
                <td>$ 32000.00</td>
                <td><span class="badge bg-success">Entregado</span></td>
                <td>NULL</td>
                <td>
                    <a href="#" class="btn btn-sm btn-info">Ver Detalle</a>
                </td>
            </tr>
        </tbody>
    </table>
</div>
    
</asp:Content>
