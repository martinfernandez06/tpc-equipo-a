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

        // Sincroniza stock/estado con la BD, dibuja el carrito y devuelve true si está apto para iniciar compra
        private bool CargarCarrito()
        {
            Dominio.Carrito carrito = Session["Carrito"] != null ? (Dominio.Carrito)Session["Carrito"] : new Dominio.Carrito();

            if (carrito.Items.Count > 0)
            {
                ProductoNegocio negocio = new ProductoNegocio();
                List<Producto> listaDb = negocio.Listar();

                bool haySinStockOInactivo = false;
                bool hayCantidadExcedida = false;

                foreach (ItemCarrito item in carrito.Items)
                {
                    Producto productoDb = listaDb.Find(x => x.Id == item.Producto.Id);
                    if (productoDb != null)
                    {
                        item.Producto.Stock = productoDb.Stock;
                        item.Producto.Activo = productoDb.Activo;
                        item.Producto.PrecioVenta = productoDb.PrecioVenta;

                        if (!productoDb.Activo || productoDb.Stock <= 0)
                        {
                            haySinStockOInactivo = true;
                        }
                        else if (item.Cantidad > productoDb.Stock)
                        {
                            hayCantidadExcedida = true;
                        }
                    }
                    else
                    {
                        item.Producto.Stock = 0;
                        item.Producto.Activo = false;
                        haySinStockOInactivo = true;
                    }
                }

                Session["Carrito"] = carrito;

                rptCarrito.DataSource = carrito.Items;
                rptCarrito.DataBind();

                lblSubtotalResumen.Text = carrito.Total.ToString("C");
                lblTotalResumen.Text = carrito.Total.ToString("C");

                divTablaCarrito.Visible = true;
                lblVacio.Visible = false;

                if (haySinStockOInactivo && hayCantidadExcedida)
                {
                    lblAvisoStock.Text = "Tenés productos sin stock y otros que superan la disponibilidad. Quitalos o bajá la cantidad para poder iniciar la compra.";
                    lblAvisoStock.Visible = true;
                    btnCheckout.Enabled = false;
                    return false;
                }
                else if (haySinStockOInactivo)
                {
                    lblAvisoStock.Text = "Tenés productos sin stock o no disponibles. Quitalos del carrito para poder iniciar la compra.";
                    lblAvisoStock.Visible = true;
                    btnCheckout.Enabled = false;
                    return false;
                }
                else if (hayCantidadExcedida)
                {
                    lblAvisoStock.Text = "La cantidad elegida de algún producto supera el stock disponible. Bajá la cantidad o quitalo del carrito para continuar.";
                    lblAvisoStock.Visible = true;
                    btnCheckout.Enabled = false;
                    return false;
                }
                else
                {
                    lblAvisoStock.Visible = false;
                    btnCheckout.Enabled = true;
                    return true;
                }
            }
            else
            {
                divTablaCarrito.Visible = false;
                lblVacio.Visible = true;
                lblAvisoStock.Visible = false;
                lblSubtotalResumen.Text = "$0,00";
                lblTotalResumen.Text = "$0,00";
                btnCheckout.Enabled = false;
                return false;
            }
        }

        // Atrapa los clics en los botones de +, - y Eliminar de cualquier fila
        protected void rptCarrito_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            lblError.Visible = false;

            Dominio.Carrito carrito = Session["Carrito"] != null ? (Dominio.Carrito)Session["Carrito"] : new Dominio.Carrito();

            int idProducto = int.Parse(e.CommandArgument.ToString());
            ItemCarrito item = carrito.Items.Find(i => i.Producto.Id == idProducto);

            if (item != null)
            {
                if (e.CommandName == "Sumar")
                {
                    ProductoNegocio negocio = new ProductoNegocio();
                    Producto productoDb = negocio.Listar().Find(x => x.Id == idProducto);

                    if (productoDb != null && productoDb.Activo && item.Cantidad < productoDb.Stock)
                    {
                        item.Cantidad++;
                        item.Producto.Stock = productoDb.Stock;
                    }
                    else
                    {
                        lblError.Text = "No podés sumar más unidades de \"" + item.Producto.Nombre + "\" porque llegaste al límite disponible.";
                        lblError.Visible = true;
                    }
                }
                else if (e.CommandName == "Restar")
                {
                    if (item.Cantidad > 1)
                    {
                        item.Cantidad--;
                    }
                }
                else if (e.CommandName == "Eliminar")
                {
                    carrito.Items.Remove(item);
                }

                Session["Carrito"] = carrito;
                CargarCarrito();
            }
        }

        protected void btnIniciarCompra_Click(object sender, EventArgs e)
        {
            // Revalidamos stock antes de dejar pasar al checkout
            if (!CargarCarrito())
                return;

            if (Session["usuario"] == null)
            {
                Response.Redirect("Login.aspx?redirect=checkout", false);
                Context.ApplicationInstance.CompleteRequest();
            }
            else
            {
                Response.Redirect("Checkout.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }
    }
}