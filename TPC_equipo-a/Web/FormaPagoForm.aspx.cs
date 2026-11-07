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
                // Si la URL trae un "?id=...", significa que venimos a MODIFICAR
                if (Request.QueryString["id"] != null)
                {
                    int id = int.Parse(Request.QueryString["id"].ToString());
                    FormaPagoNegocio negocio = new FormaPagoNegocio();

                    // Buscamos la forma de pago en la lista para rellenar los datos
                    List<FormaPago> lista = negocio.Listar();
                    FormaPago seleccionada = lista.Find(x => x.Id == id);

                    if (seleccionada != null)
                    {
                        txtDescripcion.Text = seleccionada.Descripcion;
                        chkActiva.Checked = seleccionada.Activa;
                    }
                }
            }
        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                FormaPago nueva = new FormaPago();
                FormaPagoNegocio negocio = new FormaPagoNegocio();

                // Capturamos lo que escribió el usuario en la pantalla
                nueva.Descripcion = txtDescripcion.Text;
                nueva.Activa = chkActiva.Checked;

                // Decidimos si modificamos o agregamos
                if (Request.QueryString["id"] != null)
                {
                    nueva.Id = int.Parse(Request.QueryString["id"].ToString());
                    negocio.Modificar(nueva); // Llama al UPDATE de SQL
                }
                else
                {
                    negocio.Agregar(nueva); // Llama al INSERT de SQL
                }

                // Volvemos a la tabla para ver los cambios
                Response.Redirect("AdminFormasPago.aspx", false);
            }
            catch (Exception ex)
            {
                // Si hay error en la base de datos, frena acá
                throw ex;
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            // Si se arrepiente, lo mandamos de vuelta al listado.
            Response.Redirect("AdminFormasPago.aspx", false);
        }
    }
}