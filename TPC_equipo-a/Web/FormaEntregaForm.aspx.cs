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
                        chkActiva.Checked = seleccionada.Activa;

                        // Cargamos también el estado de este campo nuevo
                        chkRequiereDireccion.Checked = seleccionada.RequiereDireccion;
                    }
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                FormaEntrega nueva = new FormaEntrega();
                FormaEntregaNegocio negocio = new FormaEntregaNegocio();

                nueva.Descripcion = txtDescripcion.Text;
                nueva.Activa = chkActiva.Checked;
                nueva.RequiereDireccion = chkRequiereDireccion.Checked;

                if (Request.QueryString["id"] != null)
                {
                    nueva.Id = int.Parse(Request.QueryString["id"].ToString());
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

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminFormasEntrega.aspx", false);
        }
    }
}