using CPD.Repositorio.Banco;
using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
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
                    pnlEquipamentosItens.Controls.Add(pnl);
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
                    pnlAmbientesItens.Controls.Add(pnl);
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            pnlBodyReservar.Visible = false;
            if (!Logado.Usuario(Session))
            {
                Response.Redirect("~/login.aspx");
            }
            litDdlNmProf.Visible = Logado.Admin(Session);
            if (!String.IsNullOrEmpty(txtInputData.Text) && !String.IsNullOrEmpty(txtHorarioInicio.Text) && !String.IsNullOrEmpty(txtHorarioFim.Text))
            {
                DateTime inicio = DateTime.Parse($"{txtInputData.Text} {txtHorarioInicio.Text}");
                DateTime fim = DateTime.Parse($"{txtInputData.Text} {txtHorarioFim.Text}");
                if (DateTime.Compare(inicio, fim) > 0)
                {
                    litErro.Text = $@"<div class='box1'>
				        <p class='erro'>Horário inválido</p>
				        <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			        </div>";
                    return;
                };
                if (DateTime.Compare(inicio, DateTime.Now) < 0)
                {
                    litErro.Text = $@"<div class='box1'>
				        <p class='erro'>Data inválida</p>
				        <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			        </div>";
                    return;
                };
                AdicionarItensLivresNoPanel(inicio, fim);
                pnlBodyReservar.Visible = true;
            } 
            else
            {
                if (IsPostBack)
                {
                    litErro.Text = $@"<div class='box1'>
				        <p class='erro'>Preencha todos os campos</p>
				        <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			        </div>";
                }
            }
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
                for (int i = 0; i < pnlAmbientesItens.Controls.Count; i++)
                {
                    for (int j = 0; j < pnlAmbientesItens.Controls[i].Controls.Count; j++)
                    {
                        if (pnlAmbientesItens.Controls[i].Controls[j] is RadioButton)
                        {
                            RadioButton radioButton = (RadioButton)pnlAmbientesItens.Controls[i].Controls[j];
                            if (radioButton.Checked)
                            {
                                itensReserva.Add(new ItemLivreDTO(radioButton.ID.Replace("rdb", ""), null, 1));
                            }
                        }
                    }
                }

                for (int i = 0; i < pnlEquipamentosItens.Controls.Count; i++)
                {
                    for (int j = 0; j < pnlEquipamentosItens.Controls[i].Controls.Count; j++)
                    {
                        for (int k = 0; k < pnlEquipamentosItens.Controls[i].Controls[j].Controls.Count; k++)
                        {
                            if (pnlEquipamentosItens.Controls[i].Controls[j].Controls[k] is TextBox)
                            {
                                TextBox txt = (TextBox)pnlEquipamentosItens.Controls[i].Controls[j].Controls[k];
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
                int rm = int.Parse(Session["rm_usuario"].ToString());
                if (Logado.Admin(Session))
                {
                    rm = int.Parse(txtNmProf.Text);
                }
                controller.ReservarItens(itensReserva, rm, inicio, fim);
                Usuario usuario = new UsuarioController().BuscarUsuarioPorRM(rm);
                List<ReservaEquipamento> reservas = new ReservaGenericaController().ListarReservasEquipamentosComFiltro(rm, inicio);
                string html = 
                $@"<table border><tr><th>Dia da reserva</th><th>Horário inicio</th><th>Horário fim</th></tr><tr><td align='center'>{inicio:dd/MM/yyyy}</td><td align='center'>{inicio:HH:mm}</td><td align='center'>{fim:HH:mm}</td></tr></table>
                <br>
                <table border><tr><th>Ítens</th></tr>";
                reservas.ForEach(it =>
                {
                    html += $@"<tr><td>{it.Equipamento.Nome}</td></tr>";
                });
                html += "</table>";
                Email.Enviar(usuario.Email, "Reserva de ítens CPD", html);
                Response.Redirect("~/index.aspx");
            }
            catch (SPException ex)
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>{ex.Message}</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
        }
    }
}