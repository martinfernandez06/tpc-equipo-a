<%@ Page Title="Categorias" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminCategorias.aspx.cs" Inherits="Web.AdminCategorias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Todas las categorias</h1>
    <asp:UpdatePanel ID="upCategorias" runat="server">
        <ContentTemplate>
            <div class="mb-3">
                <asp:Label ID="lblFiltro" runat="server" Text="Buscar por nombre"></asp:Label>
                <asp:TextBox ID="txtFiltro" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged" runat="server"></asp:TextBox>
                <asp:Label ID="lblAviso" runat="server" Text="" CssClass="text-danger"></asp:Label>
                <asp:DropDownList ID="ddlEstado" CssClass="form-select" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged">
                    <asp:ListItem Text="Todas" />
                    <asp:ListItem Text="Activas" />
                    <asp:ListItem Text="Inactivas" />
                </asp:DropDownList>
                <a href="~/FormularioCategoria" class="btn btn-primary" runat="server">Nueva</a>
            </div>
            <div class="row">
                <div class="col-md-8">
                    <asp:GridView ID="dgvCategorias" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false" DataKeyNames="Id" OnSelectedIndexChanged="dgvCategorias_SelectedIndexChanged" OnPageIndexChanging="dgvCategorias_PageIndexChanging" AllowPaging="true" PageSize="10" EmptyDataText="No se encontraron categorias">
                        <Columns>
                            <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
                            <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
                            <asp:CheckBoxField HeaderText="Activa" DataField="Activa" />
                            <asp:CommandField HeaderText="Accion" ShowSelectButton="true" ButtonType="Button" SelectText="Editar" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
