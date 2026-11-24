using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class AdminProductos : System.Web.UI.Page
    {
        protected global::System.Web.UI.WebControls.TextBox txtFiltroNombre;
        protected global::System.Web.UI.WebControls.TextBox txtFiltroCodigo;
        protected global::System.Web.UI.WebControls.DropDownList ddlFiltroCategoria;
        protected global::System.Web.UI.WebControls.DropDownList ddlFiltroEstado;
        protected global::System.Web.UI.WebControls.Button btnFiltrar;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();

                // Cargar categorias para el filtro
                CategoriaNegocio catNegocio = new CategoriaNegocio();
                ddlFiltroCategoria.DataSource = catNegocio.listarActivas();
                ddlFiltroCategoria.DataTextField = "Nombre";
                ddlFiltroCategoria.DataValueField = "Id";
                ddlFiltroCategoria.DataBind();
                ddlFiltroCategoria.Items.Insert(0, new ListItem("Todas", "0"));
            }
        }

        private void CargarGrilla()
        {
            try
            {
                ProductoNegocio negocio = new ProductoNegocio();
                List<Producto> lista = negocio.Listar();

                // Filtro por Código de Producto
                string filtroCodigo = txtFiltroCodigo != null ? txtFiltroCodigo.Text.Trim() : "";
                if (!string.IsNullOrEmpty(filtroCodigo))
                {
                    lista = lista.FindAll(x => x.Codigo != null && x.Codigo.ToUpper().Contains(filtroCodigo.ToUpper()));
                }

                // Filtro por Nombre
                string filtroNombre = txtFiltroNombre.Text.Trim();
                if (!string.IsNullOrEmpty(filtroNombre))
                {
                    lista = lista.FindAll(x => x.Nombre.ToUpper().Contains(filtroNombre.ToUpper()));
                }

                // Filtro por Categoría
                if (ddlFiltroCategoria.Items.Count > 0)
                {
                    int idCategoria = int.Parse(ddlFiltroCategoria.SelectedValue);
                    if (idCategoria != 0)
                    {
                        lista = lista.FindAll(x => x.Categoria.Id == idCategoria);
                    }
                }

                // Filtro por Estado
                int estado = int.Parse(ddlFiltroEstado.SelectedValue);
                if (estado != -1)
                {
                    bool estadoBool = (estado == 1);
                    lista = lista.FindAll(x => x.Activo == estadoBool);
                }

                repProductos.DataSource = lista;
                repProductos.DataBind();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error al listar los productos: " + ex.Message);
            }
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            CargarGrilla();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtFiltroNombre.Text = "";
            if (txtFiltroCodigo != null) txtFiltroCodigo.Text = "";
            ddlFiltroCategoria.SelectedIndex = 0;
            ddlFiltroEstado.SelectedIndex = 0;
            CargarGrilla();
        }
    }
}