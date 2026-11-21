using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using Dominio;
using Negocio;

namespace Web
{
    public partial class MiPerfil : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Usuario usuario = ObtenerUsuarioActual();

            if (usuario == null)
                return;

            if (!IsPostBack)
            {
                CargarDatosPersonales(usuario);
                CargarDirecciones(usuario.Id);
            }
        }


        // USUARIO AUTENTICADO


        private Usuario ObtenerUsuarioActual()
        {
            Usuario usuario = Session["usuario"] as Usuario;

            if (usuario == null)
            {
                Response.Redirect("~/Login.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return null;
            }

            return usuario;
        }


        // MENSAJES


        private void MostrarMensaje(string mensaje, bool correcto)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;

            pnlMensaje.CssClass = correcto
                ? "alert alert-success mb-4"
                : "alert alert-danger mb-4";
        }


        // DATOS PERSONALES


        private void CargarDatosPersonales(Usuario usuario)
        {
            txtNombre.Text = usuario.Nombre;
            txtApellido.Text = usuario.Apellido;
            txtEmail.Text = usuario.Email;
            txtTelefono.Text = usuario.Telefono;
        }

        protected void btnGuardarPerfil_Click(object sender, EventArgs e)
        {
            Usuario usuario = ObtenerUsuarioActual();

            if (usuario == null)
                return;

            // validadores Perfil

            Page.Validate("Perfil");

            if (!Page.IsValid)
                return;

            string nombre = txtNombre.Text.Trim();
            string apellido = txtApellido.Text.Trim();
            string email = txtEmail.Text.Trim();
            string telefono = txtTelefono.Text.Trim();

            try
            {
                // Validación formato del correo

                MailAddress direccionEmail = new MailAddress(email);

                if (direccionEmail.Address != email)
                {
                    MostrarMensaje("Ingresá un correo electrónico válido.", false);
                    return;
                }

                if (usuario.Perfil == null)
                {
                    MostrarMensaje(
                        "No se pudo verificar el perfil de tu cuenta.",
                        false
                    );
                    return;
                }

                usuario.Nombre = nombre;
                usuario.Apellido = apellido;
                usuario.Email = email;
                usuario.Telefono = telefono;

                UsuarioNegocio negocio = new UsuarioNegocio();
                negocio.Modificar(usuario);

                // Actualizamos el objeto de sesión

                Session["usuario"] = usuario;

                MostrarMensaje(
                    "Tus datos personales se actualizaron correctamente.",
                    true
                );
            }
            catch (FormatException)
            {
                MostrarMensaje("Ingresá un correo electrónico válido.", false);
            }
            catch (Exception ex)
            {
                MostrarMensaje(
                    "No se pudieron actualizar tus datos: " + ex.Message,
                    false
                );
            }
        }


        // LISTADO DE DIRECCIONES


        private List<Direccion> ObtenerDirecciones(int idUsuario)
        {
            DireccionNegocio negocio = new DireccionNegocio();

            return negocio.ListarPorUsuario(idUsuario);
        }

        private void CargarDirecciones(int idUsuario)
        {
            try
            {
                List<Direccion> direcciones = ObtenerDirecciones(idUsuario);

                // Se muestran solamente las direcciones activas

                gvDirecciones.DataSource = direcciones
                    .Where(d => d.Activa)
                    .ToList();

                gvDirecciones.DataBind();
            }
            catch (Exception ex)
            {
                MostrarMensaje(
                    "No se pudieron cargar las direcciones: " + ex.Message,
                    false
                );
            }
        }


        // AGREGAR DIRECCIÓN


        protected void btnNuevaDireccion_Click(object sender, EventArgs e)
        {
            Usuario usuario = ObtenerUsuarioActual();

            if (usuario == null)
                return;

            LimpiarFormularioDireccion();

            hfIdDireccion.Value = "0";
            lblTituloDireccion.Text = "Nueva dirección";
            btnGuardarDireccion.Text = "Guardar dirección";

            pnlFormularioDireccion.Visible = true;
        }


        // EDITAR DIRECCIÓN


        private Direccion ObtenerDireccionPropia(int idDireccion, int idUsuario)
        {
            List<Direccion> direcciones = ObtenerDirecciones(idUsuario);

            // Verificamos que la dirección pertenezca al usuario

            return direcciones.FirstOrDefault(d =>
                d.Id == idDireccion &&
                d.IdUsuario == idUsuario
            );
        }

        protected void gvDirecciones_RowCommand(
            object sender,
            System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            Usuario usuario = ObtenerUsuarioActual();

            if (usuario == null)
                return;

            int idDireccion;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out idDireccion))
                return;

            try
            {
                Direccion direccion = ObtenerDireccionPropia(
                    idDireccion,
                    usuario.Id
                );

                if (direccion == null || !direccion.Activa)
                {
                    MostrarMensaje(
                        "La dirección seleccionada no existe o no está disponible.",
                        false
                    );

                    CargarDirecciones(usuario.Id);
                    return;
                }

                if (e.CommandName == "EditarDireccion")
                {
                    CargarFormularioEdicion(direccion);
                }
                else if (e.CommandName == "MarcarPrincipal")
                {
                    MarcarDireccionPrincipal(direccion, usuario);
                }
                else if (e.CommandName == "DesactivarDireccion")
                {
                    DesactivarDireccion(direccion, usuario);
                }
            }
            catch (Exception ex)
            {
                MostrarMensaje(
                    "No se pudo realizar la operación: " + ex.Message,
                    false
                );

                CargarDirecciones(usuario.Id);
            }
        }

        private void CargarFormularioEdicion(Direccion direccion)
        {
            hfIdDireccion.Value = direccion.Id.ToString();

            txtCalle.Text = direccion.Calle;
            txtNumero.Text = direccion.Numero;
            txtLocalidad.Text = direccion.Localidad;
            txtProvincia.Text = direccion.Provincia;
            txtCodigoPostal.Text = direccion.CodigoPostal;
            txtObservaciones.Text = direccion.Observaciones;

            chkPrincipal.Checked = direccion.Principal;

            lblTituloDireccion.Text = "Editar dirección";
            btnGuardarDireccion.Text = "Guardar cambios";

            pnlFormularioDireccion.Visible = true;
        }


        // GUARDAR DIRECCIÓN


        protected void btnGuardarDireccion_Click(object sender, EventArgs e)
        {
            Usuario usuario = ObtenerUsuarioActual();

            if (usuario == null)
                return;

            // Ejecuta validadores de Direccion

            Page.Validate("Direccion");

            if (!Page.IsValid)
                return;

            string calle = txtCalle.Text.Trim();
            string numero = txtNumero.Text.Trim();
            string localidad = txtLocalidad.Text.Trim();
            string provincia = txtProvincia.Text.Trim();
            string codigoPostal = txtCodigoPostal.Text.Trim();
            string observaciones = txtObservaciones.Text.Trim();

            int idDireccion;

            if (!int.TryParse(hfIdDireccion.Value, out idDireccion))
            {
                MostrarMensaje("La dirección seleccionada no es válida.", false);
                return;
            }

            try
            {
                DireccionNegocio negocio = new DireccionNegocio();

                Direccion direccion = new Direccion
                {
                    Id = idDireccion,
                    IdUsuario = usuario.Id,
                    Calle = calle,
                    Numero = numero,
                    Localidad = localidad,
                    Provincia = provincia,
                    CodigoPostal = codigoPostal,
                    Observaciones = observaciones
                };

                if (idDireccion == 0)
                {
                    List<Direccion> direcciones = ObtenerDirecciones(usuario.Id);

                    bool yaTienePrincipal = direcciones.Any(d =>
                        d.Activa && d.Principal
                    );

                    bool esPrincipal = chkPrincipal.Checked || !yaTienePrincipal;

                    direccion.Principal = esPrincipal;

                    negocio.Agregar(direccion);

                    MostrarMensaje("La dirección se agregó correctamente.", true);
                }
                else
                {
                    // Verifica que la dirección pertenezca al usuario

                    Direccion existente = ObtenerDireccionPropia(
                        idDireccion,
                        usuario.Id
                    );

                    if (existente == null || !existente.Activa)
                    {
                        MostrarMensaje(
                            "No se puede modificar esta dirección.",
                            false
                        );

                        return;
                    }

                    negocio.Modificar(direccion);

                    if (chkPrincipal.Checked)
                    {
                        negocio.MarcarPrincipal(
                            direccion.Id,
                            usuario.Id
                        );
                    }

                    MostrarMensaje("La dirección se modificó correctamente.", true);
                }

                pnlFormularioDireccion.Visible = false;

                LimpiarFormularioDireccion();

                CargarDirecciones(usuario.Id);
            }
            catch (Exception ex)
            {
                MostrarMensaje(

                    "No se pudo guardar la dirección: " + ex.Message,
                    false
                );
            }
        }


        // MARCAR DIRECCIÓN COMO PRINCIPAL


        private void MarcarDireccionPrincipal(Direccion direccion, Usuario usuario)
        {
            if (direccion == null ||
                direccion.IdUsuario != usuario.Id ||
                !direccion.Activa)
            {
                MostrarMensaje("La dirección seleccionada no es válida.", false);
                return;
            }

            DireccionNegocio negocio = new DireccionNegocio();

            negocio.MarcarPrincipal(
                direccion.Id,
                usuario.Id
            );

            MostrarMensaje(
                "La dirección principal se actualizó correctamente.",
                true
            );

            CargarDirecciones(usuario.Id);
        }


        // DESACTIVAR DIRECCIÓN


        private void DesactivarDireccion(Direccion direccion, Usuario usuario)
        {
            if (direccion == null ||
                direccion.IdUsuario != usuario.Id ||
                !direccion.Activa)
            {
                MostrarMensaje("La dirección seleccionada no es válida.", false);
                return;
            }

            DireccionNegocio negocio = new DireccionNegocio();

            if (direccion.Principal)
            {
                List<Direccion> direcciones = ObtenerDirecciones(usuario.Id);

                // Buscamos otra dirección activa para poner como principal

                Direccion alternativa = direcciones.FirstOrDefault(d =>
                    d.Activa &&
                    d.IdUsuario == usuario.Id &&
                    d.Id != direccion.Id
                );

                // No desactivamos la única dirección principal activa

                if (alternativa == null)
                {
                    MostrarMensaje(
                        "No podés desactivar tu única dirección activa. " +
                        "Primero agregá otra dirección y establecela como principal.",
                        false
                    );

                    return;
                }

                // Primero asignamos otra dirección como principal

                negocio.MarcarPrincipal(
                    alternativa.Id,
                    usuario.Id
                );
            }

            // Baja lógica

            negocio.CambiarEstado(
                direccion.Id,
                false
            );

            MostrarMensaje("La dirección se desactivó correctamente.", true);

            CargarDirecciones(usuario.Id);
        }


        // CANCELAR FORMULARIO


        protected void btnCancelarDireccion_Click(object sender, EventArgs e)
        {
            Usuario usuario = ObtenerUsuarioActual();

            if (usuario == null)
                return;

            pnlFormularioDireccion.Visible = false;

            LimpiarFormularioDireccion();

            CargarDirecciones(usuario.Id);
        }

        private void LimpiarFormularioDireccion()
        {
            hfIdDireccion.Value = "0";

            txtCalle.Text = "";
            txtNumero.Text = "";
            txtLocalidad.Text = "";
            txtProvincia.Text = "";
            txtCodigoPostal.Text = "";
            txtObservaciones.Text = "";

            chkPrincipal.Checked = false;
        }
    }
}
