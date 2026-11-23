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
                string idParam = Request.QueryString["id"];

                if (!string.IsNullOrEmpty(idParam) && int.TryParse(idParam, out int id))
                {
                    FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                    List<FormaEntrega> lista = negocio.Listar();
                    FormaEntrega seleccionada = lista.Find(x => x.Id == id);

                    if (seleccionada == null)
                    {
                        Response.Redirect("AdminFormasEntrega.aspx", false);
                        return;
                    }

                    txtDescripcion.Text = seleccionada.Descripcion;
                    chkRequiereDireccion.Checked = seleccionada.RequiereDireccion;

                    lblTitulo.Text = "Modificar forma de entrega";
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
                    lblTitulo.Text = "Nueva forma de entrega";
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

                FormaEntregaNegocio negocio = new FormaEntregaNegocio();

                if (negocio.existeDescripcion(descripcion, id))
                {
                    lblError.Text = "Ya existe una forma de entrega con esa descripción.";
                    lblError.Visible = true;
                    return;
                }

                FormaEntrega formaEntrega = new FormaEntrega();
                formaEntrega.Descripcion = descripcion;
                formaEntrega.RequiereDireccion = chkRequiereDireccion.Checked;

                if (id != 0)
                {
                    formaEntrega.Id = id;
                    negocio.Modificar(formaEntrega);
                }
                else
                {
                    formaEntrega.Activa = true;
                    negocio.Agregar(formaEntrega);
                }

                Response.Redirect("AdminFormasEntrega.aspx", false);
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo guardar la forma de entrega: " + ex.Message;
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
                    FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                    negocio.CambiarEstado(id, true);

                    Response.Redirect("AdminFormasEntrega.aspx", false);
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
                    FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                    negocio.CambiarEstado(id, false);

                    Response.Redirect("AdminFormasEntrega.aspx", false);
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No se pudo desactivar la forma de entrega: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}