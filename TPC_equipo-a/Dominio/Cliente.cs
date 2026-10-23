using System;
using System.Collections.Generic;

namespace Dominio
{
    public class Cliente
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        
       //Un cliente tiene una lista de domicilios
        public List<Direccion> Domicilios { get; set; }

        public Cliente()
       
        {
            
            Domicilios = new List<Direccion>();
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