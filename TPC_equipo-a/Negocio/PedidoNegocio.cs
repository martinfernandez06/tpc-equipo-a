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
        public List<Pedido> listarPedido(int? idEstado, DateTime? fechaDesde, DateTime? fechaHasta, string cliente)
        {
            List<Pedido> lista = new List<Pedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spListarPedidos");
                // cada filtro que viene vacio lo mando como null y el sp no filtra por ese dato
                datos.setearParametro("@IdEstado", idEstado.HasValue ? (object)idEstado.Value : DBNull.Value);
                // hasvalue me dice si eligio una fecha, si no mando null
                datos.setearParametro("@FechaDesde", fechaDesde.HasValue ? (object)fechaDesde.Value : DBNull.Value);
                datos.setearParametro("@FechaHasta", fechaHasta.HasValue ? (object)fechaHasta.Value : DBNull.Value);
                // si no escribio nada o solo espacios mando null, el trim saca los espacios de los costados
                datos.setearParametro("@Cliente", string.IsNullOrWhiteSpace(cliente) ? DBNull.Value : (object)cliente.Trim());
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido aux = new Pedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    // creo los objetos de adentro porque el constructor de Pedido no los inicializa, si no quedan en null y rompe al cargarles datos
                    aux.Cliente = new Usuario();
                    aux.Cliente.Id = (int)datos.Lector["IdUsuario"];
                    aux.Cliente.Nombre = (string)datos.Lector["NombreCliente"];
                    aux.Cliente.Apellido = (string)datos.Lector["ApellidoCliente"];
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
                    if (!(datos.Lector["EmpresaEnvio"] is DBNull))
                    {
                        aux.EmpresaEnvio = (string)datos.Lector["EmpresaEnvio"];
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

        public Pedido buscarPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            Pedido aux = new Pedido();

            try
            {
                datos.setearProcedimiento("spBuscarPedidoPorId");
                datos.setearParametro("@Id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    aux.Id = (int)datos.Lector["Id"];
                    aux.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    aux.Cliente = new Usuario();
                    aux.Cliente.Id = (int)datos.Lector["IdUsuario"];
                    aux.Cliente.Nombre = (string)datos.Lector["NombreCliente"];
                    aux.Cliente.Apellido = (string)datos.Lector["ApellidoCliente"];
                    aux.Cliente.Email = (string)datos.Lector["Email"];
                    if (!(datos.Lector["Telefono"] is DBNull))
                    {
                        aux.Cliente.Telefono = (string)datos.Lector["Telefono"];
                    }
                    aux.FormaEntrega = new FormaEntrega();
                    aux.FormaEntrega.Id = (int)datos.Lector["IdFormaEntrega"];
                    aux.FormaEntrega.Descripcion = (string)datos.Lector["FormaEntrega"];
                    if (!(datos.Lector["IdDireccion"] is DBNull))
                    {
                        aux.Direccion = new Direccion();
                        aux.Direccion.Id = (int)datos.Lector["IdDireccion"];
                        aux.Direccion.Calle = (string)datos.Lector["Calle"];
                        aux.Direccion.Numero = (string)datos.Lector["Numero"];
                        aux.Direccion.Localidad = (string)datos.Lector["Localidad"];
                        aux.Direccion.Provincia = (string)datos.Lector["Provincia"];
                        aux.Direccion.CodigoPostal = (string)datos.Lector["CodigoPostal"];
                    }
                    aux.FormaPago = new FormaPago();
                    aux.FormaPago.Id = (int)datos.Lector["IdFormaPago"];
                    aux.FormaPago.Descripcion = (string)datos.Lector["FormaPago"];
                    aux.Estado = new EstadoPedido();
                    aux.Estado.Id = (int)datos.Lector["IdEstado"];
                    aux.Estado.Descripcion = (string)datos.Lector["Estado"];
                    aux.Total = (decimal)datos.Lector["Total"];
                    if (!(datos.Lector["CodigoSeguimiento"] is DBNull))
                    {
                        aux.CodigoSeguimiento = (string)datos.Lector["CodigoSeguimiento"];
                    }
                    if (!(datos.Lector["EmpresaEnvio"] is DBNull))
                    {
                        aux.EmpresaEnvio = (string)datos.Lector["EmpresaEnvio"];
                    }
                    if (!(datos.Lector["EstadoComprobante"] is DBNull))
                    {
                        aux.EstadoComprobante = (string)datos.Lector["EstadoComprobante"];
                    }
                    if (!(datos.Lector["ComprobanteUrl"] is DBNull))
                    {
                        aux.ComprobanteUrl = (string)datos.Lector["ComprobanteUrl"];
                    }
                }
                return aux;
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
        public List<ItemPedido> ListarItems(int idPedido)
        {
            List<ItemPedido> listaItemPedidos = new List<ItemPedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spListarItemsPorPedido");
                datos.setearParametro("@IdPedido",idPedido);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ItemPedido aux = new ItemPedido();
                    aux.Producto = new Producto();
                    aux.Producto.Id = (int)datos.Lector["IdProducto"];
                    aux.Producto.Nombre = (string)datos.Lector["Nombre"];
                    if (!(datos.Lector["ImagenUrl"] is DBNull))
                    {
                        aux.Producto.ImagenUrl = (string)datos.Lector["ImagenUrl"];
                    }
                    aux.Cantidad = (int)datos.Lector["Cantidad"];
                    aux.PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"];
                    listaItemPedidos.Add(aux);
                }
                return listaItemPedidos;
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
        public List<HistorialEstado> ListarHistorial(int idPedido)
        {
            List<HistorialEstado> listaHistorialEstado = new List<HistorialEstado>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spListarHistorialPorPedido");
                datos.setearParametro("@IdPedido",idPedido);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    HistorialEstado aux = new HistorialEstado();
                    aux.Id = (int)datos.Lector["Id"];
                    // el sp no devuelve el idpedido, pero es el mismo que recibe el metodo
                    aux.IdPedido = idPedido;
                    aux.Estado = new EstadoPedido();
                    aux.Estado.Id = (int)datos.Lector["IdEstado"];
                    aux.Estado.Descripcion = (string)datos.Lector["Estado"];
                    aux.Usuario = new Usuario();
                    aux.Usuario.Id = (int)datos.Lector["IdUsuario"];
                    aux.Usuario.Nombre = (string)datos.Lector["NombreUsuario"];
                    aux.Usuario.Apellido = (string)datos.Lector["ApellidoUsuario"];
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];
                    listaHistorialEstado.Add(aux);
                }
                return listaHistorialEstado;
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
        // trae las observaciones de un pedido, las mas viejas primero
        public List<ObservacionPedido> ListarObservaciones(int idPedido)
        {
            List<ObservacionPedido> listaObservaciones = new List<ObservacionPedido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spListarObservacionesPorPedido");
                datos.setearParametro("@IdPedido", idPedido);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ObservacionPedido aux = new ObservacionPedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Usuario = new Usuario();
                    aux.Usuario.Id = (int)datos.Lector["IdUsuario"];
                    aux.Usuario.Nombre = (string)datos.Lector["NombreUsuario"];
                    aux.Usuario.Apellido = (string)datos.Lector["ApellidoUsuario"];
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];
                    aux.Observacion = (string)datos.Lector["Observacion"];
                    listaObservaciones.Add(aux);
                }
                return listaObservaciones;
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

        public void CambiarEstado(int idPedido, int idEstado, int idUsuario, string empresaEnvio, string codigoSeguimiento)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spCambiarEstadoPedido");
                datos.setearParametro("@IdPedido",idPedido);
                datos.setearParametro("@IdEstado",idEstado);
                datos.setearParametro("@IdUsuario",idUsuario);
                //si viene vacío o con espacios manda el NULL de la bd, y si tiene algo manda el texto
                datos.setearParametro("@EmpresaEnvio", string.IsNullOrWhiteSpace(empresaEnvio) ? DBNull.Value : (object)empresaEnvio);
                datos.setearParametro("@CodigoSeguimiento", string.IsNullOrWhiteSpace(codigoSeguimiento) ? DBNull.Value : (object)codigoSeguimiento);
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
        public void ActualizarSeguimiento(int idPedido, string codigoSeguimiento)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spActualizarSeguimiento");
                datos.setearParametro("@IdPedido",idPedido);
                datos.setearParametro("@CodigoSeguimiento", string.IsNullOrWhiteSpace(codigoSeguimiento) ? DBNull.Value : (object)codigoSeguimiento);
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
        public void CancelarPedido(int idPedido, int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spCancelarPedido");
                datos.setearParametro("@IdPedido",idPedido);
                datos.setearParametro("@IdUsuario",idUsuario);
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
        public void AgregarObservacion(int idPedido, int idUsuario, string observacion)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spAgregarObservacionPedido");
                datos.setearParametro("@IdPedido",idPedido);
                datos.setearParametro("@IdUsuario",idUsuario);
                datos.setearParametro("@Observacion",observacion);
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
