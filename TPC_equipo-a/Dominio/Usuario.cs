using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Usuario
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Email { get; set; }
        public string Clave { get; set; }
        public string Telefono { get; set; }
        public Perfil Perfil { get; set; }
        public bool Activo { get; set; }
        public DateTime FechaAlta { get; set; }
        public DateTime? UltimoAcceso { get; set; }
        public bool EmailConfirmado { get; set; }
        
        // Relación 1 a N con direcciones
        public List<Direccion> Direcciones { get; set; }

        public Usuario()
        {
            Perfil = new Perfil();
            Direcciones = new List<Direccion>();
            Activo = true;
        }
    }
}
