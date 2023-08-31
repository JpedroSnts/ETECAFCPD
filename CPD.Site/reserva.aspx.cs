using CPD.Site.Controller;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class reserva : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ReservaController controller = new ReservaController();
            List<ViewModel.EquipamentoLivre> equipamentoLivres = controller.ListarEquipamentosLivres(DateTime.Now, DateTime.Now);
            foreach (var el in equipamentoLivres)
            {
                litTeste.Text += $@"
                    {el.CodigoBase} - {el.Nome} - {el.Quantidade} <br>
                ";
            }
        }
    }
}