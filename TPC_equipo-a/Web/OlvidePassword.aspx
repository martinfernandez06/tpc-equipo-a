<%@ Page Title="Recuperar contraseña" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OlvidePassword.aspx.cs" Inherits="Web.OlvidePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">

                <div class="card shadow-sm border-0">
                    <div class="card-body p-4 p-md-5">

                        <div class="text-center mb-4">
                            <i class="bi bi-key-fill fs-1 text-primary"></i>

                            <h2 class="fw-bold mt-3">
                                Recuperar contraseña
                            </h2>

                            <p class="text-muted">
                                Ingresá tu correo electrónico y te enviaremos un enlace
                                para restablecer tu contraseña.
                            </p>
                        </div>

                        <asp:Panel ID="pnlFormulario"
                            runat="server">

                            <div class="mb-3">

                                <label for="<%= txtEmail.ClientID %>"
                                    class="form-label fw-semibold">
                                    Correo electrónico
                                </label>

                                <asp:TextBox
                                    ID="txtEmail"
                                    runat="server"
                                    TextMode="Email"
                                    CssClass="form-control"
                                    MaxLength="100"
                                    placeholder="ejemplo@correo.com" />

                                <asp:RequiredFieldValidator
                                    ID="rfvEmail"
                                    runat="server"
                                    ControlToValidate="txtEmail"
                                    ValidationGroup="Recuperacion"
                                    CssClass="text-danger small"
                                    ErrorMessage="Ingresá tu correo electrónico."
                                    Display="Dynamic" />

                                <asp:RegularExpressionValidator
                                    ID="revEmail"
                                    runat="server"
                                    ControlToValidate="txtEmail"
                                    ValidationGroup="Recuperacion"
                                    CssClass="text-danger small"
                                    ErrorMessage="Ingresá un correo electrónico válido."
                                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                    Display="Dynamic" />

                            </div>

                            <asp:Label
                                ID="lblError"
                                runat="server"
                                CssClass="text-danger fw-bold"
                                Visible="false" />

                            <div class="d-grid mt-4">

                                <asp:Button
                                    ID="btnEnviar"
                                    runat="server"
                                    Text="Enviar enlace"
                                    CssClass="btn btn-primary btn-lg fw-bold"
                                    ValidationGroup="Recuperacion"
                                    OnClick="btnEnviar_Click" />

                            </div>

                        </asp:Panel>

                        <asp:Panel
                            ID="pnlExito"
                            runat="server"
                            Visible="false">

                            <div class="text-center">

                                <i class="bi bi-envelope-check-fill fs-1 text-success"></i>

                                <h4 class="fw-bold mt-3">
                                    Revisá tu correo
                                </h4>

                                <p class="text-muted">
                                    Si existe una cuenta con ese correo electrónico,
                                    te enviamos un enlace para restablecer tu contraseña.
                                </p>

                            </div>

                        </asp:Panel>

                        <div class="text-center mt-4">

                            <a href="Login.aspx"
                               class="text-decoration-none">
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