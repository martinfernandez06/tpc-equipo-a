using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class MisCompras : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // si no hay nadie logueado lo mando al login, mis compras es solo para clientes
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            if (!IsPostBack)
            {
                CargarPedidos();
            }
        }
        private void CargarPedidos()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            PedidoNegocio negocio = new PedidoNegocio();
            List<Pedido> lista = negocio.listarPedidosPorCliente(usuario.Id,null,null);

            // a cada pedido le cargo sus productos para mostrarlos adentro cuando se abre
            foreach (Pedido pedido in lista) {
                pedido.Items = negocio.ListarItems(pedido.Id);
            }
        }
    }
}