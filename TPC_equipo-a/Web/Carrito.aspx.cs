using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class Carrito : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnIniciarCompra_Click(object sender, EventArgs e){

            // Verifico si el usuario inicio sesión
            if (Session["usuario"] == null)
            {

             // No está logueado
            Response.Redirect("Login.aspx?redirect=checkout", false);
    }
    else
    {
        // Ya está logueado
        Response.Redirect("Checkout.aspx", false);
    }
}
    }
}