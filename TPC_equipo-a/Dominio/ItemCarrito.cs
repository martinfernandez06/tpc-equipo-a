using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class ItemCarrito
    {
        public Producto Producto { get; set; }
        public int Cantidad { get; set; }

        // Propiedad de solo lectura que calcula el subtotal en el momento.
        public decimal Subtotal
        {
            get { return Producto.PrecioVenta * Cantidad; }
        }
    }
}
