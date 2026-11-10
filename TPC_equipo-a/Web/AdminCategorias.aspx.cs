using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class AdminCategorias : System.Web.UI.Page
    {
        private void filtrar()
        {
            string filtro = txtFiltro.Text.Trim();

            List<Categoria> lista = (List<Categoria>)Session["listaCategorias"];

            if (filtro.Length >= 2)
            {
                lista = lista.FindAll(x => x.Nombre.ToUpper().Contains(filtro.ToUpper()));
            }

            if (ddlEstado.SelectedValue == "Activas")
            {
                lista = lista.FindAll(x => x.Activa);
            }
            else if (ddlEstado.SelectedValue == "Inactivas")
            {
                lista = lista.FindAll(x => !x.Activa);
            }
            dgvCategorias.DataSource = lista;

            if (filtro.Length >= 2)
            {
                dgvCategorias.EmptyDataText = $"No se encontraron categorias con {filtro}";
            }
            else
            {
                dgvCategorias.EmptyDataText = "No se encontraron categorias.";
            }

            if (filtro.Length == 1)
            {
                lblAviso.Text = "Para buscar por nombre escribí 2 letras o más.";
            }
            else
            {
                lblAviso.Text = "";
            }
            dgvCategorias.DataBind();

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CategoriaNegocio negocio = new CategoriaNegocio();
                Session.Add("listaCategorias", negocio.listar());
                dgvCategorias.DataSource = Session["listaCategorias"];
                dgvCategorias.DataBind();
            }

        }
        protected void dgvCategorias_SelectedIndexChanged(object sender, EventArgs e)
        {
            var id = dgvCategorias.SelectedDataKey.Value.ToString();

            Response.Redirect($"FormularioCategoria.aspx?id={id}", false);
        }
        protected void txtFiltro_TextChanged(object sender, EventArgs e)
        {
            dgvCategorias.PageIndex = 0; 
            filtrar();
        }
        protected void ddlEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgvCategorias.PageIndex = 0; 
            filtrar();
        }
        protected void dgvCategorias_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvCategorias.PageIndex = e.NewPageIndex;
            filtrar();
        }

        protected void btnLimpiarFiltro_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = "";
            ddlEstado.SelectedIndex = 0;
            dgvCategorias.PageIndex = 0;
            filtrar();
        }
    }
}