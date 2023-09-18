using CPD.Repositorio.Banco;
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
            if (!Logado.Usuario(Session))
            {
                Response.Redirect("~/login.aspx");
            }
            litDdlNmProf.Visible = Logado.Admin(Session);
            DateTime inicio = DateTime.Now;
            DateTime fim = inicio.AddDays(1);
            if (!String.IsNullOrEmpty(txtInputData.Text) && !String.IsNullOrEmpty(txtHorarioInicio.Text) && !String.IsNullOrEmpty(txtHorarioFim.Text))
            {
                inicio = DateTime.Parse($"{txtInputData.Text} {txtHorarioInicio.Text}");
                fim = DateTime.Parse($"{txtInputData.Text} {txtHorarioFim.Text}");
            }
            AdicionarItensLivresNoPanel(inicio, fim);
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            
        }

        protected void btnReservar_Click(object sender, EventArgs e)
        {
            try
            {
                if (Logado.Admin(Session) && String.IsNullOrEmpty(txtNmProf.Text)) return;

                List<ItemLivreDTO> itensReserva = new List<ItemLivreDTO>();
                for (int i = 0; i < pnlAmbientes.Controls.Count; i++)
                {
                    for (int j = 0; j < pnlAmbientes.Controls[i].Controls.Count; j++)
                    {
                        if (pnlAmbientes.Controls[i].Controls[j] is RadioButton)
                        {
                            RadioButton radioButton = (RadioButton)pnlAmbientes.Controls[i].Controls[j];
                            if (radioButton.Checked)
                            {
                                itensReserva.Add(new ItemLivreDTO(radioButton.ID.Replace("rdb", ""), null, 1));
                            }
                        }
                    }
                }

                for (int i = 0; i < pnlEquipamentos.Controls.Count; i++)
                {
                    for (int j = 0; j < pnlEquipamentos.Controls[i].Controls.Count; j++)
                    {
                        for (int k = 0; k < pnlEquipamentos.Controls[i].Controls[j].Controls.Count; k++)
                        {
                            if (pnlEquipamentos.Controls[i].Controls[j].Controls[k] is TextBox)
                            {
                                TextBox txt = (TextBox)pnlEquipamentos.Controls[i].Controls[j].Controls[k];
                                if (txt.Text != "0")
                                {
                                    itensReserva.Add(new ItemLivreDTO(txt.ID.Replace("txt", ""), null, int.Parse(txt.Text)));
                                }
                            }
                        }
                    }
                }

                DateTime inicio = DateTime.Now;
                DateTime fim = DateTime.Today.AddHours(23).AddMinutes(59);
                if (!String.IsNullOrEmpty(txtInputData.Text))
                {
                    if (!String.IsNullOrEmpty(txtHorarioFim.Text))
                    {
                        fim = DateTime.Parse($"{txtInputData.Text} {txtHorarioFim.Text}");
                    }
                    if (!String.IsNullOrEmpty(txtHorarioInicio.Text))
                    {
                        inicio = DateTime.Parse($"{txtInputData.Text} {txtHorarioInicio.Text}");
                    }
                }

                ReservaController controller = new ReservaController();
                if (!Logado.Admin(Session))
                {
                    controller.ReservarItens(itensReserva, int.Parse(Session["rm_usuario"].ToString()), inicio, fim);
                    Response.Redirect("~/index.aspx");
                    return;
                }
                controller.ReservarItens(itensReserva, int.Parse(txtNmProf.Text), inicio, fim);
                Response.Redirect("~/dashboard.aspx");
            }
            catch (SPException ex)
            {
                litErro.Text = $"<div style='color: red;'>{ex.Message}</div>";
            }
        }
    }
}