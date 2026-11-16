
<%@ Page Title="Registro" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="Web.Registro" %>

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
                                    <label for="<%= txtNombre.ClientID %>" class="form-label font-weight-bold">Nombre</label>

                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50" placeholder="Tu nombre" />

                                    <asp:RequiredFieldValidator
                                        ID="rfvNombre"
                                        runat="server"
                                        ControlToValidate="txtNombre"
                                        ErrorMessage="El nombre es obligatorio."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>

                                <!-- Apellido -->
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtApellido.ClientID %>" class="form-label font-weight-bold">Apellido</label>

                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" MaxLength="50" placeholder="Tu apellido" />

                                    <asp:RequiredFieldValidator
                                        ID="rfvApellido"
                                        runat="server"
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

                                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" MaxLength="100" placeholder="ejemplo@correo.com" />
                                </div>

                                <asp:RequiredFieldValidator
                                    ID="rfvEmail"
                                    runat="server"
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="El correo electrónico es obligatorio."
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />

                                <asp:RegularExpressionValidator
                                    ID="revEmail"
                                    runat="server"
                                    ControlToValidate="txtEmail"
                                    ErrorMessage="Ingresá un formato de correo válido."
                                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />
                            </div>

                            <!-- Teléfono -->
                            <div class="mb-3">
                                <label for="<%= txtTelefono.ClientID %>" class="form-label font-weight-bold">Teléfono</label>

                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>

                                    <asp:TextBox ID="txtTelefono" runat="server" CssClass="form-control" MaxLength="30" placeholder="Ej: 1123456789" />
                                </div>

                                <asp:RequiredFieldValidator
                                    ID="rfvTelefono"
                                    runat="server"
                                    ControlToValidate="txtTelefono"
                                    ErrorMessage="El teléfono es obligatorio."
                                    CssClass="text-danger small"
                                    Display="Dynamic"
                                    ValidationGroup="Registro" />
                            </div>

                            <div class="row">
                                <!-- Contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtPassword.ClientID %>" class="form-label font-weight-bold">Contraseña</label>

                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>

                                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" placeholder="••••••••" />
                                    </div>

                                    <asp:RequiredFieldValidator
                                        ID="rfvPassword"
                                        runat="server"
                                        ControlToValidate="txtPassword"
                                        ErrorMessage="La contraseña es obligatoria."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>

                                <!-- Confirmar Contraseña -->
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtConfirmPassword.ClientID %>" class="form-label font-weight-bold">Repetir Contraseña</label>

                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-lock"></i></span>

                                        <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="form-control" MaxLength="50" placeholder="••••••••" />
                                    </div>

                                    <asp:RequiredFieldValidator
                                        ID="rfvConfirm"
                                        runat="server"
                                        ControlToValidate="txtConfirmPassword"
                                        ErrorMessage="Debés repetir la contraseña."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />

                                    <asp:CompareValidator
                                        ID="cvPassword"
                                        runat="server"
                                        ControlToValidate="txtConfirmPassword"
                                        ControlToCompare="txtPassword"
                                        Operator="Equal"
                                        ErrorMessage="Las contraseñas no coinciden."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>
                            </div>

                            <!-- Mensaje de error -->
                            <div class="mb-3">
                                <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold" Visible="false" />
                            </div>

                            <hr class="my-4">

                            <h5 class="fw-bold mb-3 text-primary">Dirección de Envío / Domicilio</h5>

                            <div class="row">
                                <!-- Calle -->
                                <div class="col-md-8 mb-3">
                                    <label for="<%= txtCalle.ClientID %>" class="form-label font-weight-bold">Calle</label>

                                    <asp:TextBox ID="txtCalle" runat="server" CssClass="form-control" MaxLength="100" placeholder="Ej: Av. Corrientes" />

                                    <asp:RequiredFieldValidator
                                        ID="rfvCalle"
                                        runat="server"
                                        ControlToValidate="txtCalle"
                                        ErrorMessage="La calle es obligatoria."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>

                                <!-- Número -->
                                <div class="col-md-4 mb-3">
                                    <label for="<%= txtNumero.ClientID %>" class="form-label font-weight-bold">Número</label>

                                    <asp:TextBox ID="txtNumero" runat="server" CssClass="form-control" MaxLength="20" placeholder="Ej: 1234" />

                                    <asp:RequiredFieldValidator
                                        ID="rfvNumero"
                                        runat="server"
                                        ControlToValidate="txtNumero"
                                        ErrorMessage="El número es obligatorio."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>
                            </div>

                            <div class="row">
                                <!-- Provincia -->
                                <div class="col-md-6 mb-3">
                                    <label for="ddlProvincia" class="form-label font-weight-bold">Provincia</label>

                                    <select id="ddlProvincia" class="form-select">
                                        <option value="">Seleccione provincia...</option>
                                    </select>

                                    <asp:HiddenField ID="hfProvincia" runat="server" />
                                </div>

                                <!-- Localidad -->
                                <div class="col-md-6 mb-3">
                                    <label for="ddlLocalidad" class="form-label font-weight-bold">Localidad / Municipio</label>

                                    <select id="ddlLocalidad" class="form-select">
                                        <option value="">Seleccione localidad...</option>
                                    </select>

                                    <asp:HiddenField ID="hfLocalidad" runat="server" />
                                </div>
                            </div>

                            <div class="row">
                                <!-- Código Postal -->
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtCodigoPostal.ClientID %>" class="form-label font-weight-bold">Código Postal</label>

                                    <asp:TextBox ID="txtCodigoPostal" runat="server" CssClass="form-control" MaxLength="20" placeholder="Ej: 1414" />

                                    <asp:RequiredFieldValidator
                                        ID="rfvCP"
                                        runat="server"
                                        ControlToValidate="txtCodigoPostal"
                                        ErrorMessage="El código postal es obligatorio."
                                        CssClass="text-danger small"
                                        Display="Dynamic"
                                        ValidationGroup="Registro" />
                                </div>

                                <!-- Observaciones -->
                                <div class="col-md-6 mb-3">
                                    <label for="<%= txtObservaciones.ClientID %>" class="form-label font-weight-bold">Observaciones (Opcional)</label>

                                    <asp:TextBox ID="txtObservaciones" runat="server" CssClass="form-control" MaxLength="255" placeholder="Ej: Piso 3, depto B" />
                                </div>
                            </div>

                            <!-- Script Georef -->
                            <script>

document.addEventListener("DOMContentLoaded", function () {

    const ddlProvincia = document.getElementById("ddlProvincia");
    const ddlLocalidad = document.getElementById("ddlLocalidad");

    const hfProvincia = document.getElementById("<%= hfProvincia.ClientID %>");
    const hfLocalidad = document.getElementById("<%= hfLocalidad.ClientID %>");

    // 1. Cargar provincias
    fetch("https://apis.datos.gob.ar/georef/api/provincias?campos=id,nombre&orden=nombre")
        .then(response => {
            if (!response.ok) {
                throw new Error("Error al consultar las provincias.");
            }
            return response.json();
        })
        .then(data => {

            ddlProvincia.innerHTML = '<option value="">Seleccione una provincia...</option>';

            data.provincias.forEach(provincia => {
                const option = document.createElement("option");

                // El value es el ID que necesita la API
                option.value = provincia.id;

                // El usuario ve el nombre
                option.textContent = provincia.nombre;

                // Guardamos también el nombre para la base de datos
                option.dataset.nombre = provincia.nombre;

                ddlProvincia.appendChild(option);
            });

        })
        .catch(error => {
            console.error(error);
            ddlProvincia.innerHTML = '<option value="">Error al cargar provincias</option>';
        });

    // 2. Cuando se selecciona una provincia
    ddlProvincia.addEventListener("change", function () {

        const provinciaId = ddlProvincia.value;
        const provinciaNombre = ddlProvincia.selectedOptions[0]?.dataset.nombre || "";

        hfProvincia.value = provinciaNombre;
        hfLocalidad.value = "";

        ddlLocalidad.innerHTML = '<option value="">Cargando municipios...</option>';
        ddlLocalidad.disabled = true;

        if (!provinciaId) {
            ddlLocalidad.innerHTML = '<option value="">Primero seleccioná una provincia</option>';
            return;
        }

        cargarMunicipios(provinciaId);
    });

    // 3. Cuando se selecciona un municipio
    ddlLocalidad.addEventListener("change", function () {
        hfLocalidad.value = ddlLocalidad.value;
    });

    // 4. Consultar municipios según la provincia
    function cargarMunicipios(provinciaId) {

        const url = "https://apis.datos.gob.ar/georef/api/municipios"
            + "?provincia=" + encodeURIComponent(provinciaId)
            + "&campos=id,nombre"
            + "&max=5000"
            + "&orden=nombre";

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Error al consultar los municipios.");
                }
                return response.json();
            })
            .then(data => {

                ddlLocalidad.innerHTML = "";

                if (!data.municipios || data.municipios.length === 0) {
                    ddlLocalidad.innerHTML = '<option value="">No se encontraron municipios</option>';
                    return;
                }

                const opcionInicial = document.createElement("option");
                opcionInicial.value = "";
                opcionInicial.textContent = "Seleccione un municipio...";
                ddlLocalidad.appendChild(opcionInicial);

                data.municipios.forEach(municipio => {
                    const option = document.createElement("option");
                    option.value = municipio.nombre;
                    option.textContent = municipio.nombre;
                    ddlLocalidad.appendChild(option);
                });

                ddlLocalidad.disabled = false;

            })
            .catch(error => {
                console.error(error);
                ddlLocalidad.innerHTML = '<option value="">Error al cargar municipios</option>';
                ddlLocalidad.disabled = true;
            });
    }

});

document.addEventListener("DOMContentLoaded", function () {

    const ddlProvincia = document.getElementById("ddlProvincia");
    const ddlLocalidad = document.getElementById("ddlLocalidad");

    const hfProvincia = document.getElementById("<%= hfProvincia.ClientID %>");
    const hfLocalidad = document.getElementById("<%= hfLocalidad.ClientID %>");

    // 1. Cargar provincias
    fetch("https://apis.datos.gob.ar/georef/api/provincias?campos=id,nombre&orden=nombre")
        .then(response => {
            if (!response.ok) {
                throw new Error("Error al consultar las provincias.");
            }
            return response.json();
        })
        .then(data => {

            ddlProvincia.innerHTML = '<option value="">Seleccione una provincia...</option>';

            data.provincias.forEach(provincia => {
                const option = document.createElement("option");

                // El value es el ID que necesita la API
                option.value = provincia.id;

                // El usuario ve el nombre
                option.textContent = provincia.nombre;

                // Guardamos también el nombre para la base de datos
                option.dataset.nombre = provincia.nombre;

                ddlProvincia.appendChild(option);
            });

        })
        .catch(error => {
            console.error(error);
            ddlProvincia.innerHTML = '<option value="">Error al cargar provincias</option>';
        });

    // 2. Cuando se selecciona una provincia
    ddlProvincia.addEventListener("change", function () {

        const provinciaId = ddlProvincia.value;
        const provinciaNombre = ddlProvincia.selectedOptions[0]?.dataset.nombre || "";

        hfProvincia.value = provinciaNombre;
        hfLocalidad.value = "";

        ddlLocalidad.innerHTML = '<option value="">Cargando municipios...</option>';
        ddlLocalidad.disabled = true;

        if (!provinciaId) {
            ddlLocalidad.innerHTML = '<option value="">Primero seleccioná una provincia</option>';
            return;
        }

        cargarMunicipios(provinciaId);
    });

    // 3. Cuando se selecciona un municipio
    ddlLocalidad.addEventListener("change", function () {
        hfLocalidad.value = ddlLocalidad.value;
    });

    // 4. Consultar municipios según la provincia
    function cargarMunicipios(provinciaId) {

        const url = "https://apis.datos.gob.ar/georef/api/municipios"
            + "?provincia=" + encodeURIComponent(provinciaId)
            + "&campos=id,nombre"
            + "&max=5000"
            + "&orden=nombre";

        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error("Error al consultar los municipios.");
                }
                return response.json();
            })
            .then(data => {

                ddlLocalidad.innerHTML = "";

                if (!data.municipios || data.municipios.length === 0) {
                    ddlLocalidad.innerHTML = '<option value="">No se encontraron municipios</option>';
                    return;
                }

                const opcionInicial = document.createElement("option");
                opcionInicial.value = "";
                opcionInicial.textContent = "Seleccione un municipio...";
                ddlLocalidad.appendChild(opcionInicial);

                data.municipios.forEach(municipio => {
                    const option = document.createElement("option");
                    option.value = municipio.nombre;
                    option.textContent = municipio.nombre;
                    ddlLocalidad.appendChild(option);
                });

                ddlLocalidad.disabled = false;

            })
            .catch(error => {
                console.error(error);
                ddlLocalidad.innerHTML = '<option value="">Error al cargar municipios</option>';
                ddlLocalidad.disabled = true;
            });
    }

});

                            </script>

                            <!-- Botón Registrarse -->
                            <div class="d-grid gap-2 mt-4">
                                <asp:Button
                                    ID="btnRegistrar"
                                    runat="server"
                                    Text="Registrarse"
                                    CssClass="btn btn-primary btn-lg fw-bold"
                                    OnClick="btnRegistrar_Click"
                                    ValidationGroup="Registro" />
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
