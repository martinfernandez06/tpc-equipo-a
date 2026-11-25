<%@ Page Title="Hubo un problema" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="Web.Error" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mp-contenedor mx-auto my-5">
        <div class="card-tienda estado-mp-error p-4 p-md-5 text-center">
            <div class="icono-estado-mp icono-mp-error mb-3">
                <i class="bi bi-exclamation-triangle-fill"></i>
            </div>
            <h1 class="h4 mb-2">Hubo un problema</h1>
            <p class="dato-chico mb-4">
                <asp:Label ID="lblMensaje" runat="server" Text="Algo salió mal. Probá de nuevo en unos minutos."></asp:Label>
            </p>
            <a runat="server" href="~/Default" class="btn btn-ecommerce-primario">Volver al catálogo</a>
        </div>
    </div>

</asp:Content>