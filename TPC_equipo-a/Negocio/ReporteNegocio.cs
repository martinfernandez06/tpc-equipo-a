using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class ReporteNegocio
    {
        public ResumenVentas ObtenerResumenVentas(DateTime? fechaDesde, DateTime? fechaHasta)
        {
            AccesoDatos datos = new AccesoDatos();
            ResumenVentas resumen = new ResumenVentas();
            
            try
            {
                datos.setearProcedimiento("spReporteTotalVendido");
                // hasvalue me dice si eligio una fecha, si no mando null
                datos.setearParametro("@FechaDesde", fechaDesde.HasValue ? (object)fechaDesde.Value : DBNull.Value);
                datos.setearParametro("@FechaHasta", fechaHasta.HasValue ? (object)fechaHasta.Value : DBNull.Value);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    resumen.CantidadPedidos = (int)datos.Lector["CantidadPedidos"];
                    resumen.TotalVendido = (decimal)datos.Lector["TotalVendido"];
                    resumen.TicketPromedio = (decimal)datos.Lector["TicketPromedio"];
                }
                return resumen;
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
        public List<PedidosPorEstado> ListarPedidosPorEstado(DateTime? fechaDesde, DateTime? fechaHasta)
        {
            AccesoDatos datos = new AccesoDatos();
            List<PedidosPorEstado> lista = new List<PedidosPorEstado>();

            try
            {
                datos.setearProcedimiento("spReportePedidosPorEstado");
                // hasvalue me dice si eligio una fecha, si no mando null
                datos.setearParametro("@FechaDesde", fechaDesde.HasValue ? (object)fechaDesde.Value : DBNull.Value);
                datos.setearParametro("@FechaHasta", fechaHasta.HasValue ? (object)fechaHasta.Value : DBNull.Value);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    PedidosPorEstado aux = new PedidosPorEstado();
                    aux.Estado = (string)datos.Lector["Estado"];
                    aux.Cantidad = (int)datos.Lector["Cantidad"];
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
        public List<ProductoVendido> ListarProductosMasVendidos(DateTime? fechaDesde, DateTime? fechaHasta)
        {
            AccesoDatos datos = new AccesoDatos();
            List<ProductoVendido> lista = new List<ProductoVendido>();

            try
            {
                datos.setearProcedimiento("spReporteProductosMasVendidos");
                // hasvalue me dice si eligio una fecha, si no mando null
                datos.setearParametro("@FechaDesde", fechaDesde.HasValue ? (object)fechaDesde.Value : DBNull.Value);
                datos.setearParametro("@FechaHasta", fechaHasta.HasValue ? (object)fechaHasta.Value : DBNull.Value);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ProductoVendido producto = new ProductoVendido();
                    producto.Nombre = (string)datos.Lector["Nombre"];
                    producto.Unidades = (int)datos.Lector["Unidades"];
                    producto.TotalVendido = (decimal)datos.Lector["TotalVendido"];
                    if (!(datos.Lector["Codigo"] is DBNull))
                    {
                        producto.Codigo = (string)datos.Lector["Codigo"];
                    }
                    lista.Add(producto);
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
