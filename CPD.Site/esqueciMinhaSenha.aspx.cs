using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CPD.Repositorio.Banco;
using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.Util;

namespace CPD.Site
{
    public partial class esqueciMinhaSenha : System.Web.UI.Page
    {
        private Token token = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(Request["token"]))
            {
                pnlAlterarSenha.Visible = false;
                pnlRm.Visible = true;
            }
            else
            {
                pnlAlterarSenha.Visible = true;
                pnlRm.Visible = false;
                try
                {
                    string codigo = Request["token"].ToString();
                    TokenController tokenController = new TokenController();
                    token = tokenController.BuscarToken(codigo);
                    if (token == null || String.IsNullOrEmpty(token.Codigo))
                    {
                        Response.Redirect("/esqueciMinhaSenha.aspx");
                    }
                    if (token.Data.AddMinutes(5) < DateTime.Now)
                    {
                        Response.Redirect("/esqueciMinhaSenha.aspx");
                    }
                }
                catch (Exception)
                {
                    Response.Redirect("/esqueciMinhaSenha.aspx");
                }
            }
        }

        protected void btnAlterarSenha_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtNovaSenha.Text) || String.IsNullOrEmpty(txtConfirmarSenha.Text))
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Preencha todos os campos</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return;
            }
            else
            {
                litErro.Text = "";
            }
            try
            {
                TokenController tokenController = new TokenController();
                tokenController.AlterarSenha(token.Codigo, txtNovaSenha.Text, txtConfirmarSenha.Text);
                Response.Redirect("/login.aspx");
            }
            catch (SPException ex)
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>{ex.Message}</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
        }

        protected void btnRecuperar_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtEmail.Text))
            {
                try
                {
                    TokenController tokenController = new TokenController();
                    Token tokenEmail = tokenController.GerarToken(txtEmail.Text);
                    string textoEmail = $@"
                    <p>Altere sua senha clicando <strong><a href='{APPCONFIG.BASE_URL}/esqueciMinhaSenha.aspx?token={tokenEmail.Codigo}'>aqui</a></strong></p>
                    <small>este link é valido por 5 minutos</small>
                ";
                    Email.Enviar(tokenEmail.Email, "Recuperação de senha CPD", textoEmail);
                    Response.Redirect("/login.aspx");
                }
                catch (SPException ex)
                {
                    litErro.Text = $@"<div class='box1'>
				        <p class='erro'>{ex.Message}</p>
				        <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			        </div>";
                }
                catch (Exception ex) 
                {
                    litErro.Text = $@"<div class='box1'>
				        <p class='erro'>{ex.Message}</p>
				        <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			        </div>";
                }
                return;
            }
            litErro.Text = $@"<div class='box1'>
				<p class='erro'>Insira um email válido</p>
				<img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			</div>";
        }
    }
}