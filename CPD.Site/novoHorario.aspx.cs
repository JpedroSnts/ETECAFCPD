using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class novoHorario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                AmbienteController ambienteController = new AmbienteController();
                ambienteController.ListarAmbientes().ForEach((a) =>
                {
                    ddlAmbiente.Items.Add(new ListItem(a.Nome, a.Sigla));
                });
            }

            if (!Logado.Admin(Session))
            {
                string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
                Response.Redirect(ultimaPagina);
            }
        }

        protected void btnAdicionar_Click(object sender, EventArgs e)
        {
            DateTime inicio = DateTime.Parse($"{txtHorarioInicio.Text}");
            DateTime fim = DateTime.Parse($"{txtHorarioFim.Text}");

            if (ddlAmbiente.SelectedIndex == -1 || ddlDiaSemana.SelectedIndex == -1 || String.IsNullOrEmpty(txtHorarioInicio.Text) || String.IsNullOrEmpty(txtHorarioFim.Text))
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Preencha todos os campos</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return;
            }
            else
            {
                litErro.Text = "";
            }

            if (DateTime.Compare(inicio, fim) > 0)
            {
                litErro.Text = $@"<div class='box1'>
				        <p class='erro'>Horário inválido</p>
				        <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			        </div>";
                return;
            }
            else
            {
                litErro.Text = "";
            }


            DiaSemana dia = new DiaSemana()
            {
                Codigo = int.Parse(ddlDiaSemana.SelectedValue),
                Nome = ddlDiaSemana.Text
            };
            Ambiente ambiente = new Ambiente()
            {
                Sigla = ddlAmbiente.SelectedValue,
                Nome = ddlDiaSemana.Text
            };
            UsoAmbiente uso = new UsoAmbiente()
            {
                Ambiente = ambiente,
                DiaSemana = dia,
                Inicio = DateTime.Parse(inicio.ToString("HH:mm:ss")),
                Termino = DateTime.Parse(fim.ToString("HH:mm:ss"))
            };
            UsoAmbienteController usoC = new UsoAmbienteController();
            usoC.Adicionar(uso);
            Response.Redirect("~/gradeHorario.aspx");
        }
    }
}