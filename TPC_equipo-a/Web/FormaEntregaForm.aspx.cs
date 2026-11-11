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
    public partial class FormaEntregaForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"].ToString());
                    FormaEntregaNegocio negocio = new FormaEntregaNegocio();

                    List<FormaEntrega> lista = negocio.Listar();
                    FormaEntrega seleccionada = lista.Find(x => x.Id == id);

                    if (seleccionada != null)
                    {
                        txtDescripcion.Text = seleccionada.Descripcion;
                        chkRequiereDireccion.Checked = seleccionada.RequiereDireccion;
                        chkActiva.Checked = seleccionada.Activa;

                        lblTitulo.Text = "Modificar Forma de Entrega";
                    }
                }
                else
                {
                    lblTitulo.Text = "Nueva Forma de Entrega";
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                Page.Validate();
                if (!Page.IsValid)
                    return;

                FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                int id = Request.QueryString["id"] != null ? int.Parse(Request.QueryString["id"]) : 0;

                if (negocio.existeDescripcion(txtDescripcion.Text, id))
                {
                    lblError.Text = "Ya existe una forma de entrega con esa descripción.";
                    lblError.Visible = true;
                    return;
                }

                FormaEntrega nueva = new FormaEntrega();
                nueva.Descripcion = txtDescripcion.Text;
                nueva.RequiereDireccion = chkRequiereDireccion.Checked;
                nueva.Activa = chkActiva.Checked;
                lblError.Visible = false;

                if (id != 0)
                {
                    nueva.Id = id;
                    negocio.Modificar(nueva);
                }
                else
                {
                    negocio.Agregar(nueva);
                }

                Response.Redirect("AdminFormasEntrega.aspx", false);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}