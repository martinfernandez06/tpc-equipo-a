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
    public partial class FormularioProducto : System.Web.UI.Page
    {
       protected void Page_Load(object sender, EventArgs e){

    if (!IsPostBack)
    {
        // Cargo las categorias en el DropDownList

        CategoriaNegocio catNegocio = new CategoriaNegocio();
        ddlCategoria.DataSource = catNegocio.listar();
        ddlCategoria.DataTextField = "Nombre";
        ddlCategoria.DataValueField = "Id";
        ddlCategoria.DataBind();

        // Item por defecto al inicio para mejorar la exp de usuario

        ddlCategoria.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccione una categoría...", "0"));

        // Valido si recibo un ID por URL (Modificacion)

        if (Request.QueryString["id"] != null) {

            int id = int.Parse(Request.QueryString["id"]);

            ProductoNegocio negocio = new ProductoNegocio();
            
            // Busco el producto en la lista por su ID

            List<Producto> lista = negocio.Listar(); 

            Producto seleccionado = lista.Find(x => x.Id == id);

            if (seleccionado != null)
            {
                // Guardo el ID en la Session para usarlo al momento de guardar

                Session.Add("productoModificando", seleccionado.Id);

               

                txtNombre.Text = seleccionado.Nombre;
                txtDescripcion.Text = seleccionado.Descripcion;
                txtPrecio.Text = seleccionado.PrecioVenta.ToString("0.00");
                txtStock.Text = seleccionado.Stock.ToString();
                txtImagenUrl.Text = seleccionado.ImagenUrl;
                ddlCategoria.SelectedValue = seleccionado.Categoria.Id.ToString();
            }
        }
        else
        {
            //sin ID es un Alta nuevo, limpio la session por seguridad

            Session.Remove("productoModificando");
        }
    }
}

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            try
            {
                Producto producto = new Producto();
                producto.Categoria = new Categoria();

              
                producto.Nombre = txtNombre.Text;
                producto.Descripcion = txtDescripcion.Text;
                producto.PrecioVenta = decimal.Parse(txtPrecio.Text);
                producto.Stock = int.Parse(txtStock.Text);
                producto.ImagenUrl = txtImagenUrl.Text;
                producto.Categoria.Id = int.Parse(ddlCategoria.SelectedValue);
                producto.Activo = true; 

                ProductoNegocio negocio = new ProductoNegocio();

                // Verifico si modifica o agrega
                if (string.IsNullOrEmpty(hfId.Value))
                {
                    // Es un Alta
                    negocio.Agregar(producto);
                }
                else
                {
                    // Es una Modificación (asigo ID existente)
                    producto.Id = int.Parse(hfId.Value);
                    negocio.Modificar(producto);
                }

            
                Response.Redirect("AdminProductos.aspx", false);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }
    }
}