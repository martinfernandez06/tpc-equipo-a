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
                                <!--Nombre -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtNombre" class="form-label font-weight-bold">Nombre</label>
                                    <input type="text" class="form-control" id="txtNombre" placeholder="Tu nombre" required />
                                </div>
                                <!-- Apellido -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtApellido" class="form-label font-weight-bold">Apellido</label>
                                    <input type="text" class="form-control" id="txtApellido" placeholder="Tu apellido" required />
                                </div>
                            </div>

                            <!-- Mail -->
                            <div class="mb-3">
                                <label for="txtEmail" class="form-label font-weight-bold">Correo Electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text">📧</span>
                                    <input type="email" class="form-control" id="txtEmail" placeholder="ejemplo@correo.com" required />
                                </div>
                            </div>

                            <!-- Tel -->
                            <div class="mb-3">
                                <label for="txtTelefono" class="form-label font-weight-bold">Teléfono</label>
                                <div class="input-group">
                                    <span class="input-group-text">📞</span>
                                    <input type="tel" class="form-control" id="txtTelefono" placeholder="Ej: 1123456789" />
                                </div>
                            </div>

                            <div class="row">

                                <!-- Contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtPassword" class="form-label font-weight-bold">Contraseña</label>
                                    <div class="input-group">
                                        <span class="input-group-text">🔒</span>
                                        <input type="password" class="form-control" id="txtPassword" placeholder="••••••••" required />
                                    </div>
                                </div>

                                <!-- Confirmar Contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="txtConfirmPassword" class="form-label font-weight-bold">Repetir Contraseña</label>
                                    <div class="input-group">
                                        <span class="input-group-text">🔒</span>
                                        <input type="password" class="form-control" id="txtConfirmPassword" placeholder="••••••••" required />
                                    </div>
                                </div>
                            </div>

                            
                            <div class="d-grid gap-2 mt-4">
                                <a href="Login.aspx" class="btn btn-primary btn-lg fw-bold">
                                    Registrarse
                                </a>
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