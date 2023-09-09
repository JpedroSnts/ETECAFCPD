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
    public partial class excluirGradeHorario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Admin(Session))
            {
                Response.StatusCode = 401;
                Response.End();
            }
            if (!String.IsNullOrEmpty(Request["dia"]) && !String.IsNullOrEmpty(Request["inicio"]) && !String.IsNullOrEmpty(Request["fim"]))
            {
                UsoAmbiente usoAmbiente = new UsoAmbiente();
                usoAmbiente.DiaSemana = new DiaSemana { Codigo = int.Parse(Request["dia"]) };
                usoAmbiente.Inicio = DateTime.Parse(Request["inicio"]);
                usoAmbiente.Termino = DateTime.Parse(Request["fim"]);
                UsoAmbienteController controller = new UsoAmbienteController();
                controller.Remover(usoAmbiente);
            }
        }
    }
}