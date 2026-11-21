
using Dominio;
using Negocio;
using System;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Si ya existe una sesión iniciada, no necesitamos recuperar nada

            if (Session["usuario"] != null)
                return;

            // Buscamos la cookie persistente
            HttpCookie cookie = Request.Cookies["Recordarme"];

            if (cookie == null || string.IsNullOrWhiteSpace(cookie.Value))
                return;

            try
            {
                // El navegador guarda el token 
                // En la base de datos solamente almacenamos su hash

                string tokenHash = CalcularHash(cookie.Value);

                UsuarioNegocio negocio = new UsuarioNegocio();

                Usuario usuario = negocio.BuscarUsuarioPorTokenRecordarme(tokenHash);

                if (usuario != null)
                {
                    // Recuperamos la sesión del usuario
                    Session["usuario"] = usuario;
                }
                else
                {
                    // Token inválido o vencido: eliminamos la cookie
                    EliminarCookieRecordarme();
                }
            }
            catch
            {
                // Ante un error de recuperación, no iniciamos sesión
                EliminarCookieRecordarme();
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

        private void EliminarCookieRecordarme()
        {
            HttpCookie cookie = new HttpCookie("Recordarme");

            cookie.Value = "";
            cookie.Expires = DateTime.Now.AddDays(-1);
            cookie.HttpOnly = true;
            cookie.Secure = Request.IsSecureConnection;
            cookie.Path = ResolveUrl("~/");

            Response.Cookies.Add(cookie);
        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // Buscamos el carrito en la memoria
            if (Session["Carrito"] != null)
            {
                Dominio.Carrito carrito = (Dominio.Carrito)Session["Carrito"];

                // Si hay productos, mostramos el globito con el número total de artículos
                if (carrito.CantidadArticulos > 0)
                {
                    lblCantidadCarrito.Text = carrito.CantidadArticulos.ToString();
                    lblCantidadCarrito.Visible = true;
                }
                else
                {
                    lblCantidadCarrito.Visible = false;
                }
            }
            else
            {
                lblCantidadCarrito.Visible = false;
            }

            // Aseguramos que el título completo incluya la marca incluso en postbacks de UpdatePanel
            if (string.IsNullOrWhiteSpace(Page.Title))
            {
                Page.Title = "Magva";
            }
            else if (!Page.Title.EndsWith("Magva"))
            {
                Page.Title += " Magva";
            }
        }
    }
}
