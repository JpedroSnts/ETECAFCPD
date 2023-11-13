using CPD.Repositorio.Controller;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Admin
{
    public partial class ocorrenciaEquipamento : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnCadastrar_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtNome.Text) || String.IsNullOrEmpty(txtCodigo.Text))
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Preencha todos os campos</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return;
            }

            string codigo = txtCodigo.Text;
            string nome = txtNome.Text;

            OcorrenciaEquipamentoController oec = new OcorrenciaEquipamentoController();
            if (oec.AdicionarOcorrencia(codigo, nome))
            {
                litErro.Text = $@"<div class='box1'>
				    <p>Tipo Ocorrencia cadastrado</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
            else
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Tipo Ocorrencia já está cadastrado</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
        }
    }
}