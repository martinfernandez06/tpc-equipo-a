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
                // 1. Cargo las categorías en el DropDownList
                CategoriaNegocio catNegocio = new CategoriaNegocio();
                ddlCategoria.Items.Clear();
                
                List<Categoria> activas = catNegocio.listarActivas();
                ddlCategoria.DataSource = activas;
                ddlCategoria.DataTextField = "Nombre";
                ddlCategoria.DataValueField = "Id";
                ddlCategoria.DataBind();

                // Agregamos el ítem por defecto al inicio
                ddlCategoria.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccione una categoría...", "0"));

                // 2. Validamos si recibimos un ID por la URL (Modificación)
                string idStr = Request.QueryString["id"] != null ? Request.QueryString["id"].ToString() : "";

                if (idStr != "")
                {
                    int id = int.Parse(idStr);
                    ProductoNegocio negocio = new ProductoNegocio();
                    List<Producto> lista = negocio.Listar();
                    Producto seleccionado = lista.Find(x => x.Id == id);

                    if (seleccionado != null)
                    {
                        // Guardamos el ID en la Session para usarlo al momento de guardar
                        Session.Add("productoModificando", seleccionado.Id);

                        // Pre-cargamos los controles con los datos existentes
                        txtNombre.Text = seleccionado.Nombre;
                        txtDescripcion.Text = seleccionado.Descripcion;
                        txtPrecio.Text = seleccionado.PrecioVenta.ToString("0.00", CultureInfo.InvariantCulture);
                        txtStock.Text = seleccionado.Stock.ToString();
                        txtImagenUrl.Text = seleccionado.ImagenUrl;

                        // Verificamos si la categoría del producto sigue activa
                        Categoria categoriaActiva = activas.Find(x => x.Id == seleccionado.Categoria.Id);
                        if (categoriaActiva == null)
                        {
                            ddlCategoria.Items.Add(new ListItem(seleccionado.Categoria.Nombre + " (inactiva)", seleccionado.Categoria.Id.ToString()));
                        }

                        ddlCategoria.SelectedValue = seleccionado.Categoria.Id.ToString();
                    }
                }
                else
                {
                    // Si entramos sin ID (es un Alta nuevo), limpiamos la sesión por seguridad

                    Session.Remove("productoModificando");
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            try
            {
                // Validaciones obligatorias de campos de texto

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

                // 2. Validar que se haya seleccionado una categoría válida

                if (ddlCategoria.SelectedValue == "0" || string.IsNullOrEmpty(ddlCategoria.SelectedValue))
                {
                    MostrarAlerta("Debe seleccionar una categoría válida.");
                    return;
                }

                // 3. Validar Precio (obligatorio, formato numérico y mayor a cero) 

                if (!decimal.TryParse(txtPrecio.Text, NumberStyles.Number, CultureInfo.InvariantCulture, out decimal precio) || precio <= 0)
                {
                    MostrarAlerta("El precio es obligatorio y debe ser mayor a cero.");
                    return;
                }

                // 4. Validar Stock (obligatorio, número entero y no negativo)

                if (!int.TryParse(txtStock.Text, out int stock) || stock < 0)
                {
                    MostrarAlerta("El stock es obligatorio y no puede ser negativo.");
                    return;
                }

                // Si todas las validaciones son correctas, armamos el objeto Producto
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

                // 5. Evaluamos si es un Alta o una Modificación según la Session
                if (Session["productoModificando"] == null)
                {
                    // Es un Alta nuevo
                    negocio.Agregar(producto);
                }
                else
                {
                    // Es una Modificación (recuperamos el ID de la sesión)
                    producto.Id = (int)Session["productoModificando"];
                    negocio.Modificar(producto);

                    // Limpiamos la sesión una vez utilizado
                    Session.Remove("productoModificando");
                }

                // Redirigimos al panel de administración
                Response.Redirect("AdminProductos.aspx", false);
            }
            catch (Exception ex)
            {
                MostrarAlerta("Ocurrió un error: " + ex.Message.Replace("'", ""));
            }
        }

        // Método auxiliar para mostrar alertas emergentes en el navegador
        private void MostrarAlerta(string mensaje)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "alertaValidacion", $"alert('{mensaje}');", true);
        }
    }
}