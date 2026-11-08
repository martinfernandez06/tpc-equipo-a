using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class HistorialEstado
    {
        public int Id { get; set; }
        public int IdPedido { get; set; }
        public EstadoPedido Estado { get; set; }
        public Usuario Usuario { get; set; }
        public DateTime Fecha { get; set; }
    }
}