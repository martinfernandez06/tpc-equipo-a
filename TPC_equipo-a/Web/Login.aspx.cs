
using System;
using Dominio;
using Negocio;

namespace Web
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Si se inició sesión previamente redirige al destino correspondiente
                if (Session["usuario"] != null)
                {
                    if (Session["volverAlCheckout"] != null &&
                        (bool)Session["volverAlCheckout"])
                    {
                        Session.Remove("volverAlCheckout");
                        Response.Redirect("Checkout.aspx", false);
                    }
                    else
                    {
                        Response.Redirect("Default.aspx", false);
                    }

                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Muestra alerta de éxito si viene del registro
                if (Request.QueryString["registrado"] == "exito")
                {
                    pnlExito.Visible = true;
                }

                // Muestra aviso si viene del Checkout
                if (Session["mensajeCheckout"] != null)
                {
                    pnlAvisoCheckout.Visible = true;
                    Session.Remove("mensajeCheckout");
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();

                // Intenta buscar el usuario por email y contraseña (el SP ya filtra Activo = 1)
                Usuario user = negocio.Login(txtEmail.Text.Trim(), txtPassword.Text);

                if (user != null)
                {
                    // Actualiza fecha y hora del último acceso en la BD
                    negocio.ActualizarUltimoAcceso(user.Id);

                    // Sincroniza la propiedad local y guarda el objeto en sesión
                    user.UltimoAcceso = DateTime.Now;
                    Session["usuario"] = user;

                    // Si venía intentando comprar, lo manda al Checkout
                    if (Session["volverAlCheckout"] != null &&
                        (bool)Session["volverAlCheckout"])
                    {
                        Session.Remove("volverAlCheckout");
                        Response.Redirect("Checkout.aspx", false);
                    }
                    else
                    {
                        // Si entró al login, redirige a página principal
                        Response.Redirect("Default.aspx", false);
                    }

                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    // Si retorna null las credenciales son incorrectas o el usuario está inactivo
                    lblError.Text = "Correo electrónico o contraseña incorrectos, o la cuenta se encuentra desactivada.";
                    lblError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No fue posible iniciar sesión. Intentá nuevamente: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}
