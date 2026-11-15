using Dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Negocio
{
    public class PedidoNegocio
    {
        // guarda el pedido con todos sus productos y devuelve el numero que le dio la bd
        public int AgregarPedido(Pedido nuevo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // primero guardo los datos generales del pedido en PEDIDOS
                datos.setearProcedimiento("spAltaPedido");
                datos.setearParametro("@IdUsuario", nuevo.Cliente.Id);
                datos.setearParametro("@IdFormaEntrega", nuevo.FormaEntrega.Id);
                // si es retiro en el local no hay direccion y mando null a la bd, el object es para que el ternario acepte int y dbnull
                datos.setearParametro("@IdDireccion", nuevo.Direccion != null ? (object)nuevo.Direccion.Id : DBNull.Value);
                datos.setearParametro("@IdFormaPago", nuevo.FormaPago.Id);
                datos.setearParametro("@Total", nuevo.Total);

                // el sp devuelve el id del pedido nuevo en una columna sin nombre, por eso lo leo por posicion
                int idPedido = 0;
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    idPedido = (int)datos.Lector[0];
                }
                // despues guardo el detalle, un renglon por cada producto del carrito en ITEMS_PEDIDO, el sp tambien descuenta el stock
                foreach (ItemPedido item in nuevo.Items)
                {
                    // uno nuevo por cada item porque datos sigue ocupado con el pedido
                    AccesoDatos datosItem = new AccesoDatos();
                    datosItem.setearProcedimiento("spAltaItemPedido");
                    datosItem.setearParametro("@IdPedido", idPedido);
                    datosItem.setearParametro("@IdProducto", item.Producto.Id);
                    datosItem.setearParametro("@Cantidad", item.Cantidad);
                    datosItem.setearParametro("@PrecioUnitario", item.PrecioUnitario);
                    datosItem.ejecutarAccion();
                    datosItem.cerrarLectura();
                }
                // devuelvo el numero para mostrarlo en la confirmacion de compra
                return idPedido;
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
        public List<Pedido> listarPedido()
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spListarPedidos");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido aux = new Pedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    // creo los objetos de adentro porque el constructor de Pedido no los inicializa, si no quedan en null y rompe al cargarles datos
                    aux.Cliente = new Usuario();
                    aux.Cliente.Id = (int)datos.Lector["IdUsuario"];
                    aux.FormaPago = new FormaPago();
                    aux.FormaPago.Descripcion = (string)datos.Lector["FormaPago"];
                    aux.FormaEntrega = new FormaEntrega();
                    aux.FormaEntrega.Descripcion = (string)datos.Lector["FormaEntrega"];
                    aux.Estado = new EstadoPedido();
                    aux.Estado.Descripcion = (string)datos.Lector["Estado"];
                    aux.Total = (decimal)datos.Lector["Total"];
                    // estas columnas pueden venir NULL de la bd, solo las cargo si no son DBNull porque castear un DBNull a string rompe
                    if (!(datos.Lector["CodigoSeguimiento"] is DBNull))
                    {
                        aux.CodigoSeguimiento = (string)datos.Lector["CodigoSeguimiento"];
                    }
                    if (!(datos.Lector["EstadoComprobante"] is DBNull))
                    {
                        aux.EstadoComprobante = (string)datos.Lector["EstadoComprobante"];
                    }
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
        public List<Pedido> listarPedidosPorCliente(int idUsuario)
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spListarPedidosPorCliente");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido aux = new Pedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    // creo los objetos de adentro porque el constructor de Pedido no los inicializa, si no quedan en null y rompe al cargarles datos
                    aux.FormaPago = new FormaPago();
                    aux.FormaPago.Descripcion = (string)datos.Lector["FormaPago"];
                    aux.FormaEntrega = new FormaEntrega();
                    aux.FormaEntrega.Descripcion = (string)datos.Lector["FormaEntrega"];
                    aux.Estado = new EstadoPedido();
                    aux.Estado.Descripcion = (string)datos.Lector["Estado"];
                    aux.Total = (decimal)datos.Lector["Total"];
                    // estas columnas pueden venir NULL de la bd, solo las cargo si no son DBNull porque castear un DBNull a string rompe
                    if (!(datos.Lector["CodigoSeguimiento"] is DBNull))
                    {
                        aux.CodigoSeguimiento = (string)datos.Lector["CodigoSeguimiento"];
                    }
                    if (!(datos.Lector["EstadoComprobante"] is DBNull))
                    {
                        aux.EstadoComprobante = (string)datos.Lector["EstadoComprobante"];
                    }
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
