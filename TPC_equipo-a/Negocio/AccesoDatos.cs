using System;
using System.Configuration;
using System.Data.SqlClient;


namespace Negocio
{
    public class AccesoDatos
    {
        private SqlConnection conexion;
        private SqlCommand comando;
        private SqlDataReader lector;

        public SqlDataReader Lector
        {
            get { return lector; }
        }

        public AccesoDatos()
        {
            // Leo automáticamente la cadena de conexión "CadenaDB" desde el Web.config

            conexion = new SqlConnection(ConfigurationManager.ConnectionStrings["CadenaDB"].ConnectionString);
            comando = new SqlCommand();
        }

        public void setConsulta(string consulta)
        {
            comando.CommandType = System.Data.CommandType.Text;
            comando.CommandText = consulta;
        }

        public void ejecutarLectura()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                lector = comando.ExecuteReader();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void cerrarLectura()
        {
            if (lector != null && !lector.IsClosed)
                lector.Close();

            if (conexion != null && conexion.State == System.Data.ConnectionState.Open)
                conexion.Close();
        }
    }
}