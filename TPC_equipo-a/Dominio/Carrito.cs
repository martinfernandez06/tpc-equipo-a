using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Carrito
    {
        // Inicializamos la lista para que nunca sea null
        public List<ItemCarrito> Items { get; set; } = new List<ItemCarrito>();

        // Propiedad de solo lectura que suma los subtotales de todos los ítems.
        public decimal Total
        {
            get { return Items.Sum(x => x.Subtotal); }
        }

        // Método de ayuda para contar cuántos productos distintos hay.
        public int CantidadArticulos
        {
            get { return Items.Sum(x => x.Cantidad); }
        }
    }
}
