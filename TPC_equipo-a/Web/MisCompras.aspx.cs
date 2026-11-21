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

            List<Pedido> lista = negocio.listarPedidosPorCliente(usuario.Id, desde, hasta);


            // el numerito de cada pestaña, en curso es de pendiente a enviado
            int enCurso = lista.FindAll(x => x.Estado.Id <= 4).Count;
            int entregados = lista.FindAll(x => x.Estado.Id == 5).Count;
            int cancelados = lista.FindAll(x => x.Estado.Id == 6).Count;
            btnTodos.Text = $"Todos <span class=\"cuenta-pestana\">{lista.Count}</span>";
            btnEnCurso.Text = $"En curso <span class=\"cuenta-pestana\">{enCurso}</span>";
            btnEntregados.Text = $"Entregados <span class=\"cuenta-pestana\">{entregados}</span>";
            btnCancelados.Text = $"Cancelados <span class=\"cuenta-pestana\">{cancelados}</span>";


            // la pestaña elegida queda en el viewstate, si no hay ninguna arranca en todos
            string pestana = "todos";
            if (ViewState["pestana"] != null)
                pestana = (string)ViewState["pestana"];

            btnTodos.CssClass = ClasePestana("todos", pestana);
            btnEnCurso.CssClass = ClasePestana("encurso", pestana);
            btnEntregados.CssClass = ClasePestana("entregados", pestana);
            btnCancelados.CssClass = ClasePestana("cancelados", pestana);

            List<Pedido> mostrar = lista;
            if (pestana == "encurso")
                mostrar = lista.FindAll(x => x.Estado.Id <= 4);
            else if (pestana == "entregados")
                mostrar = lista.FindAll(x => x.Estado.Id == 5);
            else if (pestana == "cancelados")
                mostrar = lista.FindAll(x => x.Estado.Id == 6);


            // los productos solo de los que se van a mostrar, asi no voy a la bd de mas
            foreach (Pedido pedido in mostrar)
            {
                pedido.Items = negocio.ListarItems(pedido.Id);
            }

            rptPedidos.DataSource = mostrar;
            rptPedidos.DataBind();
            // limpiar solo aparece si hay alguna fecha puesta
            btnLimpiar.Visible = desde.HasValue || hasta.HasValue;
        }

        // la pestaña elegida lleva la clase activa para pintarla de violeta
        private string ClasePestana(string nombre, string elegida)
        {
            if (nombre == elegida)
                return "pestana activa";
            return "pestana";
        }

        // color del badge segun el estado, pagado y en preparacion van iguales
        protected string ClaseEstado(object idEstado)
        {
            switch ((int)idEstado)
            {
                case 1:
                    return "badge-estado badge-pendiente";
                case 2:
                case 3:
                    return "badge-estado badge-pagado";
                case 4:
                    return "badge-estado badge-enviado";
                case 5:
                    return "badge-estado badge-entregado";
                default:
                    return "badge-estado badge-cancelado";
            }
        }

        // hasta 3 fotitos, si hay mas el texto dice cuantos faltan
        protected List<ItemPedido> Miniaturas(object items)
        {
            List<ItemPedido> lista = (List<ItemPedido>)items;
            if (lista.Count <= 3)
                return lista;
            return lista.GetRange(0, 3);
        }

        // el primer producto y cuantos mas hay
        protected string ResumenProductos(object items)
        {
            List<ItemPedido> lista = (List<ItemPedido>)items;
            if (lista.Count == 0)
                return "";
            string texto = lista[0].Producto.Nombre;
            if (lista.Count > 1)
                texto += $" y {lista.Count - 1} más";
            return texto;
        }

        // si el producto no tiene foto va la imagen generica
        protected string ImagenProducto(object url)
        {
            if (url == null || string.IsNullOrWhiteSpace(url.ToString()))
                return ResolveUrl("~/Imagenes/sin-imagen.svg");
            return url.ToString();
        }

        // cantidad por precio de cada producto, con el precio que pago en ese momento
        protected string Subtotal(object cantidad, object precio)
        {
            return ((int)cantidad * (decimal)precio).ToString("C");
        }

        // los de retiro no tienen direccion, ahi va el texto del local
        protected string TextoDireccion(object direccion)
        {
            if (direccion == null)
                return "Lo retirás en el local";
            Direccion d = (Direccion)direccion;
            return $"{d.Calle} {d.Numero}, {d.Localidad}, {d.Provincia} (CP {d.CodigoPostal})";
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

        // las 4 pestañas usan este evento, el commandargument dice cual tocaron
        protected void btnPestana_Click(object sender, EventArgs e)
        {
            Page.Validate("fechas");
            if (!Page.IsValid)
                return;
            LinkButton boton = (LinkButton)sender;
            ViewState["pestana"] = boton.CommandArgument;
            CargarPedidos();
        }
    }
}