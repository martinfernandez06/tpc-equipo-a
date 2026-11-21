using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using Dominio;
using Negocio;

namespace Web
{
    public partial class OlvidePassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            Page.Validate("Recuperacion");

            if (!Page.IsValid)
                return;

            try
            {
                string email = txtEmail.Text.Trim();

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

                // Buscamos el usuario utilizando la información disponible.
                Usuario usuario = usuarioNegocio.BuscarPorEmail(email);

                // No mostramos si el correo existe o no.
                // Esto evita revelar qué correos tienen cuenta.
                if (usuario != null)
                {
                    string token = GenerarToken();
                    string tokenHash = CalcularHash(token);

                    DateTime fechaExpiracion = DateTime.UtcNow.AddHours(24);

                    usuarioNegocio.GuardarTokenRecuperacion(
                        usuario.Id,
                        tokenHash,
                        fechaExpiracion
                    );

                    string urlRecuperacion =
                        Request.Url.GetLeftPart(UriPartial.Authority) +
                        ResolveUrl("~/RestablecerPassword.aspx") +
                        "?token=" + HttpUtility.UrlEncode(token);

                    string nombreSeguro =
                        HttpUtility.HtmlEncode(usuario.Nombre);

                    string urlSegura =
                        HttpUtility.HtmlAttributeEncode(urlRecuperacion);

                    string asunto = "Recuperá tu contraseña";

                    string cuerpo = @"
                        <!DOCTYPE html>

                        <html lang='es'>

                        <head>
                            <meta charset='UTF-8'>
                        </head>

                        <body style='margin:0; padding:30px; background-color:#f4f6f9; font-family:Arial,sans-serif;'>

                            <div style='max-width:600px; margin:auto; background:#ffffff; border-radius:12px; overflow:hidden;'>

                                <div style='background:#0d6efd; padding:25px; text-align:center;'>
                                    <h1 style='color:#ffffff; margin:0;'>FinishBack</h1>
                                </div>

                                <div style='padding:35px; color:#333333;'>

                                    <h2>¡Hola, " + nombreSeguro + @"!</h2>

                                    <p style='font-size:15px; line-height:1.6;'>
                                        Recibimos una solicitud para restablecer la contraseña
                                        de tu cuenta de FinishBack.
                                    </p>

                                    <p style='font-size:15px; line-height:1.6;'>
                                        Si realizaste esta solicitud, hacé clic en el siguiente botón:
                                    </p>

                                    <div style='text-align:center; margin:30px 0;'>

                                        <a href='" + urlSegura + @"'
                                           style='display:inline-block; padding:14px 28px; background:#0d6efd; color:#ffffff; text-decoration:none; border-radius:7px; font-weight:bold;'>

                                            Restablecer mi contraseña

                                        </a>

                                    </div>

                                    <p style='font-size:13px; color:#666666; line-height:1.6;'>
                                        Este enlace tiene una validez de 24 horas y solo puede utilizarse una vez.
                                    </p>

                                    <p style='font-size:13px; color:#666666; line-height:1.6;'>
                                        Si no solicitaste restablecer tu contraseña, podés ignorar este mensaje.
                                    </p>

                                    <p style='font-size:12px; color:#888888;'>
                                        Si el botón no funciona, copiá y pegá este enlace en tu navegador:
                                    </p>

                                    <p style='font-size:12px; word-break:break-all;'>
                                        <a href='" + urlSegura + @"'>" +
                                        HttpUtility.HtmlEncode(urlRecuperacion) +
                                        @"</a>
                                    </p>

                                </div>

                                <div style='background:#f4f6f9; padding:18px; text-align:center; color:#888888; font-size:12px;'>

                                    © FinishBack - Todos los derechos reservados.

                                </div>

                            </div>

                        </body>

                        </html>";

                    try
                    {
                        EmailService emailService = new EmailService();

                        emailService.armarCorreo(
                            usuario.Email,
                            asunto,
                            cuerpo
                        );

                        emailService.enviarEmail();
                    }
                    catch (Exception)
                    {
                        // No mostramos información sobre la existencia
                        // de la cuenta aunque falle el envío.
                    }
                }

                pnlFormulario.Visible = false;
                pnlExito.Visible = true;
            }
            catch (Exception)
            {
                lblError.Text =
                    "No fue posible procesar la solicitud. Intentá nuevamente más tarde.";

                lblError.Visible = true;
            }
        }

        private string GenerarToken()
        {
            byte[] bytes = new byte[32];

            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(bytes);
            }

            return Convert.ToBase64String(bytes)
                .TrimEnd('=')
                .Replace('+', '-')
                .Replace('/', '_');
        }

        private string CalcularHash(string token)
        {
            using (SHA256 sha256 = SHA256.Create())
            {
                byte[] bytes = Encoding.UTF8.GetBytes(token);
                byte[] hash = sha256.ComputeHash(bytes);

                StringBuilder resultado = new StringBuilder();

                foreach (byte b in hash)
                    resultado.Append(b.ToString("x2"));

                return resultado.ToString();
            }
        }
    }
}