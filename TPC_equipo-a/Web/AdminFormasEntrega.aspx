<%@ Page Title="Formas de Entrega" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminFormasEntrega.aspx.cs" Inherits="Web.AdminFormasEntrega" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
        <h1 class="h3 m-0 me-auto">Formas de Entrega</h1>
        
        <asp:DropDownList ID="ddlFiltro" runat="server" CssClass="form-select w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltro_SelectedIndexChanged">
            <asp:ListItem Text="Todas" Value="Todos"></asp:ListItem>
            <asp:ListItem Text="Activas" Value="Activos"></asp:ListItem>
            <asp:ListItem Text="Inactivas" Value="Inactivos"></asp:ListItem>
        </asp:DropDownList>
        
        <asp:LinkButton ID="btnAgregar" runat="server" CssClass="btn btn-primary" OnClick="btnAgregar_Click">
            <i class="bi bi-plus-lg me-1"></i>Nueva
        </asp:LinkButton>
    </div>

    <hr class="mb-3" />

    <div class="table-responsive">
        <asp:GridView ID="dgvFormasEntrega" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false" 
            DataKeyNames="Id" OnSelectedIndexChanged="dgvFormasEntrega_SelectedIndexChanged" EmptyDataText="No hay registros cargados.">
            <Columns>
                <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                <asp:CheckBoxField DataField="RequiereDireccion" HeaderText="Pide Dirección" />
                <asp:CheckBoxField DataField="Activa" HeaderText="Activa" />
                
                <asp:CommandField HeaderText="Accion" ShowSelectButton="true" ButtonType="Button" SelectText="Editar" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>