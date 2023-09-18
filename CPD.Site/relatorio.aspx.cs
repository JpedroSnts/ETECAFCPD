using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class relatorio : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //if (!Logado.Admin(Session))
            //{
            //    string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
            //    Response.Redirect(ultimaPagina);
            //}
        }

        protected void btnGerarRelatorio_Click(object sender, EventArgs e)
        {
            DateTime inicio = DateTime.Parse(dataInicio.Text);
            DateTime fim = DateTime.Parse(dataFinal.Text);
            Relatorio relatorio = null;
            if (ddlRelatorio.SelectedValue == "ocorrencias")
            {
                RelatorioController rC = new RelatorioController();
                relatorio = rC.relatorioOcorrencia(inicio, fim);
            }
        }
    }
}