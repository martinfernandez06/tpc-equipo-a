<%@ Page Title="Formas de Pago" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminFormasPago.aspx.cs" Inherits="Web.AdminFormasPago" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<h2>Administración de Formas de Pago</h2>
    <hr />
    
<div class="row mb-3 align-items-center">
        <div class="col-md-6">
            <asp:Button ID="btnAgregar" runat="server" Text="Agregar Nueva" CssClass="btn btn-primary" OnClick="btnAgregar_Click" />
        </div>
        <div class="col-md-6 text-end">
            <label class="fw-bold me-2">Filtrar:</label>
            <asp:DropDownList ID="ddlFiltro" runat="server" CssClass="form-select d-inline-block w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlFiltro_SelectedIndexChanged">
                <asp:ListItem Text="Todos" Value="Todos"></asp:ListItem>
                <asp:ListItem Text="Activos" Value="Activos"></asp:ListItem>
                <asp:ListItem Text="Inactivos" Value="Inactivos"></asp:ListItem>
            </asp:DropDownList>
        </div>
    </div>

    <asp:GridView ID="dgvFormasPago" runat="server" CssClass="table table-striped table-bordered" AutoGenerateColumns="false" 
        DataKeyNames="Id" OnSelectedIndexChanged="dgvFormasPago_SelectedIndexChanged" OnRowCommand="dgvFormasPago_RowCommand">
        <Columns>
            <asp:BoundField DataField="Id" HeaderText="Id" />
            <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
            <asp:CheckBoxField DataField="Activa" HeaderText="Activa" />
            
            <asp:CommandField ShowSelectButton="true" SelectText="Modificar" ControlStyle-CssClass="btn btn-warning btn-sm" />
            
            <asp:ButtonField ButtonType="Button" CommandName="CambiarEstado" Text="Cambiar Estado" ControlStyle-CssClass="btn btn-info btn-sm" />
        </Columns>
    </asp:GridView>
    </asp:Content>