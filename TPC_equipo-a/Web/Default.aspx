<%@ Page Title="Catalogo Productos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Web._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Catalogo de Productos</h2>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <asp:Repeater runat="server" ID="repProductos">
            <ItemTemplate>
                <div class="col">
                    <div class="card h-100">
                        <img class="card-img-top" src='<%#  Eval("ImagenUrl") %>' alt= '<%# Eval("Nombre") %>' />
                        <div class="card-body">
                            <h4 class="card-title"><%# Eval("Nombre") %> </h4>
                            <p class="card-text"><%# Eval("Descripcion") %></p>
                            <p class="fw-bold"><%# Eval("PrecioVenta", "{0:C}") %></p>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
    <asp:Label ID="lblSinProductos" runat="server" CssClass="d-block mt-4 text-secondary" Visible="false">No hay productos disponibles por el momento.</asp:Label>
</asp:Content>
