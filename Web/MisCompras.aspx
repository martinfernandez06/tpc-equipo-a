<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MisCompras.aspx.cs" Inherits="Web.MisCompras" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
    <h2>Mis Compras</h2>
    <hr />
    
    <table class="table table-striped table-hover">
        <thead class="table-primary">
            <tr>
                <th>Nº Pedido (Id)</th>
                <th>Fecha de Creación</th>
                <th>Forma de Entrega</th>
                <th>Total</th>
                <th>Estado</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>1045</td>
                <td>2026-10-23 14:30</td>
                <td>Envío a Domicilio</td>
                <td>$ 87500.00</td>
                <td><span class="badge bg-info text-dark">En preparación</span></td>
                <td>
                    <a href="#" class="btn btn-sm btn-outline-primary">Ver Ítems</a>
                </td>
            </tr>
            <tr>
                <td>0988</td>
                <td>2026-10-15 11:20</td>
                <td>Retiro en Local</td>
                <td>$ 55000.00</td>
                <td><span class="badge bg-success">Entregado</span></td>
                <td>
                    <a href="#" class="btn btn-sm btn-outline-primary">Ver Ítems</a>
                </td>
            </tr>
        </tbody>
    </table>
</div>
</asp:Content>
