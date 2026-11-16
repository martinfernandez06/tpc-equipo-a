<%@ Page Title="Categorias" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminCategorias.aspx.cs" Inherits="Web.AdminCategorias" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:UpdatePanel ID="upCategorias" runat="server">
        <ContentTemplate>
            <%-- titulo a la izquierda y nueva a la derecha --%>
            <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                <h1 class="h3 m-0 me-auto">Categorías</h1>
                <a href="~/FormularioCategoria" class="btn btn-ecommerce-primario" runat="server"><i class="bi bi-plus-lg me-1"></i>Nueva</a>
            </div>

            <%-- barra de filtros, filtra sola al escribir o elegir porque trabaja con la lista en session --%>
            <div class="card card-admin mb-3">
                <div class="card-body">
                    <div class="row g-2 align-items-end">
                        <div class="col-md-5">
                            <div class="dato-titulo">Nombre</div>
                            <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control input-admin" placeholder="Buscar por nombre" AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged" />
                        </div>
                        <div class="col-md-3">
                            <div class="dato-titulo">Estado</div>
                            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select input-admin" AutoPostBack="true" OnSelectedIndexChanged="ddlEstado_SelectedIndexChanged">
                                <asp:ListItem Text="Todas" />
                                <asp:ListItem Text="Activas" />
                                <asp:ListItem Text="Inactivas" />
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-auto">
                            <asp:Button ID="btnLimpiarFiltro" runat="server" Text="Limpiar" CssClass="btn btn-admin-secundario" OnClick="btnLimpiarFiltro_Click" />
                        </div>
                    </div>
                    <%-- aviso en rojo cuando escribe una sola letra --%>
                    <div class="mt-2">
                        <asp:Label ID="lblAviso" runat="server" Text="" CssClass="text-danger small"></asp:Label>
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <asp:GridView ID="dgvCategorias" runat="server" CssClass="table table-striped table-bordered align-middle tabla-admin" AutoGenerateColumns="false" DataKeyNames="Id" OnSelectedIndexChanged="dgvCategorias_SelectedIndexChanged" OnPageIndexChanging="dgvCategorias_PageIndexChanging" AllowPaging="true" PageSize="10" PagerStyle-CssClass="paginado-admin" EmptyDataText="No se encontraron categorias">
                    <Columns>
                        <asp:BoundField HeaderText="Nombre" DataField="Nombre" />
                        <asp:BoundField HeaderText="Descripción" DataField="Descripcion" />
                        <%-- badge verde si esta activa y gris si no, el ternario elige la clase y el texto --%>
                        <asp:TemplateField HeaderText="Estado" HeaderStyle-Width="120px">
                            <ItemTemplate>
                                <span class='<%# (bool)Eval("Activa") ? "badge bg-success" : "badge bg-secondary" %>'>
                                    <%# (bool)Eval("Activa") ? "Activa" : "Inactiva" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:CommandField HeaderText="Accion" ShowSelectButton="true" ButtonType="Button" ControlStyle-CssClass="btn btn-sm btn-ecommerce-primario" SelectText="Editar" HeaderStyle-Width="110px" />
                    </Columns>
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>