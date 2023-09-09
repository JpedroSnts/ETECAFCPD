using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Api
{
    public partial class buscarProfessor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!Logado.Admin(Session))
            //{
            //    Response.StatusCode = 401;
            //    Response.End();
            //}
            Response.ContentType = "application/json";
            UsuarioController usuarioController = new UsuarioController();
            List<Usuario> usuarios = usuarioController.BuscarProfessores(Request["q"]?.Trim());
            string json = "{'results':[";
            usuarios.ForEach((u) =>
            {
                json += $"{{'id':'{u.RM}','text':'{PrimeiroEUltimoNome(u.Nome)}'}},";
            });
            if (json.EndsWith(",")) json = json.Substring(0, json.Length - 1);
            json += "],'pagination':{'more':false}}";
            Response.Write(json.Replace('\'', '"'));
        }

        private string PrimeiroEUltimoNome(string nomeCompleto)
        {
            var nomes = nomeCompleto.Split(' ');
            return nomes[0] + " " + nomes[nomes.Length - 1];
        }
    }
}