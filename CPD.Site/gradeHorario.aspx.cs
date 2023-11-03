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
    public partial class gradeHorario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Admin(Session))
            {
                string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
                Response.Redirect(ultimaPagina);
            }
            if (!IsPostBack)
            {
                AmbienteController ambienteController = new AmbienteController();
                ambienteController.ListarAmbientes().ForEach((a) =>
                {
                    ddlAmbiente.Items.Add(new ListItem(a.Nome, a.Sigla));
                });
                UsoAmbienteController usoAmbientecontroller = new UsoAmbienteController();
                usoAmbientecontroller.Listar(null, null, null).ForEach((ua) =>
                {
                    litHorarios.Text += $@"<tr>
                                            <td>{ua.DiaSemana.Nome}</td>
                                            <td>{ua.Inicio:HH:mm} - {ua.Termino:HH:mm}</td>
                                            <td>{ua.Ambiente.Nome}</td>
                                            <td><div class='btnExcluirUsoAmbiente' dia='{ua.DiaSemana.Codigo}' inicio='{ua.Inicio:HH:mm}' fim='{ua.Termino:HH:mm}'>Excluir</div></td>
                                        </tr>";
                });
            }
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            litHorarios.Text = "";
            Ambiente ambiente = new Ambiente { Sigla = ddlAmbiente.SelectedValue };
            DiaSemana diaSemana = new DiaSemana { Codigo = int.Parse(ddlDiaSemana.SelectedValue) };
            string periodo = ddlPeriodos.SelectedValue;
            UsoAmbienteController controller = new UsoAmbienteController();
            controller.Listar(diaSemana, ambiente, periodo).ForEach((ua) =>
            {
                litHorarios.Text += $@"<tr>
                                        <td>{ua.DiaSemana.Nome}</td>
                                        <td>{ua.Inicio:HH:mm} - {ua.Termino:HH:mm}</td>
                                        <td>{ua.Ambiente.Nome}</td>
                                        <td><div class='btnExcluirUsoAmbiente' dia='{ua.DiaSemana.Codigo}' inicio='{ua.Inicio:HH:mm}' fim='{ua.Termino:HH:mm}'>Excluir</div></td>
                                    </tr>";
            });;
        }

        protected void btnAdcHorario_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/novoHorario.aspx");
        }
    }
}