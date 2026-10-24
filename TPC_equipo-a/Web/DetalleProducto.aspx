<%@ Page Title="Detalle de producto" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DetalleProducto.aspx.cs" Inherits="Web.DetalleProducto" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row">
        <div class="col-md-6">
            <img src="https://tse2.mm.bing.net/th/id/OIP.itcXgg4BieCfTSMd6gY_6wHaJq?r=0&rs=1&pid=ImgDetMain&o=7&rm=3" class="card-img-fluid" alt="Pantalón negro" />
        </div>
        <div class="col-md-6">
            <h2>Pantalon Negro</h2>
            <p>Pantalones</p>
            <p>Pantalon negro para hombre de garbarina.</p>
            <p class="fw-bold">$34.560</p>
            <p>Stock: 2</p>
            <div class="d-grid gap-2 d-md-flex ">
                <a  class="btn btn-primary align-items-center" runat="server" href="~/Carrito">Agregar al carrito</a>
                <a class="btn btn-outline-secondary" runat="server" href="~/Default">Volver al catalogo</a>
            </div>
        </div>
    </div>
</asp:Content>
