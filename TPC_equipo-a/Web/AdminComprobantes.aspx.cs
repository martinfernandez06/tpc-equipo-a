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
    public partial class AdminComprobantes : System.Web.UI.Page
    {
        // trae los pendientes, se usa al entrar y despues de aceptar o rechazar
        private void CargarComprobante()
        {
            PedidoNegocio negocio = new PedidoNegocio();
            dgvComprobantes.DataSource = negocio.ListarComprobantesPendientes();
            dgvComprobantes.DataBind();
        }


        // devuelve el id del admin logueado asi el historial guarda quien hizo cada cambio
        // si la sesion se vencio con la pantalla abierta lo mando al login y devuelve 0
        private int IdAdminLogueado()
        {
            if (Session["usuario"] == null)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return 0;
            }
            Usuario admin = (Usuario)Session["usuario"];
            return admin.Id;
        }

        // true si el comprobante es un pdf, el tolower es por si viene como .PDF
        protected bool EsPdf(object url)
        {
            if (url == null)
            {
                return false;
            }
            return url.ToString().ToLower().EndsWith(".pdf");
        }
        // true si es una foto, si no hay archivo no muestra nada
        protected bool EsImagen(object url)
        {
            if (url == null)
            {
                return false;
            }
            return !EsPdf(url);
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarComprobante();
            }
        }
        // guarda el pedido de la fila y pide confirmacion antes de aceptar
        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            // saco el mensaje del aceptar o rechazar anterior para que no quede colgado
            lblMensaje.Visible = false;
            // cierro el cartel del rechazo para que no queden los dos abiertos
            pnlConfirmarRechazo.Visible = false;
            // el sender es el boton que tocaron, llega como object y lo convierto para leer su commandargument
            LinkButton btn = (LinkButton)sender;
            // guardo el pedido en el hidden porque cuando toquen si aceptar ya no se sabe de que fila venia
            hfIdPedido.Value = btn.CommandArgument;
            // el $ adelante deja meter el numero de pedido adentro del texto, entre llaves
            lblConfirmarAceptar.Text = $"¿Aceptar el comprobante del pedido #{btn.CommandArgument}? El pedido pasa a Pagado.";
            pnlConfirmarAceptar.Visible = true;
        }

        // guarda el pedido de la fila y abre el cartel para escribir el motivo
        protected void btnRechazar_Click(object sender, EventArgs e)
        {
            // saco el mensaje anterior y cierro el cartel del aceptar para que no queden los dos abiertos
            lblMensaje.Visible = false;
            pnlConfirmarAceptar.Visible = false;
            LinkButton btn = (LinkButton)sender;
            hfIdPedido.Value = btn.CommandArgument;
            // vacio el motivo para que no quede escrito el del pedido anterior
            txtMotivo.Text = "";
            lblConfirmarRechazo.Text = $"Rechazar el comprobante del pedido #{btn.CommandArgument}. El pedido sigue pendiente de pago.";
            pnlConfirmarRechazo.Visible = true;
        }
        // acepta el comprobante del pedido guardado en el hidden y muestra como salio
        protected void btnSiAceptar_Click(object sender, EventArgs e)
        {
            // si no hay pedido guardado, por ejemplo si tocaron si dos veces rapido, no hago nada
            if (string.IsNullOrEmpty(hfIdPedido.Value))
            {
                return;
            }


            int idAdmin = IdAdminLogueado();
            if (idAdmin == 0)
                return;

            try
            {
                int idPedido = int.Parse(hfIdPedido.Value);
                PedidoNegocio negocio = new PedidoNegocio();
                negocio.AceptarComprobante(idPedido, idAdmin);
                lblMensaje.CssClass = "alert alert-success d-block";
                lblMensaje.Text = $"Comprobante del pedido #{idPedido} aceptado. El pedido pasó a Pagado.";
                lblMensaje.Visible = true;
            }
            catch (Exception ex)
            {

                lblMensaje.CssClass = "alert alert-danger d-block";
                lblMensaje.Text = ex.Message;
                lblMensaje.Visible = true;
            }
            // pase lo que pase recargo la grilla, si salio bien o si otro ya lo reviso el pedido sale de la bandeja
            CargarComprobante();
            pnlConfirmarAceptar.Visible = false;
            hfIdPedido.Value = "";
        }
        // cierra la confirmacion sin hacer nada
        protected void btnNoAceptar_Click(object sender, EventArgs e)
        {
            pnlConfirmarAceptar.Visible = false;
            hfIdPedido.Value = "";
        }

        // rechaza el comprobante con el motivo escrito, el pedido sigue pendiente de pago
        protected void btnSiRechazar_Click(object sender, EventArgs e)
        {
            // vuelvo a validar en el servidor por si se saltean la validacion del navegador
            Page.Validate("rechazo");
            if (!Page.IsValid)
                return;
            // si no hay pedido guardado, por ejemplo si tocaron confirmar dos veces rapido, no hago nada
            if (string.IsNullOrEmpty(hfIdPedido.Value))
            {
                return;
            }

            int idAdmin = IdAdminLogueado();
            if (idAdmin == 0)
                return;

            try
            {
                int idPedido = int.Parse(hfIdPedido.Value);
                PedidoNegocio negocio = new PedidoNegocio();
                negocio.RechazarComprobante(idPedido, idAdmin, txtMotivo.Text);
                lblMensaje.CssClass = "alert alert-success d-block";
                lblMensaje.Text = $"Comprobante del pedido #{idPedido} rechazado. El pedido sigue pendiente de pago.";
                lblMensaje.Visible = true;
            }
            catch (Exception ex)
            {
                lblMensaje.CssClass = "alert alert-danger d-block";
                lblMensaje.Text = ex.Message;
                lblMensaje.Visible = true;
            }
            // pase lo que pase recargo la grilla y cierro el cartel
            CargarComprobante();
            pnlConfirmarRechazo.Visible = false;
            hfIdPedido.Value = "";
            txtMotivo.Text = "";
        }

        // cierra el cartel del rechazo sin hacer nada
        protected void btnNoRechazar_Click(object sender, EventArgs e)
        {
            pnlConfirmarRechazo.Visible = false;
            hfIdPedido.Value = "";
            txtMotivo.Text = "";
        }
    }
}