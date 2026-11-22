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
    public partial class AdminFormasPago : System.Web.UI.Page
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
            FormaPagoNegocio negocio = new FormaPagoNegocio();
            List<FormaPago> lista = negocio.Listar();

            if (ddlFiltro.SelectedValue == "Activos")
            {
                lista = lista.FindAll(x => x.Activa);
            }
            else if (ddlFiltro.SelectedValue == "Inactivos")
            {
                lista = lista.FindAll(x => !x.Activa);
            }

            dgvFormasPago.DataSource = lista;
            dgvFormasPago.DataBind();
        }

        protected void ddlFiltro_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarGrilla();
        }
    }
}