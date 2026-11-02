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
                        lblTitulo.Text = "Modificar categoria";
                        btnAceptar.Text = "Modificar";

                        if (!seleccionada.Activa)
                        {
                            btnEstado.Text = "Activar";
                        }
                    }
                    else
                    {
                        btnEstado.Visible = false;
                        lblTitulo.Text = "Nueva categoria";
                        btnAceptar.Text = "Crear";
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

        protected void btnEstado_Click(object sender, EventArgs e)
        {
            try
            {
                // solo si vino id en la url
                if (Request.QueryString["id"] != null)
                {
                    CategoriaNegocio negocio = new CategoriaNegocio();
                    // paso a int el id que vino en la url
                    int Id = int.Parse(Request.QueryString["id"]);
                    // traigo la categoria de la bd para saber si esta activa o no
                    Categoria nueva = negocio.buscarPorId(Id);
                    // le doy vuelta el estado, si estaba activa queda inactiva y al reves
                    nueva.Activa = !nueva.Activa;
                    // guardo el estado nuevo en la bd
                    negocio.cambiarEstadoCategoria(Id,nueva.Activa);

                    Response.Redirect("AdminCategorias.aspx", false);
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}