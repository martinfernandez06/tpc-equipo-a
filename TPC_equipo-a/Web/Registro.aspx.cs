
using System;
using System.Data.SqlClient;
using Dominio;
using Negocio;

namespace Web
{
    public partial class Registro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            // Validar provincia y localidad seleccionadas
            if (string.IsNullOrWhiteSpace(hfProvincia.Value) ||
                string.IsNullOrWhiteSpace(hfLocalidad.Value))
            {
                lblError.Text = "Debés seleccionar una provincia y una localidad.";
                lblError.Visible = true;
                return;
            }

            try
            {
                // Cargar el objeto Usuario
                Usuario nuevo = new Usuario();
                nuevo.Nombre = txtNombre.Text.Trim();
                nuevo.Apellido = txtApellido.Text.Trim();
                nuevo.Email = txtEmail.Text.Trim();
                nuevo.Clave = txtPassword.Text;
                nuevo.Telefono = txtTelefono.Text.Trim();

                nuevo.Perfil = new Perfil();
                nuevo.Perfil.Id = 2; // Cliente por defecto

                // Registrar usuario y obtener su ID autogenerado
                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                int idNuevoUsuario = usuarioNegocio.Registrar(nuevo);

                if (idNuevoUsuario > 0)
                {
                    // Cargar la primera Dirección asociada al nuevo usuario
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

                    // Enviar mail de bienvenida
                    try
                    {
                        EmailService emailService = new EmailService();

                        string cuerpo =
                            $"<h1>¡Bienvenido a nuestro E-Commerce, {nuevo.Nombre}!</h1>" +
                            "<p>Tu cuenta ha sido creada exitosamente. Ya podés realizar tus compras.</p>";

                        emailService.armarCorreo(
                            nuevo.Email,
                            "¡Bienvenido a la tienda!",
                            cuerpo
                        );

                        emailService.enviarEmail();
                    }
                    catch (Exception)
                    {
                        // Si falla el envío del correo,
                        // el usuario igualmente queda registrado.
                    }

                    // Redirigir al Login con aviso de éxito
                    Response.Redirect("Login.aspx?registrado=exito", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
                else
                {
                    lblError.Text = "No se pudo completar el registro. Intentá nuevamente.";
                    lblError.Visible = true;
                }
            }
            catch (SqlException ex)
            {
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
    }
}
