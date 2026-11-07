<%@ Page Title="" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="FormaPagoForm.aspx.cs" Inherits="Web.FormaPagoForm" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Formulario de Forma de Pago</h2>
    <hr />
    
    <div class="row">
        <div class="col-md-6">
            
            <div class="mb-3">
                <label for="txtDescripcion" class="form-label">Descripción:</label>
                <asp:TextBox ID="txtDescripcion" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                
                <!-- Validacion -->
                <asp:RequiredFieldValidator ID="rfvDescripcion" runat="server" ControlToValidate="txtDescripcion" 
                    ErrorMessage="La descripción es obligatoria" CssClass="text-danger" Display="Dynamic">
                </asp:RequiredFieldValidator>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger fw-bold mt-2 d-block" Visible="false"></asp:Label>
            </div>
            
            <div class="mb-3">
                <asp:CheckBox ID="chkActiva" runat="server" Text=" Activa (Visible para los clientes)" Checked="true" />
            </div>

            <div class="mb-3 mt-4">
                <asp:Button ID="btnGuardar" runat="server" Text="Guardar" CssClass="btn btn-primary me-2" OnClick="btnGuardar_Click" />
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="btn btn-secondary" OnClick="btnCancelar_Click" CausesValidation="false" />
            </div>

        </div>
    </div>
</asp:Content>