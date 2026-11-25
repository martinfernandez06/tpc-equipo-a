
using System;
using System.Security.Cryptography;
using System.Text;
using Negocio;

namespace Web
{
    public partial class ConfirmarEmail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                ConfirmarCorreo();
        }

        private void ConfirmarCorreo()
        {
            try
            {
                // Obtenie el token del correo
                string token = Request.QueryString["token"];

                if (string.IsNullOrWhiteSpace(token))
                {
                    MostrarResultado(
                        "El enlace de confirmación no es válido o está incompleto.",
                        false
                    );
                    return;
                }

                // Calcula el hash del token
                string tokenHash = CalcularHash(token);

                // Confirma el correo mediante la capa de negocio
                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

                bool confirmado = usuarioNegocio.ConfirmarEmail(tokenHash);

                
                if (confirmado)
                {
                    MostrarResultado(
                        "¡Tu correo electrónico fue confirmado correctamente! Ya podés iniciar sesión en Magva.",
                        true
                    );
                }
                else
                {
                    MostrarResultado(
                        "El enlace de confirmación es inválido, ya fue utilizado o ha vencido. Si necesitás uno nuevo, solicitá otro enlace de confirmación.",
                        false
                    );
                }
            }
            catch (Exception)
            {
                MostrarResultado(
                    "Ocurrió un error al intentar confirmar tu correo. Por favor, intentá nuevamente más tarde.",
                    false
                );
            }
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

        private void MostrarResultado(string mensaje, bool exito)
        {
            lblMensaje.Text = mensaje;

            if (exito)
            {
                lblMensaje.CssClass = "d-block text-success mb-4";
                lnkLogin.Visible = true;
            }
            else
            {
                lblMensaje.CssClass = "d-block text-danger mb-4";
                lnkLogin.Visible = true;
                lnkLogin.Text = "Volver al inicio de sesión";
            }
        }
    }
}
