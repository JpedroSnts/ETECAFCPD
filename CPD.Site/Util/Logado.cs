using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;

namespace CPD.Site.Util
{
    public static class Logado
    {
        public static bool Admin(HttpSessionState Session)
        {
            if (Session["rm_usuario"] != null && Session["tipo_usuario"].ToString() == "1")
                return true;
            return false;
        }

        public static bool Usuario(HttpSessionState Session)
        {
            if (Session["rm_usuario"] != null)
                return true;
            return false;
        }
    }
}