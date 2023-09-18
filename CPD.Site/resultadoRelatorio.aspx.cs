using CPD.Repositorio.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class resultadoRelatorio : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!Logado.Admin(Session))
            //{
            //    string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
            //    Response.Redirect(ultimaPagina);
            //}
            if (!String.IsNullOrEmpty(Request["inicio"]) && !String.IsNullOrEmpty(Request["fim"]) && !String.IsNullOrEmpty(Request["tipoRelatorio"]))
            {
                DateTime inicio = DateTime.Parse(Request["inicio"]);
                DateTime fim = DateTime.Parse(Request["fim"]);
                string tipoRelatorio = Request["tipoRelatorio"];

                Relatorio relatorio = null;
                //if (tipoRelatorio == "ocorrencias")
                //{
                //    RelatorioController rC = new RelatorioController();
                //    relatorio = rC.relatorioOcorrencia(inicio, fim);
                //}
            }
        }
    }
}