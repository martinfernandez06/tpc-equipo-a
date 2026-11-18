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

                    if (item.Cantidad < productoDb.Stock)
                    {
                        item.Cantidad++;
                    }
                    else
                    {
                        lblError.Text = "No podés sumar más unidades de '" + productoDb.Nombre + "' porque llegaste al límite del stock disponible.";
                        lblError.Visible = true;
                    }
                }
                else if (e.CommandName == "Restar")
                {
                    if (item.Cantidad > 1)
                    {
                        item.Cantidad--;
                    }
                    else
                    {
                        // Si tiene 1 y toca restar de nuevo, directamente lo eliminamos del carrito
                        carrito.Items.Remove(item);
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
            // Dejamos esto listo para cuando arranques tu próxima tarjeta mañana
            Response.Redirect("Checkout.aspx", false);
        }
    }
}