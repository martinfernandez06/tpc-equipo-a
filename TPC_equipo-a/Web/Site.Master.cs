using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Buscamos el carrito en la memoria
            if (Session["Carrito"] != null)
            {
                Dominio.Carrito carrito = (Dominio.Carrito)Session["Carrito"];

                // Si hay productos, mostramos el globito con el número total de artículos
                if (carrito.CantidadArticulos > 0)
                {
                    lblCantidadCarrito.Text = carrito.CantidadArticulos.ToString();
                    lblCantidadCarrito.Visible = true;
                }
                else
                {
                    lblCantidadCarrito.Visible = false;
                }
            }
            else
            {
                lblCantidadCarrito.Visible = false;
            }
        }
    }
}