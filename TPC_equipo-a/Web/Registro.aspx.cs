
using System;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
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
            Page.Validate("Registro");

            if (!Page.IsValid)
                return;

            try
            {
                // 1. Validar contraseña del lado del servidor
                string clave = txtPassword.Text;

                if (clave.Length < 7 ||
                    !Regex.IsMatch(clave, @"[A-Za-z]") ||
                    !Regex.IsMatch(clave, @"\d"))
                {
                    lblError.Text = "La contraseña debe tener al menos 7 caracteres e incluir letras y números.";
                    lblError.Visible = true;
                    return;
                }

                // 2. Cargar el objeto Usuario
                Usuario nuevo = new Usuario();
                nuevo.Nombre = txtNombre.Text.Trim();
                nuevo.Apellido = txtApellido.Text.Trim();
                nuevo.Email = txtEmail.Text.Trim();
                nuevo.Clave = clave;
                nuevo.Telefono = txtTelefono.Text.Trim();
                nuevo.Perfil = new Perfil();
                nuevo.Perfil.Id = 2; // Cliente por defecto

                // 3. Registrar usuario y obtener su ID autogenerado
                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                int idNuevoUsuario = usuarioNegocio.Registrar(nuevo);

                if (idNuevoUsuario > 0)
                {
                    // 4. Cargar la primera Dirección asociada al usuario
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

                    // 5. Redirigir al Login con aviso de éxito
                    Response.Redirect("Login.aspx?registrado=exito", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
            catch (SqlException ex)
            {
                // 2627 o 2601: correo electrónico duplicado
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
