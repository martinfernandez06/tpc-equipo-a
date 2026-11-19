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
    public partial class Carrito : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCarrito();
            }
        }

        // Método auxiliar para no repetir código. Dibuja el carrito y calcula totales.
        private void CargarCarrito()
        {
            // Traemos el carrito de la Session
            Dominio.Carrito carrito = Session["Carrito"] != null ? (Dominio.Carrito)Session["Carrito"] : new Dominio.Carrito();

            // Si hay productos, mostramos la tabla. Si no, mostramos el cartel de vacío.
            if (carrito.Items.Count > 0)
            {
                // Actualizamos el stock de cada ítem con la base de datos para deshabilitar el botón + correctamente
                ProductoNegocio negocio = new ProductoNegocio();
                List<Producto> listaDb = negocio.Listar();
                foreach (ItemCarrito item in carrito.Items)
                {
                    Producto productoDb = listaDb.Find(x => x.Id == item.Producto.Id);
                    if (productoDb != null)
                    {
                        item.Producto.Stock = productoDb.Stock;
                    }
                }

                rptCarrito.DataSource = carrito.Items;
                rptCarrito.DataBind();

                // Actualizamos los importes en la tarjetita de resumen
                lblSubtotalResumen.Text = carrito.Total.ToString("C");
                lblTotalResumen.Text = carrito.Total.ToString("C");

                divTablaCarrito.Visible = true;
                lblVacio.Visible = false;
                btnCheckout.Enabled = true;
            }
            else
            {
                divTablaCarrito.Visible = false;
                lblVacio.Visible = true;
                lblSubtotalResumen.Text = "$0,00";
                lblTotalResumen.Text = "$0,00";
                btnCheckout.Enabled = false;
            }
        }

        // Este evento atrapa los clics en los botones de +, - y Eliminar de cualquier fila
        protected void rptCarrito_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblError.Visible = false;

            Dominio.Carrito carrito = Session["Carrito"] != null ? (Dominio.Carrito)Session["Carrito"] : new Dominio.Carrito();

            // Leemos el ID del producto que viene oculto en el CommandArgument del botón HTML
            int idProducto = int.Parse(e.CommandArgument.ToString());
            ItemCarrito item = carrito.Items.Find(i => i.Producto.Id == idProducto);

            if (item != null)
            {
                if (e.CommandName == "Sumar")
                {
                    // Vamos a la base a chequear el stock real antes de dejarlo sumar
                    ProductoNegocio negocio = new ProductoNegocio();
                    Producto productoDb = negocio.Listar().Find(x => x.Id == idProducto);

                    if (productoDb != null && item.Cantidad < productoDb.Stock)
                    {
                        item.Cantidad++;
                        item.Producto.Stock = productoDb.Stock;
                    }
                    else
                    {
                        lblError.Text = "No podés sumar más unidades de '" + item.Producto.Nombre + "' porque llegaste al límite del stock disponible.";
                        lblError.Visible = true;
                    }
                }
                else if (e.CommandName == "Restar")
                {
                    // Solo restamos si hay más de 1 unidad; el borrado queda exclusivo para el botón eliminar
                    if (item.Cantidad > 1)
                    {
                        item.Cantidad--;
                    }
                }
                else if (e.CommandName == "Eliminar")
                {
                    carrito.Items.Remove(item);
                }

                // Guardamos los cambios en Session y volvemos a dibujar la pantalla
                Session["Carrito"] = carrito;
                CargarCarrito();
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            // Dejo listo para la proxima tarjeta...
            Response.Redirect("Checkout.aspx", false);
        }
    }
}