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
        protected void Page_Load(object sender, EventArgs e) {
        
        if (!IsPostBack) {

        // Cargo categorias en el DropDownList

        CategoriaNegocio catNegocio = new CategoriaNegocio();

        ddlCategoria.DataSource = catNegocio.listar();

        ddlCategoria.DataTextField = "Nombre";

        ddlCategoria.DataValueField = "Id";

        ddlCategoria.DataBind();
        

    }
}


    protected void btnAceptar_Click(object sender, EventArgs e) {

    try
    {
        // Instancio  nuevo producto y categoria

        Producto nuevo = new Producto();
        nuevo.Categoria = new Categoria();

        // Asigno los valores de los controles de la pantalla

        nuevo.Nombre = txtNombre.Text;
        nuevo.Descripcion = txtDescripcion.Text;
        nuevo.PrecioVenta = decimal.Parse(txtPrecio.Text);
        nuevo.Stock = int.Parse(txtStock.Text);
        nuevo.ImagenUrl = txtImagenUrl.Text;
        nuevo.Categoria.Id = int.Parse(ddlCategoria.SelectedValue);
        nuevo.Activo = true;

        // Llamo al negocio para guardar en la BD

        ProductoNegocio negocio = new ProductoNegocio();
        negocio.Agregar(nuevo);

        // // Vuelvo al listado

        Response.Redirect("AdminProductos.aspx", false);
    }
    catch (Exception ex)
    {
        // Manejo de errores para mostrar un label con el mensaje
        System.Diagnostics.Debug.WriteLine(ex.Message);
    }
}


















    }
}