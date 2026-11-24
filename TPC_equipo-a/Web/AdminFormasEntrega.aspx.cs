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
    public partial class AdminFormasEntrega : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();
            }
        }

        private void CargarGrilla()
        {
            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            List<FormaEntrega> lista = negocio.Listar();

            if (ddlFiltro.SelectedValue == "Activos")
            {
                lista = lista.FindAll(x => x.Activa);
            }
            else if (ddlFiltro.SelectedValue == "Inactivos")
            {
                lista = lista.FindAll(x => !x.Activa);
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