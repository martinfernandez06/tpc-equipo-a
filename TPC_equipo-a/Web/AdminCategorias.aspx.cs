using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class AdminCategorias : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CategoriaNegocio negocio = new CategoriaNegocio();

                // Le pasamos la lista de la base de datos a nuestro GridView
                dgvCategorias.DataSource = negocio.listar();

                // Renderizamos los datos en la tabla
                dgvCategorias.DataBind();
            }

        }
        // se ejecuta al tocar editar en una fila
        protected void dgvCategorias_SelectedIndexChanged(object sender, EventArgs e)
        {
            // var toma el tipo solo. traigo el id escondido de la fila y lo paso a texto
            var id = dgvCategorias.SelectedDataKey.Value.ToString();

            // voy al formulario con el id por url el ? le diremos que parametros pasaremos
            Response.Redirect($"FormularioCategoria.aspx?id={id}",false);
        }
    }
}