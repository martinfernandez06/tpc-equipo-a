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

                ddlCategoria.DataSource = catNegocio.listarActivas();
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
                    ddlCategoria.SelectedValue = seleccionado.Categoria.Id.ToString();
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones de campos de texto
                if (string.IsNullOrWhiteSpace(txtNombre.Text))
                {
                    MostrarAlerta("El nombre del producto es obligatorio.");
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtDescripcion.Text))
                {
                    MostrarAlerta("La descripción es obligatoria.");
                    return;
                }

                // Validar que se haya seleccionado una categoría 
                if (ddlCategoria.SelectedValue == "0" || string.IsNullOrEmpty(ddlCategoria.SelectedValue))
                {
                    MostrarAlerta("Debe seleccionar una categoría válida.");
                    return;
                }

                // el campo numerico siempre manda el precio con punto, lo leo en formato neutro
                if (!decimal.TryParse(txtPrecio.Text, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal precio) || precio <= 0)
                {
                    MostrarAlerta("El precio es obligatorio y debe ser mayor a cero.");
                    return;
                }

                // Validar Stock (obligatorio, número entero y no negativo)
                if (!int.TryParse(txtStock.Text, out int stock) || stock < 0)
                {
                    MostrarAlerta("El stock es obligatorio y no puede ser negativo.");
                    return;
                }

                // Si todas las validaciones son correctas, armo el objeto Producto
                Producto producto = new Producto();
                producto.Categoria = new Categoria();

                producto.Nombre = txtNombre.Text.Trim();
                producto.Descripcion = txtDescripcion.Text.Trim();
                producto.PrecioVenta = precio;
                producto.Stock = stock;
                producto.ImagenUrl = txtImagenUrl.Text.Trim();
                producto.Categoria.Id = int.Parse(ddlCategoria.SelectedValue);
                producto.Activo = true;

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
                MostrarAlerta("Ocurrió un error: " + ex.Message.Replace("'", ""));
            }
        }

        //  auxiliar para mostrar alertas en el navegador 
        private void MostrarAlerta(string mensaje)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertaValidacion", $"alert('{mensaje}');", true);
        }

    }
}
