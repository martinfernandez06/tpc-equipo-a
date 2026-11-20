using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Pedido
    {
        public int Id { get; set; }
        public DateTime FechaCreacion { get; set; }
        public Usuario Cliente { get; set; }
        public FormaPago FormaPago { get; set; }
        public FormaEntrega FormaEntrega { get; set; }
        public Direccion Direccion { get; set; } // null si es retiro en el local
        public EstadoPedido Estado { get; set; }
        public List<ItemPedido> Items { get; set; }
        public List<ObservacionPedido> Observaciones { get; set; }
        //Un pedido puede tener muchas observaciones asi que la relacion 1 a muchos del DER
        public string CodigoSeguimiento { get; set; }
        public string EmpresaEnvio { get; set; }
        public string ComprobanteUrl { get; set; }
        public string EstadoComprobante { get; set; }
        public string MotivoCancelacion { get; set; } // lo escribe el admin o el cliente al cancelar null si el pedido no se cancelo
        public List<HistorialEstado> Historial { get; set; }
        public decimal Total { get; set; }

        public Pedido()
        {
            Items = new List<ItemPedido>();
            // Se inicializa en el constructor, igual que Items, para que nunca sea null
            Observaciones = new List<ObservacionPedido>();
            // Inicialización de la nueva lista del historial
            Historial = new List<HistorialEstado>();
            FechaCreacion = DateTime.Now;
        }

        
    }
}
