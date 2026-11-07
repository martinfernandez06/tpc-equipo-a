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
                FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                dgvFormasEntrega.DataSource = negocio.Listar();
                dgvFormasEntrega.DataBind();
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
    }
}