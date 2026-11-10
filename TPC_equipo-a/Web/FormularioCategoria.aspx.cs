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
                    string id = Request.QueryString["id"] != null ? Request.QueryString["id"].ToString() : "";

                    if (id != "")
                    {
                        CategoriaNegocio negocio = new CategoriaNegocio();
                        Categoria seleccionada = negocio.buscarPorId(int.Parse(id));

                        txtNombre.Text = seleccionada.Nombre;
                        txtDescripcion.Text = seleccionada.Descripcion;

                        chkActiva.Checked = seleccionada.Activa;
                        lblTitulo.Text = "Modificar Categoría";
                    }
                    else
                    {
                        lblTitulo.Text = "Nueva Categoría";
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
                CategoriaNegocio negocio = new CategoriaNegocio();

                lblNombreRepetido.Text = "";

                Page.Validate();
                if (!Page.IsValid)
                    return;

                int id = Request.QueryString["id"] != null ? int.Parse(Request.QueryString["id"]) : 0;

                if (negocio.existeNombreCategoria(txtNombre.Text, id))
                {
                    lblNombreRepetido.Text = "Ya existe una categoria con ese nombre.";
                    return;
                }

                // armo la categoria con lo que escribio el usuario
                Categoria nuevaCategoria = new Categoria();
                nuevaCategoria.Nombre = txtNombre.Text;
                nuevaCategoria.Descripcion = txtDescripcion.Text;
                nuevaCategoria.Activa = chkActiva.Checked;

                if (Request.QueryString["id"] != null)
                {
                    nuevaCategoria.Id = int.Parse(Request.QueryString["id"]);
                    negocio.modificarCategoria(nuevaCategoria);
                    negocio.cambiarEstadoCategoria(nuevaCategoria.Id, nuevaCategoria.Activa);
                }
                else
                {
                    negocio.agregarCategoria(nuevaCategoria);
                }

                Response.Redirect("AdminCategorias.aspx", false);
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
    }
}