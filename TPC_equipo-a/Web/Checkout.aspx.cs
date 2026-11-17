using System;

namespace Web
{
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verifica si el usuario inició sesión
            if (Session["usuario"] == null)
            {
                // Guarda el mensaje para mostrarlo en el Login
                Session["mensajeCheckout"] = true;

                // Guarda que el usuario quería iniciar una compra
                Session["volverAlCheckout"] = true;

                // Redirige al Login
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
        }
    }
}