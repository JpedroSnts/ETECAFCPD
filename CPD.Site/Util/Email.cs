using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Web;

namespace CPD.Site.Util
{
    public static class Email
    {
        public static bool Enviar(string destinatario, string assunto, string texto)
        {
            SmtpClient client = new SmtpClient
            {
                Credentials = new NetworkCredential(APPCONFIG.EMAIL_REMETENTE, APPCONFIG.SENHA_REMETENTE),
                Host = APPCONFIG.SMTP_HOST,
                Port = APPCONFIG.SMTP_PORT,
                EnableSsl = APPCONFIG.SMTP_SSL
            };

            MailMessage mail = new MailMessage();
            mail.To.Add(destinatario);
            mail.From = new MailAddress(APPCONFIG.EMAIL_REMETENTE, APPCONFIG.NOME_REMETENTE, System.Text.Encoding.UTF8);
            mail.Subject = assunto;
            mail.SubjectEncoding = System.Text.Encoding.UTF8;
            mail.Body = $"<html><body>{texto}</body></html>";
            mail.BodyEncoding = System.Text.Encoding.UTF8;
            mail.IsBodyHtml = true;
            mail.Priority = MailPriority.High;

            try
            {
                client.Send(mail);
                return true;
            }
            catch
            {
                return false;
            }
        }
    }
}