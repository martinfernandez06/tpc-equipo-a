using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
namespace Web
{
    public partial class MisCompras : System.Web.UI.Page
    {

        // el pedido que vuelve abierto despues de tocar enviar y el error que se muestra ahi
        protected int idPedidoAbierto = 0;
        protected string mensajeComprobante = "";

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

            // que se ve cuando no hay pedidos para mostrar
            bool hayFecha = desde.HasValue || hasta.HasValue;
            bool sinCompras = lista.Count == 0 && !hayFecha;
            btnLimpiar.Visible = hayFecha;
            pnlSinCompras.Visible = sinCompras;
            pnlPestanas.Visible = !sinCompras;
            pnlFiltroFechas.Visible = !sinCompras;
            lblBajada.Visible = !sinCompras;
            pnlEncabezado.Visible = mostrar.Count > 0;
            pnlSinResultados.Visible = !sinCompras && mostrar.Count == 0;
            btnLimpiarSinResultados.Visible = hayFecha;
            if (lista.Count == 0)
                lblSinResultados.Text = "No hay compras entre esas fechas";
            else
                lblSinResultados.Text = TextoPestanaVacia(pestana);
        }

        // la pestaña elegida lleva la clase activa para pintarla de violeta
        private string ClasePestana(string nombre, string elegida)
        {
            if (nombre == elegida)
                return "pestana activa";
            return "pestana";
        }

        // el mensaje de cada pestaña cuando no tiene pedidos
        private string TextoPestanaVacia(string pestana)
        {
            if (pestana == "encurso")
                return "No tenés compras en curso";
            if (pestana == "entregados")
                return "Todavía no te entregaron ninguna compra";
            return "No tenés compras canceladas";
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

        // dice en que caso esta el comprobante de cada pedido asi los avisos y el chip saben si se muestran
        protected string CasoComprobante(object dato)
        {
            Pedido pedido = (Pedido)dato;

            // si no es transferencia no lleva comprobante y no se muestra nada
            if (!pedido.FormaPago.RequiereComprobante)
                return "";

            // el cancelado va primero porque el 6 tambien es mayor que 2
            if (pedido.Estado.Id == 6)
            {
                if (pedido.EstuvoPagado)
                    return "devolucion";
                return "";
            }

            if (pedido.Estado.Id >= 2)
                return "confirmado";

            // de aca para abajo el pedido sigue pendiente de pago
            if (pedido.EstadoComprobante == null)
                return "pagar";
            if (pedido.EstadoComprobante == "Pendiente")
                return "revision";
            return "rechazado";
        }

        // trae del web config los datos de la cuenta para transferir
        protected string DatoTransferencia(string clave)
        {
            return ConfigurationManager.AppSettings[clave];
        }


        // el pedido donde toco enviar vuelve abierto asi ve como salio
        protected string ClaseAbierto(object id)
        {
            if ((int)id == idPedidoAbierto)
                return "collapse show";
            return "collapse";
        }

        // la flecha queda para arriba si el pedido vuelve abierto
        protected string FlechaAbierta(object id)
        {
            if ((int)id == idPedidoAbierto)
                return "true";
            return "false";
        }

        // el error solo aparece en el pedido donde toco enviar
        protected bool MostrarError(object id)
        {
            return (int)id == idPedidoAbierto && mensajeComprobante != "";
        }
        // >>> muestra el boton para retomar el pago solo si es MP pendiente
        protected bool MostrarBotonPagarMP(object idEstado, object descripcionPago, object requiereComprobante)
        {
            if (idEstado == null || descripcionPago == null || requiereComprobante == null)
                return false;

            int estado = Convert.ToInt32(idEstado);
            bool conComprobante = Convert.ToBoolean(requiereComprobante);
            string pago = descripcionPago.ToString();

            // 1 = Pendiente de pago
            return estado == 1
                && !conComprobante
                && pago.IndexOf("Mercado Pago", StringComparison.OrdinalIgnoreCase) >= 0;
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

        // el boton de enviar hace un postback completo porque el del updatepanel no lleva archivos
        protected void rptPedidos_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            Button boton = (Button)e.Item.FindControl("btnEnviarComprobante");
            if (boton != null)
                ScriptManager.GetCurrent(this).RegisterPostBackControl(boton);
        }

        protected void btnEnviarComprobante_Click(object sender, EventArgs e)
        {
            // el page_load lo manda al login pero el click igual se ejecuta asi que corto aca
            if (Session["usuario"] == null)
                return;

            Usuario usuario = (Usuario)Session["usuario"];
            Button boton = (Button)sender;
            int idPedido = int.Parse(boton.CommandArgument);
            HtmlInputFile archivo = (HtmlInputFile)boton.NamingContainer.FindControl("fuComprobante");

            // pase lo que pase el pedido vuelve abierto con el resultado
            idPedidoAbierto = idPedido;

            // el accept del input se saltea facil asi que el tipo y el peso se controlan aca
            string extension = "";
            if (archivo.PostedFile != null)
                extension = Path.GetExtension(archivo.PostedFile.FileName).ToLower();

            string error = "";
            if (archivo.PostedFile == null || archivo.PostedFile.ContentLength == 0)
                error = "Elegí el comprobante antes de enviarlo.";
            else if (extension != ".jpg" && extension != ".jpeg" && extension != ".png" && extension != ".pdf")
                error = "Solo se aceptan archivos JPG, PNG o PDF.";
            else if (archivo.PostedFile.ContentLength > 5 * 1024 * 1024)
                error = "El comprobante no puede pesar más de 5 MB.";

            if (error != "")
            {
                mensajeComprobante = error;
                CargarPedidos();
                return;
            }

            // git no sube carpetas vacias asi que si no esta la creo
            string carpeta = Server.MapPath("~/Comprobantes/");
            if (!Directory.Exists(carpeta))
                Directory.CreateDirectory(carpeta);

            // el nombre lo armo yo con el pedido y la hora asi no se pisa con otro ni trae nombres raros
            string nombre = $"comprobante-{idPedido}-{DateTime.Now:yyyyMMddHHmmss}{extension}";
            string ruta = carpeta + nombre;

            try
            {
                archivo.PostedFile.SaveAs(ruta);
                PedidoNegocio negocio = new PedidoNegocio();
                negocio.SubirComprobante(idPedido, usuario.Id, "~/Comprobantes/" + nombre);
            }
            catch (Exception ex)
            {
                // si el sp no lo dejo borro el archivo asi no quedan sueltos en la carpeta
                if (File.Exists(ruta))
                    File.Delete(ruta);
                mensajeComprobante = ex.Message;
            }

            // si salio bien el pedido vuelve abierto con el aviso de que lo estan revisando
            CargarPedidos();
        }
    }
}