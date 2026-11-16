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
    public partial class DetallePedido : System.Web.UI.Page
    {
        // devuelve la clase de bootstrap con el color de cada estado para mostrarlo como badge
        protected string ClaseEstado(object estado)
        {
            switch (estado.ToString())
            {
                case "Pendiente de pago":
                    return "badge bg-warning text-dark";
                case "Pagado":
                    return "badge bg-info text-dark";
                case "En preparación":
                    return "badge bg-primary";
                case "Enviado":
                    return "badge bg-secondary";
                case "Entregado":
                    return "badge bg-success";
                case "Cancelado":
                    return "badge bg-danger";
                default:
                    return "badge bg-light text-dark";
            }
        }

        // carga todos los datos del pedido, se llama al entrar y despues de cada cambio para refrescar
        private void CargarPedido(int id)
        {
            PedidoNegocio negocio = new PedidoNegocio();
            Pedido seleccionado = negocio.buscarPorId(id);

            // si el id no existe en la bd el pedido viene vacio con id 0, lo mando de vuelta a la lista
            if (seleccionado.Id == 0)
            {
                Response.Redirect("AdminPedidos.aspx", false);
                return;
            }

            lblNumero.Text = seleccionado.Id.ToString();
            // el formato dd/MM/yyyy HH:mm saca los segundos para que se lea mas limpio
            lblFecha.Text = seleccionado.FechaCreacion.ToString("dd/MM/yyyy HH:mm");
            lblCliente.Text = seleccionado.Cliente.Id.ToString();
            lblEstado.Text = seleccionado.Estado.Descripcion;
            lblEstado.CssClass = ClaseEstado(seleccionado.Estado.Descripcion);
            lblFormaPago.Text = seleccionado.FormaPago.Descripcion;
            lblFormaEntrega.Text = seleccionado.FormaEntrega.Descripcion;
            // ternario, si no tiene codigo viene null y muestro un texto en vez de dejarlo vacio
            lblCodigoSeguimiento.Text = seleccionado.CodigoSeguimiento != null ? seleccionado.CodigoSeguimiento : "Sin codigo";
            // la C da formato de pesos, solo sirve con numeros, no con textos
            lblTotal.Text = seleccionado.Total.ToString("C");

            dgvItems.DataSource = negocio.ListarItems(id);
            dgvItems.DataBind();

            dgvHistorial.DataSource = negocio.ListarHistorial(id);
            dgvHistorial.DataBind();

            dgvObservaciones.DataSource = negocio.ListarObservaciones(id);
            dgvObservaciones.DataBind();

            // cargo solo los estados que vienen despues del actual, asi no se puede elegir uno para atras
            // el clear es porque este metodo se llama de nuevo despues de cada cambio y si no se repiten
            int estadoActual = seleccionado.Estado.Id;
            ddlEstado.Items.Clear();

            if (estadoActual < 2)
                ddlEstado.Items.Add(new ListItem("Pagado", "2"));
            if (estadoActual < 3)
                ddlEstado.Items.Add(new ListItem("En preparación", "3"));
            if (estadoActual < 4)
                ddlEstado.Items.Add(new ListItem("Enviado", "4"));
            if (estadoActual < 5)
                ddlEstado.Items.Add(new ListItem("Entregado", "5"));

            // si el pedido esta cerrado se oculta la card, y cancelar solo se ve si todavia no salio
            pnlAcciones.Visible = estadoActual < 5;
            btnCancelar.Visible = estadoActual < 4;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // tryparse devuelve false si el id no vino o no es un numero, asi no rompe nada con ?id=abc
                int id;
                if (int.TryParse(Request.QueryString["id"], out id))
                {
                    CargarPedido(id);
                }
                else
                {
                    // si entran sin id en la url los mando de vuelta a la lista
                    Response.Redirect("AdminPedidos.aspx", false);
                }
            }
        }

        protected void btnAgregarObservacion_Click(object sender, EventArgs e)
        {
            // vuelvo a validar en el servidor por si se saltean la validacion del navegador
            Page.Validate("observacion");
            if (!Page.IsValid)
                return;

            int id = int.Parse(Request.QueryString["id"]);
            PedidoNegocio negocio = new PedidoNegocio();
            // el usuario 1 es fijo hasta que este el login
            negocio.AgregarObservacion(id, 1, txtObservacion.Text.Trim());

            txtObservacion.Text = "";
            CargarPedido(id);
        }

        protected void btnCambiarEstado_Click(object sender, EventArgs e)
        {
            try
            {
                int id = int.Parse(Request.QueryString["id"]);
                // el value de cada opcion es el id del estado en la bd
                int elegido = int.Parse(ddlEstado.SelectedValue);

                PedidoNegocio negocio = new PedidoNegocio();
                // el usuario 1 es fijo hasta que este el login
                negocio.CambiarEstado(id, elegido, 1);

                lblMensaje.Text = "Estado actualizado";
                lblMensaje.CssClass = "text-success d-block my-2";
                CargarPedido(id);
            }
            catch (Exception ex)
            {
                // si el sp corta con un throw, el mensaje que escribimos en la bd llega aca en ex.Message
                lblMensaje.Text = ex.Message;
                lblMensaje.CssClass = "text-danger d-block my-2";
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            try
            {
                int id = int.Parse(Request.QueryString["id"]);
                PedidoNegocio negocio = new PedidoNegocio();
                // el usuario 1 es fijo hasta que este el login
                negocio.CancelarPedido(id, 1);

                lblMensaje.Text = "Pedido cancelado, las unidades volvieron al stock";
                lblMensaje.CssClass = "text-success d-block my-2";
                CargarPedido(id);
            }
            catch (Exception ex)
            {
                // igual que en cambiar estado, el error del sp se muestra en rojo
                lblMensaje.Text = ex.Message;
                lblMensaje.CssClass = "text-danger d-block my-2";
            }
        }
    }
}