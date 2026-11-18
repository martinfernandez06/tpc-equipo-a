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

                if (!string.IsNullOrEmpty(idString))
                {
                    int idProducto = int.Parse(idString);
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

                        // Atrapamos el aviso oculto adentro del if del producto seleccionado
                        if (Request.QueryString["error"] == "stock")
                        {
                            lblError.Text = "No podés agregar más unidades. Alcanzaste el límite de stock disponible.";
                            lblError.Visible = true;
                        }
                    }
                    else
                    {
                        // Si mandan un ID que no existe en la base, los devolvemos al catálogo
                        Response.Redirect("Default.aspx", false);
                    }
                }
                else
                {
                    // Si entran directo a la página sin ID en la URL, los devolvemos al catálogo
                    Response.Redirect("Default.aspx", false);
                }
            }
        }

        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;

            // Leemos lo que escribió el cliente y lo que hay de stock real en pantalla
            int stockDisponible = int.Parse(lblStock.Text);
            int cantidadSolicitada = int.Parse(txtCantidad.Text);

            // Validación: No pueden pedir más de lo que hay, ni números menores a uno
            if (cantidadSolicitada > stockDisponible)
            {
                lblError.Text = "No hay suficiente stock. Solo quedan " + stockDisponible + " unidades.";
                lblError.Visible = true;
            }
            else if (cantidadSolicitada <= 0)
            {
                lblError.Text = "La cantidad debe ser mayor a cero.";
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

                // Llevamos al cliente a ver su carrito
                Response.Redirect("Carrito.aspx", false);
            }
        }
    }
}