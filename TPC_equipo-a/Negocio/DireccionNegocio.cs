using System;
using System.Collections.Generic;
using Dominio;

namespace Negocio
{
    public class DireccionNegocio
    {
        public List<Direccion> ListarPorUsuario(int idUsuario)
        {
            List<Direccion> lista = new List<Direccion>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spListarDireccionesPorUsuario");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Direccion aux = new Direccion();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.IdUsuario = (int)datos.Lector["IdUsuario"];
                    aux.Calle = (string)datos.Lector["Calle"];
                    aux.Numero = (string)datos.Lector["Numero"];
                    aux.Provincia = (string)datos.Lector["Provincia"];
                    aux.Localidad = (string)datos.Lector["Localidad"];
                    aux.CodigoPostal = (string)datos.Lector["CodigoPostal"];
                    aux.Observaciones = !(datos.Lector["Observaciones"] is DBNull) ? (string)datos.Lector["Observaciones"] : "";
                    aux.Activa = (bool)datos.Lector["Activa"];
                    aux.Principal = (bool)datos.Lector["Principal"];

                    lista.Add(aux);
                }

                return lista;
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

        public void Agregar(Direccion nueva)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("spAltaDireccion");
                datos.setearParametro("@IdUsuario", nueva.IdUsuario);
                datos.setearParametro("@Calle", nueva.Calle);
                datos.setearParametro("@Numero", nueva.Numero);
                datos.setearParametro("@Provincia", nueva.Provincia);
                datos.setearParametro("@Localidad", nueva.Localidad);
                datos.setearParametro("@CodigoPostal", nueva.CodigoPostal);
                datos.setearParametro("@Observaciones", string.IsNullOrEmpty(nueva.Observaciones) ? (object)DBNull.Value : nueva.Observaciones);
                datos.setearParametro("@Principal", nueva.Principal);

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

        public void Modificar(Direccion dir)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("spModificarDireccion");
                datos.setearParametro("@Id", dir.Id);
                datos.setearParametro("@Calle", dir.Calle);
                datos.setearParametro("@Numero", dir.Numero);
                datos.setearParametro("@Provincia", dir.Provincia);
                datos.setearParametro("@Localidad", dir.Localidad);
                datos.setearParametro("@CodigoPostal", dir.CodigoPostal);
                datos.setearParametro("@Observaciones", string.IsNullOrEmpty(dir.Observaciones) ? (object)DBNull.Value : dir.Observaciones);

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

        public void MarcarPrincipal(int idDireccion, int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("spMarcarDireccionPrincipal");
                datos.setearParametro("@Id", idDireccion);
                datos.setearParametro("@IdUsuario", idUsuario);
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

        public void CambiarEstado(int idDireccion, bool activa)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("spCambiarEstadoDireccion");
                datos.setearParametro("@Id", idDireccion);
                datos.setearParametro("@Activa", activa);
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