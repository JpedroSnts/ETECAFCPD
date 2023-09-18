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
            string tipo = "";
            if (ddlRelatorio.SelectedValue == "ocorrencia") tipo = "ocorrencia";
            if (ddlRelatorio.SelectedValue == "reservasC") tipo = "reservasC";
            if (ddlRelatorio.SelectedValue == "reservasA") tipo = "reservasA";
            if (ddlRelatorio.SelectedValue == "reservasNA") tipo = "reservasNA";
            if (tipo == "")
            {
                //ERRO
                return;
            }
            Page.ClientScript.RegisterStartupScript(this.GetType(), "OpenWindow", 
                $"window.open('/resultadoRelatorio.aspx?inicio={dataInicio.Text}&fim={dataFinal.Text}&tipoRelatorio={tipo}','_newtab');", true
                );
        }
    }
}