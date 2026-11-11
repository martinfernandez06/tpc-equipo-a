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
    public partial class FormaPagoForm : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"].ToString());
                    FormaPagoNegocio negocio = new FormaPagoNegocio();

                    List<FormaPago> lista = negocio.Listar();
                    FormaPago seleccionada = lista.Find(x => x.Id == id);

                    if (seleccionada != null)
                    {
                        txtDescripcion.Text = seleccionada.Descripcion;
                        chkActiva.Checked = seleccionada.Activa;

                        lblTitulo.Text = "Modificar Forma de Pago";
                    }
                }
                else
                {
                    lblTitulo.Text = "Nueva Forma de Pago";
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

                FormaPagoNegocio negocio = new FormaPagoNegocio();

                int id = Request.QueryString["id"] != null ? int.Parse(Request.QueryString["id"]) : 0;

                if (negocio.existeDescripcion(txtDescripcion.Text, id))
                {
                    lblError.Text = "Ya existe una forma de pago con esa descripción.";
                    lblError.Visible = true;
                    return;
                }

                FormaPago nueva = new FormaPago();
                nueva.Descripcion = txtDescripcion.Text;
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

                Response.Redirect("AdminFormasPago.aspx", false);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}