using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using static System.Net.Mime.MediaTypeNames;

namespace Web
{
    public partial class FormularioCategoria : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    // leo el id de la url, si no vino queda vacio
                    string id = Request.QueryString["id"] != null ? Request.QueryString["id"].ToString() : "";

                    // si hay id es modificar, si esta vacio es un alta
                    if (id != "")
                    {
                        CategoriaNegocio negocio = new CategoriaNegocio();
                        // busco la categoria en la bd, el id viene como texto y lo paso a int
                        Categoria seleccionada = negocio.buscarPorId(int.Parse(id));

                        // precargo los datos
                        txtNombre.Text = seleccionada.Nombre;
                        txtDescripcion.Text = seleccionada.Descripcion;
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            try
            {
                // armo la categoria con lo que escribio el usuario
                Categoria nuevaCategoria = new Categoria();
                nuevaCategoria.Nombre = txtNombre.Text;
                nuevaCategoria.Descripcion = txtDescripcion.Text;


                CategoriaNegocio negocio = new CategoriaNegocio();
                // si vino id en la url es modificar
                if (Request.QueryString["id"] != null)
                {
                    // le cargo el id viene como texto, lo paso a int para que sepa cual cambiar
                    nuevaCategoria.Id = int.Parse(Request.QueryString["id"]);
                    negocio.modificarCategoria(nuevaCategoria);
                }
                // si no vino id es una categoria nueva
                else
                {
                    negocio.agregarCategoria(nuevaCategoria);
                }

                // vuelvo al listado, false para que no corte la ejecucion
                Response.Redirect("AdminCategorias.aspx", false);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}