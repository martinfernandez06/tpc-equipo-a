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
    public partial class AdminCategorias : System.Web.UI.Page
    {
        // filtra la lista guardada en session por nombre y por estado
        // la llaman los dos filtros y el paginado, asi siempre se aplican juntos
        private void filtrar()
        {
            // saco los espacios de adelante y de atras de lo que escribio
            string filtro = txtFiltro.Text.Trim();

            // traigo la lista de session, sin ir a la bd
            List<Categoria> lista = (List<Categoria>)Session["listaCategorias"];

            // filtro por nombre solo si escribio 2 letras o mas
            if (filtro.Length >= 2)
            {
                lista = lista.FindAll(x => x.Nombre.ToUpper().Contains(filtro.ToUpper()));
            }

            // filtro por estado, si elige todas no se filtra
            if (ddlEstado.SelectedValue == "Activas")
            {
                lista = lista.FindAll(x => x.Activa);
            }
            else if (ddlEstado.SelectedValue == "Inactivas")
            {
                lista = lista.FindAll(x => !x.Activa);
            }
            dgvCategorias.DataSource = lista;


            // mensaje que se ve si la tabla queda vacia
            if (filtro.Length >= 2)
            {
                dgvCategorias.EmptyDataText = $"No se encontraron categorias con {filtro}";
            }
            else
            {
                dgvCategorias.EmptyDataText = "No se encontraron categorias.";
            }

            // aviso en rojo si escribio una sola letra
            if (filtro.Length == 1)
            {
                lblAviso.Text = "Para buscar por nombre escribí 2 letras o más.";
            }
            else
            {
                lblAviso.Text = "";
            }
            dgvCategorias.DataBind();

        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CategoriaNegocio negocio = new CategoriaNegocio();
                // guardo la lista en session la primera vez para filtrar sin ir a la bd
                Session.Add("listaCategorias", negocio.listar());
                // le pasamos la lista de la base de datos a nuestro GridView
                dgvCategorias.DataSource = Session["listaCategorias"];
                // renderizamos los datos en la tabla
                dgvCategorias.DataBind();
            }

        }
        // se ejecuta al tocar editar en una fila
        protected void dgvCategorias_SelectedIndexChanged(object sender, EventArgs e)
        {
            // var toma el tipo solo. traigo el id escondido de la fila y lo paso a texto
            var id = dgvCategorias.SelectedDataKey.Value.ToString();

            // voy al formulario con el id por url el ? le diremos que parametros pasaremos
            Response.Redirect($"FormularioCategoria.aspx?id={id}", false);
        }
        // se ejecuta al salir del buscador despues de escribir
        protected void txtFiltro_TextChanged(object sender, EventArgs e)
        {
            dgvCategorias.PageIndex = 0; // filtro nuevo arranca en la pagina 1 
            filtrar();
        }
        // se ejecuta al elegir otra opcion del desplegable de estado
        protected void ddlEstado_SelectedIndexChanged(object sender, EventArgs e)
        {
            dgvCategorias.PageIndex = 0; // filtro nuevo arranca en la pagina 1 
            filtrar();
        }

        // se ejecuta al tocar un numero de pagina abajo de la tabla
        protected void dgvCategorias_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // paso a la pagina que toco y vuelvo a filtrar para no perder el filtro
            dgvCategorias.PageIndex = e.NewPageIndex;
            filtrar();
        }

        protected void btnLimpiarFiltro_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = "";
            ddlEstado.SelectedIndex = 0;
            dgvCategorias.PageIndex = 0;
            filtrar();
        }
    }
}