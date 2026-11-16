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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                PedidoNegocio negocio = new PedidoNegocio();
                // los cuatro filtros en null para que al entrar traiga todos los pedidos
                dgvPedidos.DataSource = negocio.listarPedido(null, null, null, null);
                dgvPedidos.DataBind();
            }
        }

        protected void dgvPedidos_SelectedIndexChanged(object sender, EventArgs e)
        {
            // var toma el tipo solo. traigo el id escondido de la fila y lo paso a texto
            var id = dgvPedidos.SelectedDataKey.Value.ToString();
            // voy al formulario con el id por url el ? le diremos que parametros pasaremos
            Response.Redirect($"DetallePedido.aspx?id={id}", false);
        }
    }
}