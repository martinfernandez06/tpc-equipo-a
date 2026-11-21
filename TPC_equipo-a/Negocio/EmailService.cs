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
        }

        public void armarCorreo(string destino, string asunto, string cuerpo)
        {
            email = new MailMessage();

            email.To.Add(destino);

            email.From = new MailAddress(
                "no-reply@finishback.com",
                "FinishBack"
            );

            email.Subject = asunto;
            email.IsBodyHtml = true;
            email.Body = cuerpo;
        }

        public void enviarEmail()
        {
            server.Send(email);
        }
    }
}