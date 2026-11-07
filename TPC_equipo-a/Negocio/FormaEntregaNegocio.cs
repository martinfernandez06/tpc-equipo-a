using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio;

namespace Negocio
{
    public class FormaEntregaNegocio
    {
        public List<FormaEntrega> Listar()
        {
            List<FormaEntrega> lista = new List<FormaEntrega>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT Id, Descripcion, RequiereDireccion, Activa FROM FORMAS_ENTREGA");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    FormaEntrega aux = new FormaEntrega();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.RequiereDireccion = (bool)datos.Lector["RequiereDireccion"];
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
        public void Agregar(FormaEntrega nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("INSERT INTO FORMAS_ENTREGA (Descripcion, RequiereDireccion, Activa) VALUES (@Descripcion, @RequiereDireccion, @Activa)");
                datos.setearParametro("@Descripcion", nuevo.Descripcion);
                datos.setearParametro("@RequiereDireccion", nuevo.RequiereDireccion);
                datos.setearParametro("@Activa", nuevo.Activa);
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
        public void Modificar(FormaEntrega modificado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE FORMAS_ENTREGA SET Descripcion = @Descripcion, RequiereDireccion = @RequiereDireccion, Activa = @Activa WHERE Id = @Id");
                datos.setearParametro("@Descripcion", modificado.Descripcion);
                datos.setearParametro("@RequiereDireccion", modificado.RequiereDireccion);
                datos.setearParametro("@Activa", modificado.Activa);
                datos.setearParametro("@Id", modificado.Id);
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
        public void CambiarEstado(int id, bool activa)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE FORMAS_ENTREGA SET Activa = @Activa WHERE Id = @Id");
                datos.setearParametro("@Activa", activa);
                datos.setearParametro("@Id", id);
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