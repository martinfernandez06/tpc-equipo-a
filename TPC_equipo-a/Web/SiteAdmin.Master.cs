
using System;
using Dominio;
using System.Web.UI;

namespace Web
{
    public partial class SiteAdmin : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Usuario usuario = Session["usuario"] as Usuario;

            // Verificar usuario autenticado
            // y que su perfil sea Administrador.
            if (usuario == null ||
                usuario.Perfil == null ||
                usuario.Perfil.Id != 1)
            {
                Response.Redirect("~/Default.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            // Mostrar el nombre del administrador.
            if (!IsPostBack)
            {
                lblNombreUsuario.Text = usuario.Nombre;
            }
        }
    }
}
