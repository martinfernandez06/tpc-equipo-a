using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace Web
{
    public partial class AdminReportes : System.Web.UI.Page
    {
        // el mismo de detalle pedido, devuelve el color del badge segun el estado
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
        // trae los tres reportes con las fechas del filtro, se usa al entrar, al buscar y al limpiar
        private void CargarReportes()
        {
            ReporteNegocio negocio = new ReporteNegocio();

            // si la fecha queda vacia el tryparse falla, queda en null y el sp no filtra por esa fecha
            DateTime? fechaDesde = null;
            DateTime desde;

            DateTime? fechaHasta = null;
            DateTime hasta;

            if (DateTime.TryParse(txtDesde.Text, out desde))
            {
                fechaDesde = desde;
            }

            if (DateTime.TryParse(txtHasta.Text, out hasta))
            {
                fechaHasta = hasta;
            }
            // los numeros de las tarjetas vienen en una sola fila
            ResumenVentas resumen = negocio.ObtenerResumenVentas(fechaDesde, fechaHasta);

            lblTotalVendido.Text = resumen.TotalVendido.ToString("C");
            lblCantidadPedidos.Text = resumen.CantidadPedidos.ToString();
            lblTicketPromedio.Text = resumen.TicketPromedio.ToString("C");

            // la guardo en una variable porque la uso dos veces, para la grilla y para sumar el total
            List<PedidosPorEstado> estados = negocio.ListarPedidosPorEstado(fechaDesde, fechaHasta);

            dgvEstados.DataSource = estados;
            dgvEstados.DataBind();
            int total = 0;

            // sumo las cantidades de cada estado para mostrar el total al pie de la grilla
            foreach (var estado in estados)
            {
                total += estado.Cantidad;
            }

            // el pie recien existe despues del databind, por eso se llena aca y no antes
            dgvEstados.FooterRow.Cells[0].Text = "Total";
            dgvEstados.FooterRow.Cells[1].Text = total.ToString();

            dgvProductos.DataSource = negocio.ListarProductosMasVendidos(fechaDesde, fechaHasta);
            dgvProductos.DataBind();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            // el max hace que el calendario no deje elegir dias despues de la fecha actual
            // yyyy-MM-dd es el formato que entiende el calendario, MM es mes y mm serian minutos
            string hoy = DateTime.Today.ToString("yyyy-MM-dd");

            txtDesde.Attributes["max"] = hoy;
            txtHasta.Attributes["max"] = hoy;

            // los validadores comparan contra la fecha actual por si escriben la fecha a mano
            cvDesdeHoy.ValueToCompare = hoy;
            cvHastaHoy.ValueToCompare = hoy;

            if (!IsPostBack)
            {
                CargarReportes();
            }

        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            // vuelvo a validar en el servidor por si se saltean la validacion del navegador
            Page.Validate("filtros");
            if (!Page.IsValid)
                return;
            CargarReportes();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            // sin fechas los reportes vuelven a mostrar todo
            txtDesde.Text = "";
            txtHasta.Text = "";
            CargarReportes();
        }
    }
}