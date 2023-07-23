using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;

namespace CPD.Repositorio.Banco
{
    public static class StringConexao
    {
        public static string GetStringConexao()
        {
            return "SERVER=localhost;UID=root;PASSWORD=root;DATABASE=bancoetecaf";
        }
    }
}