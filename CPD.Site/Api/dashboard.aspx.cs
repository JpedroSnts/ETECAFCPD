using CPD.Repositorio.Model;
using CPD.Site.Controller;
using CPD.Site.ViewModel;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Api
{
    public partial class dashboard : System.Web.UI.Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {
            //if (Session["rm_usuario"] == null || Session["tipo_usuario"].ToString() != "1")
            //{
            //    string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/home.aspx";
            //    Response.Redirect(ultimaPagina);
            //}
            Response.AddHeader("Access-Control-Allow-Origin", "*");
            Response.ContentType = "application/json";
            var dashboardController = new DashboardController();
            var status = (EStatusReserva) int.Parse(Request["status"] ?? "0");
            var filtro = Request["filtro"];
            var data = DateTime.MinValue;
            if (!String.IsNullOrEmpty(Request["data"])) data = DateTime.Parse(Request["data"]);
            var json = JsonConvert.SerializeObject(ReservaDTO.OrdenarReservas(dashboardController.ListarReservas(filtro, status, data)));
            Response.Write(json);
        }
    }
}