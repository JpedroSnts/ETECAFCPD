using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using IronPdf;

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

                if (tipoRelatorio == "Ocorrencias")
                {
                    litTipoRelatorio.Text = tipoRelatorio.ToString() + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

                    litTituloTabela.Text = $@"<tr>
                                                <th>DATA</th>
                                                <th>RM</th>
                                                <th>PROFESSOR</th>
                                                <th>E-MAIL</th>
                                                <th>ITEM</th>
                                                <th>TIPO OCORRÊNCIA</th>
                                            </tr>";

                    relatorio = rC.relatorioOcorrencia(inicio, fim);

                    for (int i = 0; i < relatorio.Ocorrencia.Count; i++)
                    {
                        litConteudoTabela.Text += $@"<tr>
                                                        <td>{relatorio.Ocorrencia[i].Data}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.RM}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Nome}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Email}</td>
                                                        <td>{relatorio.Reserva[i].Ambiente.Nome}</td>
                                                        <td>{relatorio.Ocorrencia[i].TipoOcorrencia.Nome}</td>
                                                    </tr>";
                    }

                }
                if (tipoRelatorio == "Reservas Canceladas")
                {
                    litTipoRelatorio.Text = tipoRelatorio.ToString() + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

                    litTituloTabela.Text = $@"<tr>
                                                <th>DATA</th>
                                                <th>RM</th>
                                                <th>PROFESSOR</th>
                                                <th>E-MAIL</th>
                                                <th>ITEM</th>
                                                <th>DATA CANCELAMENTO</th>
                                            </tr>";

                    relatorio = rC.relatorioReservasCanceladas(inicio, fim);

                    for (int i = 0; i < relatorio.Reserva.Count; i++)
                    {
                        litConteudoTabela.Text += $@"<tr>
                                                        <td>{relatorio.Reserva[i].DataSaidaPrevista}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.RM}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Nome}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Email}</td>
                                                        <td>{relatorio.Reserva[i].Ambiente.Nome}</td>
                                                        <td>{relatorio.Reserva[i].DataCancelamento}</td>
                                                    </tr>";
                    }

                }
                if (tipoRelatorio == "Reservas Atrasadas")
                {
                    /* NAO FUNCIONA */

                    litTipoRelatorio.Text = tipoRelatorio.ToString() + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

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

                    for (int i = 0; i < relatorio.Reserva.Count; i++)
                    {
                        litConteudoTabela.Text += $@"<tr>
                                                        <td>{relatorio.Reserva[i].DataSaidaPrevista}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.RM}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Nome}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Email}</td>
                                                        <td>{relatorio.Reserva[i].Ambiente.Nome}</td>
                                                        <td>{relatorio.Ocorrencia[i].TipoOcorrencia.Nome}</td>
                                                    </tr>";
                    }

                }
                if (tipoRelatorio == "Reservas Não Realizadas")
                {
                    litTipoRelatorio.Text = tipoRelatorio.ToString() + " de " + inicio.ToString("dd/MM/yyyy") + " a " + fim.ToString("dd/MM/yyyy");

                    litTituloTabela.Text = $@"<tr>
                                                <th>DATA</th>
                                                <th>RM</th>
                                                <th>PROFESSOR</th>
                                                <th>E-MAIL</th>
                                                <th>ITEM</th>
                                            </tr>";

                    relatorio = rC.relatorioReservasNaoRealizadas(inicio, fim);

                    for (int i = 0; i < relatorio.Reserva.Count; i++)
                    {
                        litConteudoTabela.Text += $@"<tr>
                                                        <td>{relatorio.Reserva[i].DataSaidaPrevista}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.RM}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Nome}</td>
                                                        <td>{relatorio.Reserva[i].Usuario.Email}</td>
                                                        <td>{relatorio.Reserva[i].Ambiente.Nome}</td>
                                                    </tr>";
                    }

                }
            }
        }
    }
}