using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio;

namespace Web
{
    public partial class AdminFormasPago : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                FormaPagoNegocio negocio = new FormaPagoNegocio();
                dgvFormasPago.DataSource = negocio.Listar();
                dgvFormasPago.DataBind();
            }
        }
        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormaPagoForm.aspx", false);
        }

        protected void dgvFormasPago_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Capturamos el ID de la fila seleccionada para enviarlo por la URL
            string id = dgvFormasPago.SelectedDataKey.Value.ToString();
            Response.Redirect("FormaPagoForm.aspx?id=" + id, false);
        }
        protected void dgvFormasPago_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            // Verificamos que hayan hecho click.
            if (e.CommandName == "CambiarEstado")
            {
                // Obtenemos el número de fila que se clickeó
                int index = Convert.ToInt32(e.CommandArgument);
                // Extraemos el ID de esa fila
                int id = Convert.ToInt32(dgvFormasPago.DataKeys[index].Value);

                FormaPagoNegocio negocio = new FormaPagoNegocio();

                // Buscamos la forma de pago original para saber si estaba en true o false
                System.Collections.Generic.List<Dominio.FormaPago> lista = negocio.Listar();
                Dominio.FormaPago seleccionada = lista.Find(x => x.Id == id);

                if (seleccionada != null)
                {
                    // Llamamos a CambiarEstado, pasándole el ID y el valor CONTRARIO al actual(!)
                    negocio.CambiarEstado(id, !seleccionada.Activa);

                    // Refrescamos la grilla para que se vea el cambio
                    CargarGrilla();
                }
            }
        }

        // Método auxiliar para no repetir código
        private void CargarGrilla()
        {
            FormaPagoNegocio negocio = new FormaPagoNegocio();
            System.Collections.Generic.List<Dominio.FormaPago> lista = negocio.Listar();

            // Aplicamos el filtro de la lista
            if (ddlFiltro.SelectedValue == "Activos")
            {
                lista = lista.FindAll(x => x.Activa == true);
            }
            else if (ddlFiltro.SelectedValue == "Inactivos")
            {
                lista = lista.FindAll(x => x.Activa == false);
            }

            dgvFormasPago.DataSource = lista;
            dgvFormasPago.DataBind();
        }

        // Este evento se dispara automáticamente al cambiar el valor del DropDownList
        protected void ddlFiltro_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarGrilla();
        }
    }
}