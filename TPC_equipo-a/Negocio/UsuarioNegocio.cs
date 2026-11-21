
using System;
using System.Collections.Generic;
using Dominio;

namespace Negocio
{
    public class UsuarioNegocio
    {
        public int Registrar(Usuario nuevo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spAltaUsuario");
                datos.setearParametro("@Nombre", nuevo.Nombre);
                datos.setearParametro("@Apellido", nuevo.Apellido);
                datos.setearParametro("@Email", nuevo.Email);
                datos.setearParametro("@Clave", nuevo.Clave);
                datos.setearParametro("@Telefono", string.IsNullOrEmpty(nuevo.Telefono) ? (object)DBNull.Value : nuevo.Telefono);
                datos.setearParametro("@IdPerfil", nuevo.Perfil.Id);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return Convert.ToInt32(datos.Lector["Id"]);
                }

                return 0;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarLectura();
            }
        }

        public Usuario Login(string email, string clave)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spBuscarUsuarioPorEmailYClave");
                datos.setearParametro("@Email", email);
                datos.setearParametro("@Clave", clave);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Usuario user = new Usuario();

                    user.Id = (int)datos.Lector["Id"];
                    user.Nombre = (string)datos.Lector["Nombre"];
                    user.Apellido = (string)datos.Lector["Apellido"];
                    user.Email = (string)datos.Lector["Email"];
                    user.Clave = (string)datos.Lector["Clave"];
                    user.Telefono = !(datos.Lector["Telefono"] is DBNull)
                        ? (string)datos.Lector["Telefono"]
                        : "";

                    user.Perfil = new Perfil();
                    user.Perfil.Id = (int)datos.Lector["IdPerfil"];
                    user.Perfil.Descripcion = (string)datos.Lector["PerfilDescripcion"];

                    user.Activo = (bool)datos.Lector["Activo"];
                    user.EmailConfirmado = (bool)datos.Lector["EmailConfirmado"];
                    user.FechaAlta = (DateTime)datos.Lector["FechaAlta"];

                    user.UltimoAcceso = !(datos.Lector["UltimoAcceso"] is DBNull)
                        ? (DateTime?)datos.Lector["UltimoAcceso"]
                        : null;

                    return user;
                }

                return null;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarLectura();
            }
        }

        public void Modificar(Usuario user)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spModificarUsuario");
                datos.setearParametro("@Id", user.Id);
                datos.setearParametro("@Nombre", user.Nombre);
                datos.setearParametro("@Apellido", user.Apellido);
                datos.setearParametro("@Email", user.Email);
                datos.setearParametro("@Telefono", string.IsNullOrEmpty(user.Telefono) ? (object)DBNull.Value : user.Telefono);
                datos.setearParametro("@IdPerfil", user.Perfil.Id);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarLectura();
            }
        }

        public void CambiarEstado(int idUsuario, bool activo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spCambiarEstadoUsuario");
                datos.setearParametro("@Id", idUsuario);
                datos.setearParametro("@Activo", activo);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarLectura();
            }
        }

        public void ActualizarUltimoAcceso(int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spActualizarUltimoAcceso");
                datos.setearParametro("@Id", idUsuario);

                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarLectura();
            }
        }

        public void GuardarTokenConfirmacion(int idUsuario, string tokenHash, DateTime fechaExpiracion)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spGuardarTokenUsuario");

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@TokenHash", tokenHash);
                datos.setearParametro("@Tipo", "CONFIRMACION");
                datos.setearParametro("@FechaExpiracion", fechaExpiracion);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarLectura();
            }
        }

        
            public bool ConfirmarEmail(string tokenHash)
            {
                AccesoDatos datos = new AccesoDatos();

                try
                {
                    datos.setearProcedimiento("spConfirmarEmail");
                    datos.setearParametro("@TokenHash", tokenHash);

                    datos.ejecutarLectura();

                    if (datos.Lector.Read())
                    {
                        return Convert.ToBoolean(datos.Lector["Confirmado"]);
                    }

                    return false;
                }
                finally
                {
                    datos.cerrarLectura();
                }
            }


            public void GuardarTokenRecuperacion(int idUsuario, string tokenHash, DateTime fechaExpiracion)
                    {
                        AccesoDatos datos = new AccesoDatos();

                        try
                        {
                            datos.setearProcedimiento("spGuardarTokenUsuario");

                            datos.setearParametro("@IdUsuario", idUsuario);
                            datos.setearParametro("@TokenHash", tokenHash);
                            datos.setearParametro("@Tipo", "RECUPERACION");
                            datos.setearParametro("@FechaExpiracion", fechaExpiracion);

                            datos.ejecutarAccion();
                        }
                        finally
                        {
                            datos.cerrarLectura();
                        }
                    }

            public bool ValidarTokenRecuperacion(string tokenHash)
                    {
                        AccesoDatos datos = new AccesoDatos();

                        try
                        {
                            datos.setearProcedimiento("spValidarTokenRecuperacion");
                            datos.setearParametro("@TokenHash", tokenHash);

                            datos.ejecutarLectura();

                            return datos.Lector.Read();
                        }
                        finally
                        {
                            datos.cerrarLectura();
                        }
                    }

            public bool RestablecerPassword(string tokenHash, string nuevaClave)
                    {
                        AccesoDatos datos = new AccesoDatos();

                        try
                        {
                            datos.setearProcedimiento("spRestablecerPassword");

                            datos.setearParametro("@TokenHash", tokenHash);
                            datos.setearParametro("@NuevaClave", nuevaClave);

                            datos.ejecutarLectura();

                            if (datos.Lector.Read())
                            {
                                return Convert.ToBoolean(datos.Lector["Restablecido"]);
                            }

                            return false;
                        }
                        finally
                        {
                            datos.cerrarLectura();
                        }
                    }


    public Usuario BuscarPorEmail(string email) {

    AccesoDatos datos = new AccesoDatos();

    try
    {
        datos.setearConsulta(@"
            SELECT
                U.Id,
                U.Nombre,
                U.Apellido,
                U.Email,
                U.Activo,
                U.EmailConfirmado
            FROM USUARIOS U
            WHERE U.Email = @Email
              AND U.Activo = 1
        ");

        datos.setearParametro("@Email", email);

        datos.ejecutarLectura();

        if (datos.Lector.Read())
        {
            Usuario usuario = new Usuario();

            usuario.Id = (int)datos.Lector["Id"];
            usuario.Nombre = (string)datos.Lector["Nombre"];
            usuario.Apellido = (string)datos.Lector["Apellido"];
            usuario.Email = (string)datos.Lector["Email"];
            usuario.Activo = (bool)datos.Lector["Activo"];
            usuario.EmailConfirmado = (bool)datos.Lector["EmailConfirmado"];

            return usuario;
        }

        return null;
    }
    finally
    {
        datos.cerrarLectura();
    }
}




    }
}
