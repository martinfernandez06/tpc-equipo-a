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
    public partial class DetalleProducto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Capturamos el ID que viene en la URL
                string idString = Request.QueryString["id"];

                if (int.TryParse(idString, out int idProducto))
                {
                    ProductoNegocio negocio = new ProductoNegocio();

                    // Traemos la lista y buscamos el producto específico
                    List<Producto> lista = negocio.Listar();
                    Producto seleccionado = lista.Find(x => x.Id == idProducto);

                    if (seleccionado != null)
                    {
                        // Inyectamos los datos reales en las etiquetas del HTML
                        lblNombre.Text = seleccionado.Nombre;
                        lblCodigo.Text = seleccionado.Codigo ?? "N/A"; // Si es null, muestra N/A
                        lblCategoria.Text = seleccionado.Categoria.Nombre;
                        lblDescripcion.Text = seleccionado.Descripcion;
                        lblPrecio.Text = seleccionado.PrecioVenta.ToString("C"); // "C" le da formato de moneda local
                        lblStock.Text = seleccionado.Stock.ToString();
                        imgProducto.Src = seleccionado.ImagenUrl;

                        // la miga de la categoria lleva al catalogo ya filtrado por esa categoria
                        hlMigaCategoria.NavigateUrl = "~/Default?categoria=" + seleccionado.Categoria.Id;

                        // si el producto no tiene foto cargada uso la imagen generica, igual que en el catalogo
                        if (string.IsNullOrEmpty(seleccionado.ImagenUrl))
                        {
                            imgProducto.Src = ResolveUrl("~/Imagenes/sin-imagen.svg");
                        }

                        // stock en palabras con la misma regla que el catalogo, sin stock no se puede tocar la cantidad ni el boton
                        lblTextoStock.Text = _Default.TextoStock(seleccionado.Stock);
                        lblTextoStock.CssClass = "texto-stock d-block mb-4 " + _Default.ClaseStock(seleccionado.Stock);
                        txtCantidad.Enabled = _Default.HayStock(seleccionado.Stock);
                        btnAgregarCarrito.Enabled = _Default.HayStock(seleccionado.Stock);

                        btnMenos.Enabled = _Default.HayStock(seleccionado.Stock);
                        btnMas.Enabled = _Default.HayStock(seleccionado.Stock);
                        txtCantidad.Attributes["max"] = seleccionado.Stock.ToString(); // las flechitas del navegador tampoco pasan del stock

                        // Atrapamos el aviso oculto adentro del if del producto seleccionado
                        if (Request.QueryString["error"] == "stock")
                        {
                            lblError.Text = "No podés agregar más unidades. Alcanzaste el límite de stock disponible.";
                            lblError.Visible = true;
                        }

                        // abajo del boton muestro como se puede recibir y pagar
                        CargarFormas();
                    }
                    else
                    {
                        // Si mandan un ID que no existe en la base, los devolvemos al catálogo
                        Response.Redirect("Default.aspx", false);
                    }
                }
                else
                {
                    // Si entran directo a la página sin un ID válido en la URL, los devolvemos al catálogo
                    Response.Redirect("Default.aspx", false);
                }
            }
        }

        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            lblExito.Visible = false;

            // Validamos que lo que escribió el cliente sea un número válido mayor a cero
            if (!int.TryParse(txtCantidad.Text, out int cantidadSolicitada) || cantidadSolicitada <= 0)
            {
                lblError.Text = "La cantidad debe ser un número válido mayor a cero.";
                lblError.Visible = true;
                return;
            }

            // Leemos lo que hay de stock real en pantalla
            int stockDisponible = int.Parse(lblStock.Text);

            // Validación: No pueden pedir más de lo que hay
            if (cantidadSolicitada > stockDisponible)
            {
                lblError.Text = "No hay suficiente stock. Solo quedan " + stockDisponible + " unidades.";
                lblError.Visible = true;
            }
            else
            {
                // Buscamos el producto real de la base de datos
                int idProducto = int.Parse(Request.QueryString["id"]);
                ProductoNegocio negocio = new ProductoNegocio();
                Producto seleccionado = negocio.Listar().Find(x => x.Id == idProducto);

                // Traemos el carrito de la Session (o creamos uno nuevo vacío si es el primer producto)
                Dominio.Carrito carrito = Session["Carrito"] != null ? (Dominio.Carrito)Session["Carrito"] : new Dominio.Carrito();

                // Nos fijamos si el cliente ya tenía este mismo producto en el carrito
                ItemCarrito itemExistente = carrito.Items.Find(i => i.Producto.Id == seleccionado.Id);

                if (itemExistente != null)
                {
                    // Si ya estaba, sumamos la cantidad (validando que la suma no supere el stock de la base)
                    if (itemExistente.Cantidad + cantidadSolicitada > stockDisponible)
                    {
                        lblError.Text = "Ya tenés " + itemExistente.Cantidad + " unidades en el carrito. No podés superar el stock.";
                        lblError.Visible = true;
                        return; // Cortamos acá para que no lo agregue
                    }
                    itemExistente.Cantidad += cantidadSolicitada;
                }
                else
                {
                    // Si no estaba, creamos el ítem nuevo y lo metemos en la lista
                    ItemCarrito nuevoItem = new ItemCarrito();
                    nuevoItem.Producto = seleccionado;
                    nuevoItem.Cantidad = cantidadSolicitada;

                    carrito.Items.Add(nuevoItem);
                }

                // Sobreescribimos la Session con el carrito actualizado
                Session["Carrito"] = carrito;

                // Mostramos confirmación sin salir de la página y reseteamos la cantidad a 1
                lblExito.Text = "Producto agregado al carrito.";
                lblExito.Visible = true;
                txtCantidad.Text = "1";
            }
        }
        // suma uno a la cantidad sin pasar del stock
        protected void btnMas_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            lblExito.Visible = false;

            int stock = int.Parse(lblStock.Text);
            // si la caja tiene letras, esta vacia o tiene menos de 1, arranco de 0 asi el mas la deja en 1
            if (!int.TryParse(txtCantidad.Text, out int cantidad) || cantidad < 1)
            {
                cantidad = 0;
            }

            if (cantidad < stock)
            {
                cantidad = cantidad + 1;
            }
            else
            {
                cantidad = stock; // si escribieron a mano mas que el stock la bajo al maximo
            }
            txtCantidad.Text = cantidad.ToString();
        }

        // resta uno a la cantidad sin bajar de 1
        protected void btnMenos_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            lblExito.Visible = false;

            int stock = int.Parse(lblStock.Text);
            if (!int.TryParse(txtCantidad.Text, out int cantidad) || cantidad <= 1)
            {
                cantidad = 1;
            }
            else if (cantidad > stock)
            {
                cantidad = stock; // si escribieron a mano mas que el stock la bajo al maximo
            }
            else
            {
                cantidad = cantidad - 1;
            }
            txtCantidad.Text = cantidad.ToString();
        }

        // trae las formas de entrega y de pago activas y las muestra abajo del boton si no hay ninguna de un tipo se esconde esa parte
        private void CargarFormas()
        {
            FormaEntregaNegocio entregaNegocio = new FormaEntregaNegocio();
            List<FormaEntrega> entregas = entregaNegocio.Listar().FindAll(x => x.Activa);
            repFormasEntrega.DataSource = entregas;
            repFormasEntrega.DataBind();
            pnlFormasEntrega.Visible = entregas.Count > 0;

            FormaPagoNegocio pagoNegocio = new FormaPagoNegocio();
            List<FormaPago> pagos = pagoNegocio.Listar().FindAll(x => x.Activa);
            repFormasPago.DataSource = pagos;
            repFormasPago.DataBind();
            pnlFormasPago.Visible = pagos.Count > 0;

            // si no hay ninguna de las dos escondo la caja entera para que no quede el borde vacio
            pnlFormas.Visible = entregas.Count > 0 || pagos.Count > 0;
        }
    }
}