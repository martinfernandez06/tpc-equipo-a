<%@ Page Title="Mi perfil" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MiPerfil.aspx.cs" Inherits="Web.MiPerfil" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        /* Checkbox de dirección principal sin recuadro envolvente */
        .checkbox-principal input[type="checkbox"] {
            width: 1em;
            height: 1em;
            margin-top: 0.25em;
            margin-left: -1.5em;
            vertical-align: top;
            background-color: #fff;
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain;
            border: 1px solid rgba(0, 0, 0, .25);
            border-radius: 0.25em;
            appearance: none;
            -webkit-appearance: none;
            box-shadow: none !important;
            outline: none !important;
        }

        .checkbox-principal input[type="checkbox"]:checked {
            background-color: #0d6efd;
            border-color: #0d6efd;
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'%3e%3cpath fill='none' stroke='%23fff' stroke-linecap='round' stroke-linejoin='round' stroke-width='3' d='m6 10 3 3 6-6'/%3e%3c/svg%3e");
        }

        .checkbox-principal input[type="checkbox"]:focus {
            box-shadow: none !important;
        }

        /* Mensajes de validación */
        .validator-error {
            display: block;
            color: #dc3545;
            font-size: 0.875rem;
            margin-top: 4px;
        }
    </style>

    <div class="container py-4">

        <div class="mb-4">
            <h2>Mi perfil</h2>
            <p class="text-muted">Administrá tus datos personales y tus direcciones de entrega.</p>
        </div>

        <%-- MENSAJES GENERALES --%>

        <asp:Panel ID="pnlMensaje" runat="server" Visible="false" CssClass="alert mb-4">
            <asp:Label ID="lblMensaje" runat="server"></asp:Label>
        </asp:Panel>

        <%-- DATOS PERSONALES --%>

        <div class="card shadow-sm mb-4">

            <div class="card-header">
                <h4 class="mb-0">Datos personales</h4>
            </div>

            <div class="card-body">

                <div class="row g-3">

                    <div class="col-md-6">
                        <label class="form-label" for="<%= txtNombre.ClientID %>">Nombre</label>

                        <asp:TextBox ID="txtNombre" runat="server"
                            CssClass="form-control"
                            MaxLength="100"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server"
                            ControlToValidate="txtNombre"
                            ErrorMessage="El nombre es obligatorio."
                            Text="El nombre es obligatorio."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Perfil" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label" for="<%= txtApellido.ClientID %>">Apellido</label>

                        <asp:TextBox ID="txtApellido" runat="server"
                            CssClass="form-control"
                            MaxLength="100"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvApellido" runat="server"
                            ControlToValidate="txtApellido"
                            ErrorMessage="El apellido es obligatorio."
                            Text="El apellido es obligatorio."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Perfil" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label" for="<%= txtEmail.ClientID %>">Correo electrónico</label>

                        <asp:TextBox ID="txtEmail" runat="server"
                            CssClass="form-control"
                            TextMode="Email"
                            MaxLength="150"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server"
                            ControlToValidate="txtEmail"
                            ErrorMessage="El correo electrónico es obligatorio."
                            Text="El correo electrónico es obligatorio."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Perfil" />

                        <asp:RegularExpressionValidator ID="revEmail" runat="server"
                            ControlToValidate="txtEmail"
                            ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                            ErrorMessage="Ingresá un correo electrónico válido."
                            Text="Ingresá un correo electrónico válido."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Perfil" />
                    </div>

                    <div class="col-md-6">
                        <label class="form-label" for="<%= txtTelefono.ClientID %>">Teléfono</label>

                        <asp:TextBox ID="txtTelefono" runat="server"
                            CssClass="form-control"
                            MaxLength="30"></asp:TextBox>
                    </div>

                </div>

                <div class="mt-4">
                    <asp:Button ID="btnGuardarPerfil" runat="server"
                        Text="Guardar cambios"
                        CssClass="btn btn-ecommerce-primario"
                        ValidationGroup="Perfil"
                        OnClick="btnGuardarPerfil_Click" />
                </div>

            </div>
        </div>

        <%-- DIRECCIONES --%>

        <div class="card shadow-sm mb-4">

            <div class="card-header d-flex justify-content-between align-items-center flex-wrap gap-2">
                <h4 class="mb-0">Mis direcciones</h4>

                <asp:Button ID="btnNuevaDireccion" runat="server"
                    Text="Agregar dirección"
                    CssClass="btn btn-ecommerce-primario"
                    CausesValidation="false"
                    OnClick="btnNuevaDireccion_Click" />
            </div>

            <div class="card-body">

                <p class="text-muted">
                    Podés administrar tus direcciones de entrega y elegir cuál querés utilizar como principal.
                </p>

                <asp:GridView ID="gvDirecciones" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="table table-hover align-middle"
                    GridLines="None"
                    DataKeyNames="Id"
                    EmptyDataText="Todavía no tenés direcciones registradas."
                    OnRowCommand="gvDirecciones_RowCommand">

                    <Columns>

                        <asp:BoundField DataField="Calle" HeaderText="Calle" />
                        <asp:BoundField DataField="Numero" HeaderText="Número" />
                        <asp:BoundField DataField="Localidad" HeaderText="Localidad" />
                        <asp:BoundField DataField="Provincia" HeaderText="Provincia" />
                        <asp:BoundField DataField="CodigoPostal" HeaderText="Código postal" />

                        <asp:TemplateField HeaderText="Observaciones">
                            <ItemTemplate>
                                <%# Eval("Observaciones") %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Principal">
                            <ItemTemplate>
                                <asp:Label ID="lblPrincipal" runat="server"
                                    Visible='<%# Convert.ToBoolean(Eval("Principal")) %>'
                                    Text="Principal"
                                    CssClass="badge bg-success">
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Acciones">
                            <ItemTemplate>

                                <div class="d-flex flex-wrap gap-1">

                                    <asp:LinkButton ID="btnEditarDireccion" runat="server"
                                        Text="Editar"
                                        CssClass="btn btn-sm btn-outline-primary"
                                        CommandName="EditarDireccion"
                                        CommandArgument='<%# Eval("Id") %>'
                                        CausesValidation="false" />

                                    <asp:LinkButton ID="btnMarcarPrincipal" runat="server"
                                        Text="Hacer principal"
                                        CssClass="btn btn-sm btn-outline-success"
                                        CommandName="MarcarPrincipal"
                                        CommandArgument='<%# Eval("Id") %>'
                                        CausesValidation="false"
                                        Visible='<%# !Convert.ToBoolean(Eval("Principal")) %>' />

                                    <asp:LinkButton ID="btnDesactivarDireccion" runat="server"
                                        Text="Desactivar"
                                        CssClass="btn btn-sm btn-outline-danger"
                                        CommandName="DesactivarDireccion"
                                        CommandArgument='<%# Eval("Id") %>'
                                        CausesValidation="false"
                                        OnClientClick="return confirm('¿Estás seguro de que querés desactivar esta dirección?');" />

                                </div>

                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                </asp:GridView>

            </div>
        </div>

        <%-- AGREGAR O EDITAR DIRECCIÓN --%>

        <asp:Panel ID="pnlFormularioDireccion" runat="server"
            Visible="false"
            CssClass="card shadow-sm mb-4">

            <div class="card-header">
                <h4 class="mb-0">
                    <asp:Label ID="lblTituloDireccion" runat="server"
                        Text="Nueva dirección"></asp:Label>
                </h4>
            </div>

            <div class="card-body">

                <asp:HiddenField ID="hfIdDireccion" runat="server" Value="0" />

                <div class="row g-3">

                    <%-- CALLE Y NÚMERO --%>

                    <div class="col-md-4">
                        <label class="form-label" for="<%= txtCalle.ClientID %>">Calle</label>

                        <asp:TextBox ID="txtCalle" runat="server"
                            CssClass="form-control"
                            MaxLength="150"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvCalle" runat="server"
                            ControlToValidate="txtCalle"
                            ErrorMessage="La calle es obligatoria."
                            Text="La calle es obligatoria."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Direccion" />
                    </div>

                    <div class="col-md-8">
                        <label class="form-label" for="<%= txtNumero.ClientID %>">Número</label>

                        <asp:TextBox ID="txtNumero" runat="server"
                            CssClass="form-control"
                            MaxLength="20"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvNumero" runat="server"
                            ControlToValidate="txtNumero"
                            ErrorMessage="El número es obligatorio."
                            Text="El número es obligatorio."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Direccion" />
                    </div>

                    <%-- LOCALIDAD Y PROVINCIA --%>

                    <div class="col-md-4">
                        <label class="form-label" for="<%= txtLocalidad.ClientID %>">Localidad</label>

                        <asp:TextBox ID="txtLocalidad" runat="server"
                            CssClass="form-control"
                            MaxLength="100"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvLocalidad" runat="server"
                            ControlToValidate="txtLocalidad"
                            ErrorMessage="La localidad es obligatoria."
                            Text="La localidad es obligatoria."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Direccion" />
                    </div>

                    <div class="col-md-8">
                        <label class="form-label" for="<%= txtProvincia.ClientID %>">Provincia</label>

                        <asp:TextBox ID="txtProvincia" runat="server"
                            CssClass="form-control"
                            MaxLength="100"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvProvincia" runat="server"
                            ControlToValidate="txtProvincia"
                            ErrorMessage="La provincia es obligatoria."
                            Text="La provincia es obligatoria."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Direccion" />
                    </div>

                    <%-- CÓDIGO POSTAL Y OBSERVACIONES --%>

                    <div class="col-md-4">
                        <label class="form-label" for="<%= txtCodigoPostal.ClientID %>">Código postal</label>

                        <asp:TextBox ID="txtCodigoPostal" runat="server"
                            CssClass="form-control"
                            MaxLength="15"></asp:TextBox>

                        <asp:RequiredFieldValidator ID="rfvCodigoPostal" runat="server"
                            ControlToValidate="txtCodigoPostal"
                            ErrorMessage="El código postal es obligatorio."
                            Text="El código postal es obligatorio."
                            CssClass="validator-error"
                            Display="Dynamic"
                            ValidationGroup="Direccion" />
                    </div>

                    <div class="col-md-8">
                        <label class="form-label" for="<%= txtObservaciones.ClientID %>">Observaciones</label>

                        <asp:TextBox ID="txtObservaciones" runat="server"
                            CssClass="form-control"
                            MaxLength="250"
                            placeholder="Piso, departamento, entre calles, etc."></asp:TextBox>
                    </div>

                    <%-- DIRECCIÓN PRINCIPAL --%>

                    <div class="col-12">
                        <div class="form-check checkbox-principal">

                            <asp:CheckBox ID="chkPrincipal" runat="server" />

                            <label class="form-check-label" for="<%= chkPrincipal.ClientID %>">
                                Establecer como dirección principal
                            </label>

                        </div>
                    </div>

                </div>

                <div class="mt-4 d-flex gap-2 flex-wrap">

                    <asp:Button ID="btnGuardarDireccion" runat="server"
                        Text="Guardar dirección"
                        CssClass="btn btn-ecommerce-primario"
                        ValidationGroup="Direccion"
                        OnClick="btnGuardarDireccion_Click" />

                    <asp:Button ID="btnCancelarDireccion" runat="server"
                        Text="Cancelar"
                        CssClass="btn btn-outline-secondary"
                        CausesValidation="false"
                        OnClick="btnCancelarDireccion_Click" />

                </div>

            </div>
        </asp:Panel>

    </div>

</asp:Content>