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
                RelatorioController rC = new RelatorioController();

                if (tipoRelatorio == "ocorrencias")
                {
                    litTipoRelatorio.Text = char.ToUpper(tipoRelatorio[0]) + tipoRelatorio.Substring(1) + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

                    litTituloTabela.Text = $@"<tr>
                                                <th>DATA</th>
                                                <th>RM</th>
                                                <th>PROFESSOR</th>
                                                <th>E-MAIL</th>
                                                <th>ITEM</th>
                                                <th>TIPO OCORRÊNCIA</th>
                                            </tr>";

                    relatorio = rC.relatorioOcorrencia(inicio, fim);

                    
                }
                if (tipoRelatorio == "reservasC")
                {
                    litTipoRelatorio.Text = char.ToUpper(tipoRelatorio[0]) + tipoRelatorio.Substring(1) + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

                    litTituloTabela.Text = $@"<tr>
                                                <th>DATA</th>
                                                <th>RM</th>
                                                <th>PROFESSOR</th>
                                                <th>E-MAIL</th>
                                                <th>ITEM</th>
                                                <th>DATA CANCELAMENTO</th>
                                            </tr>";

                    relatorio = rC.relatorioReservasCanceladas(inicio, fim);
                    
                }
                if (tipoRelatorio == "reservasA")
                {
                    litTipoRelatorio.Text = char.ToUpper(tipoRelatorio[0]) + tipoRelatorio.Substring(1) + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

                    litTituloTabela.Text = $@"<tr>
                                                <th>DATA</th>
                                                <th>HORARIO PREVISTO</th>
                                                <th>HORARIO RETIRADO</th>
                                                <th>RM</th>
                                                <th>PROFESSOR</th>
                                                <th>E-MAIL</th>
                                                <th>ITEM</th>
                                            </tr>";

                    relatorio = rC.relatorioReservasAtrasadas(inicio, fim);

                }
                if (tipoRelatorio == "reservasNA")
                {
                    litTipoRelatorio.Text = char.ToUpper(tipoRelatorio[0]) + tipoRelatorio.Substring(1) + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

                    litTituloTabela.Text = $@"<tr>
                                                <th>DATA</th>
                                                <th>RM</th>
                                                <th>PROFESSOR</th>
                                                <th>E-MAIL</th>
                                                <th>ITEM</th>
                                            </tr>";

                    relatorio = rC.relatorioReservasNaoRealizadas(inicio, fim);

                }
            }
        }
    }
}