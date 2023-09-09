using CPD.Site.Controller;
using CPD.Site.Util;
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
        private void AdicionarItensLivresNoPanel(DateTime inicio, DateTime fim)
        {
            ReservaController controller = new ReservaController();
            List<ItemLivreDTO> equipamentoLivres = controller.ListarItensLivres(inicio, fim);
            foreach (var el in equipamentoLivres)
            {
                if (el.Tipo == ETipoItem.Equipamento)
                {
                    Panel pnl = new Panel();
                    pnl.ID = $"pnl{el.Sigla}";
                    pnl.CssClass = "item-reserva";

                    Label lblNome = new Label();
                    lblNome.Text = el.Nome;
                    pnl.Controls.Add(lblNome);

                    Label lblItem = new Label();
                    lblItem.CssClass = "item";

                    Image imgMenos = new Image();
                    imgMenos.CssClass = "iconMenos";
                    imgMenos.ImageUrl = "Estatico/imagens/menos.svg";
                    lblItem.Controls.Add(imgMenos);

                    TextBox txtQt = new TextBox();
                    txtQt.ID = $"txt{el.Sigla}";
                    txtQt.Text = "0";
                    txtQt.MaxLength = el.Quantidade;
                    txtQt.ReadOnly = true;
                    txtQt.CssClass = "numQtEquip";
                    lblItem.Controls.Add(txtQt);

                    Image imgMais = new Image();
                    imgMais.CssClass = "iconMais";
                    imgMais.ImageUrl = "Estatico/imagens/mais.svg";
                    lblItem.Controls.Add(imgMais);

                    pnl.Controls.Add(lblItem);
                    pnlEquipamentos.Controls.Add(pnl);
                }
                else
                {
                    Panel pnl = new Panel();
                    pnl.ID = $"pnl{el.Sigla}";
                    pnl.CssClass = "item-reserva";

                    Label lblNome = new Label();
                    lblNome.Text = el.Nome;
                    pnl.Controls.Add(lblNome);

                    RadioButton rdb = new RadioButton();
                    rdb.ID = $"rdb{el.Sigla}";
                    rdb.CssClass = "rdbAmb";
                    rdb.Attributes.Add("OnClick", $"javascript:SelectSingleRadiobutton('rdb{el.Sigla}')");
                    pnl.Controls.Add(rdb);
                    pnlAmbientes.Controls.Add(pnl);
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!Logado.Admin(Session))
                {
                    txtInputNmProf.Visible = false;
                }
                DateTime inicio = DateTime.Today;
                DateTime fim = inicio.AddDays(1);
                AdicionarItensLivresNoPanel(inicio, fim);
            }
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtInputData.Text) && !String.IsNullOrEmpty(txtHorarioInicio.Text) && !String.IsNullOrEmpty(txtHorarioFim.Text))
            {
                DateTime inicio = DateTime.Parse($"{txtInputData.Text} {txtHorarioInicio.Text}");
                DateTime fim = DateTime.Parse($"{txtInputData.Text} {txtHorarioFim.Text}");
                AdicionarItensLivresNoPanel(inicio, fim);
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