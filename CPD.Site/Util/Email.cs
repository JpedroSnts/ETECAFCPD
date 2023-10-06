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
            string nomeRemetente = "Contato CPD";
            string remetente = "cpd_contato_teste@outlook.com";
            string senha = "SENHA DO EMAIL";

            SmtpClient client = new SmtpClient
            {
                Credentials = new NetworkCredential(remetente, senha),
                Host = "smtp-mail.outlook.com",
                Port = 587,
                EnableSsl = true
            };

            MailMessage mail = new MailMessage();
            mail.To.Add(destinatario);
            mail.From = new MailAddress(remetente, nomeRemetente, System.Text.Encoding.UTF8);
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