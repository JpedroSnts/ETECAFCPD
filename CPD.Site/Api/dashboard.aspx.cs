using CPD.Site.Controller;
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
            Response.ContentType = "application/json";
            DashboardController dashboardController = new DashboardController();
            string json = JsonConvert.SerializeObject(dashboardController.ListarReservasDeHoje());
            Response.Write(json);
        }
    }
}