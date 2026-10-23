namespace Dominio
{
    public class FormaEntrega
    {
        public int Id { get; set; }
        public string Nombre { get; set; } // Ej: Retiro en local, domicilio
        public bool RequiereDireccion { get; set; } // true para envios, false para retiro
        public bool Activa { get; set; }

        public FormaEntrega() { }

        public FormaEntrega(int id, string nombre, bool requiereDireccion, bool activa = true)
        {
            Id = id;
            Nombre = nombre;
            RequiereDireccion = requiereDireccion;
            Activa = activa;
        }
    }
}