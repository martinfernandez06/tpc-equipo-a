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
                string idParam = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out int id))
                {
                    FormaPagoNegocio negocio = new FormaPagoNegocio();
                    List<FormaPago> lista = negocio.Listar();
                    FormaPago seleccionada = lista.Find(x => x.Id == id);

                    if (seleccionada == null)
                    {
                        Response.Redirect("AdminFormasPago.aspx", false);
                        return;
                    }

                    txtDescripcion.Text = seleccionada.Descripcion;
                    chkRequiereComprobante.Checked = seleccionada.RequiereComprobante;

                    lblTitulo.Text = "Modificar forma de pago";
                    btnGuardar.Text = "Modificar";

                    lblEstado.Text = "Activa";
                    lblEstado.CssClass = "badge bg-success";

                    if (!seleccionada.Activa)
                    {
                        btnEstado.Text = "Activar";
                        lblEstado.Text = "Inactiva";
                        lblEstado.CssClass = "badge bg-secondary";
                        btnEstado.CssClass = "btn btn-admin-secundario ms-auto";
                    }
                }
                else
                {
                    lblTitulo.Text = "Nueva forma de pago";
                    btnGuardar.Text = "Crear";
                    lblEstado.Visible = false;
                    btnEstado.Visible = false;
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                lblError.Visible = false;
                lblError.Text = "";

                Page.Validate();
                if (!Page.IsValid)
                    return;

                string descripcion = txtDescripcion.Text.Trim();
                int id = Request.QueryString["id"] != null ? int.Parse(Request.QueryString["id"]) : 0;

                FormaPagoNegocio negocio = new FormaPagoNegocio();

                if (negocio.existeDescripcion(descripcion, id))
                {
                    lblError.Text = "Ya existe una forma de pago con esa descripción.";
                    lblError.Visible = true;
                    return;
                }

                FormaPago formaPago = new FormaPago();
                formaPago.Descripcion = descripcion;
                formaPago.RequiereComprobante = chkRequiereComprobante.Checked;

                if (id != 0)
                {
                    formaPago.Id = id;
                    negocio.Modificar(formaPago);
                }
                else
                {
                    formaPago.Activa = true;
                    negocio.Agregar(formaPago);
                }

                Response.Redirect("AdminFormasPago.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo guardar la forma de pago: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnEstado_Click(object sender, EventArgs e)
        {
            try
            {
                if (btnEstado.Text == "Desactivar")
                {
                    pnlConfirmar.Visible = true;
                    pnlBotones.Visible = false;
                    return;
                }

                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"]);
                    FormaPagoNegocio negocio = new FormaPagoNegocio();
                    negocio.CambiarEstado(id, true);

                    Response.Redirect("AdminFormasPago.aspx", false);
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo cambiar el estado: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnNoDesactivar_Click(object sender, EventArgs e)
        {
            pnlConfirmar.Visible = false;
            pnlBotones.Visible = true;
        }

        protected void btnSiDesactivar_Click(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"]);
                    FormaPagoNegocio negocio = new FormaPagoNegocio();
                    negocio.CambiarEstado(id, false);

                    Response.Redirect("AdminFormasPago.aspx", false);
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo desactivar la forma de pago: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}