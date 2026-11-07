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
                FormaPagoNegocio negocio = new FormaPagoNegocio();
                dgvFormasPago.DataSource = negocio.Listar();
                dgvFormasPago.DataBind();
            }
        }
        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormaPagoForm.aspx", false);
        }

        protected void dgvFormasPago_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Capturamos el ID de la fila seleccionada para enviarlo por la URL
            string id = dgvFormasPago.SelectedDataKey.Value.ToString();
            Response.Redirect("FormaPagoForm.aspx?id=" + id, false);
        }
    }
}