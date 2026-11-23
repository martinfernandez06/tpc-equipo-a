<%@ Page Title="Formas de Entrega" Language="C#" MasterPageFile="~/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="AdminFormasEntrega.aspx.cs" Inherits="Web.AdminFormasEntrega" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:UpdatePanel ID="upFormasEntrega" runat="server">
        <ContentTemplate>

            <div class="d-flex flex-wrap align-items-center gap-2 mb-3">
                <h1 class="h3 m-0 me-auto">Formas de entrega</h1>

                <asp:DropDownList ID="ddlFiltro" runat="server" CssClass="form-select input-admin w-auto"
                    AutoPostBack="true" OnSelectedIndexChanged="ddlFiltro_SelectedIndexChanged">
                    <asp:ListItem Text="Todas" Value="Todos"></asp:ListItem>
                    <asp:ListItem Text="Activas" Value="Activos"></asp:ListItem>
                    <asp:ListItem Text="Inactivas" Value="Inactivos"></asp:ListItem>
                </asp:DropDownList>

                <a href="FormaEntregaForm.aspx" class="btn btn-ecommerce-primario">
                    <i class="bi bi-plus-lg me-1"></i>Nueva
                </a>
            </div>

            <div class="table-responsive">
                <asp:GridView ID="dgvFormasEntrega" runat="server"
                    CssClass="table table-striped table-bordered align-middle tabla-admin"
                    AutoGenerateColumns="false"
                    DataKeyNames="Id"
                    EmptyDataText="No se encontraron formas de entrega.">
                    <EmptyDataRowStyle CssClass="text-center text-muted py-4" />
                    <Columns>
                        <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />

                        <asp:TemplateField HeaderText="Dirección" HeaderStyle-Width="160px">
                            <ItemTemplate>
                                <%# (bool)Eval("RequiereDireccion")
                                    ? "<span class='badge bg-light text-dark border'>Requiere</span>"
                                    : "<span class='text-muted small'>No requiere</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Estado" HeaderStyle-Width="120px">
                            <ItemTemplate>
                                <%# (bool)Eval("Activa")
                                    ? "<span class='badge bg-success'>Activa</span>"
                                    : "<span class='badge bg-secondary'>Inactiva</span>" %>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Acciones" HeaderStyle-Width="110px">
                            <ItemTemplate>
                                <a href='<%# "FormaEntregaForm.aspx?id=" + Eval("Id") %>' class="btn btn-sm btn-admin-secundario">
                                    Editar
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>