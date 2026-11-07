using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Negocio;

namespace Web
{
    public partial class AdminFormasEntrega : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarGrilla();
            }
        }

        protected void btnAgregar_Click(object sender, EventArgs e)
        {
            Response.Redirect("FormaEntregaForm.aspx", false);
        }

        protected void dgvFormasEntrega_SelectedIndexChanged(object sender, EventArgs e)
        {
            string id = dgvFormasEntrega.SelectedDataKey.Value.ToString();
            Response.Redirect("FormaEntregaForm.aspx?id=" + id, false);
        }
        protected void dgvFormasEntrega_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CambiarEstado")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                int id = Convert.ToInt32(dgvFormasEntrega.DataKeys[index].Value);

                FormaEntregaNegocio negocio = new FormaEntregaNegocio();
                System.Collections.Generic.List<Dominio.FormaEntrega> lista = negocio.Listar();
                Dominio.FormaEntrega seleccionada = lista.Find(x => x.Id == id);

                if (seleccionada != null)
                {
                    negocio.CambiarEstado(id, !seleccionada.Activa);
                    CargarGrilla();
                }
            }
        }
        // Agregamos el método auxiliar 
        private void CargarGrilla()
        {
            FormaEntregaNegocio negocio = new FormaEntregaNegocio();
            System.Collections.Generic.List<Dominio.FormaEntrega> lista = negocio.Listar();

            if (ddlFiltro.SelectedValue == "Activos")
            {
                lista = lista.FindAll(x => x.Activa == true);
            }
            else if (ddlFiltro.SelectedValue == "Inactivos")
            {
                lista = lista.FindAll(x => x.Activa == false);
            }

            dgvFormasEntrega.DataSource = lista;
            dgvFormasEntrega.DataBind();
        }

        // 3. Agregamos el evento del filtro
        protected void ddlFiltro_SelectedIndexChanged(object sender, EventArgs e)
        {
            CargarGrilla();
        }
    }
}