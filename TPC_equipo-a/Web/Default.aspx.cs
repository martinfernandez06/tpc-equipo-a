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

        // Evento del botón Al Carrito
        protected void btnAgregarCarrito_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int idProducto = int.Parse(btn.CommandArgument);

            // Lógica para guardar en Session
            System.Diagnostics.Debug.WriteLine("Agregar producto ID: " + idProducto);
        }
    }
}
