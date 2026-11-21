
<%@ Page Title="Confirmar correo electrónico" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ConfirmarEmail.aspx.cs" Inherits="Web.ConfirmarEmail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">

                <div class="card border-0 shadow-sm rounded-4">
                    <div class="card-body text-center p-5">

                        <div class="mb-4">
                            <i class="bi bi-envelope-check text-primary" style="font-size: 3rem;"></i>
                        </div>

                        <h2 class="fw-bold mb-3">Confirmación de correo</h2>

                        <asp:Label
                            ID="lblMensaje"
                            runat="server"
                            CssClass="d-block text-muted mb-4"
                            Text="Estamos verificando tu correo electrónico..." />

                        <asp:HyperLink
                            ID="lnkLogin"
                            runat="server"
                            NavigateUrl="~/Login.aspx"
                            CssClass="btn btn-primary px-4 rounded-pill"
                            Visible="false">
                            Ir al inicio de sesión
                        </asp:HyperLink>

                    </div>
                </div>

            </div>
        </div>
    </div>

</asp:Content>
