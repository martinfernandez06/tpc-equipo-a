using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class FormularioProducto : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // leo el id de la url, si no vino queda vacio
                string id = Request.QueryString["id"] != null ? Request.QueryString["id"].ToString() : "";

                CategoriaNegocio catNegocio = new CategoriaNegocio();

                // LIMPIAMOS ANTES DE CARGAR PARA QUE NO SE ACUMULEN
                ddlCategoria.Items.Clear();

                // traigo las categorias activas y las guardo para usarlas abajo al modificar
                List<Categoria> activas = catNegocio.listarActivas();
                ddlCategoria.DataSource = activas;
                ddlCategoria.DataTextField = "Nombre";
                ddlCategoria.DataValueField = "Id";
                ddlCategoria.DataBind();

                // 2. Agregamos el ítem por defecto al inicio
                ddlCategoria.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccione una categoría...", "0"));

                if (id != "")
                {
                    // traigo todos los productos y busco el que tiene el id de la url
                    ProductoNegocio negocio = new ProductoNegocio();
                    List<Producto> lista = negocio.Listar();
                    // el id viene como texto, lo paso a int para compararlo con el id del producto
                    Producto seleccionado = lista.Find(x => x.Id == int.Parse(id));

                    txtNombre.Text = seleccionado.Nombre;
                    txtDescripcion.Text = seleccionado.Descripcion;
                    // paso el precio a texto con punto decimal, que es lo que entiende el campo numerico
                    txtPrecio.Text = seleccionado.PrecioVenta.ToString("0.00", CultureInfo.InvariantCulture);
                    txtStock.Text = seleccionado.Stock.ToString();
                    txtImagenUrl.Text = seleccionado.ImagenUrl;
                    // busco la categoria del producto entre las activas
                    Categoria categoriaActiva = activas.Find(x => x.Id == seleccionado.Categoria.Id);
                    // si no esta es porque la desactivaron, la agrego marcada para que se pueda guardar sin cambiarla
                    if (categoriaActiva == null)
                    {
                        // agrega una opción al final del DropDownList
                        ddlCategoria.Items.Add(new ListItem(seleccionado.Categoria.Nombre + " (inactiva)", seleccionado.Categoria.Id.ToString()));
                    }
                    ddlCategoria.SelectedValue = seleccionado.Categoria.Id.ToString();
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            try
            {
                // reviso los validadores, si algo esta mal corto aca y se ven los mensajes en rojo
                Page.Validate();
                if (!Page.IsValid)
                    return;

                // los validadores ya revisaron el precio y el stock, aca solo los paso a numero
                // el precio viene con punto del campo numerico, lo leo en formato neutro
                decimal precio = decimal.Parse(txtPrecio.Text, NumberStyles.Number, CultureInfo.InvariantCulture);
                int stock = int.Parse(txtStock.Text);

                // Si todas las validaciones son correctas, armo el objeto Producto
                Producto producto = new Producto();
                producto.Categoria = new Categoria();

                producto.Nombre = txtNombre.Text.Trim();
                producto.Descripcion = txtDescripcion.Text.Trim();
                producto.PrecioVenta = precio;
                producto.Stock = stock;
                producto.ImagenUrl = txtImagenUrl.Text.Trim();
                producto.Categoria.Id = int.Parse(ddlCategoria.SelectedValue);

                ProductoNegocio negocio = new ProductoNegocio();

                // Si vino el id en la url es una modificacion
                if (Request.QueryString["id"] != null)
                {
                    // el id viene como texto, lo parseo a int 
                    producto.Id = int.Parse(Request.QueryString["id"]);
                    negocio.Modificar(producto);
                }
                // Si no vino un id es un producto nuevo
                else
                {
                    negocio.Agregar(producto);
                }

                // Redirijo al panel de administracion
                Response.Redirect("AdminProductos.aspx", false);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
