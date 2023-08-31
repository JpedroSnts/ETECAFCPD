using CPD.Site.Controller;
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
            DashboardController dashboardController = new DashboardController();
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            string json = serializer.Serialize(dashboardController.ListarReservasDeHoje());
            Response.Headers.Add("Content-Type", "application/json");
            Response.Write(json);
        }
    }
}