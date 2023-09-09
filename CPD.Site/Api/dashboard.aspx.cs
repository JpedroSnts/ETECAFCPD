using CPD.Repositorio.Model;
using CPD.Repositorio.Util;
using CPD.Site.Controller;
using CPD.Site.Util;
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
            if (!Logado.Admin(Session))
            {
                Response.StatusCode = 401;
                Response.End();
            }
            Response.ContentType = "application/json";

            if (!String.IsNullOrEmpty(Request["rm"]) && !String.IsNullOrEmpty(Request["dt_saida"]) && !String.IsNullOrEmpty(Request["itens"]) && !String.IsNullOrEmpty(Request["status"]))
            {
                var dashboarController = new DashboardController();
                dashboarController.ConcluirReserva(int.Parse(Request["rm"]), Request["itens"], Request["status"], DateTime.Parse(Request["dt_saida"]));
            }
            if (!String.IsNullOrEmpty(Request["itens-livres"]))
            {
                ListarItensLivres();
                return;
            }
            ListarReservas();
        }

        private void ListarItensLivres()
        {
            var reservaController = new ReservaController();
            DateTime dataFinalDoDia = DateTime.Today.AddHours(23).AddMinutes(59).AddSeconds(59);
            Response.Write(JsonConvert.SerializeObject(reservaController.ListarItensLivres(DateTime.Now, dataFinalDoDia)));
        }

        private void ListarReservas()
        {
            var dashboardController = new DashboardController();
            var status = (EStatusReserva)int.Parse(Request["status"] ?? "0");
            var filtro = Request["filtro"];
            var data = DateTime.MinValue;
            if (!String.IsNullOrEmpty(Request["data"])) data = DateTime.Parse(Request["data"]);
            Response.Write(JsonConvert.SerializeObject(ReservaDTO.OrdenarReservas(dashboardController.ListarReservas(filtro, status, data))));
        }
    }
}