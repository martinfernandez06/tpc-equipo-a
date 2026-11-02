<%@ Page Title="Categorias" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminCategorias.aspx.cs" Inherits="Web.AdminCategorias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Todas las categorias</h1>
    <div class="mb-3">
        <a href="~/FormularioCategoria" class="btn btn-primary" runat="server">Nueva</a>
    </div>
    <div class="row">
        <div class="col-md-8">
            <asp:GridView ID="dgvCategorias" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false" DataKeyNames="Id" OnSelectedIndexChanged="dgvCategorias_SelectedIndexChanged">
                <Columns>
                    <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
                    <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
                    <asp:CheckBoxField HeaderText="Activa" DataField="Activa" />
                    <asp:CommandField HeaderText="Accion" ShowSelectButton="true" ButtonType="Button" SelectText="Editar" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
