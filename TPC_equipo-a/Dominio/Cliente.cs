using System;
using System.Collections.Generic;

namespace Dominio
{
    // Cliente hereda de usuario
    // Cliente ES un usuario jaja
    public class Cliente : Usuario
    {
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Telefono { get; set; }
        public List<Direccion> Direcciones { get; set; } // un cliente puede tener varias

        public Cliente()
       
        {
            
            Direcciones = new List<Direccion>();
        }

        public Cliente(string nombre, string apellido, string email, string telefono) : this()
        {
            Nombre = nombre;
            Apellido = apellido;
            Email = email;
            Telefono = telefono;
        }
    }
}