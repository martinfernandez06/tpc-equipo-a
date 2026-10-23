<%@ Page Title="Iniciar Sesión" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="Web.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm border-0 rounded-lg">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">Iniciar Sesión</h4>
                    </div>
                    <div class="card-body p-4">
                        <form id="formLogin">
                            <!-- mail -->
                            <div class="mb-3">
                                <label for="txtEmail" class="form-label font-weight-bold">Correo Electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i> 📧</span>
                                    <input type="email" class="form-control" id="txtEmail" placeholder="ejemplo@correo.com" required />
                                </div>
                            </div>

                            <!-- Password -->
                            <div class="mb-3">
                                <label for="txtPassword" class="form-label font-weight-bold">Contraseña</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i> 🔒</span>
                                    <input type="password" class="form-control" id="txtPassword" placeholder="••••••••" required />
                                </div>
                            </div>

                            <!--Olvide contraseña -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="chkRecordarme" />
                                    <label class="form-check-label text-muted" for="chkRecordarme">
                                        Recordarme
                                    </label>
                                </div>
                                <a href="#" class="text-decoration-none small">¿Olvidaste tu contraseña?</a>
                            </div>

                            <!-- Iniciar Sesion -->
                            <div class="d-grid gap-2">
                                <a href="Default.aspx" class="btn btn-primary btn-lg fw-bold">
                                    Ingresar
                                </a>
                            </div>
                        </form>
                    </div>

                    <!-- Enlace fin -->
                    <div class="card-footer text-center py-3 bg-light border-0">
                        <span class="text-muted">¿No tenés una cuenta? </span>
                        <a href="Registro.aspx" class="fw-bold text-decoration-none">Registrate acá</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>