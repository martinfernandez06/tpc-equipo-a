using System;

namespace Web
{
    public partial class CerrarSesion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Elimina  datos de sesión
            Session.Clear();

            // cierra la sesión actual
            Session.Abandon();

            // Redirige a Login
            Response.Redirect("Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}