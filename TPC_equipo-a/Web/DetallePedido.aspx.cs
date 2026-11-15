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

            // Cargo el dgv de Items
            dgvItems.DataSource = negocio.ListarItems(id);
            dgvItems.DataBind();

            dgvHistorial.DataSource = negocio.ListarHistorial(id);
            dgvHistorial.DataBind();

            dgvObservaciones.DataSource = negocio.ListarObservaciones(id);
            dgvObservaciones.DataBind();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // leo el id de la url, si no vino queda vacio
                string id = Request.QueryString["id"] != null ? Request.QueryString["id"].ToString() : "";
                if (id != "")
                {
                    CargarPedido(int.Parse(id));
                }
                else
                {
                    // si entran sin id en la url los mando de vuelta a la lista
                    Response.Redirect("AdminPedidos.aspx");
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
    }
}