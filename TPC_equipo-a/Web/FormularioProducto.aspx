<%@ Page Title="Gestión de Producto" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormularioProducto.aspx.cs" Inherits="Web.FormularioProducto" Culture="en-US" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <%-- encabezado igual que FormularioCategoria: titulo + badge a la izquierda y Volver a la derecha --%>
    <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
        <asp:Label ID="lblTitulo" CssClass="h3 m-0" runat="server" Text=""></asp:Label>
        <asp:Label ID="lblEstado" runat="server" Text=""></asp:Label>
        <a href="AdminProductos.aspx" class="btn btn-sm btn-admin-secundario ms-auto">
            <i class="bi bi-arrow-left me-1"></i>Volver
        </a>
    </div>

    <div class="row g-3 align-items-start">
        <%-- columna izquierda: formulario de datos --%>
        <div class="col-lg-8">
            <div class="card card-admin">
                <div class="card-header">Datos del producto</div>
                <div class="card-body">

                    <asp:HiddenField ID="hfId" runat="server" />

                    <%-- Codigo, Nombre y Categoria --%>
                    <div class="row g-3 mb-3">
                        <div class="col-md-3">
                            <label for="<%= txtCodigo.ClientID %>" class="dato-titulo d-block">Código propio</label>
                            <asp:TextBox ID="txtCodigo" runat="server" CssClass="form-control input-admin" placeholder="(Opcional)" />
                            <div class="form-text small">Dejar vacío para auto-generar.</div>
                        </div>

                        <div class="col-md-5">
                            <label for="<%= txtNombre.ClientID %>" class="dato-titulo d-block">Nombre del producto</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control input-admin" placeholder="Ej: Notebook Gamer" />
                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre"
                                ErrorMessage="El nombre es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <div class="col-md-4">
                            <label for="<%= ddlCategoria.ClientID %>" class="dato-titulo d-block">Categoría</label>
                            <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select input-admin"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvCategoria" runat="server" ControlToValidate="ddlCategoria"
                                InitialValue="0" ErrorMessage="Debe seleccionar una categoría." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                    </div>

                    <%-- Precio y Stock --%>
                    <div class="row g-3 mb-3">
                        <div class="col-md-6">
                            <label for="<%= txtPrecio.ClientID %>" class="dato-titulo d-block">Precio de venta ($)</label>
                            <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control input-admin" TextMode="Number" step="0.01" placeholder="Ej: 155740,50" />
                            <div class="form-text small">Sin puntos de miles, los centavos van con coma.</div>
                            <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" ControlToValidate="txtPrecio"
                                ErrorMessage="El precio es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                            <asp:CompareValidator ID="cvPrecio" runat="server" ControlToValidate="txtPrecio"
                                Operator="GreaterThan" ValueToCompare="0" Type="Double"
                                ErrorMessage="El precio debe ser mayor a cero." CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <div class="col-md-6">
                            <label for="<%= txtStock.ClientID %>" class="dato-titulo d-block">Stock</label>
                            <asp:TextBox ID="txtStock" runat="server" CssClass="form-control input-admin" TextMode="Number" placeholder="0" />
                            <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock"
                                ErrorMessage="El stock es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                            <asp:CompareValidator ID="cvStock" runat="server" ControlToValidate="txtStock"
                                Operator="GreaterThanEqual" ValueToCompare="0" Type="Integer"
                                ErrorMessage="El stock no puede ser negativo." CssClass="text-danger small" Display="Dynamic" />
                        </div>
                    </div>

                    <%-- URL de la Imagen --%>
                    <div class="mb-3">
                        <label for="<%= txtImagenUrl.ClientID %>" class="dato-titulo d-block">URL de la imagen</label>
                        <asp:TextBox ID="txtImagenUrl" runat="server" CssClass="form-control input-admin" placeholder="https://ejemplo.com/imagen.jpg" />
                        <div class="form-text small">Ingresá el enlace web de la imagen del producto.</div>
                    </div>

                    <%-- Descripcion --%>
                    <div class="mb-3">
                        <label for="<%= txtDescripcion.ClientID %>" class="dato-titulo d-block">Descripción</label>
                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control input-admin" TextMode="MultiLine" Rows="3" placeholder="Detalles y características principales..." />
                        <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion"
                            ErrorMessage="La descripción es obligatoria." CssClass="text-danger small" Display="Dynamic" />
                    </div>

                    <%-- UpdatePanel solo para las acciones y confirmacion: evita que Desactivar mueva el scroll --%>
                    <asp:UpdatePanel ID="upAcciones" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lblError" runat="server" CssClass="text-danger small fw-bold d-block mb-3" Visible="false"></asp:Label>

                            <asp:Panel ID="pnlBotones" runat="server" CssClass="d-flex flex-wrap gap-2">
                                <asp:Button ID="btnAceptar" runat="server" Text="Crear" CssClass="btn btn-ecommerce-primario" OnClick="btnAceptar_Click" />
                                <a href="AdminProductos.aspx" class="btn btn-admin-secundario">Cancelar</a>
                                <asp:Button ID="btnEstado" runat="server" Text="Desactivar" CssClass="btn btn-admin-peligro ms-auto" OnClick="btnEstado_Click" CausesValidation="false" />
                            </asp:Panel>

                            <asp:Panel ID="pnlConfirmar" runat="server" Visible="false" CssClass="border border-danger p-3 mt-3">
                                <div class="fw-bold text-danger">¿Desactivar este producto?</div>
                                <div class="small mb-3">Va a dejar de verse en el catálogo de la tienda.</div>
                                <div class="d-flex gap-2">
                                    <asp:Button ID="btnSiDesactivar" runat="server" Text="Sí, desactivar" CssClass="btn btn-danger rounded-0" CausesValidation="false" OnClick="btnSiDesactivar_Click" />
                                    <asp:Button ID="btnNoDesactivar" runat="server" Text="No" CssClass="btn btn-admin-secundario" CausesValidation="false" OnClick="btnNoDesactivar_Click" />
                                </div>
                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </div>
            </div>
        </div>

        <%-- columna derecha: vista previa de la imagen --%>
        <div class="col-lg-4">
            <div class="card card-admin">
                <div class="card-header">Vista previa</div>
                <div class="card-body">
                    <div class="img-detalle-caja d-flex align-items-center justify-content-center overflow-hidden">
                        <img id="imgPreview" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==" alt="Vista previa del producto" class="mw-100 mh-100 d-none" />
                        <div id="previewVacio" class="text-center text-muted p-3">
                            <i class="bi bi-image fs-1 d-block mb-1"></i>
                            <span id="previewTexto" class="small">Ingresá una URL para ver la imagen</span>
                        </div>
                    </div>
                    <div class="form-text small mt-2">
                        Se actualiza automáticamente al pegar el enlace.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
(function () {
    const elUrl = document.getElementById('<%= txtImagenUrl.ClientID %>');
    const elImg = document.getElementById('imgPreview');
    const elVacio = document.getElementById('previewVacio');
    const elTexto = document.getElementById('previewTexto');

    if (!(elUrl instanceof HTMLInputElement) || !(elImg instanceof HTMLImageElement) || !elVacio || !elTexto) {
        return;
    }

    const inputUrl = elUrl;
    const img = elImg;
    const vacio = elVacio;
    const texto = elTexto;
    const placeholderSrc = img.src;

    function mostrarVacio(mensaje = '') {
        img.classList.add('d-none');
        vacio.classList.remove('d-none');
        texto.textContent = mensaje;
    }

    function actualizarPreview() {
        const url = inputUrl.value.trim();
        if (!url) {
            img.src = placeholderSrc;
            mostrarVacio('Ingresá una URL para ver la imagen');
            return;
        }
        img.src = url;
    }

    img.addEventListener('load', function () {
        if (inputUrl.value.trim()) {
            img.classList.remove('d-none');
            vacio.classList.add('d-none');
        }
    });

    img.addEventListener('error', function () {
        if (inputUrl.value.trim()) {
            mostrarVacio('No se pudo cargar la imagen. Revisá la URL.');
        }
    });

    inputUrl.addEventListener('input', actualizarPreview);
    inputUrl.addEventListener('change', actualizarPreview);

    actualizarPreview();
})();
    </script>

</asp:Content>
