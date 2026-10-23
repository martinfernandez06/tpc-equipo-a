using System;

namespace Dominio
{
    public class Direccion
    {
        public int Id { get; set; }
        public int IdUsuario { get; set; }
        public string Calle { get; set; }
        public string Numero { get; set; }
        public string Provincia { get; set; } // para ver si usamos la API de Georef
        public string Localidad { get; set; }
        public string CodigoPostal { get; set; }
        public string Observaciones { get; set; }
        public bool Activa { get; set; } // no se la borra si ya se la uso en un pedido

        // Constructor por defecto
        public Direccion() {
            // toda direccion nueva nace activa
            Activa = true;
        }

       
        public Direccion(string calle, string numero,string provincia, string localidad, string codigoPostal, string observaciones = "") : this()
        {
            Calle = calle;
            Numero = numero;
            Provincia = provincia;
            Localidad = localidad;
            CodigoPostal = codigoPostal;
            Observaciones = observaciones;
        }
    }
}