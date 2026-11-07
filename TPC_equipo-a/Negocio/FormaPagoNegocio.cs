using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio;

namespace Negocio
{
    public class FormaPagoNegocio
    {
        public List<FormaPago> Listar()
        {
            List<FormaPago> lista = new List<FormaPago>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT Id, Descripcion, Activa FROM FORMAS_PAGO");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    FormaPago aux = new FormaPago();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
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

        public void Agregar(FormaPago nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("INSERT INTO FORMAS_PAGO (Descripcion, Activa) VALUES (@Descripcion, 1)");
                datos.setearParametro("@Descripcion", nuevo.Descripcion);
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

        public void Modificar(FormaPago modificado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE FORMAS_PAGO SET Descripcion = @Descripcion WHERE Id = @Id");
                datos.setearParametro("@Descripcion", modificado.Descripcion);
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
                datos.setearConsulta("UPDATE FORMAS_PAGO SET Activa = @Activa WHERE Id = @Id");
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