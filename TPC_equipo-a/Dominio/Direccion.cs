using System;

namespace Dominio
{
    public class Direccion
    {
        public int Id { get; set; }
        public int IdUsuario { get; set; }
        public string Calle { get; set; }
        public string Numero { get; set; }
        public string Localidad { get; set; }
        public string CodigoPostal { get; set; }
        public string Observaciones { get; set; }

        // Constructor por defecto
        public Direccion() { }

       
        public Direccion(string calle, string numero, string localidad, string codigoPostal, string observaciones = "")
        {
            Calle = calle;
            Numero = numero;
            Localidad = localidad;
            CodigoPostal = codigoPostal;
            Observaciones = observaciones;
        }
    }
}