
using System;
using System.Data.SqlClient;
using System.Text;
using System.Text.RegularExpressions;
using System.Security.Cryptography;
using System.Web;
using Dominio;
using Negocio;

namespace Web
{
    public partial class Registro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

         Session.Remove("usuario") ;
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            Page.Validate("Registro");

            if (!Page.IsValid)
                return;

            try
            {
                // Validar contraseña lado del servidor
                string clave = txtPassword.Text;

                if (clave.Length < 7 ||
                    !Regex.IsMatch(clave, @"[A-Za-z]") ||
                    !Regex.IsMatch(clave, @"\d"))
                {
                    lblError.Text = "La contraseña debe tener al menos 7 caracteres e incluir letras y números.";
                    lblError.Visible = true;
                    return;
                }

                // Cargar el objeto Usuario
                Usuario nuevo = new Usuario();
                nuevo.Nombre = txtNombre.Text.Trim();
                nuevo.Apellido = txtApellido.Text.Trim();
                nuevo.Email = txtEmail.Text.Trim();
                nuevo.Clave = clave;
                nuevo.Telefono = txtTelefono.Text.Trim();
                nuevo.Perfil = new Perfil();
                nuevo.Perfil.Id = 2;

                // Registra usuario y obtener su ID
                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                int idNuevoUsuario = usuarioNegocio.Registrar(nuevo);

                if (idNuevoUsuario <= 0)
                {
                    lblError.Text = "No se pudo completar el registro.";
                    lblError.Visible = true;
                    return;
                }

                // Registra la primera dirección
                Direccion nuevaDir = new Direccion();
                nuevaDir.IdUsuario = idNuevoUsuario;
                nuevaDir.Calle = txtCalle.Text.Trim();
                nuevaDir.Numero = txtNumero.Text.Trim();
                nuevaDir.Provincia = hfProvincia.Value;
                nuevaDir.Localidad = hfLocalidad.Value;
                nuevaDir.CodigoPostal = txtCodigoPostal.Text.Trim();
                nuevaDir.Observaciones = txtObservaciones.Text.Trim();
                nuevaDir.Principal = true;

                DireccionNegocio direccionNegocio = new DireccionNegocio();
                direccionNegocio.Agregar(nuevaDir);

                // Genera token
                string token = GenerarToken();
                string tokenHash = CalcularHash(token);

                // Guarda el hash del token en la bd
                DateTime fechaExpiracion = DateTime.UtcNow.AddHours(24);

                usuarioNegocio.GuardarTokenConfirmacion(
                    idNuevoUsuario,
                    tokenHash,
                    fechaExpiracion
                );

                // enlace de confirmacion
                string urlConfirmacion =
                    Request.Url.GetLeftPart(UriPartial.Authority) +
                    ResolveUrl("~/ConfirmarEmail.aspx") +
                    "?token=" + HttpUtility.UrlEncode(token);

                // correo

                string nombreSeguro = HttpUtility.HtmlEncode(nuevo.Nombre);
                string urlSegura = HttpUtility.HtmlAttributeEncode(urlConfirmacion);

                string asunto = "Confirmá tu correo electrónico";

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
                                    Gracias por registrarte en FinishBack.
                                    Para completar la creación de tu cuenta, necesitamos que confirmes tu dirección de correo electrónico.
                                </p>

                                <div style='text-align:center; margin:30px 0;'>
                                    <a href='" + urlSegura + @"'
                                       style='display:inline-block; padding:14px 28px; background:#0d6efd; color:#ffffff; text-decoration:none; border-radius:7px; font-weight:bold;'>
                                        Confirmar mi correo
                                    </a>
                                </div>

                                <p style='font-size:13px; color:#666666; line-height:1.6;'>
                                    Este enlace tiene una validez de 24 horas.
                                    Si no creaste una cuenta en FinishBack, podés ignorar este mensaje.
                                </p>

                                <p style='font-size:12px; color:#888888;'>
                                    Si el botón no funciona, copiá y pegá este enlace en tu navegador:
                                </p>

                                <p style='font-size:12px; word-break:break-all;'>
                                    <a href='" + urlSegura + @"'>" + HttpUtility.HtmlEncode(urlConfirmacion) + @"</a>
                                </p>
                            </div>

                            <div style='background:#f4f6f9; padding:18px; text-align:center; color:#888888; font-size:12px;'>
                                © FinishBack - Todos los derechos reservados.
                            </div>

                        </div>
                    </body>
                    </html>";

                // Enviar correo mediante Mailtrap
                try
                {
                    EmailService emailService = new EmailService();

                    emailService.armarCorreo(
                        nuevo.Email,
                        asunto,
                        cuerpo
                    );

                    emailService.enviarEmail();
                }
                catch (Exception)
                {
                    // La cuenta ya fue creada, pero falló el envío.

                    Response.Redirect(
                        "Login.aspx?registrado=pendiente&correoError=1",
                        false
                    );

                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                // Redirigie al login
                Response.Redirect(
                    "Login.aspx?registrado=pendiente",
                    false
                );

                Context.ApplicationInstance.CompleteRequest();
            }
            catch (SqlException ex)
            {
                // correo electrónico duplicado
                if (ex.Number == 2627 || ex.Number == 2601)
                {
                    lblError.Text = "Ya existe una cuenta registrada con ese correo electrónico.";
                }
                else
                {
                    lblError.Text = "Ocurrió un error en la base de datos al registrar el usuario.";
                }

                lblError.Visible = true;
            }
            catch (Exception ex)
            {
                lblError.Text = "Ocurrió un error inesperado: " + ex.Message;
                lblError.Visible = true;
            }
        }

        // Genera token aleatorio
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

        // Calcula SHA256 del token para guardar el hash
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
