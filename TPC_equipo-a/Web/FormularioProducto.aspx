<%@ Page Title="Gestión de Producto" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="FormularioProducto.aspx.cs" Inherits="Web.FormularioProducto" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Detalle de Producto</h4>
                    </div>
                    <div class="card-body">

                        <!-- ID  oculto para caso de modificacion -->

                        <asp:HiddenField ID="hfId" runat="server" />

                        <!-- Nombre y Categoria -->

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="txtNombre" class="form-label fw-bold">Nombre del Producto</label>
                                <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Notebook Gamer" />
                                <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" 
                                    ErrorMessage="El nombre es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label for="ddlCategoria" class="form-label fw-bold">Categoría</label>
                                <asp:DropDownList ID="ddlCategoria" runat="server" CssClass="form-select">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvCategoria" runat="server" ControlToValidate="ddlCategoria" 
                                    InitialValue="0" ErrorMessage="Debe seleccionar una categoría." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                        </div>

                        <!-- Precio y Stock -->

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="txtPrecio" class="form-label fw-bold">Precio de Venta ($)</label>
                                <asp:TextBox ID="txtPrecio" runat="server" CssClass="form-control" TextMode="Number" step="0.01" placeholder="0.00" />
                                <asp:RequiredFieldValidator ID="rfvPrecio" runat="server" ControlToValidate="txtPrecio" 
                                    ErrorMessage="El precio es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                                
                                <!-- Precio sea mayor a 0 -->

                                <asp:CompareValidator ID="cvPrecio" runat="server" ControlToValidate="txtPrecio" 
                                    Operator="GreaterThan" ValueToCompare="0" Type="Double" 
                                    ErrorMessage="El precio debe ser mayor a cero." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label for="txtStock" class="form-label fw-bold">Stock</label>
                                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control" TextMode="Number" placeholder="0" />
                                <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock" 
                                    ErrorMessage="El stock es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                               
                                <!-- stock mayor o igual a 0 (no negativo) -->

                                <asp:CompareValidator ID="cvStock" runat="server" ControlToValidate="txtStock" 
                                    Operator="GreaterThanEqual" ValueToCompare="0" Type="Integer" 
                                    ErrorMessage="El stock no puede ser negativo." CssClass="text-danger small" Display="Dynamic" />
                            </div>
                        </div>

                        <!-- URL de la Imagen -->

                        <div class="mb-3">
                            <label for="txtImagenUrl" class="form-label fw-bold">URL de la Imagen</label>
                            <asp:TextBox ID="txtImagenUrl" runat="server" CssClass="form-control" placeholder="https://ejemplo.com/imagen.jpg" />
                            <div class="form-text">Ingresá el enlace web de la imagen del producto.</div>
                        </div>

                        <!-- Descripcion -->

                        <div class="mb-3">
                            <label for="txtDescripcion" class="form-label fw-bold">Descripción</label>
                            <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Detalles y características principales..." />
                            <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion" 
                                ErrorMessage="La descripción es obligatoria." CssClass="text-danger small" Display="Dynamic" />
                        </div>

                        <!-- Accion y Navegacion -->

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