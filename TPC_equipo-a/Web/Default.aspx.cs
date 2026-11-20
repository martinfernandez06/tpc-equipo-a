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
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                // Cargamos las categorías en el desplegable
                CategoriaNegocio catNegocio = new CategoriaNegocio();
                ddlCategorias.DataSource = catNegocio.listarActivas();
                ddlCategorias.DataTextField = "Nombre";
                ddlCategorias.DataValueField = "Id";
                ddlCategorias.DataBind();
                ddlCategorias.Items.Insert(0, new ListItem("Todas las categorías...", "0"));

                // si viene de las migas del detalle con ?categoria=id abro el catalogo ya filtrado por esa categoria
                string idCategoria = Request.QueryString["categoria"];
                if (!string.IsNullOrEmpty(idCategoria) && ddlCategorias.Items.FindByValue(idCategoria) != null)
                {
                    ddlCategorias.SelectedValue = idCategoria;
                }
                // Reemplazamos la lógica directa por el llamado a la función que la contiene
                CargarCatalogo();
            }
        }

        // Envolvemos la lógica en esta función para que el botón Buscar la pueda usar
        private void CargarCatalogo()
        {
            ProductoNegocio negocio = new ProductoNegocio();
            // traigo todos los productos de la bd
            List<Producto> lista = negocio.Listar();
            // me quedo solo con los activos, los inactivos no se muestran en la tienda
            lista = lista.FindAll(x => x.Activo);

            // Filtramos por lo que escriba el usuario (Nombre o Código)
            string textoBuscar = txtBuscar.Text.Trim().ToUpper();
            if (!string.IsNullOrEmpty(textoBuscar))
            {
                lista = lista.FindAll(x =>
                    x.Nombre.ToUpper().Contains(textoBuscar) ||
                    (x.Codigo != null && x.Codigo.ToUpper().Contains(textoBuscar))
                );
            }

            // Filtramos por la categoría elegida
            if (ddlCategorias.SelectedIndex > 0)
            {
                int idCategoria = int.Parse(ddlCategorias.SelectedValue);
                lista = lista.FindAll(x => x.Categoria.Id == idCategoria);
            }

            // si el producto no tiene foto cargada en la bd le pongo la imagen generica, como en la clase del perfil
            foreach (Producto p in lista)
            {
                if (string.IsNullOrEmpty(p.ImagenUrl))
                {
                    p.ImagenUrl = ResolveUrl("~/Imagenes/sin-imagen.svg");
                }
            }

            // le paso la lista al repeater y la dibujo
            repProductos.DataSource = lista;
            repProductos.DataBind();

            // si no quedo ningun producto muestro un aviso distinto si es por la busqueda o porque la tienda no tiene productos
            bool hayFiltro = !string.IsNullOrEmpty(txtBuscar.Text.Trim()) || ddlCategorias.SelectedIndex > 0;
            lblSinProductos.Visible = false;
            pnlSinResultados.Visible = false;
            if (lista.Count == 0)
            {
                if (hayFiltro)
                {
                    pnlSinResultados.Visible = true;
                }
                else
                {
                    lblSinProductos.Visible = true;
                }
            }
            // cantidad de productos que quedaron, el if es para que con uno solo no diga 1 productos
            if (lista.Count == 1)
            {
                lblCantidad.Text = "1 producto";
            }
            else
            {
                lblCantidad.Text = $"{lista.Count} productos";
            }

            // chips con lo que de verdad se filtro, el htmlencode es para que si escriben codigo se muestre como texto y no se ejecute
            bool hayTexto = !string.IsNullOrEmpty(txtBuscar.Text.Trim());
            bool hayCategoria = ddlCategorias.SelectedIndex > 0;
            btnQuitarTexto.Visible = hayTexto;
            btnQuitarTexto.Text = "\"" + HttpUtility.HtmlEncode(txtBuscar.Text.Trim()) + "\" <i class=\"bi bi-x\"></i>";
            btnQuitarCategoria.Visible = hayCategoria;
            btnQuitarCategoria.Text = ddlCategorias.SelectedItem.Text + " <i class=\"bi bi-x\"></i>";
            pnlFiltrando.Visible = hayTexto || hayCategoria;
        }

        // texto del stock que se ve en la tarjeta 3 o menos es pocos
        public static string TextoStock(object stock)
        {
            int cantidad = Convert.ToInt32(stock);
            if (cantidad <= 0)
            {
                return "Sin stock";
            }
            if (cantidad == 1)
            {
                return "Última unidad";
            }
            if (cantidad <= 3)
            {
                return "Últimas " + cantidad + " unidades";
            }
            return "En stock";
        }

        // clase del color del stock, se define en ecommerce.css
        public static string ClaseStock(object stock)
        {
            int cantidad = Convert.ToInt32(stock);
            if (cantidad <= 0)
            {
                return "stock-sin";
            }
            if (cantidad <= 3)
            {
                return "stock-pocos";
            }
            return "stock-ok";
        }

        // si no hay stock el boton agregar queda deshabilitado
        public static bool HayStock(object stock)
        {
            int cantidad = Convert.ToInt32(stock);
            if (cantidad > 0)
            {
                return true;
            }
            return false;
        }

        // Evento del botón Buscar
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            lblMensaje.Visible = false;
            CargarCatalogo();
        }

        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            lblMensaje.Visible = false;

            // Capturamos el botón que fue clickeado y leemos el ID del producto
            LinkButton btn = (LinkButton)sender;
            int idProducto = int.Parse(btn.CommandArgument);

            // Buscamos el producto real en la base de datos
            ProductoNegocio negocio = new ProductoNegocio();
            Producto seleccionado = negocio.Listar().Find(x => x.Id == idProducto);

            if (seleccionado == null)
            {
                return;
            }

            // Validamos que haya al menos 1 en stock en la base de datos
            if (seleccionado.Stock < 1)
            {
                // Validación 1: Cuando el stock absoluto es menor a 1.
                lblMensaje.CssClass = "alert alert-danger d-block mb-3";
                lblMensaje.Text = "No hay stock disponible para \"" + seleccionado.Nombre + "\".";
                lblMensaje.Visible = true;
                return;
            }

            // Traemos el carrito de la Session (o creamos uno nuevo)
            Dominio.Carrito carrito = Session["Carrito"] != null ? (Dominio.Carrito)Session["Carrito"] : new Dominio.Carrito();

            // Nos fijamos si ya lo tenía agregado de antes
            ItemCarrito itemExistente = carrito.Items.Find(i => i.Producto.Id == seleccionado.Id);

            if (itemExistente != null)
            {
                // Si ya lo tiene, le sumamos 1 (validando que la suma no supere el stock máximo)
                if (itemExistente.Cantidad + 1 <= seleccionado.Stock)
                {
                    itemExistente.Cantidad += 1;
                }
                else
                {
                    // Validación 2: Cuando sumar 1 supera el stock máximo
                    lblMensaje.CssClass = "alert alert-danger d-block mb-3";
                    lblMensaje.Text = "No podés agregar más unidades de \"" + seleccionado.Nombre + "\". Alcanzaste el límite de stock disponible (" + seleccionado.Stock + ").";
                    lblMensaje.Visible = true;
                    return;
                }
            }
            else
            {
                // Si es la primera vez que lo elige, creamos el ítem.
                ItemCarrito nuevoItem = new ItemCarrito();
                nuevoItem.Producto = seleccionado;
                nuevoItem.Cantidad = 1; // El agregado rápido suma de a 1.

                carrito.Items.Add(nuevoItem);
            }

            // Guardamos en la memoria y mostramos confirmación sin salir del catálogo
            Session["Carrito"] = carrito;
            lblMensaje.CssClass = "alert alert-success d-block mb-3";
            lblMensaje.Text = "Se agregó \"" + seleccionado.Nombre + "\" al carrito.";
            lblMensaje.Visible = true;
        }
        // deja el filtro como al entrar y vuelve a mostrar todos los productos
        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            lblMensaje.Visible = false;
            txtBuscar.Text = "";
            ddlCategorias.SelectedIndex = 0;
            CargarCatalogo();
        }

        // saca solo lo escrito y deja la categoria como estaba
        protected void btnQuitarTexto_Click(object sender, EventArgs e)
        {
            lblMensaje.Visible = false;
            txtBuscar.Text = "";
            CargarCatalogo();
        }
        // saca solo la categoria y deja lo escrito como estaba
        protected void btnQuitarCategoria_Click(object sender, EventArgs e)
        {
            lblMensaje.Visible = false;
            ddlCategorias.SelectedIndex = 0;
            CargarCatalogo();
        }
    }
}
