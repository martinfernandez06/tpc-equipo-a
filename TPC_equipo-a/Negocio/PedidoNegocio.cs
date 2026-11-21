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

                // me guardo el nombre del producto que se esta guardando, si falla se lo muestro al cliente
                string productoActual = "";

                try
                {
                    // despues guardo el detalle, un renglon por cada producto del carrito en ITEMS_PEDIDO, el sp tambien descuenta el stock
                    foreach (ItemPedido item in nuevo.Items)
                    {
                        productoActual = item.Producto.Nombre;
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
                }
                catch (Exception ex)
                {
                    // si un producto fallo deshago lo que se alcanzo a guardar, asi no queda un pedido a medias con stock tomado
                    AnularPedidoIncompleto(idPedido);

                    // si fue por stock le digo cual producto es, asi sabe cual sacar del carrito
                    if (ex.Message.Contains("No hay stock suficiente"))
                    {
                        throw new Exception("No hay stock suficiente de \"" + productoActual + "\", otro cliente lo compró recién. Sacalo del carrito o bajá la cantidad para seguir.");
                    }
                    throw;
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

        // borra el pedido que quedo a medias y devuelve el stock, lo usa AgregarPedido cuando falla un producto
        private void AnularPedidoIncompleto(int idPedido)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearProcedimiento("spAnularPedidoIncompleto");
                datos.setearParametro("@IdPedido", idPedido);
                datos.ejecutarAccion();
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
                    aux.FormaPago = new FormaPago();
                    aux.FormaPago.Id = (int)datos.Lector["IdFormaPago"];
                    aux.FormaPago.Descripcion = (string)datos.Lector["FormaPago"];
                    aux.FormaPago.RequiereComprobante = (bool)datos.Lector["RequiereComprobante"];
                    aux.FormaEntrega = new FormaEntrega();
                    aux.FormaEntrega.Descripcion = (string)datos.Lector["FormaEntrega"];
                    aux.Estado = new EstadoPedido();
                    aux.Estado.Id = (int)datos.Lector["IdEstado"];
                    aux.Estado.Descripcion = (string)datos.Lector["Estado"];
                    aux.Total = (decimal)datos.Lector["Total"];
                    aux.EstuvoPagado = (bool)datos.Lector["EstuvoPagado"];

                    if (!(datos.Lector["CodigoSeguimiento"] is DBNull))
                    {
                        aux.CodigoSeguimiento = (string)datos.Lector["CodigoSeguimiento"];
                    }
                    if (!(datos.Lector["EmpresaEnvio"] is DBNull))
                    {
                        aux.EmpresaEnvio = (string)datos.Lector["EmpresaEnvio"];
                    }
                    if (!(datos.Lector["ComprobanteUrl"] is DBNull))
                    {
                        aux.ComprobanteUrl = (string)datos.Lector["ComprobanteUrl"];
                    }
                    if (!(datos.Lector["EstadoComprobante"] is DBNull))
                    {
                        aux.EstadoComprobante = (string)datos.Lector["EstadoComprobante"];
                    }
                    if (!(datos.Lector["MotivoRechazoComprobante"] is DBNull))
                    {
                        aux.MotivoRechazoComprobante = (string)datos.Lector["MotivoRechazoComprobante"];
                    }
                    if (!(datos.Lector["MotivoCancelacion"] is DBNull))
                    {
                        aux.MotivoCancelacion = (string)datos.Lector["MotivoCancelacion"];
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
                    aux.FormaPago.RequiereComprobante = (bool)datos.Lector["RequiereComprobante"];
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
                    if (!(datos.Lector["MotivoCancelacion"] is DBNull))
                    {
                        aux.MotivoCancelacion = (string)datos.Lector["MotivoCancelacion"];
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
                datos.setearParametro("@IdPedido", idPedido);
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
                datos.setearParametro("@IdPedido", idPedido);
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
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdEstado", idEstado);
                datos.setearParametro("@IdUsuario", idUsuario);
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
        public void ActualizarSeguimiento(int idPedido, string empresaEnvio, string codigoSeguimiento)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spActualizarSeguimiento");
                datos.setearParametro("@IdPedido", idPedido);
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
        // cancela desde el admin, el motivo es obligatorio y el cliente lo ve en mis compras.
        public void CancelarPedido(int idPedido, int idUsuario, string motivo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spCancelarPedido");
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@Motivo", string.IsNullOrWhiteSpace(motivo) ? DBNull.Value : (object)motivo.Trim());
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

        // cancela desde mis compras solo si el pedido es del cliente, sigue sin pagar y no mando comprobante, si no el sp tira error
        public void CancelarPedidoCliente(int idPedido, int idUsuario, string motivo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spCancelarPedidoCliente");
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@Motivo", string.IsNullOrWhiteSpace(motivo) ? DBNull.Value : (object)motivo.Trim());
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
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@Observacion", observacion);
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
        // pedidos con el comprobante esperando revision para la bandeja, el mas viejo primero
        public List<Pedido> ListarComprobantesPendientes()
        {
            AccesoDatos datos = new AccesoDatos();
            List<Pedido> lista = new List<Pedido>();

            try
            {
                datos.setearProcedimiento("spListarComprobantesPendientes");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Pedido aux = new Pedido();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    aux.Total = (decimal)datos.Lector["Total"];
                    if (!(datos.Lector["ComprobanteUrl"] is DBNull))
                    {
                        aux.ComprobanteUrl = (string)datos.Lector["ComprobanteUrl"];
                    }
                    // creo los objetos de adentro porque el constructor de Pedido no los inicializa, si no quedan en null y rompe al cargarles datos
                    aux.Cliente = new Usuario();
                    aux.Cliente.Nombre = (string)datos.Lector["NombreCliente"];
                    aux.Cliente.Apellido = (string)datos.Lector["ApellidoCliente"];
                    aux.Cliente.Email = (string)datos.Lector["Email"];
                    aux.FormaPago = new FormaPago();
                    aux.FormaPago.Descripcion = (string)datos.Lector["FormaPago"];
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
        // cuantos comprobantes hay esperando revision, para el numerito del menu
        public int ContarComprobantesPendientes()
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spContarComprobantesPendientes");
                datos.ejecutarLectura();

                int cantidad = 0;
                if (datos.Lector.Read())
                {
                    cantidad = (int)datos.Lector["Cantidad"];
                }
                return cantidad;
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
        // acepta el comprobante y el pedido pasa solo a pagado, si ya lo revisaron o lo cancelaron el sp tira error
        public void AceptarComprobante(int idPedido, int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spAceptarComprobante");
                datos.setearParametro("@IdPedido", idPedido);
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
        // rechaza el comprobante, el pedido sigue pendiente de pago y el motivo lo ve el cliente y queda como observacion
        public void RechazarComprobante(int idPedido, int idUsuario, string motivo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spRechazarComprobante");
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdUsuario", idUsuario);
                // si viene vacio o con espacios manda el null de la bd, y si tiene algo manda el texto sin espacios a los costados
                datos.setearParametro("@Motivo", string.IsNullOrWhiteSpace(motivo) ? DBNull.Value : (object)motivo.Trim());
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
        // el cliente sube el comprobante de la transferencia si el pedido no es suyo o ya tiene uno en revision el sp tira error
        public void SubirComprobante(int idPedido, int idUsuario, string comprobanteUrl)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearProcedimiento("spSubirComprobante");
                datos.setearParametro("@IdPedido", idPedido);
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@ComprobanteUrl", string.IsNullOrWhiteSpace(comprobanteUrl) ? DBNull.Value : (object)comprobanteUrl);
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
