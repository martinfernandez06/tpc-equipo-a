using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class Error : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // el mensaje lo deja la pantalla que fallo y lo borro asi no vuelve a salir si recarga
            if (!IsPostBack && Session["error"] != null)
            {
                lblMensaje.Text = Session["error"].ToString();
                Session.Remove("error");
            }
        }
    }
}