using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class ResumenVentas
    {
        public int CantidadPedidos { get; set; }
        public decimal TotalVendido { get; set; }
        public decimal TicketPromedio { get; set; }
    }
}
