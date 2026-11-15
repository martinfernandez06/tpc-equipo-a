using System;
using Dominio;
using Negocio;

namespace Web
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Solo se ejecuta la primera vez que carga la página (no en los postbacks)
            if (!IsPostBack)
            {
                // Si el usuario ya inició sesión previamente, lo mandamos al inicio
                if (Session["usuario"] != null)
                {
                    Response.Redirect("Default.aspx", false);
                    return;
                }

                // Verificamos si viene el parámetro de registro exitoso desde Registro.aspx
                if (Request.QueryString["registrado"] == "exito")
                {
                    pnlExito.Visible = true;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // Validar los controles del lado del servidor asociados al ValidationGroup
            if (!Page.IsValid)
                return;

            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();
                Usuario user = negocio.Login(txtEmail.Text.Trim(), txtPassword.Text);

                if (user != null)
                {
                    // 1. Actualizar la fecha y hora del último acceso en la base de datos
                    negocio.ActualizarUltimoAcceso(user.Id);

                    // 2. Sincronizar la propiedad local y guardar el objeto actualizado en la sesión
                    user.UltimoAcceso = DateTime.Now;
                    Session.Add("usuario", user);

                    // Redirección segura
                    Response.Redirect("Default.aspx", false);
                }
                else
                {
                    lblError.Text = "Correo electrónico o contraseña incorrectos.";
                    lblError.Visible = true;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "No fue posible iniciar sesión. Intentá nuevamente.";
                lblError.Visible = true;
            }
        }
    }
}