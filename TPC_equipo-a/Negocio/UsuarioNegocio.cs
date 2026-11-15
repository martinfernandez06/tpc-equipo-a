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
                datos.setearParametro("@IdPerfil", nuevo.Perfil.Id); // Por defecto cliente suele ser ID 2

                // Si querés que devuelva el ID autogenerado, podés adaptar el SP con SCOPE_IDENTITY() o ejecutar acción directa.
                datos.ejecutarAccion();
                return 0; // O retornar el ID si modificás spAltaUsuario para que haga un SELECT SCOPE_IDENTITY()
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
                    user.Telefono = !(datos.Lector["Telefono"] is DBNull) ? (string)datos.Lector["Telefono"] : "";
                    
                    user.Perfil = new Perfil();
                    user.Perfil.Id = (int)datos.Lector["IdPerfil"];
                    user.Perfil.Descripcion = (string)datos.Lector["PerfilDescripcion"];

                    user.Activo = (bool)datos.Lector["Activo"];
                    user.FechaAlta = (DateTime)datos.Lector["FechaAlta"];
                    user.UltimoAcceso = !(datos.Lector["UltimoAcceso"] is DBNull) ? (DateTime?)datos.Lector["UltimoAcceso"] : null;

                    return user;
                }

                return null; // Si no encuentra coincidencia
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


        public void ActualizarUltimoAcceso(int idUsuario){

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
            
            
            }
}