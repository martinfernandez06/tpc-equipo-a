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

            // le paso la lista al repeater y la dibujo
            repProductos.DataSource = lista;
            repProductos.DataBind();

            // si no quedo ningun producto activo muestro el aviso
            if (lista.Count == 0)
            {
                lblSinProductos.Visible = true;
            }
            else
            {
                lblSinProductos.Visible = false; // Apagamos el aviso si la búsqueda encuentra algo
            }
        }

        // Evento del botón Buscar
        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            CargarCatalogo();
        }
        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            // Capturamos el botón que fue clickeado y leemos el ID del producto
            LinkButton btn = (LinkButton)sender;
            int idProducto = int.Parse(btn.CommandArgument);

            // Buscamos el producto real en la base de datos
            ProductoNegocio negocio = new ProductoNegocio();
            Producto seleccionado = negocio.Listar().Find(x => x.Id == idProducto);

            // Validamos que haya al menos 1 en stock en la base de datos
            if (seleccionado.Stock < 1)
            {
                // Validación 1: Cuando el stock absoluto es menor a 1.
                Response.Redirect("DetalleProducto.aspx?id=" + idProducto + "&error=stock", false);
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
                    Response.Redirect("DetalleProducto.aspx?id=" + idProducto + "&error=stock", false);
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

            // Guardamos en la memoria y lo llevamos a ver su carrito actualizado.
            Session["Carrito"] = carrito;
            Response.Redirect("Carrito.aspx", false);
        }
    }
}
