using System;
using System.Net;
using System.Net.Mail;

namespace Negocio
{
    public class EmailService
    {
        private MailMessage email;
        private SmtpClient server;

        public EmailService()
        {
            server = new SmtpClient();
            server.Credentials = new NetworkCredential("tu_correo@gmail.com", "tu_contraseña_de_aplicacion");
            server.EnableSsl = true;
            server.Port = 587;
            server.Host = "smtp.gmail.com";
        }

        public void armarCorreo(string destino, string asunto, string cuerpo)
        {
            email = new MailMessage();
            email.To.Add(destino);
            email.From = new MailAddress("no-reply@ecommerce.com");
            email.Subject = asunto;
            email.IsBodyHtml = true;
            email.Body = cuerpo;
        }

        public void enviarEmail()
        {
            try
            {
                server.Send(email);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}