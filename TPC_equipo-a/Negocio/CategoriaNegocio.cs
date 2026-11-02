using System;
using System.Collections.Generic;
using Dominio;

namespace Negocio
{
    public class CategoriaNegocio
    {
        public List<Categoria> listar()
        {
            List<Categoria> lista = new List<Categoria>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT Id, Nombre, Descripcion, Activa FROM CATEGORIAS");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Categoria aux = new Categoria();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Descripcion = !(datos.Lector["Descripcion"] is DBNull) ? (string)datos.Lector["Descripcion"] : "";
                    aux.Activa = (bool)datos.Lector["Activa"];

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
        public void agregarCategoria(Categoria nueva)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spAltaCategoria");
                datos.setearParametro("@Nombre",nueva.Nombre);
                datos.setearParametro("@Descripcion",nueva.Descripcion);
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
        public void modificarCategoria(Categoria modificada)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spModificarCategoria");
                datos.setearParametro("@Nombre", modificada.Nombre);
                datos.setearParametro("@Descripcion", modificada.Descripcion);
                datos.setearParametro("@Id", modificada.Id);
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
        public void cambiarEstadoCategoria(int id, bool activa)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spCambiarEstadoCategoria");
                datos.setearParametro("@Id",id);
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
        public Categoria buscarPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spBuscarCategoriaPorId");
                datos.setearParametro("@id",id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Categoria aux = new Categoria();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Descripcion = !(datos.Lector["Descripcion"] is DBNull) ? (string)datos.Lector["Descripcion"] : "";
                    aux.Activa = (bool)datos.Lector["Activa"];
                    // Si leyo correctamente devolvemos esa categoria
                    return aux;
                }
                // Si no, no existe ese id
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
    }
}