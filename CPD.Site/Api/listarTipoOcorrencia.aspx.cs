using CPD.Repositorio.Controller;
using CPD.Site.Controller;
using CPD.Site.Util;
using CPD.Site.ViewModel;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Api
{
    public partial class listarTipoOcorrencia : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Admin(Session))
            {
                string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
                Response.Redirect(ultimaPagina);
            }
            TipoOcorrenciaAmbienteController aController = new TipoOcorrenciaAmbienteController();
            TipoOcorrenciaEquipamentoController eController = new TipoOcorrenciaEquipamentoController();
            string jsonAmb = JsonConvert.SerializeObject(aController.Listar());
            string jsonEqp = JsonConvert.SerializeObject(eController.Listar());
            string json = $"{{ 'TipoOcorrenciaAmbiente' : {jsonAmb} , 'TipoOcorrenciaEquipamento' : {jsonEqp} }}";
            Response.ContentType = "application/json";
            Response.StatusCode = 200;
            Response.Write(json.Replace("'", "\""));
        }
    }
}