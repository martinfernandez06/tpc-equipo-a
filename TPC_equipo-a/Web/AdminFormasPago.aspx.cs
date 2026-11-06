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
    }
}