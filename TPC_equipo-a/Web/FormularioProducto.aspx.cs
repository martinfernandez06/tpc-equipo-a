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
    protected void Page_Load(object sender, EventArgs e)
{
    if (!IsPostBack)
{
    CategoriaNegocio catNegocio = new CategoriaNegocio();
    
    // LIMPIAMOS ANTES DE CARGAR PARA QUE NO SE ACUMULEN
    ddlCategoria.Items.Clear(); 
    
    ddlCategoria.DataSource = catNegocio.listarActivas();
    ddlCategoria.DataTextField = "Nombre";
    ddlCategoria.DataValueField = "Id";
    ddlCategoria.DataBind();

        // 2. Agregamos el ítem por defecto al inicio
        ddlCategoria.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Seleccione una categoría...", "0"));

        // 3. Valido si recibo un ID por URL (Modificación)
        if (Request.QueryString["id"] != null) 
        {
            int id = int.Parse(Request.QueryString["id"]);
            ProductoNegocio negocio = new ProductoNegocio();
            
            List<Producto> lista = negocio.Listar(); 
            Producto seleccionado = lista.Find(x => x.Id == id);

            if (seleccionado != null)
            {
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
            Session.Remove("productoModificando");
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

        //Validar Precio (obligatorio, formato numérico y mayor a cero)
        if (!decimal.TryParse(txtPrecio.Text.Replace('.', ','), out decimal precio) || precio <= 0)
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

        //es un Alta o una Modificacion
        if (Session["productoModificando"] == null)
        {
            // Es un Alta nuevo
            negocio.Agregar(producto);
        }
        else
        {
            // Es una Modificacion recupero el ID
            producto.Id = (int)Session["productoModificando"];
            negocio.Modificar(producto);
            
            // Limpio la sesion
            Session.Remove("productoModificando");
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
