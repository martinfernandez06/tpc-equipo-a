using System;
using System.Collections.Generic;
using Dominio;

namespace Negocio
{
    public class ProductoNegocio
    {
        public List<Producto> Listar()
        {
            List<Producto> lista = new List<Producto>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                // CAMBIO CLAVE: Reemplazo la consulta de texto por el procedimiento almacenado

                datos.setearProcedimiento("spListarProductos") ;
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Producto aux = new Producto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Descripcion = !(datos.Lector["Descripcion"] is DBNull) ? (string)datos.Lector["Descripcion"] : "";
                    aux.PrecioVenta = (decimal)datos.Lector["PrecioVenta"];
                    aux.Stock = (int)datos.Lector["Stock"];
                    
                    // Mapeo de la categoria y su nombre obtenido mediante el JOIN del SP
                    aux.Categoria = new Categoria();
                    aux.Categoria.Id = (int)datos.Lector["IdCategoria"];
                    aux.Categoria.Nombre = (string)datos.Lector["CategoriaNombre"];
                    
                    aux.ImagenUrl = !(datos.Lector["ImagenUrl"] is DBNull) ? (string)datos.Lector["ImagenUrl"] : "";
                    aux.Activo = (bool)datos.Lector["Activo"];

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



        public void Agregar(Producto nuevo) {
        
        
        AccesoDatos datos = new AccesoDatos() ;
        
        try {

            // Usando procedimiento almacenado spAltaProducto

            datos.setearProcedimiento("spAltaProducto") ;
        
            datos.setearParametro("@Nombre", nuevo.Nombre) ;
            datos.setearParametro("@Descripcion", nuevo.Descripcion) ;
            datos.setearParametro("@PrecioVenta", nuevo.PrecioVenta) ;
            datos.setearParametro("@Stock", nuevo.Stock) ;
            datos.setearParametro("@IdCategoria", nuevo.Categoria.Id);
            datos.setearParametro("@ImagenUrl", nuevo.ImagenUrl);

            // Activo es 1 en la BD

            datos.setearParametro("@Activo", true);

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