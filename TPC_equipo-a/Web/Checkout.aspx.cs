
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
    public partial class Checkout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Verifica si el usuario inició sesión.
            if (Session["usuario"] == null)
            {
                // Guarda el mensaje para mostrarlo en el Login.
                Session["mensajeCheckout"] = true;

                // Guarda que el usuario quería iniciar una compra.
                Session["volverAlCheckout"] = true;

                // Redirige al Login.
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            if (!IsPostBack)
            {
                Dominio.Carrito carrito = Session["Carrito"] as Dominio.Carrito;

                // Si no hay productos en el carrito, bloqueamos el checkout.
                if (carrito == null || carrito.Items.Count == 0)
                {
                    pnlCheckout.Visible = false;
                    pnlCarritoVacio.Visible = true;
                    return;
                }

                Usuario usuario = (Usuario)Session["usuario"];

                CargarDatosCliente(usuario);
                CargarFormasEntrega();
                CargarDirecciones(usuario.Id);
                CargarFormasPago();
                CargarResumenProductos(carrito);
                ActualizarPanelEntregaYResumen();
            }
        }

        private void CargarDatosCliente(Usuario usuario)
        {
            lblClienteNombre.Text = usuario.Nombre + " " + usuario.Apellido;
            lblClienteEmail.Text = usuario.Email;
            lblClienteTelefono.Text = string.IsNullOrWhiteSpace(usuario.Telefono) ? "No informado" : usuario.Telefono;

            DireccionNegocio dirNegocio = new DireccionNegocio();
            List<Direccion> direcciones = dirNegocio.ListarPorUsuario(usuario.Id);
            Direccion principal = direcciones.Find(d => d.Principal);

            if (principal != null)
            {
                lblClienteDireccionPrincipal.Text = FormatearDireccion(principal);
            }
            else
            {
                lblClienteDireccionPrincipal.Text = "Sin dirección principal cargada";
            }
        }

        private void CargarFormasEntrega()
        {
            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            List<FormaEntrega> activas = negocio.Listar().FindAll(x => x.Activa);

            rblFormaEntrega.DataSource = activas;
            rblFormaEntrega.DataTextField = "Descripcion";
            rblFormaEntrega.DataValueField = "Id";
            rblFormaEntrega.DataBind();

            // Preseleccionamos Envío a domicilio (si existe) para mostrar la dirección principal precargada; si no, la primera opción.
            FormaEntrega envio = activas.Find(x => x.RequiereDireccion);
            if (envio != null)
            {
                rblFormaEntrega.SelectedValue = envio.Id.ToString();
            }
            else if (rblFormaEntrega.Items.Count > 0)
            {
                rblFormaEntrega.SelectedIndex = 0;
            }
        }

        private void CargarDirecciones(int idUsuario, int? idSeleccionar = null)
        {
            DireccionNegocio negocio = new DireccionNegocio();
            List<Direccion> direcciones = negocio.ListarPorUsuario(idUsuario);

            ddlDirecciones.Items.Clear();

            if (direcciones.Count > 0)
            {
                foreach (Direccion dir in direcciones)
                {
                    string texto = FormatearDireccion(dir) + (dir.Principal ? " (Principal)" : "");
                    ddlDirecciones.Items.Add(new ListItem(texto, dir.Id.ToString()));
                }

                // Si recién cargó una nueva, seleccionamos esa; si no, precargamos la principal.
                if (idSeleccionar.HasValue && ddlDirecciones.Items.FindByValue(idSeleccionar.Value.ToString()) != null)
                {
                    ddlDirecciones.SelectedValue = idSeleccionar.Value.ToString();
                }
                else
                {
                    Direccion principal = direcciones.Find(d => d.Principal);
                    if (principal != null)
                    {
                        ddlDirecciones.SelectedValue = principal.Id.ToString();
                    }
                }

                divSelectorDireccion.Visible = true;
                lblSinDirecciones.Visible = false;
                pnlNuevaDireccion.Visible = false;
            }
            else
            {
                // Si el cliente no tiene direcciones, abrimos el formulario para que pueda cargar una.
                divSelectorDireccion.Visible = false;
                lblSinDirecciones.Visible = true;
                pnlNuevaDireccion.Visible = true;
            }
        }

        private void CargarFormasPago()
        {
            FormaPagoNegocio negocio = new FormaPagoNegocio();
            List<FormaPago> activas = negocio.Listar().FindAll(x => x.Activa);

            rblFormaPago.DataSource = activas;
            rblFormaPago.DataTextField = "Descripcion";
            rblFormaPago.DataValueField = "Id";
            rblFormaPago.DataBind();
        }

        private void CargarResumenProductos(Dominio.Carrito carrito)
        {
            rptResumen.DataSource = carrito.Items;
            rptResumen.DataBind();
            lblResumenTotal.Text = carrito.Total.ToString("C");
        }

        private void ActualizarPanelEntregaYResumen()
        {
            // Forma de entrega y visibilidad del bloque de direcciones.
            FormaEntrega entregaSeleccionada = ObtenerFormaEntregaSeleccionada();
            if (entregaSeleccionada != null)
            {
                lblResumenEntrega.Text = entregaSeleccionada.Descripcion;
                pnlDirecciones.Visible = entregaSeleccionada.RequiereDireccion;
                liResumenDireccion.Visible = entregaSeleccionada.RequiereDireccion;

                if (entregaSeleccionada.RequiereDireccion)
                {
                    if (ddlDirecciones.Items.Count > 0 && ddlDirecciones.SelectedItem != null)
                    {
                        lblResumenDireccion.Text = ddlDirecciones.SelectedItem.Text;
                    }
                    else
                    {
                        lblResumenDireccion.Text = "Falta cargar dirección";
                    }
                }
            }
            else
            {
                lblResumenEntrega.Text = "Sin seleccionar";
                pnlDirecciones.Visible = false;
                liResumenDireccion.Visible = false;
            }

            // Forma de pago seleccionada.
            if (rblFormaPago.SelectedItem != null)
            {
                lblResumenPago.Text = rblFormaPago.SelectedItem.Text;
            }
            else
            {
                lblResumenPago.Text = "Sin seleccionar";
            }
        }

        private FormaEntrega ObtenerFormaEntregaSeleccionada()
        {
            if (!int.TryParse(rblFormaEntrega.SelectedValue, out int idEntrega))
                return null;

            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            return negocio.Listar().Find(x => x.Id == idEntrega && x.Activa);
        }

        private string FormatearDireccion(Direccion d)
        {
            string texto = $"{d.Calle} {d.Numero}, {d.Localidad}, {d.Provincia} (CP {d.CodigoPostal})";
            if (!string.IsNullOrWhiteSpace(d.Observaciones))
            {
                texto += $" - {d.Observaciones}";
            }
            return texto;
        }

        protected void rblFormaEntrega_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblError.Visible = false;
            ActualizarPanelEntregaYResumen();
        }

        protected void ddlDirecciones_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblError.Visible = false;
            ActualizarPanelEntregaYResumen();
        }

        protected void rblFormaPago_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblError.Visible = false;
            ActualizarPanelEntregaYResumen();
        }

        protected void btnMostrarNuevaDireccion_Click(object sender, EventArgs e)
        {
            lblErrorDireccion.Visible = false;
            pnlNuevaDireccion.Visible = !pnlNuevaDireccion.Visible;
        }

        protected void btnCancelarDireccion_Click(object sender, EventArgs e)
        {
            lblErrorDireccion.Visible = false;
            LimpiarFormularioDireccion();
            pnlNuevaDireccion.Visible = false;
        }

        protected void btnGuardarDireccion_Click(object sender, EventArgs e)
        {
            lblErrorDireccion.Visible = false;

            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            // Validamos campos obligatorios de la nueva dirección.
            if (string.IsNullOrWhiteSpace(txtCalle.Text) ||
                string.IsNullOrWhiteSpace(txtNumero.Text) ||
                string.IsNullOrWhiteSpace(txtLocalidad.Text) ||
                string.IsNullOrWhiteSpace(txtProvincia.Text) ||
                string.IsNullOrWhiteSpace(txtCodigoPostal.Text))
            {
                lblErrorDireccion.Text = "Completá calle, número, localidad, provincia y código postal.";
                lblErrorDireccion.Visible = true;
                return;
            }

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                DireccionNegocio dirNegocio = new DireccionNegocio();

                // Si es su primera dirección, la marcamos como principal automáticamente.
                bool tieneDirecciones = dirNegocio.ListarPorUsuario(usuario.Id).Count > 0;

                Direccion nueva = new Direccion();
                nueva.IdUsuario = usuario.Id;
                nueva.Calle = txtCalle.Text.Trim();
                nueva.Numero = txtNumero.Text.Trim();
                nueva.Localidad = txtLocalidad.Text.Trim();
                nueva.Provincia = txtProvincia.Text.Trim();
                nueva.CodigoPostal = txtCodigoPostal.Text.Trim();
                nueva.Observaciones = txtObservaciones.Text.Trim();
                nueva.Principal = !tieneDirecciones || chkPrincipal.Checked;

                dirNegocio.Agregar(nueva);

                // Buscamos el ID de la dirección recién creada (la de mayor Id del usuario) para dejarla seleccionada.
                List<Direccion> actualizadas = dirNegocio.ListarPorUsuario(usuario.Id);
                int idNueva = actualizadas.Count > 0 ? actualizadas.Max(d => d.Id) : 0;

                LimpiarFormularioDireccion();
                CargarDatosCliente(usuario);
                CargarDirecciones(usuario.Id, idNueva > 0 ? (int?)idNueva : null);
                ActualizarPanelEntregaYResumen();
            }
            catch (Exception)
            {
                lblErrorDireccion.Text = "No se pudo guardar la dirección. Intentá nuevamente.";
                lblErrorDireccion.Visible = true;
            }
        }

        private void LimpiarFormularioDireccion()
        {
            txtCalle.Text = string.Empty;
            txtNumero.Text = string.Empty;
            txtLocalidad.Text = string.Empty;
            txtProvincia.Text = string.Empty;
            txtCodigoPostal.Text = string.Empty;
            txtObservaciones.Text = string.Empty;
            chkPrincipal.Checked = false;
        }

        protected void btnConfirmarCompra_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;

            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            Dominio.Carrito carrito = Session["Carrito"] as Dominio.Carrito;

            // Validación: no permitir pedidos sin ítems.
            if (carrito == null || carrito.Items.Count == 0)
            {
                pnlCheckout.Visible = false;
                pnlCarritoVacio.Visible = true;
                return;
            }

            // Validación: forma de entrega.
            FormaEntrega formaEntrega = ObtenerFormaEntregaSeleccionada();
            if (formaEntrega == null)
            {
                lblError.Text = "Seleccioná una forma de entrega para continuar.";
                lblError.Visible = true;
                return;
            }

            Usuario usuario = (Usuario)Session["usuario"];

            // Validación: dirección obligatoria si la entrega es con envío.
            Direccion direccionSeleccionada = null;
            if (formaEntrega.RequiereDireccion)
            {
                if (!int.TryParse(ddlDirecciones.SelectedValue, out int idDireccion) || idDireccion <= 0)
                {
                    lblError.Text = "Para envíos a domicilio debés elegir una dirección guardada o cargar una nueva.";
                    lblError.Visible = true;
                    return;
                }

                DireccionNegocio dirNegocio = new DireccionNegocio();
                direccionSeleccionada = dirNegocio.ListarPorUsuario(usuario.Id).Find(d => d.Id == idDireccion);

                if (direccionSeleccionada == null)
                {
                    lblError.Text = "La dirección seleccionada no es válida. Elegí otra o cargá una nueva.";
                    lblError.Visible = true;
                    return;
                }
            }

            // Validación: forma de pago obligatoria.
            if (!int.TryParse(rblFormaPago.SelectedValue, out int idFormaPago))
            {
                lblError.Text = "Seleccioná una forma de pago antes de confirmar la compra.";
                lblError.Visible = true;
                return;
            }

            FormaPagoNegocio pagoNegocio = new FormaPagoNegocio();
            FormaPago formaPago = pagoNegocio.Listar().Find(x => x.Id == idFormaPago && x.Activa);
            if (formaPago == null)
            {
                lblError.Text = "La forma de pago elegida no está disponible.";
                lblError.Visible = true;
                return;
            }

            try
            {
                // Revalidamos precios y stock reales en la base de datos antes de crear el pedido.
                ProductoNegocio prodNegocio = new ProductoNegocio();
                List<Producto> productosDb = prodNegocio.Listar();

                List<ItemPedido> itemsPedido = new List<ItemPedido>();
                decimal totalReal = 0;

                foreach (ItemCarrito itemCarrito in carrito.Items)
                {
                    Producto productoDb = productosDb.Find(p => p.Id == itemCarrito.Producto.Id);

                    if (productoDb == null || !productoDb.Activo)
                    {
                        lblError.Text = $"El producto \"{itemCarrito.Producto.Nombre}\" ya no está disponible. Volvé al carrito para quitarlo.";
                        lblError.Visible = true;
                        return;
                    }

                    if (itemCarrito.Cantidad <= 0 || itemCarrito.Cantidad > productoDb.Stock)
                    {
                        lblError.Text = $"No hay stock suficiente de \"{productoDb.Nombre}\". Stock disponible actual: {productoDb.Stock}.";
                        lblError.Visible = true;
                        return;
                    }

                    // Sincronizamos el precio vigente desde la BD para evitar cobrar un precio viejo de Session.
                    itemCarrito.Producto.PrecioVenta = productoDb.PrecioVenta;
                    itemCarrito.Producto.Stock = productoDb.Stock;

                    ItemPedido itemPedido = new ItemPedido();
                    itemPedido.Producto = productoDb;
                    itemPedido.Cantidad = itemCarrito.Cantidad;
                    itemPedido.PrecioUnitario = productoDb.PrecioVenta;

                    itemsPedido.Add(itemPedido);
                    totalReal += itemPedido.Cantidad * itemPedido.PrecioUnitario;
                }

                // Creamos el pedido en estado "Pendiente de pago".
                Pedido nuevoPedido = new Pedido();
                nuevoPedido.Cliente = usuario;
                nuevoPedido.FormaEntrega = formaEntrega;
                nuevoPedido.Direccion = direccionSeleccionada;
                nuevoPedido.FormaPago = formaPago;
                nuevoPedido.Total = totalReal;
                nuevoPedido.Items = itemsPedido;

                PedidoNegocio pedidoNegocio = new PedidoNegocio();
                int idPedido = pedidoNegocio.AgregarPedido(nuevoPedido);

                // Vaciamos el carrito una vez creado el pedido.
                Session["Carrito"] = null;

                // Si eligió Mercado Pago vamos a la pantalla de pago simulado; si no, mostramos confirmación.
                if (formaPago.Descripcion.IndexOf("Mercado Pago", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    Response.Redirect("MercadoPagoSimulado.aspx?id=" + idPedido, false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                pnlCheckout.Visible = false;
                pnlConfirmacion.Visible = true;
                lblPedidoConfirmadoId.Text = idPedido.ToString();

                if (formaPago.Descripcion.IndexOf("Transferencia", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    lblDetallePagoConfirmado.Text = $"Total: {totalReal:C}. Podés subir tu comprobante de transferencia desde la sección Mis compras.";
                }
                else
                {
                    lblDetallePagoConfirmado.Text = $"Total: {totalReal:C}. Forma de pago elegida: {formaPago.Descripcion}.";
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo confirmar el pedido: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}
