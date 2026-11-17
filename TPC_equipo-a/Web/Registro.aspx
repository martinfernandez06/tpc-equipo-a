
<%@ Page Title="Registro de Usuario" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="Web.Registro" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-9 col-lg-8">
                <div class="card shadow-sm border-0 rounded-lg">

                    <div class="card-header bg-primary text-white text-center py-3">
                        <h4 class="mb-0 fw-bold">Crear una Cuenta</h4>
                    </div>

                    <div class="card-body p-4">
                        <div id="formRegistro">

                            <!-- Datos Personales -->
                            <h5 class="fw-bold mb-3 text-primary">Datos Personales</h5>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtNombre.ClientID %>" class="form-label font-weight-bold">Nombre</label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50" placeholder="Tu nombre" />
                                    <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                                        ControlToValidate="txtNombre"
                                        ErrorMessage="El nombre es obligatorio."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtApellido.ClientID %>" class="form-label font-weight-bold">Apellido</label>
                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" MaxLength="50" placeholder="Tu apellido" />
                                    <asp:RequiredFieldValidator ID="rfvApellido" runat="server"
                                        ControlToValidate="txtApellido"
                                        ErrorMessage="El apellido es obligatorio."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="mb-3">
                                <label for="<%= txtEmail.ClientID %>" class="form-label font-weight-bold">Correo Electrónico</label>

                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <asp:TextBox ID="txtEmail" runat="server"
                                        TextMode="Email"
                                        CssClass="form-control"
                                        MaxLength="100"
                                        placeholder="ejemplo@correo.com" />
                                </div>

                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="El correo electrónico es obligatorio."
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />

                                <asp:RegularExpressionValidator ID="revEmail" runat="server"
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="Ingresá un formato de correo válido."
                                    ValidationExpression="^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />
                            </div>

                            <!-- Teléfono -->
                            <div class="mb-3">
                                <label for="<%= txtTelefono.ClientID %>" class="form-label font-weight-bold">Teléfono</label>

                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                    <asp:TextBox ID="txtTelefono" runat="server"
                                        CssClass="form-control"
                                        MaxLength="30"
                                        placeholder="Ej: 1123456789" />
                                </div>

                                <asp:RequiredFieldValidator ID="rfvTelefono" runat="server"
                                    ControlToValidate="txtTelefono"
                                    ErrorMessage="El teléfono es obligatorio."
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />
                            </div>

                            <hr class="my-4">

                            <!-- Seguridad -->
                            <h5 class="fw-bold mb-3 text-primary">Seguridad</h5>

                            <div class="row">

                                <!-- Contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtPassword.ClientID %>" class="form-label font-weight-bold">Contraseña</label>

                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>

                                        <asp:TextBox ID="txtPassword" runat="server"
                                            TextMode="Password"
                                            CssClass="form-control"
                                            MaxLength="50"
                                            placeholder="••••••••" />

                                        <button class="btn btn-outline-secondary" type="button"
                                            onclick="togglePasswordVisibility('<%= txtPassword.ClientID %>', 'iconoOjoPass')">
                                            <i class="bi bi-eye" id="iconoOjoPass"></i>
                                        </button>
                                    </div>

                                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                        ControlToValidate="txtPassword"
                                        ErrorMessage="La contraseña es obligatoria."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />

                                    <asp:RegularExpressionValidator ID="revPassword" runat="server"
                                        ControlToValidate="txtPassword"
                                        ErrorMessage="Mínimo 7 caracteres, combinando letras y números."
                                        ValidationExpression="^(?=.*[A-Za-z])(?=.*\d).{7,}$"
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>

                                <!-- Confirmar contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtConfirmPassword.ClientID %>" class="form-label font-weight-bold">Repetir Contraseña</label>

                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>

                                        <asp:TextBox ID="txtConfirmPassword" runat="server"
                                            TextMode="Password"
                                            CssClass="form-control"
                                            MaxLength="50"
                                            placeholder="••••••••" />

                                        <button class="btn btn-outline-secondary" type="button"
                                            onclick="togglePasswordVisibility('<%= txtConfirmPassword.ClientID %>', 'iconoOjoConfirm')">
                                            <i class="bi bi-eye" id="iconoOjoConfirm"></i>
                                        </button>
                                    </div>

                                    <asp:RequiredFieldValidator ID="rfvConfirm" runat="server"
                                        ControlToValidate="txtConfirmPassword"
                                        ErrorMessage="Debés repetir la contraseña."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />

                                    <asp:CompareValidator ID="cvPassword" runat="server"
                                        ControlToValidate="txtConfirmPassword"
                                        ControlToCompare="txtPassword"
                                        Operator="Equal"
                                        ErrorMessage="Las contraseñas no coinciden."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>
                            </div>

                            <hr class="my-4">

                           <!-- Dirección de envío -->

                        <h5 class="fw-bold mb-3 text-primary">Dirección de Envío</h5>

                        <div class="row">

                            <!-- Calle -->

                            <div class="col-md-6 mb-3">
                                <label for="<%= txtCalle.ClientID %>" class="form-label font-weight-bold">Calle</label>
                                <asp:TextBox ID="txtCalle" runat="server"
                                    CssClass="form-control"
                                    MaxLength="100"
                                    placeholder="Ej: Av. Corrientes" />

                                <asp:RequiredFieldValidator ID="rfvCalle" runat="server"
                                    ControlToValidate="txtCalle"
                                    ErrorMessage="La calle es obligatoria."
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />
                            </div>

                            <!-- Número  -->

                            <div class="col-md-6 mb-3">
                                <label for="<%= txtNumero.ClientID %>" class="form-label font-weight-bold">Número</label>
                                <asp:TextBox ID="txtNumero" runat="server"
                                    CssClass="form-control"
                                    MaxLength="20"
                                    placeholder="Ej: 1234" />

                                <asp:RequiredFieldValidator ID="rfvNumero" runat="server"
                                    ControlToValidate="txtNumero"
                                    ErrorMessage="El número es obligatorio."
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />
                            </div>
                        </div>

                            <!-- Provincia y localidad -->

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="ddlProvincia" class="form-label font-weight-bold">Provincia</label>

                                    <select id="ddlProvincia" class="form-select">
                                        <option value="">Seleccione provincia...</option>
                                    </select>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="ddlLocalidad" class="form-label font-weight-bold">Localidad / Municipio</label>

                                    <select id="ddlLocalidad" class="form-select">
                                        <option value="">Seleccione localidad...</option>
                                    </select>
                                </div>
                            </div>

                            <!-- Código postal y observaciones -->

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtCodigoPostal.ClientID %>" class="form-label font-weight-bold">Código Postal</label>

                                    <asp:TextBox ID="txtCodigoPostal" runat="server"
                                        CssClass="form-control"
                                        MaxLength="20"
                                        placeholder="Ej: 1414" />

                                    <asp:RequiredFieldValidator ID="rfvCP" runat="server"
                                        ControlToValidate="txtCodigoPostal"
                                        ErrorMessage="El código postal es obligatorio."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtObservaciones.ClientID %>" class="form-label font-weight-bold">Observaciones (Opcional)</label>

                                    <asp:TextBox ID="txtObservaciones" runat="server"
                                        CssClass="form-control"
                                        MaxLength="255"
                                        placeholder="Ej: Piso 3, depto B" />
                                </div>
                            </div>

                            <!-- Campos ocultos para recuperar la ubicación -->

                            <asp:HiddenField ID="hfProvincia" runat="server" ClientIDMode="Static" />
                            <asp:HiddenField ID="hfLocalidad" runat="server" ClientIDMode="Static" />

                            <!-- Mensajes de error -->

                            <div class="mb-3 mt-3">
                                <asp:Label ID="lblError" runat="server"
                                    CssClass="text-danger fw-bold"
                                    Visible="false" />
                            </div>

                            <!-- Botón -->

                            <div class="d-grid gap-2 mt-4">
                                <asp:Button ID="btnRegistrar" runat="server"
                                    Text="Registrarse"
                                    CssClass="btn btn-primary btn-lg fw-bold"
                                    ValidationGroup="Registro"
                                    OnClientClick="return guardarUbicacion();"
                                    OnClick="btnRegistrar_Click" />
                            </div>

                        </div>
                    </div>

                    <!-- Enlace al Login -->
                    <div class="card-footer text-center py-3 bg-light border-0">
                        <span class="text-muted">¿Ya tenés una cuenta? </span>
                        <a href="Login.aspx" class="fw-bold text-decoration-none">Iniciá sesión acá</a>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- JavaScript -->
    <script >

        // Mostrar u ocultar contraseña
        function togglePasswordVisibility(inputId, iconId) {
            const inputPass = document.getElementById(inputId);
            const iconoOjo = document.getElementById(iconId);

            if (inputPass && iconoOjo) {
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
        }


        // Cargar provincias desde Georef
        async function cargarProvincias() {
            const ddlProvincia = document.getElementById("ddlProvincia");
            const provinciaGuardada = document.getElementById("hfProvincia").value;

            try {
                const response = await fetch(
                    "https://apis.datos.gob.ar/georef/api/provincias?orden=nombre"
                );

                if (!response.ok) {
                    throw new Error("No se pudieron cargar las provincias.");
                }

                const data = await response.json();

                ddlProvincia.innerHTML =
                    '<option value="">Seleccione provincia...</option>';

                data.provincias.forEach(prov => {
                    const option = document.createElement("option");
                    option.value = prov.nombre;
                    option.textContent = prov.nombre;
                    ddlProvincia.appendChild(option);
                });

                // Restaurar provincia guardada
                ddlProvincia.value = provinciaGuardada;

                if (provinciaGuardada) {
                    await cargarLocalidades(true);
                }

            } catch (error) {
                console.error("Error al cargar provincias:", error);
            }
        }


        // Cargar localidades de la provincia seleccionada
        async function cargarLocalidades(restaurar = false) {
            const ddlProvincia = document.getElementById("ddlProvincia");
            const ddlLocalidad = document.getElementById("ddlLocalidad");

            const provincia = ddlProvincia.value;

            const hfProvincia = document.getElementById("hfProvincia");
            const hfLocalidad = document.getElementById("hfLocalidad");

            const localidadGuardada = restaurar ? hfLocalidad.value : "";

            hfProvincia.value = provincia;

            if (!restaurar) {
                hfLocalidad.value = "";
            }

            ddlLocalidad.innerHTML =
                '<option value="">Seleccione localidad...</option>';

            if (!provincia) return;

            try {
                const response = await fetch(
                    `https://apis.datos.gob.ar/georef/api/localidades?provincia=${encodeURIComponent(provincia)}&max=1000&orden=nombre`
                );

                if (!response.ok) {
                    throw new Error("No se pudieron cargar las localidades.");
                }

                const data = await response.json();

                data.localidades.forEach(loc => {
                    const option = document.createElement("option");
                    option.value = loc.nombre;
                    option.textContent = loc.nombre;
                    ddlLocalidad.appendChild(option);
                });

                // Restaurar localidad guardada
                if (restaurar && localidadGuardada) {
                    ddlLocalidad.value = localidadGuardada;
                    hfLocalidad.value = ddlLocalidad.value;
                }

            } catch (error) {
                console.error("Error al cargar localidades:", error);
            }
        }


        // Guardar ubicación antes de enviar el formulario
        function guardarUbicacion() {
            const provincia = document.getElementById("ddlProvincia").value;
            const localidad = document.getElementById("ddlLocalidad").value;

            document.getElementById("hfProvincia").value = provincia;
            document.getElementById("hfLocalidad").value = localidad;

            if (!provincia || !localidad) {
                alert("Por favor, seleccioná una provincia y una localidad.");
                return false;
            }

            return true;
        }


        // Inicialización
        document.addEventListener("DOMContentLoaded", function () {

            const ddlProvincia = document.getElementById("ddlProvincia");
            const ddlLocalidad = document.getElementById("ddlLocalidad");

            ddlProvincia.addEventListener("change", function () {
                cargarLocalidades(false);
            });

            ddlLocalidad.addEventListener("change", function () {
                document.getElementById("hfLocalidad").value = this.value;
            });

            cargarProvincias();
        });

    </script>

</asp:Content>
