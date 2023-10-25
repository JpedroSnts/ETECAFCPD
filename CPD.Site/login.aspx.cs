using CPD.Repositorio.Banco;
using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Logado.Usuario(Session))
            {
                if (Logado.Admin(Session))
                {
                    Response.Redirect("~/dashboard.aspx");
                }
                Response.Redirect("~/index.aspx");
            }
        }

        protected void btnAcessar_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtRm.Text) || String.IsNullOrEmpty(txtSenha.Text))
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
                UsuarioController usuarioController = new UsuarioController();
                Usuario usuario = new Usuario
                {
                    RM = int.Parse(txtRm.Text),
                    Senha = txtSenha.Text
                };
                Usuario usuarioLogado = usuarioController.Login(usuario);
                if (usuarioLogado != null)
                {
                    Session["rm_usuario"] = usuarioLogado.RM;
                    Session["nome_usuario"] = usuarioLogado.Nome;
                    Session["foto_usuario"] = usuarioLogado.ReferenciaImagem;
                    Session["tipo_usuario"] = usuarioLogado.TipoUsuario.Codigo;
                    string ultimaPagina = Request.UrlReferrer != null ? Request.UrlReferrer.ToString() : "~/index.aspx";
                    if (usuarioLogado.TipoUsuario.Codigo == 1) ultimaPagina = "~/dashboard.aspx";
                    Response.Redirect(ultimaPagina);
                }
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