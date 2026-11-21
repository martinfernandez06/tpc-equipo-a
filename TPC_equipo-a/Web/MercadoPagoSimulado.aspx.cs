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
    public partial class MercadoPagoSimulado : System.Web.UI.Page
    {
        private const int EstadoPendienteDePago = 1;
        private const int EstadoPagado = 2;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Si no hay usuario logueado lo mandamos al login
            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                CargarPedido();
            }
        }

        private void CargarPedido()
        {
            OcultarTodosLosPaneles();

            if (!int.TryParse(Request.QueryString["id"], out int idPedido) || idPedido <= 0)
            {
                MostrarError("El número de pedido no es válido.");
                return;
            }

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                PedidoNegocio negocio = new PedidoNegocio();
                Pedido pedido = negocio.buscarPorId(idPedido);

                if (pedido == null || pedido.Id == 0)
                {
                    MostrarError("No se encontró el pedido solicitado.");
                    return;
                }

                // Verificamos que el pedido pertenezca al usuario logueado
                if (pedido.Cliente == null || pedido.Cliente.Id != usuario.Id)
                {
                    MostrarError("No tenés permisos para operar sobre este pedido.");
                    return;
                }

                // Verificamos que la forma de pago del pedido sea Mercado Pago
                if (pedido.FormaPago == null ||
                    pedido.FormaPago.RequiereComprobante ||
                    pedido.FormaPago.Descripcion.IndexOf("Mercado Pago", StringComparison.OrdinalIgnoreCase) < 0)
                {
                    MostrarError("Este pedido no fue registrado con Mercado Pago.");
                    return;
                }

                // Si ya estaba pagado, mostramos la confirmación directamente
                if (pedido.Estado != null && pedido.Estado.Id == EstadoPagado)
                {
                    lblPedidoPagadoId.Text = pedido.Id.ToString();
                    lblTotalPagado.Text = pedido.Total.ToString("C");
                    pnlPagado.Visible = true;
                    return;
                }

                // Solo permitimos pagar si está en estado Pendiente de pago (Id = 1)
                if (pedido.Estado == null || pedido.Estado.Id != EstadoPendienteDePago)
                {
                    string estadoActual = pedido.Estado != null ? pedido.Estado.Descripcion : "Desconocido";
                    MostrarError($"Este pedido ya no está pendiente de pago (estado actual: {estadoActual}).");
                    return;
                }

                lblPedidoId.Text = pedido.Id.ToString();
                lblCliente.Text = pedido.Cliente.Nombre + " " + pedido.Cliente.Apellido;
                lblTotal.Text = pedido.Total.ToString("C");

                rptItems.DataSource = negocio.ListarItems(pedido.Id);
                rptItems.DataBind();

                pnlPago.Visible = true;
            }
            catch (Exception ex)
            {
                MostrarError("Ocurrió un error al cargar el pedido: " + ex.Message);
            }
        }

        protected void btnPagar_Click(object sender, EventArgs e)
        {
            OcultarTodosLosPaneles();

            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!int.TryParse(Request.QueryString["id"], out int idPedido) || idPedido <= 0)
            {
                MostrarError("El número de pedido no es válido.");
                return;
            }

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                PedidoNegocio negocio = new PedidoNegocio();
                Pedido pedido = negocio.buscarPorId(idPedido);

                if (pedido == null || pedido.Id == 0 || pedido.Cliente == null || pedido.Cliente.Id != usuario.Id)
                {
                    MostrarError("No se encontró un pedido válido para acreditar el pago.");
                    return;
                }

                if (pedido.FormaPago == null ||
                    pedido.FormaPago.RequiereComprobante ||
                    pedido.FormaPago.Descripcion.IndexOf("Mercado Pago", StringComparison.OrdinalIgnoreCase) < 0)
                {
                    MostrarError("Este pedido no corresponde a Mercado Pago.");
                    return;
                }

                if (pedido.Estado == null || pedido.Estado.Id != EstadoPendienteDePago)
                {
                    MostrarError("El pedido ya no se encuentra pendiente de pago.");
                    return;
                }

                // Pasamos el pedido a Pagado (IdEstado = 2) y registramos el cambio en HISTORIAL_ESTADOS
                negocio.CambiarEstado(pedido.Id, EstadoPagado, usuario.Id, null, null);

                lblPedidoPagadoId.Text = pedido.Id.ToString();
                lblTotalPagado.Text = pedido.Total.ToString("C");
                pnlPagado.Visible = true;
            }
            catch (Exception ex)
            {
                MostrarError("No se pudo registrar el pago: " + ex.Message);
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            OcultarTodosLosPaneles();

            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!int.TryParse(Request.QueryString["id"], out int idPedido) || idPedido <= 0)
            {
                MostrarError("El número de pedido no es válido.");
                return;
            }

            // Cancelar en la pantalla simulada deja el pedido en estado Pendiente de pago (sin cancelarlo en BD)
            lblPedidoCanceladoId.Text = idPedido.ToString();
            lnkReintentarPago.NavigateUrl = "MercadoPagoSimulado.aspx?id=" + idPedido;
            pnlCancelado.Visible = true;
        }

        private void MostrarError(string mensaje)
        {
            OcultarTodosLosPaneles();
            lblError.Text = mensaje;
            pnlError.Visible = true;
        }

        private void OcultarTodosLosPaneles()
        {
            pnlError.Visible = false;
            pnlPago.Visible = false;
            pnlPagado.Visible = false;
            pnlCancelado.Visible = false;
        }
    }
}