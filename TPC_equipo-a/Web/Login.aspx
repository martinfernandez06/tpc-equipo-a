
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

                        <!-- Alerta de éxito de registro y confirmación de correo -->
                        <asp:Panel ID="pnlExito" runat="server" CssClass="alert alert-success alert-dismissible fade show mb-3" Visible="false" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            <asp:Label ID="lblExito" runat="server" />
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </asp:Panel>

                        <!-- Alerta cuando intenta comprar sin iniciar sesión -->
                        <asp:Panel ID="pnlAvisoCheckout" runat="server" CssClass="alert alert-info alert-dismissible fade show mb-3" Visible="false" role="alert">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            Para continuar con tu compra, necesitás iniciar sesión o registrarte. Una vez que ingreses, volverás automáticamente al proceso de compra.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Cerrar"></button>
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

                            <!-- Recordarme -->
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="form-check">
                                    <asp:CheckBox ID="chkRecordarme" runat="server" />
                                    <label class="form-check-label text-muted" for="<%= chkRecordarme.ClientID %>">
                                        Recordarme
                                    </label>
                                </div>

                                <a href="OlvidePassword.aspx" class="text-decoration-none small"> ¿Olvidaste tu contraseña? </a>
                          
                                </div>

                            <!-- Acceso de administrador -->
                            <div class="form-check mb-4">
                                <asp:CheckBox ID="chkAdministrador" runat="server" />
                                <label class="form-check-label fw-semibold" for="<%= chkAdministrador.ClientID %>">
                                    <i class="bi bi-shield-lock me-1"></i>
                                    Ingresar como administrador
                                </label>
                            </div>

                            <!-- Label para errores -->
                            <div class="mb-3">
                                <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold" Visible="false" />
                            </div>

                            <!-- Iniciar Sesión -->
                            <div class="d-grid gap-2">
                                <asp:Button ID="btnLogin" runat="server" Text="Ingresar" CssClass="btn btn-primary btn-lg fw-bold" ValidationGroup="Login" OnClick="btnLogin_Click" />
                            </div>
                        </div>
                    </div>

                    <!-- Enlace a registro -->
                    <div class="text-center mt-3">
                        <p class="small">¿No tenés cuenta? <a href="Registro.aspx?redirect=checkout">Registrate aquí</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Corrección visual de los checkbox -->
    <style>
        .form-check input[type="checkbox"] {
            appearance: auto;
            -webkit-appearance: checkbox;
            box-shadow: none !important;
            outline: none !important;
        }
    </style>

    <!-- visibilidad de la contraseña -->
    <script>
        function togglePasswordVisibility() {
            const inputPass = document.getElementById('<%= txtPassword.ClientID %>');
            const iconoOjo = document.getElementById('iconoOjo');

            if (inputPass.type === 'password') {
                inputPass.type = 'text';
                iconoOjo.classList.remove('bi-eye');
                iconoOjo.classList.add('bi-eye-slash');
            } else {
                inputPass.type = 'password';
                iconoOjo.classList.remove('bi-eye-slash');
                iconoOjo.classList.add('bi-eye');
            }
        }
    </script>
</asp:Content>
