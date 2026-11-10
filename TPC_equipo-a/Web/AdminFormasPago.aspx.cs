using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio;

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
        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormaPagoForm.aspx", false);
        }

        protected void dgvFormasPago_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvFormasPago.SelectedDataKey.Value.ToString();
            Response.Redirect("FormaPagoForm.aspx?id=" + id, false);
        }

        private void CargarGrilla()
        {
            FormaPagoNegocio negocio = new FormaPagoNegocio();
            System.Collections.Generic.List<Dominio.FormaPago> lista = negocio.Listar();

            if (ddlFiltro.SelectedValue == "Activos")
            {
                lista = lista.FindAll(x => x.Activa == true);
            }
            else if (ddlFiltro.SelectedValue == "Inactivos")
            {
                lista = lista.FindAll(x => x.Activa == false);
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