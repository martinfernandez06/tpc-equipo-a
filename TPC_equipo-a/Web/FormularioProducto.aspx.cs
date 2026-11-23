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
        protected global::System.Web.UI.WebControls.TextBox txtCodigo;
        protected global::System.Web.UI.WebControls.Label lblError;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // leo el id de la url, si no vino queda vacio
                string id = Request.QueryString["id"] != null ? Request.QueryString["id"].ToString() : "";

                CategoriaNegocio catNegocio = new CategoriaNegocio();

                // limpiamos antes de cargar para que no se acumulen
                ddlCategoria.Items.Clear();

                // traigo las categorias activas y las guardo para usarlas abajo al modificar
                List<Categoria> activas = catNegocio.listarActivas();
                ddlCategoria.DataSource = activas;
                ddlCategoria.DataTextField = "Nombre";
                ddlCategoria.DataValueField = "Id";
                ddlCategoria.DataBind();

                ddlCategoria.Items.Insert(0, new ListItem("Seleccione una categoría...", "0"));

                if (id != "")
                {
                    // traigo todos los productos y busco el que tiene el id de la url
                    ProductoNegocio negocio = new ProductoNegocio();
                    List<Producto> lista = negocio.Listar();
                    Producto seleccionado = lista.Find(x => x.Id == int.Parse(id));

                    if (seleccionado == null)
                    {
                        Response.Redirect("AdminProductos.aspx", false);
                        return;
                    }

                    // precargo los datos
                    if (txtCodigo != null) txtCodigo.Text = seleccionado.Codigo;
                    txtNombre.Text = seleccionado.Nombre;
                    txtDescripcion.Text = seleccionado.Descripcion;
                    // paso el precio a texto con punto decimal, que es lo que entiende el campo numerico
                    txtPrecio.Text = seleccionado.PrecioVenta.ToString("0.00", CultureInfo.InvariantCulture);
                    txtStock.Text = seleccionado.Stock.ToString();
                    txtImagenUrl.Text = seleccionado.ImagenUrl;

                    // si la categoria del producto fue desactivada, la agrego marcada para que se pueda guardar sin cambiarla
                    Categoria categoriaActiva = activas.Find(x => x.Id == seleccionado.Categoria.Id);
                    if (categoriaActiva == null)
                    {
                        ddlCategoria.Items.Add(new ListItem(seleccionado.Categoria.Nombre + " (inactiva)", seleccionado.Categoria.Id.ToString()));
                    }
                    ddlCategoria.SelectedValue = seleccionado.Categoria.Id.ToString();

                    lblTitulo.Text = "Modificar producto";
                    btnAceptar.Text = "Modificar";

                    // estado y boton de baja/alta logica 
                    lblEstado.Text = "Activo";
                    lblEstado.CssClass = "badge bg-success";
                    if (!seleccionado.Activo)
                    {
                        btnEstado.Text = "Activar";
                        lblEstado.Text = "Inactivo";
                        lblEstado.CssClass = "badge bg-secondary";
                        btnEstado.CssClass = "btn btn-admin-secundario ms-auto";
                    }
                }
                else
                {
                    // en el alta no hay estado para mostrar ni para cambiar
                    lblTitulo.Text = "Nuevo producto";
                    btnAceptar.Text = "Crear";
                    lblEstado.Visible = false;
                    btnEstado.Visible = false;
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

                // el precio viene con punto del campo numerico, lo leo en formato neutro
                decimal precio = decimal.Parse(txtPrecio.Text, NumberStyles.Number, CultureInfo.InvariantCulture);
                int stock = int.Parse(txtStock.Text);

                Producto producto = new Producto();
                producto.Categoria = new Categoria();

                // pasamos el codigo propio (o nulo para autogenerar)
                producto.Codigo = (txtCodigo != null && !string.IsNullOrWhiteSpace(txtCodigo.Text)) ? txtCodigo.Text.Trim() : null;
                producto.Nombre = txtNombre.Text.Trim();
                producto.Descripcion = txtDescripcion.Text.Trim();
                producto.PrecioVenta = precio;
                producto.Stock = stock;
                producto.ImagenUrl = txtImagenUrl.Text.Trim();
                producto.Categoria.Id = int.Parse(ddlCategoria.SelectedValue);

                ProductoNegocio negocio = new ProductoNegocio();

                if (Request.QueryString["id"] != null)
                {
                    producto.Id = int.Parse(Request.QueryString["id"]);
                    negocio.Modificar(producto);
                }
                else
                {
                    negocio.Agregar(producto);
                }

                Response.Redirect("AdminProductos.aspx", false);
            }
            catch (Exception ex)
            {
                if (ex.Message.ToLower().Contains("ya existe") || ex.Message.ToLower().Contains("código"))
                {
                    lblError.Text = "Este código ya está en uso. Elegí otro o dejalo vacío.";
                    lblError.Visible = true;
                }
                else
                {
                    lblError.Text = "Error de base de datos: " + ex.Message;
                    lblError.Visible = true;
                }
            }
        }

        protected void btnEstado_Click(object sender, EventArgs e)
        {
            try
            {
                // si va a desactivar primero muestro el recuadro para confirmar y corto aca
                // si dice activar sigue de largo y lo reactiva directo
                if (btnEstado.Text == "Desactivar")
                {
                    pnlConfirmar.Visible = true;
                    pnlBotones.Visible = false;
                    return;
                }

                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"]);
                    ProductoNegocio negocio = new ProductoNegocio();
                    negocio.eliminarLogico(id);

                    Response.Redirect("AdminProductos.aspx", false);
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo cambiar el estado del producto: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnNoDesactivar_Click(object sender, EventArgs e)
        {
            pnlConfirmar.Visible = false;
            pnlBotones.Visible = true;
        }

        protected void btnSiDesactivar_Click(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"]);
                    ProductoNegocio negocio = new ProductoNegocio();
                    negocio.eliminarLogico(id);

                    Response.Redirect("AdminProductos.aspx", false);
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo desactivar el producto: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}