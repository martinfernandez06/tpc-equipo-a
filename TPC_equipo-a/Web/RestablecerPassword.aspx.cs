using System;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;
using Negocio;

namespace Web
{
    public partial class RestablecerPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string token = Request.QueryString["token"];

                if (string.IsNullOrWhiteSpace(token))
                {
                    MostrarError(
                        "El enlace de recuperación no es válido o está incompleto."
                    );

                    return;
                }

                try
                {
                    string tokenHash = CalcularHash(token);

                    UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

                    bool tokenValido =
                        usuarioNegocio.ValidarTokenRecuperacion(tokenHash);

                    if (!tokenValido)
                    {
                        MostrarError(
                            "El enlace de recuperación es inválido, ya fue utilizado o ha vencido."
                        );
                    }
                }
                catch (Exception)
                {
                    MostrarError(
                        "Ocurrió un error al validar el enlace. Intentá nuevamente más tarde."
                    );
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            Page.Validate("Password");

            if (!Page.IsValid)
                return;

            string clave = txtPassword.Text;

            if (clave.Length < 7 ||
                !Regex.IsMatch(clave, @"[A-Za-z]") ||
                !Regex.IsMatch(clave, @"\d"))
            {
                lblError.Text =
                    "La contraseña debe tener al menos 7 caracteres e incluir letras y números.";

                lblError.Visible = true;

                return;
            }

            try
            {
                string token = Request.QueryString["token"];

                if (string.IsNullOrWhiteSpace(token))
                {
                    MostrarError(
                        "El enlace de recuperación no es válido o está incompleto."
                    );

                    return;
                }

                string tokenHash = CalcularHash(token);

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

                bool restablecido =
                    usuarioNegocio.RestablecerPassword(
                        tokenHash,
                        clave
                    );

                if (!restablecido)
                {
                    MostrarError(
                        "El enlace de recuperación es inválido, ya fue utilizado o ha vencido."
                    );

                    return;
                }

                pnlFormulario.Visible = false;
                pnlExito.Visible = true;
            }
            catch (Exception)
            {
                lblError.Text =
                    "No fue posible cambiar la contraseña. Intentá nuevamente más tarde.";

                lblError.Visible = true;
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

        private void MostrarError(string mensaje)
        {
            pnlFormulario.Visible = false;
            pnlExito.Visible = false;

            lblError.Text = mensaje;
            lblError.Visible = true;
        }
    }
}