using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio;

namespace Web
{
    public partial class AdminFormasEntrega : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();
            }
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormaEntregaForm.aspx", false);
        }

        protected void dgvFormasEntrega_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvFormasEntrega.SelectedDataKey.Value.ToString();
            Response.Redirect("FormaEntregaForm.aspx?id=" + id, false);
        }

        private void CargarGrilla()
        {
            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            System.Collections.Generic.List<Dominio.FormaEntrega> lista = negocio.Listar();

            if (ddlFiltro.SelectedValue == "Activos")
            {
                lista = lista.FindAll(x => x.Activa == true);
            }
            else if (ddlFiltro.SelectedValue == "Inactivos")
            {
                lista = lista.FindAll(x => x.Activa == false);
            }

            dgvFormasEntrega.DataSource = lista;
            dgvFormasEntrega.DataBind();
        }

        protected void ddlFiltro_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarGrilla();
        }
    }
}