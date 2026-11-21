
using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using Negocio;

namespace Web
{
    public partial class CerrarSesion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // Buscamos la cookie

                HttpCookie cookie = Request.Cookies["Recordarme"];

                if (cookie != null && !string.IsNullOrWhiteSpace(cookie.Value))
                {
                    // Calculamos el hash del token

                    string tokenHash = CalcularHash(cookie.Value);

                    // Revocamos el token en la BD

                    UsuarioNegocio negocio = new UsuarioNegocio();
                    negocio.RevocarTokenRecordarme(tokenHash);
                }
            }
            finally
            {
                // Eliminamos cookie

                HttpCookie cookieExpirada = new HttpCookie("Recordarme");

                cookieExpirada.Value = "";
                cookieExpirada.Expires = DateTime.Now.AddDays(-1);
                cookieExpirada.HttpOnly = true;
                cookieExpirada.Secure = Request.IsSecureConnection;
                cookieExpirada.Path = ResolveUrl("~/");

                Response.Cookies.Add(cookieExpirada);

                // Eliminamos datos de sesión 

                Session.Clear();

                // Cerramos sesión actual

                Session.Abandon();

                // Redirigimos a Login

                Response.Redirect("Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
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
                {
                    resultado.Append(b.ToString("x2"));
                }

                return resultado.ToString();
            }
        }
    }
}
