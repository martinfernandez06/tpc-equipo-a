<%@ Page Title="Catalogo Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Catalogo de Productos</h2>
    <div class="row row-cols-2 row-cols-md-3 row-cols-lg-4 row-cols-xl-5 g-3">
        <asp:Repeater runat="server" ID="repProductos">
            <ItemTemplate>
                <div class="col">
                    <div class="card h-100 card-producto">
                        <img class="card-img-top img-card-producto" src='<%#  Eval("ImagenUrl") %>' alt='<%# Eval("Nombre") %>' />
                        <div class="card-body">
                            <a href='DetalleProducto.aspx?id=<%# Eval("Id") %>' class="stretched-link text-decoration-none">
                                <h6 class="card-title titulo-card-producto"><%# Eval("Nombre") %> </h6>
                            </a>
                            <p class="fs-5 fw-bold mb-0"><%# Eval("PrecioVenta", "{0:C}") %></p>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:Label ID="lblSinProductos" runat="server" CssClass="d-block mt-4 text-secondary" Visible="false">No hay productos disponibles por el momento.</asp:Label>
</asp:Content>
