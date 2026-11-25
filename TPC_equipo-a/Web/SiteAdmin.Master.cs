
using System;
using System.Web.UI;
using Dominio;
using Negocio;

namespace Web
{
    public partial class SiteAdmin : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Usuario usuario = Session["usuario"] as Usuario;

            // sin sesion no hay usuario para preguntar si es admin asi que va primero
            if (usuario == null)
            {
                Session.Add("error", "Tenés que ingresar para ver esta pantalla.");
                Response.Redirect("~/Error.aspx");
            }

            // logueado pero sin perfil de administrador
            if (usuario.Perfil == null || usuario.Perfil.Id != 1)
            {
                Session.Add("error", "Necesitás ser administrador para entrar a esta pantalla.");
                Response.Redirect("~/Error.aspx");
            }

            // Mostrar el nombre del administrador.
            if (!IsPostBack)
            {
                lblNombreUsuario.Text = usuario.Nombre;
            }

            // Marcar en el menú la página actual.
            string pagina = Page.AppRelativeVirtualPath;

            if (pagina.Contains("Producto"))
            {
                lnkProductos.Attributes["class"] += " activo";
            }
            else if (pagina.Contains("Categoria"))
            {
                lnkCategorias.Attributes["class"] += " activo";
            }
            else if (pagina.Contains("Pago"))
            {
                lnkFormasPago.Attributes["class"] += " activo";
            }
            else if (pagina.Contains("Entrega"))
            {
                lnkFormasEntrega.Attributes["class"] += " activo";
            }
            else if (pagina.Contains("Pedido"))
            {
                lnkPedidos.Attributes["class"] += " activo";
            }
            else if (pagina.Contains("Reporte"))
            {
                lnkReportes.Attributes["class"] += " activo";
            }
            else if (pagina.Contains("Comprobante"))
            {
                lnkComprobantes.Attributes["class"] += " activo";
            }
        }

        // Actualizar el contador de comprobantes pendientes
        // después de procesar las acciones de la página.
        protected void Page_PreRender(object sender, EventArgs e)
        {
            Usuario usuario = Session["usuario"] as Usuario;

            // Evitar ejecutar la consulta si no es administrador.
            if (usuario == null ||
                usuario.Perfil == null ||
                usuario.Perfil.Id != 1)
            {
                return;
            }

            PedidoNegocio negocio = new PedidoNegocio();
            int cantidad = negocio.ContarComprobantesPendientes();

            if (cantidad > 0)
            {
                lblPendientes.Text = cantidad.ToString();
                lblPendientes.Visible = true;
            }
            else
            {
                lblPendientes.Visible = false;
            }
        }
    }
}
