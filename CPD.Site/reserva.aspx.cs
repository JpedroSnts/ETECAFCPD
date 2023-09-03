using CPD.Site.Controller;
using CPD.Site.ViewModel;
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
            List<ItemLivreDTO> equipamentoLivres = controller.ListarItensLivres(DateTime.Now, DateTime.Now);
            // div > div e input
            foreach (var el in equipamentoLivres)
            {
                Panel pnl = new Panel();
                pnl.ID = $"pnl_{el.Sigla}";

                Label lblNome = new Label();
                lblNome.Text = el.Nome;
                pnl.Controls.Add(lblNome);

                TextBox txtQuantidade = new TextBox();
                txtQuantidade.ID = $"txt_{el.Sigla}";
                txtQuantidade.TextMode = TextBoxMode.Number;
                txtQuantidade.ReadOnly = true;
                txtQuantidade.Attributes.Add("placeholder", "Quantidade");
                txtQuantidade.Attributes.Add("max", el.Quantidade.ToString());
                pnl.Controls.Add(txtQuantidade);

                pnlEquipamentos.Controls.Add(pnl);
            }
        }

        public void Cadastrar()
        {
            ReservaController controller = new ReservaController();
            List<ItemLivreDTO> itemLivreDTOs = new List<ItemLivreDTO>
            {
                new ItemLivreDTO("CONTROLE", "Controle", 2),
                new ItemLivreDTO("NOTE", "NOTE", 1),
                new ItemLivreDTO("INFOLAB", "INFOLAB", 1)
            };
            controller.ReservarItens(itemLivreDTOs, 36403, DateTime.Today, DateTime.Now);
        }
    }
}