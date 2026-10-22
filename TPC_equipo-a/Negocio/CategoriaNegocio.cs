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
                datos.setConsulta("SELECT Id, Nombre, Descripcion, Activa FROM CATEGORIAS");
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
    }
}