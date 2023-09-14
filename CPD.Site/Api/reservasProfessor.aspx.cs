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
                }
                if (Session["rm_usuario"].ToString() == Request["rm"].ToString())
                {
                    Response.ContentType = "application/json";
                    var rm = int.Parse(Request["rm"]);
                    var homeController = new HomeController();
                    Response.Write(JsonConvert.SerializeObject(ReservaDTO.OrdenarReservas(homeController.ListarReservas(rm))));
                }
                Response.StatusCode = 401;
                Response.End();
            }
        }
    }
}