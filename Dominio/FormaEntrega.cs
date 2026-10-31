namespace Dominio
{
    public class FormaEntrega
    {
        public int Id { get; set; }
        public string Descripcion { get; set; } // Ej: Retiro en local, domicilio
        public bool RequiereDireccion { get; set; } // true para envios, false para retiro
        public bool Activa { get; set; }

        public FormaEntrega() { }

        public FormaEntrega(int id, string descripcion, bool requiereDireccion, bool activa = true)
        {
            Id = id;
            Descripcion = descripcion;
            RequiereDireccion = requiereDireccion;
            Activa = activa;
        }
    }
}