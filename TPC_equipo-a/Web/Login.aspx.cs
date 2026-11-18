
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
                // Si se inició sesión previamente, redirige al destino correspondiente.
                if (Session["usuario"] != null)
                {
                    Usuario usuario = Session["usuario"] as Usuario;

                    if (usuario != null &&
                        usuario.Perfil != null &&
                        usuario.Perfil.Id == 1)
                    {
                        Response.Redirect("AdminProductos.aspx", false);
                    }
                    else if (Session["volverAlCheckout"] != null &&
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

                // Muestra alerta de éxito si viene del registro.
                if (Request.QueryString["registrado"] == "exito")
                {
                    pnlExito.Visible = true;
                }

                // Muestra aviso si viene del Checkout.
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

                // Validar credenciales.
                Usuario user = negocio.Login(
                    txtEmail.Text.Trim(),
                    txtPassword.Text
                );

                if (user == null)
                {
                    lblError.Text = "Correo electrónico o contraseña incorrectos, o la cuenta se encuentra desactivada.";
                    lblError.Visible = true;
                    return;
                }

                // Verificar que el usuario tenga un perfil asignado.
                if (user.Perfil == null)
                {
                    lblError.Text = "No se pudo verificar el perfil de tu cuenta.";
                    lblError.Visible = true;
                    return;
                }

                // Si seleccionó ingresar como administrador,
                // debe tener perfil Administrador (ID 1).
                if (chkAdministrador.Checked && user.Perfil.Id != 1)
                {
                    lblError.Text = "Tu cuenta no tiene permisos de administrador.";
                    lblError.Visible = true;
                    return;
                }

                // Si no seleccionó administrador, debe ser Cliente (ID 2).
                if (!chkAdministrador.Checked && user.Perfil.Id != 2)
                {
                    lblError.Text = "Esta cuenta no corresponde al acceso de cliente. Seleccioná el acceso correspondiente.";
                    lblError.Visible = true;
                    return;
                }

                // Actualiza fecha y hora del último acceso en la BD.
                negocio.ActualizarUltimoAcceso(user.Id);

                // Sincroniza la propiedad local y guarda el objeto en sesión.
                user.UltimoAcceso = DateTime.Now;
                Session["usuario"] = user;

                // Si ingresó como administrador, va directamente al panel.
                if (user.Perfil.Id == 1)
                {
                    Session.Remove("volverAlCheckout");

                    Response.Redirect("AdminProductos.aspx", false);
                }
                // Si es cliente y venía del Checkout, continúa la compra.
                else if (Session["volverAlCheckout"] != null &&
                         (bool)Session["volverAlCheckout"])
                {
                    Session.Remove("volverAlCheckout");
                    Response.Redirect("Checkout.aspx", false);
                }
                // Si es cliente, va a la tienda.
                else
                {
                    Response.Redirect("Default.aspx", false);
                }

                Context.ApplicationInstance.CompleteRequest();
            }
            catch (Exception ex)
            {
                lblError.Text = "No fue posible iniciar sesión. Intentá nuevamente: " + ex.Message;
                lblError.Visible = true;
            }
        }
    }
}
