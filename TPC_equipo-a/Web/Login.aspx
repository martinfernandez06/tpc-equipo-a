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
                        
                        <!-- Alerta de éxito por registro -->
                        <asp:Panel ID="pnlExito" runat="server" CssClass="alert alert-success alert-dismissible fade show mb-3" Visible="false" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> ¡Registro exitoso! Ya podés iniciar sesión con tus datos.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <div id="formLogin">

                            <!-- Mail -->
                            <div class="mb-3">
                                <label for="<%= txtEmail.ClientID %>" class="form-label font-weight-bold">Correo Electrónico</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="100" placeholder="ejemplo@correo.com" />
                                </div>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo electrónico es obligatorio." CssClass="text-danger small" Display="Dynamic" ValidationGroup="Login" />
                            </div>

                            <!-- Password con Ojito -->
                            <div class="mb-3">
                                <label for="<%= txtPassword.ClientID %>" class="form-label font-weight-bold">Contraseña</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" placeholder="••••••••" />
                                    
                                    <!-- Botón del Ojito -->
                                    <button class="btn btn-outline-secondary" type="button" id="btnTogglePassword" onclick="togglePasswordVisibility()">
                                        <i class="bi bi-eye" id="iconoOjo"></i>
                                    </button>
                                </div>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña es obligatoria." CssClass="text-danger small" Display="Dynamic" ValidationGroup="Login" />
                            </div>

                            <!-- Recordarme y Olvidé contraseña -->
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkRecordarme" runat="server" CssClass="form-check-input" />
                                    <label class="form-check-label text-muted" for="chkRecordarme">
                                        Recordarme
                                    </label>
                                </div>
                                <a href="#" class="text-decoration-none small">¿Olvidaste tu contraseña?</a>
                            </div>

                            <!-- Label para mostrar errores -->
                            <div class="mb-3">
                                <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold" Visible="false" />
                            </div>

                            <!-- Iniciar Sesión -->
                            <div class="d-grid gap-2">
                                <asp:Button ID="btnLogin" runat="server" Text="Ingresar" CssClass="btn btn-primary btn-lg fw-bold" ValidationGroup="Login" OnClick="btnLogin_Click" />
                            </div>
                        </div>
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

    <!-- Script para alternar visibilidad de la contraseña -->

    <script>
        function togglePasswordVisibility() {
            const inputPass = document.getElementById('<%= txtPassword.ClientID %>');
            const iconoOjo = document.getElementById('iconoOjo');

            if (inputPass.type === 'password') {
                inputPass.type = 'text';
                iconoOjo.classList.remove('bi-eye');
                iconoOjo.classList.add('bi-eye-slash'); // Cambia a ojo tachado
            } else {
                inputPass.type = 'password';
                iconoOjo.classList.remove('bi-eye-slash');
                iconoOjo.classList.add('bi-eye'); // Vuelve al ojo normal
            }
        }
    </script>
</asp:Content>