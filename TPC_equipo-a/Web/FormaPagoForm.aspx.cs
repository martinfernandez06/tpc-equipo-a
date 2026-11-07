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

                // Validacion para repetidos
                List<FormaPago> lista = negocio.Listar();
                bool nombreRepetido = false;

                // Decidimos si modificamos o agregamos
                if (Request.QueryString["id"] != null)
                {
                    // Si estamos modificando, nos fijamos que el nombre no lo tenga OTRO id distinto al nuestro
                    nueva.Id = int.Parse(Request.QueryString["id"].ToString());
                    nombreRepetido = lista.Exists(x => x.Descripcion.ToUpper() == nueva.Descripcion.ToUpper() && x.Id != nueva.Id);
                }
                else
                {
                    // Si es nueva, nos fijamos que el nombre no exista en toda la lista
                    nombreRepetido = lista.Exists(x => x.Descripcion.ToUpper() == nueva.Descripcion.ToUpper());
                }

                if (nombreRepetido)
                {
                    // Si está repetido, mostramos el error y frenamos la ejecución con un return
                    lblError.Text = "¡Error! Ya existe una forma de pago con ese nombre.";
                    lblError.Visible = true;
                    return;
                }
                // --- FIN DE LA VALIDACIÓN ---

                // Si pasamos la validación, ocultamos el error por las dudas y guardamos
                lblError.Visible = false;

                if (Request.QueryString["id"] != null)
                {
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
        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            // Si se arrepiente, lo mandamos de vuelta al listado.
            Response.Redirect("AdminFormasPago.aspx", false);
        }
    }
}