using CPD.Repositorio.Banco;
using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class alterarSenha : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["rm_usuario"] == null)
            {
                Response.Redirect("~/login.aspx");
            }
            litImagem.Text = $"<img id=\"userProf\" src=\"Estatico/imagens/{Session["foto_usuario"]}\" />";
            litNome.Text = Session["nome_usuario"].ToString();
            litRm.Text = Session["rm_usuario"].ToString();
        }

        protected void btnAlterarSenha_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtSenhaAtual.Text) || String.IsNullOrEmpty(txtNovaSenha.Text) || String.IsNullOrEmpty(txtConfirmarSenha.Text))
            {
                litErro.Text = $"<div style='color: red;'>Preencha todos os campos</div>";
                return;
            }
            try
            {
                UsuarioController usuarioController = new UsuarioController();
                Usuario usuario = new Usuario { RM = int.Parse(Session["rm_usuario"].ToString()), Senha = txtSenhaAtual.Text };
                usuarioController.AlterarSenha(usuario, txtNovaSenha.Text, txtConfirmarSenha.Text);
                Response.Redirect("~/logout.aspx");
            }
            catch (SPException ex)
            {
                litErro.Text = $"<div style='color: red;'>${ex.Message}</div>";
            }
        }
    }
}