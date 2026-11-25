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
    public partial class Exito : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // si no viene de terminar una compra no hay nada para mostrar y vuelve al catalogo
                if (Session["pedidoExito"] == null || Session["usuario"] == null)
                {
                    Response.Redirect("Default.aspx", false);
                    return;
                }

                int idPedido = (int)Session["pedidoExito"];
                // el flujo termino asi que lo saco para que al recargar no se vuelva a mostrar
                Session.Remove("pedidoExito");

                try
                {
                    Usuario usuario = (Usuario)Session["usuario"];
                    PedidoNegocio negocio = new PedidoNegocio();
                    Pedido pedido = negocio.buscarPorId(idPedido);

                    // solo el dueño del pedido puede ver sus datos
                    if (pedido.Id == 0 || pedido.Cliente.Id != usuario.Id)
                    {
                        Session.Add("error", "No encontramos el pedido que buscás.");
                        Response.Redirect("Error.aspx", false);
                        return;
                    }

                    lblNumero.Text = pedido.Id.ToString();
                    lblTotal.Text = pedido.Total.ToString("C");
                    lblEntrega.Text = pedido.FormaEntrega.Descripcion;
                    lblPago.Text = pedido.FormaPago.Descripcion;
                    lblEstado.Text = pedido.Estado.Descripcion;

                    // el 2 es pagado y solo llega asi desde mercado pago
                    if (pedido.Estado.Id == 2)
                    {
                        lblTitulo.Text = "¡Pago acreditado!";
                        lblEstado.CssClass = "badge-estado badge-pagado";
                        lblSiguiente.Text = "Ya recibimos tu pago. Te avisamos por mail cuando empecemos a preparar tu pedido.";
                    }
                    else
                    {
                        lblTitulo.Text = "¡Pedido confirmado!";
                        lblEstado.CssClass = "badge-estado badge-pendiente";

                        // el paso que sigue depende de como eligio pagar
                        if (pedido.FormaPago.RequiereComprobante)
                            lblSiguiente.Text = "Transferí el total y subí el comprobante desde Mis compras. Ahí tenés los datos de la cuenta.";
                        else if (pedido.Direccion == null)
                            lblSiguiente.Text = "Lo pagás en efectivo cuando lo retirás en el local.";
                        else
                            lblSiguiente.Text = "Lo pagás en efectivo cuando lo recibís.";
                    }
                }
                catch (Exception)
                {
                    Session.Add("error", "Tu pedido quedó guardado pero no pudimos mostrar el detalle. Lo podés ver en Mis compras.");
                    Response.Redirect("Error.aspx", false);
                }
            }
        }
    }
}