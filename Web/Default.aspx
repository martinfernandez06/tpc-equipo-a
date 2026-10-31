<%@ Page Title="Catalogo Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Catalogo de Productos</h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <div class="col">
                <div class="card h-100">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.itcXgg4BieCfTSMd6gY_6wHaJq?r=0&rs=1&pid=ImgDetMain&o=7&rm=3" class="card-img-top" alt="Pantalón negro" />
                    <div class="card-body">
                        <h5 class="card-title">Pantalon Negro</h5>
                        <p class="card-text">Pantalon de color negro elegante</p>
                        <div>
                            <p class="card-text fw-bold">$ 25.000</p>
                        </div>
                        <a class="btn btn-primary" runat="server" href="~/DetalleProducto">Ver detalle</a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.Y5DWj72Hm3fTiK9dsDtsJwHaJ4?r=0&rs=1&pid=ImgDetMain&o=7&rm=3" class="card-img-top" alt="Pantalón Rojo" />
                    <div class="card-body">
                        <h5 class="card-title">Pantalon Rojo</h5>
                        <p class="card-text">Pantalon super ajustado para hombres</p>
                        <div>
                            <p class="card-text fw-bold">$ 20.000</p>
                        </div>
                        <a class="btn btn-primary" runat="server" href="~/DetalleProducto">Ver detalle</a>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100">
                    <img src="https://tse2.mm.bing.net/th/id/OIP.pKJKMjQVnxqAzr36GBkpsgHaKJ?r=0&rs=1&pid=ImgDetMain&o=7&rm=3" class="card-img-top" alt="Pantalón Gris" />
                    <div class="card-body">
                        <h5 class="card-title">Pantalon Gris</h5>
                        <p class="card-text">Pantalon de color gris para hombres/machos</p>
                        <div>
                            <p class="card-text fw-bold">$ 23.000</p>
                        </div>
                        <a class="btn btn-primary" runat="server" href="~/DetalleProducto">Ver detalle</a>
                    </div>
                </div>
            </div>
        </div>

</asp:Content>
