
using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;
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

                // alerta de éxito si viene del registro

                if (Request.QueryString["registrado"] == "exito")
                {
                    pnlExito.Visible = true;
                }

                //  aviso si viene del Checkout

                if (Session["mensajeCheckout"] != null)
                {
                    pnlAvisoCheckout.Visible = true;
                    Session.Remove("mensajeCheckout");
                }
            }

            // Muestra aviso si el registro se realizó y debe confirmar el correo
            if (Request.QueryString["registrado"] == "pendiente")
            {
                pnlExito.Visible = true;
                lblExito.Text = "Te enviamos un correo electrónico para confirmar tu dirección antes de iniciar sesión.";
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();

                // Validar credenciales

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

                // Verificar que el correo electrónico esté confirmado

                if (!user.EmailConfirmado)
                {
                    lblError.Text = "Debés confirmar tu correo electrónico antes de iniciar sesión. Revisá tu bandeja de entrada.";
                    lblError.Visible = true;
                    return;
                }

                // Verificar que el usuario tenga un perfil asignado

                if (user.Perfil == null)
                {
                    lblError.Text = "No se pudo verificar el perfil de tu cuenta.";
                    lblError.Visible = true;
                    return;
                }

                // Si seleccionó ingresar como administrador,
                // debe tener perfil Administrador (ID 1)

                if (chkAdministrador.Checked && user.Perfil.Id != 1)
                {
                    lblError.Text = "Tu cuenta no tiene permisos de administrador.";
                    lblError.Visible = true;
                    return;
                }

                // Si no seleccionó administrador, debe ser Cliente (ID 2)

                if (!chkAdministrador.Checked && user.Perfil.Id != 2)
                {
                    lblError.Text = "Esta cuenta no corresponde al acceso de cliente. Seleccioná el acceso correspondiente.";
                    lblError.Visible = true;
                    return;
                }

                // Actualiza fecha y hora del último acceso en la BD

                negocio.ActualizarUltimoAcceso(user.Id);

                // Sincroniza la propiedad local y guarda el objeto en sesión

                user.UltimoAcceso = DateTime.Now;
                Session["usuario"] = user;

                // Si seleccionó Recordarme, genera el token

                if (chkRecordarme.Checked)
                {
                    CrearTokenRecordarme(negocio, user.Id);
                }

                // Si ingresó como administrador, va al panel

                if (user.Perfil.Id == 1)
                {
                    Session.Remove("volverAlCheckout");

                    Response.Redirect("AdminProductos.aspx", false);
                }
                // Si es cliente y venía del Checkout, continúa la compra

                else if (Session["volverAlCheckout"] != null &&
                         (bool)Session["volverAlCheckout"])
                {
                    Session.Remove("volverAlCheckout");
                    Response.Redirect("Checkout.aspx", false);
                }
                // Si es cliente, va a la tienda

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

        private void CrearTokenRecordarme(UsuarioNegocio negocio, int idUsuario)
        {
            // Generamos 32 bytes aleatorios seguros

            byte[] bytesToken = new byte[32];

            using (RandomNumberGenerator generador = RandomNumberGenerator.Create())
            {
                generador.GetBytes(bytesToken);
            }

            // Convertimos el token a Base64

            string token = Convert.ToBase64String(bytesToken)
                .TrimEnd('=')
                .Replace('+', '-')
                .Replace('/', '_');

            // En la base de datos guardamos el hash

            string tokenHash = CalcularHash(token);

            // El token tendrá validez por 30 días

            DateTime fechaExpiracion = DateTime.Now.AddDays(30);

            negocio.GuardarTokenRecordarme(
                idUsuario,
                tokenHash,
                fechaExpiracion
            );

            // Creamos la cookie

            HttpCookie cookie = new HttpCookie("Recordarme");

            cookie.Value = token;
            cookie.Expires = fechaExpiracion;
            cookie.HttpOnly = true;
            cookie.Secure = Request.IsSecureConnection;
            cookie.Path = ResolveUrl("~/");

            Response.Cookies.Add(cookie);
        }

        private string CalcularHash(string token)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(token);
                byte[] hash = sha256.ComputeHash(bytes);

                StringBuilder resultado = new StringBuilder();

                foreach (byte b in hash)
                {
                    resultado.Append(b.ToString("x2"));
                }

                return resultado.ToString();
            }
        }
    }
}
