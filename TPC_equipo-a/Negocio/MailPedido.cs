using System;
using System.Configuration;
using System.Net;
using Dominio;

namespace Negocio
{
    // arma y manda el mail que le llega al cliente en cada paso de su pedido
    public class MailPedido
    {
        // devuelve false si el mail no salio asi la pantalla avisa pero el cambio ya quedo guardado en la bd
        public bool Enviar(int idPedido, string tipo, string motivo = "")
        {
            try
            {
                PedidoNegocio negocio = new PedidoNegocio();
                Pedido pedido = negocio.buscarPorId(idPedido);
                if (pedido.Id == 0)
                    return false;

                string asunto = "";
                string titulo = "";
                string texto = "";

                switch (tipo)
                {
                    case "compra":
                        asunto = $"Recibimos tu pedido #{pedido.Id}";
                        titulo = "¡Gracias por tu compra!";
                        texto = $"<p>Tu pedido quedó reservado y está pendiente de pago.</p>{TextoPago(pedido)}";
                        break;
                    case "rechazado":
                        asunto = $"Revisá el comprobante de tu pedido #{pedido.Id}";
                        titulo = "No pudimos validar tu comprobante";
                        texto = $"<p>Motivo: {WebUtility.HtmlEncode(motivo)}</p><p>Subí uno nuevo desde Mis compras y seguimos con tu pedido.</p>";
                        break;
                    case "pagado":
                        asunto = $"Tu pago del pedido #{pedido.Id} está confirmado";
                        titulo = "¡Pago confirmado!";
                        texto = "<p>Ya recibimos tu pago. En breve empezamos a preparar tu pedido.</p>";
                        break;
                    case "preparacion":
                        asunto = $"Estamos preparando tu pedido #{pedido.Id}";
                        titulo = "Estamos preparando tu pedido";
                        // los de retiro no pasan por enviado asi que el texto cambia
                        if (pedido.Direccion == null)
                            texto = "<p>Cuando esté listo lo podés retirar en el local.</p>";
                        else
                            texto = "<p>Cuando lo despachemos te mandamos el código de seguimiento.</p>";
                        break;
                    case "enviado":
                        asunto = $"Tu pedido #{pedido.Id} va en camino";
                        titulo = "¡Tu pedido va en camino!";
                        texto = $"<p>Lo enviamos por {WebUtility.HtmlEncode(pedido.EmpresaEnvio)}.</p>{TextoSeguimiento(pedido)}";
                        break;
                    case "entregado":
                        asunto = $"Tu pedido #{pedido.Id} fue entregado";
                        titulo = "¡Tu pedido fue entregado!";
                        texto = "<p>Esperamos que lo disfrutes. Gracias por comprar en Magva.</p>";
                        break;
                    case "cancelado":
                        asunto = $"Tu pedido #{pedido.Id} fue cancelado";
                        titulo = "Tu pedido fue cancelado";
                        texto = $"<p>Motivo: {WebUtility.HtmlEncode(pedido.MotivoCancelacion)}</p><p>Si ya habías pagado, la tienda se va a comunicar con vos para devolverte la plata.</p>";
                        break;
                    default:
                        return false;
                }

                EmailService email = new EmailService();
                email.armarCorreo(pedido.Cliente.Email, asunto, ArmarCuerpo(pedido, titulo, texto));
                email.enviarEmail();
                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }

        // lo que tiene que hacer para pagar segun como eligio pagar
        private string TextoPago(Pedido pedido)
        {
            if (pedido.FormaPago.RequiereComprobante)
            {
                return $@"<p>Transferí <b>{pedido.Total:C}</b> a esta cuenta:</p>
                    <p style='background:#F5F3FF; padding:12px 16px; line-height:1.8;'>
                        Alias: <b>{ConfigurationManager.AppSettings["TransferenciaAlias"]}</b><br />
                        CBU: <b>{ConfigurationManager.AppSettings["TransferenciaCbu"]}</b><br />
                        Titular: {ConfigurationManager.AppSettings["TransferenciaTitular"]}<br />
                        Banco: {ConfigurationManager.AppSettings["TransferenciaBanco"]}
                    </p>
                    <p>Después subí el comprobante desde Mis compras.</p>";
            }
            if (pedido.FormaPago.Descripcion.Contains("Mercado Pago"))
                return "<p>Si no terminaste el pago lo podés retomar desde Mis compras.</p>";
            if (pedido.Direccion == null)
                return "<p>Lo pagás en efectivo cuando lo retirás en el local.</p>";
            return "<p>Lo pagás en efectivo cuando lo recibís.</p>";
        }

        // si el codigo es un link va como link y si no va como texto
        private string TextoSeguimiento(Pedido pedido)
        {
            if (string.IsNullOrEmpty(pedido.CodigoSeguimiento))
                return "";
            string codigo = WebUtility.HtmlEncode(pedido.CodigoSeguimiento);
            if (pedido.CodigoSeguimiento.StartsWith("http://") || pedido.CodigoSeguimiento.StartsWith("https://"))
                return $"<p><a href='{codigo}' style='color:#512BD4;'>Seguí tu envío acá</a></p>";
            return $"<p>Código de seguimiento: <b>{codigo}</b></p>";
        }

        private string ArmarCuerpo(Pedido pedido, string titulo, string texto)
        {
            string nombre = WebUtility.HtmlEncode(pedido.Cliente.Nombre);
            // el meta charset hace que las tildes y la ñ se vean bien en cualquier casilla
            return $@"
                <!DOCTYPE html>
                <html lang='es'>
                <head><meta charset='UTF-8'></head>
                <body style='margin:0;'>
                <div style='margin:0; padding:30px; background:#f4f6f9; font-family:Arial,sans-serif;'>
                    <div style='max-width:600px; margin:auto; background:#ffffff; border-radius:12px; overflow:hidden;'>
                        <div style='background:#512BD4; padding:25px; text-align:center;'>
                            <h1 style='color:#ffffff; margin:0;'>Magva</h1>
                        </div>
                        <div style='padding:35px; color:#333333; font-size:15px; line-height:1.6;'>
                            <p>¡Hola, {nombre}!</p>
                            <h2 style='color:#111118;'>{titulo}</h2>
                            {texto}
                            <div style='border-top:1px solid #E4E4E7; margin-top:25px; padding-top:15px; font-size:13px; color:#666666;'>
                                Pedido #{pedido.Id} · Total {pedido.Total:C} · {pedido.FormaEntrega.Descripcion}
                            </div>
                        </div>
                        <div style='background:#f4f6f9; padding:18px; text-align:center; color:#888888; font-size:12px;'>
                            © Magva - Todos los derechos reservados.
                        </div>
                    </div>
                </div>
                </body>
                </html>";
        }
    }
}