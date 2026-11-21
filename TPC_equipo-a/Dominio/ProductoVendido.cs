using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class ProductoVendido
    {
        public string Codigo { get; set; }
        public string Nombre { get; set; }
        public int Unidades { get; set; }
        public decimal TotalVendido { get; set; }
    }
}
