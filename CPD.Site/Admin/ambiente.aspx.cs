using CPD.Repositorio.Controller;
using CPD.Site.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Admin
{
    public partial class ambiente : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            litErro.Text = "";
            if (!Logado.Admin(Session))
            {
                string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
                Response.Redirect(ultimaPagina);
            }
        }

        protected void btnCadastrar_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtNome.Text) || String.IsNullOrEmpty(txtSigla.Text))
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Preencha todos os campos</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return;
            }

            string sigla = txtSigla.Text;
            string nome = txtNome.Text;

            AmbienteController ac = new AmbienteController();
            if(ac.AdicionarAmbiente(sigla, nome))
            {
                litErro.Text = $@"<div class='box1'>
				    <p>Ambiente cadastrado</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
            else
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Ambiente já está cadastrado</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
        }
    }
}