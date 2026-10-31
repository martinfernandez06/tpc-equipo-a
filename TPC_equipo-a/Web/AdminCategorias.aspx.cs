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
    }
}