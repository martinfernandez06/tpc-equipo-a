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

            try
            {
                //  Validación de longitud extra del lado del servidor

                if (txtNombre.Text.Length > 50 || 
                    txtApellido.Text.Length > 50 || 
                    txtEmail.Text.Length > 100 || 
                    txtPassword.Text.Length > 50 || 
                    (!string.IsNullOrEmpty(txtTelefono.Text) && txtTelefono.Text.Length > 30))
                {
                    lblError.Text = "Uno de los campos supera el límite máximo de caracteres permitidos.";
                    lblError.Visible = true;
                    return;
                }

                // Cargar el objeto Usuario

                Usuario nuevo = new Usuario();
                nuevo.Nombre = txtNombre.Text.Trim();
                nuevo.Apellido = txtApellido.Text.Trim();
                nuevo.Email = txtEmail.Text.Trim();
                nuevo.Clave = txtPassword.Text;
                nuevo.Telefono = txtTelefono.Text.Trim();
                
                // Perfil por defecto: Cliente (Id = 2)

                nuevo.Perfil = new Perfil();
                nuevo.Perfil.Id = 2; 

              
                UsuarioNegocio negocio = new UsuarioNegocio();
                negocio.Registrar(nuevo);

                // Redirigir al Login 

              
                Response.Redirect("Login.aspx?registrado=exito", false);
            }
            catch (SqlException ex)
            {
                // Código 2627 o 2601 en SQL Server indica violación de restricción UNIQUE (Email duplicado)

                if (ex.Number == 2627 || ex.Number == 2601){ 

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