<%@ Page Title="Registro de Usuario" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="Web.Registro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card shadow-sm border-0 rounded-lg">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">Crear una Cuenta</h4>
                    </div>
                    <div class="card-body p-4">
                        <div id="formRegistro">
                            <div class="row">
                                <!-- Nombre -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtNombre" class="form-label font-weight-bold">Nombre</label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50" placeholder="Tu nombre" />
                                    <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                                </div>
                                <!-- Apellido -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtApellido" class="form-label font-weight-bold">Apellido</label>
                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" MaxLength="50" placeholder="Tu apellido" />
                                    <asp:RequiredFieldValidator ID="rfvApellido" runat="server" ControlToValidate="txtApellido" ErrorMessage="El apellido es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label for="txtEmail" class="form-label font-weight-bold">Correo Electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="100" placeholder="ejemplo@correo.com" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo electrónico es obligatorio." CssClass="text-danger small" Display="Dynamic" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Ingresá un formato de correo válido." ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" CssClass="text-danger small" Display="Dynamic" />
                            </div>

                            <!-- Teléfono -->
                            <div class="mb-3">
                                <label for="txtTelefono" class="form-label font-weight-bold">Teléfono</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="30" placeholder="Ej: 1123456789" />
                                </div>
                            </div>

                            <div class="row">
                                <!-- Contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtPassword" class="form-label font-weight-bold">Contraseña</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" placeholder="••••••••" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña es obligatoria." CssClass="text-danger small" Display="Dynamic" />
                                </div>

                                <!-- Confirmar Contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtConfirmPassword" class="form-label font-weight-bold">Repetir Contraseña</label>
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" placeholder="••••••••" />
                                    </div>
                                    <asp:RequiredFieldValidator ID="rfvConfirm" runat="server" ControlToValidate="txtConfirmPassword" ErrorMessage="Debes repetir la contraseña." CssClass="text-danger small" Display="Dynamic" />
                                    <asp:CompareValidator ID="cvPassword" runat="server" ControlToValidate="txtConfirmPassword" ControlToCompare="txtPassword" Operator="Equal" ErrorMessage="Las contraseñas no coinciden." CssClass="text-danger small" Display="Dynamic" />
                                </div>
                            </div>

                            <!-- Label para mostrar errores generales o de la base de datos -->
                            <div class="mb-3">
                                <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold" Visible="false" />
                            </div>

                            <!-- Botón Registrarse -->
                            <div class="d-grid gap-2 mt-4">
                                <asp:Button ID="btnRegistrar" runat="server" Text="Registrarse" CssClass="btn btn-primary btn-lg fw-bold" OnClick="btnRegistrar_Click" />
                            </div>
                        </div>
                    </div>

                    <!-- Enlace a Login -->
                    <div class="card-footer text-center py-3 bg-light border-0">
                        <span class="text-muted">¿Ya tenés una cuenta? </span>
                        <a href="Login.aspx" class="fw-bold text-decoration-none">Iniciá sesión acá</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>