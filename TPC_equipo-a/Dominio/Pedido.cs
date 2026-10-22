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
        public DateTime Fecha { get; set; }
        public Usuario Cliente { get; set; }
        public FormaPago FormaPago { get; set; }
        public FormaEntrega FormaEntrega { get; set; }
        public Direccion Direccion { get; set; }
        public EstadoPedido Estado { get; set; }
        public List<ItemPedido> Items { get; set; }

        public Pedido()
        {
            Items = new List<ItemPedido>();
            Fecha = DateTime.Now;
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
