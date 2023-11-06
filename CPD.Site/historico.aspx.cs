using System;
using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.Util;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class Histórico : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Usuario(Session))
            {
                Response.Redirect("~/login.aspx");
            }
            string rm = Session["rm_usuario"].ToString();
            HistoricoController historicoController = new HistoricoController();
            historicoController.listarRA(rm).ForEach((ra) =>
            {
                if (ra.DataDevolucao > ra.DataDevolucaoPrevista)
                {

                    litHorarios.Text += $@" <tr>
                                            <td>{ra.DataSaida.ToString().Substring(0, 10)}</td>
                                            <td>{ra.DataSaida.ToString().Substring(10, 9)}</td>
                                            <td>{ra.DataDevolucao.ToString().Substring(10, 9)}
                                            <td>{ra.Ambiente.Sigla}</td>
                                            <td style='color: #ff0000'>Atrasada</td>
                                        </tr>";
                }
                else
                {
                    litHorarios.Text += $@" <tr>
                                            <td>{ra.DataSaida.ToString().Substring(0, 10)}</td>
                                            <td>{ra.DataSaida.ToString().Substring(10, 9)}</td>
                                            <td>{ra.DataDevolucao.ToString().Substring(10, 9)}
                                            <td>{ra.Ambiente.Sigla}</td>
                                            <td style='color: #00a100'>Concluida sem atraso</td>
                                        </tr>";
                }

            });
            historicoController.listarRE(rm).ForEach((re) =>
            {
                if (re.DataDevolucao > re.DataDevolucaoPrevista)
                {
                    litHorarios.Text += $@"<tr>
                                            <td>{re.DataSaida.ToString().Substring(0, 10)}</td>
                                            <td>{re.DataSaida.ToString().Substring(10, 9)}</td>
                                            <td>{re.DataDevolucao.ToString().Substring(10, 9)}
                                            <td>{re.Equipamento.Sigla}</td>
                                            <td style='color: #ff0000'>Atrasada</td>
                                        </tr>";
                }
                else
                {
                    litHorarios.Text += $@"<tr>
                                            <td>{re.DataSaida.ToString().Substring(0, 10)}</td>
                                            <td>{re.DataSaida.ToString().Substring(10, 9)}</td>
                                            <td>{re.DataDevolucao.ToString().Substring(10, 9)}
                                            <td>{re.Equipamento.Sigla}</td>
                                            <td style='color: #00a100'>Concluida sem atraso</td>
                                        </tr>";
                }
            
            }); 
        }
    }
}