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
    public partial class listarItensLivres : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Usuario(Session))
            {
                Response.StatusCode = 401;
                Response.End();
            }
            if (!String.IsNullOrEmpty(Request["inicio"]) && !String.IsNullOrEmpty(Request["fim"]) && !String.IsNullOrEmpty(Request["itens"]) && !String.IsNullOrEmpty(Request["quantidades"]))
            {
                Response.ContentType = "application/json";

                var controller = new ReservaController();
                string[] itensStr = Request["itens"].Split(',');
                string[] quantidades = Request["quantidades"].Split(',');
                List<ItemLivreDTO> itensReserva = new List<ItemLivreDTO>();
                for (int i = 0; i < itensStr.Length; i++)
                {
                    itensReserva.Add(new ItemLivreDTO(itensStr[i], null, int.Parse(quantidades[i])));
                }
                DateTime inicio = DateTime.Parse(Request["inicio"]);
                DateTime fim = DateTime.Parse(Request["fim"]);
                var itens = controller.ListarItensLivres(itensReserva, inicio, fim);
                Response.Write(JsonConvert.SerializeObject(itens));
            }
        }
    }
}