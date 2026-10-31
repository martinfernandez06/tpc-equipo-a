<%@ Page Title="Gestión de Producto" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FormularioProducto.aspx.cs" Inherits="Web.FormularioProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-sm border-0 rounded-lg">
                    <div class="card-header bg-primary text-white py-3">
                        <h4 class="mb-0 fw-bold"><i class="bi bi-box-seam"></i> Detalle del Producto</h4>
                    </div>
                    <div class="card-body p-4">
                        
                        <!-- Campo oculto para almacenar el ID en caso de modificacion futura -->

                        <asp:HiddenField ID="hfId" runat="server" />

                        <!-- Nombre y Categoria -->

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="txtNombre" class="form-label fw-bold">Nombre del Producto</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Notebook Gamer" />
                            </div>
                            <div class="col-md-6">
                                <label for="ddlCategoria" class="form-label fw-bold">Categoría</label>
                                <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione una categoría..." Value="" />
                                    <asp:ListItem Text="Electrónica" Value="1" />
                                    <asp:ListItem Text="Ropa y Calzado" Value="2" />
                                    <asp:ListItem Text="Hogar y Muebles" Value="3" />
                                    <asp:ListItem Text="Deportes" Value="4" />
                                </asp:DropDownList>
                            </div>
                        </div>

                        <!-- Precio y Stock -->

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="txtPrecio" class="form-label fw-bold">Precio de Venta ($)</label>
                                <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="0.00" />
                            </div>
                            <div class="col-md-6">
                                <label for="txtStock" class="form-label fw-bold">Stock</label>
                                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                            </div>
                        </div>

                        <!--URL de la Imagen -->

                        <div class="mb-3">
                            <label for="txtImagenUrl" class="form-label fw-bold">URL de la Imagen</label>
                            <asp:TextBox ID="txtImagenUrl" runat="server" CssClass="form-control" placeholder="https://ejemplo.com/imagen.jpg" />
                            <div class="form-text">Ingresá el enlace web de la imagen del producto.</div>
                        </div>

                        <!--Descripcion -->

                        <div class="mb-3">
                            <label for="txtDescripcion" class="form-label fw-bold">Descripción</label>
                            <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Detalles y características principales..." />
                        </div>

                        <!-- Botones de Accion y Navegacion -->

                        <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                            <a href="AdminProductos.aspx" class="btn btn-outline-secondary">
                                <i class="bi bi-arrow-left"></i> Volver al Panel
                            </a>
                            <div>
                                <asp:Button ID="btnAceptar" runat="server" Text="Guardar Producto" CssClass="btn btn-success px-4" OnClick="btnAceptar_Click" />
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>