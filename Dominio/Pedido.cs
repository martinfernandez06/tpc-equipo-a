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
        public string IdPagoMercadoPago { get; set; } // null si no se pago con Mercado Pago
        public List<ItemPedido> Items { get; set; }
        public List<ObservacionPedido> Observaciones { get; set; }
        //Un pedido puede tener muchas observaciones asi que la relacion 1 a muchos del DER

        public Pedido()
        {
            Items = new List<ItemPedido>();
            // Se inicializa en el constructor, igual que Items, para que nunca sea null
            Observaciones = new List<ObservacionPedido>();
            FechaCreacion = DateTime.Now;
        }

        public decimal Total
        {
            get
            {
                if (Items == null || Items.Count == 0) return 0;
                return Items.Sum(item => item.Subtotal);
            }
        }
    }
}
