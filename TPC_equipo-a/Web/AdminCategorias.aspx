<%@ Page Title="Categorias" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminCategorias.aspx.cs" Inherits="Web.AdminCategorias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upCategorias" runat="server">
        <ContentTemplate>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                <h1 class="h3 m-0 me-auto">Categorías</h1>
                <asp:TextBox ID="txtFiltro" placeholder="Buscar por nombre" CssClass="form-control w-auto" AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged" runat="server"></asp:TextBox>
                <asp:DropDownList ID="ddlEstado" CssClass="form-select w-auto" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged">
                    <asp:ListItem Text="Todas" />
                    <asp:ListItem Text="Activas" />
                    <asp:ListItem Text="Inactivas" />
                </asp:DropDownList>
                <asp:Button ID="btnLimpiarFiltro" runat="server" OnClick="btnLimpiarFiltro_Click" CssClass="btn btn-outline-secondary" Text="Limpiar filtro" />
                <a href="~/FormularioCategoria" class="btn btn-primary" runat="server"><i class="bi bi-plus-lg me-1"></i>Nueva</a>
            </div>

            <hr class="mb-4" />

            <asp:Label ID="lblAviso" runat="server" Text="" CssClass="text-danger d-block mb-2"></asp:Label>
            <div class="table-responsive">
                <asp:GridView ID="dgvCategorias" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false" DataKeyNames="Id" OnSelectedIndexChanged="dgvCategorias_SelectedIndexChanged" OnPageIndexChanging="dgvCategorias_PageIndexChanging" AllowPaging="true" PageSize="8" EmptyDataText="No se encontraron categorias">
                    <Columns>
                        <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
                        <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
                        <asp:CheckBoxField HeaderText="Activa" DataField="Activa" />
                        <asp:CommandField HeaderText="Accion" ShowSelectButton="true" ButtonType="Button" SelectText="Editar" />
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
