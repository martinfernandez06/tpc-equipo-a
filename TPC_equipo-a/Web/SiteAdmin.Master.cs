using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class SiteAdmin : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // marca en el menu la pagina en la que estas, busca una palabra asi tambien marca los formularios y el detalle
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
        // cuenta los comprobantes pendientes para el numerito del menu, va en prerender porque corre despues de los clics y asi ya cuenta el que aceptaron o rechazaron
        protected void Page_PreRender(object sender, EventArgs e)
        {
            PedidoNegocio negocio = new PedidoNegocio();
            int cantidad = negocio.ContarComprobantesPendientes();
            if (cantidad > 0)
            {
                lblPendientes.Text = cantidad.ToString();
                lblPendientes.Visible = true;
            }
            else
            {
                lblPendientes.Visible = false ;
            }
        }
    }
}