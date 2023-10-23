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
    public partial class relatorio : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Admin(Session))
            {
                string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
                Response.Redirect(ultimaPagina);
            }
        }

        protected void btnGerarRelatorio_Click(object sender, EventArgs e)
        {
            if (ddlRelatorio.SelectedIndex == -1 || String.IsNullOrEmpty(txtDataInicio.Text) || String.IsNullOrEmpty(txtDataFinal.Text))
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Preencha todos os campos</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return;
            }

            string tipo = "";
            if (ddlRelatorio.SelectedValue == "ocorrencias") tipo = "Ocorrencias";
            if (ddlRelatorio.SelectedValue == "reservasC") tipo = "Reservas Canceladas";
            if (ddlRelatorio.SelectedValue == "reservasA") tipo = "Reservas Atrasadas";
            if (ddlRelatorio.SelectedValue == "reservasNR") tipo = "Reservas Não Realizadas";
            if (tipo == "")
            {
                //ERRO
                return;
            }
            Page.ClientScript.RegisterStartupScript(this.GetType(), "OpenWindow", 
                $"window.open('/resultadoRelatorio.aspx?inicio={txtDataInicio.Text}&fim={txtDataFinal.Text}&tipoRelatorio={tipo}','_newtab');", true
                );
        }
    }
}