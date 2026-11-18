using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class AdminPedidos : System.Web.UI.Page
    {
        // lee los filtros de la barra y carga la grilla, lo usan todos los botones y el paginado
        // si los controles estan vacios los filtros quedan en null y trae todos los pedidos
        private void CargarPedidos()
        {
            // int? es un int que puede quedar en null, asi listarPedido sabe que no tiene que filtrar por ese dato
            int? idEstado = null;
            int estado;
            // tryparse no rompe si el valor viene mal, el out guarda ahi el numero si lo pudo convertir
            if (int.TryParse(ddlFiltroEstado.SelectedValue, out estado))
            {
                idEstado = estado;
            }

            // tryparse no rompe si llega una fecha mal, solo devuelve false y el filtro queda en null
            DateTime? fechaDesde = null;
            DateTime desde;
            if (DateTime.TryParse(txtDesde.Text, out desde))
            {
                fechaDesde = desde;
            }

            DateTime? fechaHasta = null;
            DateTime hasta;
            if (DateTime.TryParse(txtHasta.Text, out hasta))
            {
                fechaHasta = hasta;
            }

            PedidoNegocio negocio = new PedidoNegocio();
            dgvPedidos.DataSource = negocio.listarPedido(idEstado, fechaDesde, fechaHasta, txtCliente.Text);
            dgvPedidos.DataBind();
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            // el max hace que el calendario no deje elegir dias despues de la fecha actual
            // yyyy-MM-dd es el formato que entiende el calendario, MM es mes y mm serian minutos
            string hoy = DateTime.Today.ToString("yyyy-MM-dd");
            txtDesde.Attributes["max"] = hoy;
            txtHasta.Attributes["max"] = hoy;

            // los validadores comparan contra la fecha actual por si escriben la fecha a mano
            cvDesdeHoy.ValueToCompare = hoy;
            cvHastaHoy.ValueToCompare = hoy;

            if (!IsPostBack)
            {
                CargarPedidos();
            }
        }

        protected void dgvPedidos_SelectedIndexChanged(object sender, EventArgs e)
        {
            // var toma el tipo solo. traigo el id escondido de la fila y lo paso a texto
            var id = dgvPedidos.SelectedDataKey.Value.ToString();
            // voy al formulario con el id por url el ? le diremos que parametros pasaremos
            Response.Redirect($"DetallePedido.aspx?id={id}", false);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            // vuelvo a validar en el servidor por si se saltean la validacion del navegador
            Page.Validate("filtros");
            // isvalid solo se puede preguntar despues del validate, por eso va aca y no en cargarpedidos
            if (!Page.IsValid)
                return;
            // busqueda nueva arranca en la pagina 1
            dgvPedidos.PageIndex = 0;
            CargarPedidos();
        }

        protected void btnLimpiar_Click(object sender, EventArgs e)
        {
            // el 0 es la primera opcion de la lista, o sea todos
            ddlFiltroEstado.SelectedIndex = 0;
            txtCliente.Text = "";
            txtDesde.Text = "";
            txtHasta.Text = "";
            dgvPedidos.PageIndex = 0;
            // con los controles vacios cargarpedidos trae todo
            CargarPedidos();
        }

        protected void dgvPedidos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            // paso a la pagina que toco y vuelvo a cargar con los filtros puestos para no perderlos
            dgvPedidos.PageIndex = e.NewPageIndex;
            CargarPedidos();
        }
    }
}