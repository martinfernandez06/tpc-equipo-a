using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class AdminProductos : System.Web.UI.Page
    {

    protected global::System.Web.UI.WebControls.TextBox txtFiltroNombre;
        protected global::System.Web.UI.WebControls.DropDownList ddlFiltroCategoria;
        protected global::System.Web.UI.WebControls.DropDownList ddlFiltroEstado;
        protected global::System.Web.UI.WebControls.Button btnFiltrar;
       
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();

                // Cargar categorias para el filtro

                CategoriaNegocio catNegocio = new CategoriaNegocio();
                ddlFiltroCategoria.DataSource = catNegocio.listar();
                ddlFiltroCategoria.DataTextField = "Nombre";
                ddlFiltroCategoria.DataValueField = "Id";
                ddlFiltroCategoria.DataBind();
                ddlFiltroCategoria.Items.Insert(0, new ListItem("Todas", "0"));
            }
        }

        protected void btnAgregar_Click(object sender, EventArgs e) 
        {
            // Redirige al formulario de alta de productos

            Response.Redirect("FormularioProducto.aspx", false);
        }
        
        protected void btnEliminar_Click(object sender, EventArgs e) 
        {
            try 
            {
                // Recupero ID de producto desde CommandArgument de LinkButton
                LinkButton btn = (LinkButton)sender;
                int id = int.Parse(btn.CommandArgument);

                ProductoNegocio negocio = new ProductoNegocio();
                negocio.eliminarLogico(id);

                // Recargo la grilla aplicando los filtros actuales para no perder la vista
                CargarGrilla(); 
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }

       private void CargarGrilla() {
        
       try{

        ProductoNegocio negocio = new ProductoNegocio();
        List<Producto> lista = negocio.Listar();

        // Filtro por Nombre (Solo filtra si se escribio algo)
        string filtroNombre = txtFiltroNombre.Text.Trim();
        if (!string.IsNullOrEmpty(filtroNombre))
        {
            lista = lista.FindAll(x => x.Nombre.ToUpper().Contains(filtroNombre.ToUpper()));
        }

        // Filtro por Categoría (Solo filtra si se selecciono una categoria distinta de "Todas")
        // validar que el DropDownList tenga items cargados antes de parsear
        if (ddlFiltroCategoria.Items.Count > 0)
        {
            int idCategoria = int.Parse(ddlFiltroCategoria.SelectedValue);
            if (idCategoria != 0)
            {
                lista = lista.FindAll(x => x.Categoria.Id == idCategoria);
            }
        }

        // Filtro por Estado (Solo filtra si no esta en "Todos")
        int estado = int.Parse(ddlFiltroEstado.SelectedValue);
        if (estado != -1)
        {
            bool estadoBool = (estado == 1);
            lista = lista.FindAll(x => x.Activo == estadoBool);
        }

        // Enlace con el Repeater
        repProductos.DataSource = lista;
        repProductos.DataBind();
    }
    catch (Exception ex)
    {
        System.Diagnostics.Debug.WriteLine("Error al listar los productos: " + ex.Message);
    }
}
        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            CargarGrilla();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            txtFiltroNombre.Text = "";
            ddlFiltroCategoria.SelectedIndex = 0;
            ddlFiltroEstado.SelectedIndex = 0;
            CargarGrilla();
        }
    }
}