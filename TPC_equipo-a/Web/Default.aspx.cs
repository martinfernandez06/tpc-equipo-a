using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Web
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

      
            try
            {
                // Instancip la capa de negocio que acabp de crear

                CategoriaNegocio negocio = new CategoriaNegocio();
                List<Categoria> listaCategorias = negocio.listar();

                // PRUEBA DE CONEXIÓN: Si llega acá sin explotar, la conexión y la lectura funcionaron

                // cantidad de categorías leídas en la consola de depuración o en pantalla

                System.Diagnostics.Debug.WriteLine("¡Conexión exitosa! Cantidad de categorías: " + listaCategorias.Count);

               
                // Opcional: si querés ver el nombre de la primera categoría en la consola de salida de Visual Studio:
              
                if (listaCategorias.Count > 0)

                {
                    System.Diagnostics.Debug.WriteLine("Primera categoría: " + listaCategorias[0].Nombre);
                }
            }
            catch (Exception ex)
            {
                // Si hay un error de conexión (contraseña mal, puerto cerrado, etc.), saltará acá
                System.Diagnostics.Debug.WriteLine("Error de conexión: " + ex.Message);
            }
        }



        }
    }
