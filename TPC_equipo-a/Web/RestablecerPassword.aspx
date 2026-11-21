
<%@ Page Title="Restablecer contraseña" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RestablecerPassword.aspx.cs" Inherits="Web.RestablecerPassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">

                <div class="card shadow-sm border-0">
                    <div class="card-body p-4 p-md-5">

                        <div class="text-center mb-4">

                            <i class="bi bi-shield-lock-fill fs-1 text-primary"></i>

                            <h2 class="fw-bold mt-3">
                                Nueva contraseña
                            </h2>

                            <p class="text-muted">
                                Ingresá una nueva contraseña para tu cuenta.
                            </p>

                        </div>

                        <asp:Label
                            ID="lblError"
                            runat="server"
                            CssClass="d-block text-danger fw-bold mb-3"
                            Visible="false" />

                        <asp:Panel
                            ID="pnlFormulario"
                            runat="server">

                            <div class="mb-3">

                                <label for="<%= txtPassword.ClientID %>"
                                       class="form-label fw-semibold">
                                    Nueva contraseña
                                </label>

                                <asp:TextBox
                                    ID="txtPassword"
                                    runat="server"
                                    TextMode="Password"
                                    CssClass="form-control"
                                    MaxLength="50"
                                    placeholder="••••••••" />

                                <asp:RequiredFieldValidator
                                    ID="rfvPassword"
                                    runat="server"
                                    ControlToValidate="txtPassword"
                                    ValidationGroup="Password"
                                    CssClass="text-danger small"
                                    ErrorMessage="Ingresá una contraseña."
                                    Display="Dynamic" />

                            </div>

                            <div class="mb-3">

                                <label for="<%= txtConfirmarPassword.ClientID %>"
                                       class="form-label fw-semibold">
                                    Repetir contraseña
                                </label>

                                <asp:TextBox
                                    ID="txtConfirmarPassword"
                                    runat="server"
                                    TextMode="Password"
                                    CssClass="form-control"
                                    MaxLength="50"
                                    placeholder="••••••••" />

                                <asp:RequiredFieldValidator
                                    ID="rfvConfirmarPassword"
                                    runat="server"
                                    ControlToValidate="txtConfirmarPassword"
                                    ValidationGroup="Password"
                                    CssClass="text-danger small"
                                    ErrorMessage="Repetí la contraseña."
                                    Display="Dynamic" />

                                <asp:CompareValidator
                                    ID="cvPassword"
                                    runat="server"
                                    ControlToValidate="txtConfirmarPassword"
                                    ControlToCompare="txtPassword"
                                    ValidationGroup="Password"
                                    CssClass="text-danger small"
                                    ErrorMessage="Las contraseñas no coinciden."
                                    Display="Dynamic" />

                            </div>

                            <div class="d-grid mt-4">

                                <asp:Button
                                    ID="btnGuardar"
                                    runat="server"
                                    Text="Guardar nueva contraseña"
                                    CssClass="btn btn-primary btn-lg fw-bold"
                                    ValidationGroup="Password"
                                    OnClick="btnGuardar_Click" />

                            </div>

                        </asp:Panel>

                        <asp:Panel
                            ID="pnlExito"
                            runat="server"
                            Visible="false">

                            <div class="text-center">

                                <i class="bi bi-check-circle-fill fs-1 text-success"></i>

                                <h4 class="fw-bold mt-3">
                                    Contraseña actualizada
                                </h4>

                                <p class="text-muted">
                                    Tu contraseña fue cambiada correctamente.
                                    Ya podés iniciar sesión.
                                </p>

                                <a href="Login.aspx"
                                   class="btn btn-primary fw-bold mt-2">
                                    Iniciar sesión
                                </a>

                            </div>

                        </asp:Panel>

                        <div class="text-center mt-4">

                            <a href="Login.aspx" class="text-decoration-none">
                                <i class="bi bi-arrow-left me-1"></i>
                                Volver al inicio de sesión
                            </a>

                        </div>

                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
