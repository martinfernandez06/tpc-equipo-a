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
        }
    }
}