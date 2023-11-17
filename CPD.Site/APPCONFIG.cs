using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site
{
    public static class APPCONFIG
    {
        public const string EMAIL_REMETENTE = "cpd_contato_teste@outlook.com";
        public const string NOME_REMETENTE = "Contato CPD";
        public const string SENHA_REMETENTE = "CpdContatoTeste";
        public const string SMTP_HOST = "smtp-mail.outlook.com";
        public const int SMTP_PORT = 587;
        public const bool SMTP_SSL = true;
        public const string BASE_URL = "http://localhost:54802";
    }
}