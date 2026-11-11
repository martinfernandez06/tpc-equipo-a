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
                ProductoNegocio negocio = new ProductoNegocio();
                // traigo todos los productos de la bd
                List<Producto> lista = negocio.Listar();
                // me quedo solo con los activos, los inactivos no se muestran en la tienda
                lista = lista.FindAll(x => x.Activo);
                // le paso la lista al repeater y la dibujo
                repProductos.DataSource = lista;
                repProductos.DataBind();
                // si no quedo ningun producto activo muestro el aviso
                if (lista.Count == 0)
                {
                    lblSinProductos.Visible = true;
                }
            }
        }
    }
}
