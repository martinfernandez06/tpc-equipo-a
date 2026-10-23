using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    // Esta clase es para notas internas que cargara el usuario osea admin o vendedor/empleado sobre un pedido
    public class ObservacionPedido
    {
        public int Id { get; set; }
        public DateTime Fecha { get; set; }
        public string Observacion { get; set; }
        public Usuario Usuario { get; set; } // Quien escribio la observacion
    }
}
