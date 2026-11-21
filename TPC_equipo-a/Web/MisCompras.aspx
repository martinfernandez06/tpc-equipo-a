<%@ Page Title="Mis Compras" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MisCompras.aspx.cs" Inherits="Web.MisCompras" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <%-- el updatepanel recarga solo esta parte al filtrar --%>
    <asp:UpdatePanel ID="upMisCompras" runat="server">
        <ContentTemplate>
            <%-- misma franja lila que el filtro del catalogo --%>
            <div class="filtro-catalogo">
                <div class="d-flex flex-wrap align-items-start justify-content-between gap-2 mb-3">
                    <div>
                        <h1 class="titulo-detalle mb-1">Mis compras</h1>
                        <p class="small text-secondary mb-0">Todos tus pedidos en un solo lugar. Podés filtrarlos por fecha o por estado.</p>
                    </div>
                    <a href="Default.aspx" class="btn btn-tienda-secundario text-nowrap d-none d-md-inline-block"><i class="bi bi-bag me-1"></i>Seguir comprando</a>
                </div>
                <div class="row g-2 align-items-end">
                    <div class="col-6 col-md-3">
                        <div class="titulo-campo">Desde</div>
                        <asp:TextBox ID="txtDesde" runat="server" TextMode="Date" CssClass="form-control input-tienda" />
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="titulo-campo">Hasta</div>
                        <asp:TextBox ID="txtHasta" runat="server" TextMode="Date" CssClass="form-control input-tienda" />
                    </div>
                    <div class="col-12 col-md-auto d-flex gap-2">
                        <asp:Button ID="btnFiltrar" OnClick="btnFiltrar_Click" runat="server" Text="Filtrar" CssClass="btn btn-ecommerce-primario flex-grow-1 mw-100" ValidationGroup="fechas" />
                        <%-- causesvalidation false asi limpiar anda aunque las fechas esten mal --%>
                        <asp:LinkButton ID="btnLimpiar" OnClick="btnLimpiar_Click" runat="server" CssClass="btn btn-tienda-secundario text-nowrap" CausesValidation="false" ToolTip="Limpiar filtro"><i class="bi bi-x-lg"></i><span class="d-none d-lg-inline ms-1">Limpiar</span></asp:LinkButton>
                    </div>
                </div>
                <div class="mt-2">
                    <asp:CompareValidator ID="cvFechas" runat="server" ControlToValidate="txtHasta" ControlToCompare="txtDesde" Operator="GreaterThanEqual" Type="Date" ErrorMessage="La fecha hasta no puede ser anterior a la desde" ValidationGroup="fechas" Display="Dynamic" CssClass="text-danger small" />
                    <%-- comparan contra la fecha de hoy que se carga en el page_load --%>
                    <asp:CompareValidator ID="cvDesdeHoy" runat="server" ControlToValidate="txtDesde" Operator="LessThanEqual" Type="Date" ErrorMessage="La fecha desde no puede ser posterior a hoy" ValidationGroup="fechas" Display="Dynamic" CssClass="text-danger small" />
                    <asp:CompareValidator ID="cvHastaHoy" runat="server" ControlToValidate="txtHasta" Operator="LessThanEqual" Type="Date" ErrorMessage="La fecha hasta no puede ser posterior a hoy" ValidationGroup="fechas" Display="Dynamic" CssClass="text-danger small" />
                </div>
            </div>

            <asp:Label ID="lblMensaje" runat="server" Visible="false"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
