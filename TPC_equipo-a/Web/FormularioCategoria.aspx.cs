using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace Web
{
    public partial class FormularioCategoria : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            try
            {
                Categoria nuevaCategoria = new Categoria();
                nuevaCategoria.Nombre = txtNombre.Text;
                nuevaCategoria.Descripcion = txtDescripcion.Text;

                CategoriaNegocio negocio = new CategoriaNegocio();
                negocio.agregarCategoria(nuevaCategoria);

                Response.Redirect("AdminCategorias.aspx", false);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}