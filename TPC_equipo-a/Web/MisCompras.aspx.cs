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
            // el max hace que el calendario no deje elegir dias despues de hoy
            string hoy = DateTime.Today.ToString("yyyy-MM-dd");
            txtDesde.Attributes["max"] = hoy;
            txtHasta.Attributes["max"] = hoy;
            cvDesdeHoy.ValueToCompare = hoy;
            cvHastaHoy.ValueToCompare = hoy;
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

            // si la caja esta vacia queda en null y el sp no filtra por esa fecha
            DateTime? desde = null;
            DateTime? hasta = null;
            DateTime fecha;
            if (DateTime.TryParse(txtDesde.Text, out fecha))
                desde = fecha;
            if (DateTime.TryParse(txtHasta.Text, out fecha))
                hasta = fecha;

            List<Pedido> lista = negocio.listarPedidosPorCliente(usuario.Id,desde,hasta);

            // a cada pedido le cargo sus productos para mostrarlos adentro cuando se abre
            foreach (Pedido pedido in lista) {
                pedido.Items = negocio.ListarItems(pedido.Id);
            }
            // limpiar solo aparece si hay alguna fecha puesta
            btnLimpiar.Visible = desde.HasValue || hasta.HasValue;
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            // vuelvo a validar en el servidor por si se saltean la validacion del navegador
            Page.Validate("fechas");
            if (!Page.IsValid)
                return;
            CargarPedidos();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtDesde.Text = "";
            txtHasta.Text = "";
            CargarPedidos();
        }
    }
}