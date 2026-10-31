using System;
using System.Collections.Generic;
using System.Web.UI;
using Dominio;
using Negocio;

namespace Web
{
    public partial class AdminProductos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Valido que se ejecute solo en la primera carga para evitar Postbacks

            if (!IsPostBack)
            {
                CargarProductos();
            }
        }

        private void CargarProductos()
        {
            try
            {
                ProductoNegocio negocio = new ProductoNegocio();
                List<Producto> lista = negocio.Listar();

                // Vinculo la lista mediante el Procedimiento Almacenado al Repeater

                repProductos.DataSource = lista;
                repProductos.DataBind();
            }
            catch (Exception ex)
            {
                // Manejo de errores en consola

                System.Diagnostics.Debug.WriteLine("Error al listar los productos: " + ex.Message);
            }
        }



        protected void btnAgregar_Click(object sender, EventArgs e) {
    
        // Redirige al formulario de alta de productos
        Response.Redirect("FormularioProducto.aspx", false);
}




    }
}