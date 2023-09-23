using CPD.Repositorio.Model;
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
    public partial class reservasProfessor : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {       
            if (Logado.Usuario(Session))
            {
                if (String.IsNullOrEmpty(Request["rm"]))
                {
                    Response.StatusCode = 400;
                    Response.End();
                    return;
                }
                if (Session["rm_usuario"].ToString() == Request["rm"].ToString())
                {
                    var homeController = new HomeController();
                    var rm = int.Parse(Request["rm"]);
                    if (!String.IsNullOrEmpty(Request["itens"]) && !String.IsNullOrEmpty(Request["data"]))
                    {
                        var itens = Request["itens"];
                        var data = DateTime.Parse(Request["data"]);
                        homeController.CancelarReservas(itens, rm, data);
                        return;
                    }
                    Response.ContentType = "application/json";
                    Response.StatusCode = 200;
                    Response.Write(JsonConvert.SerializeObject(ReservaDTO.OrdenarReservas(homeController.ListarReservas(rm))));
                    return;
                }
                Response.StatusCode = 401;
                Response.End();
            }
        }
    }
}