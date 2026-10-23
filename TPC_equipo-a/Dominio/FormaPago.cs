using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class FormaPago
    {
        public int Id { get; set; }
        public string Descripcion { get; set; } // Efectivo, Transferencia, Tarjeta, Mercado Pago
        public bool Activa { get; set; }  // El admin puede desactivar una forma de pago que no usa sin borrarla por ejemplo por si tiene pedidos viejos con esa forma de pago
    }
}
