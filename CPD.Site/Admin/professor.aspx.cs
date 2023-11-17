using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.Util;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Admin
{
    public partial class professor : System.Web.UI.Page
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
            string nmImagem = "default.png";
            if (txtFoto.PostedFile != null && txtFoto.FileContent.Length != 0)
            {
                nmImagem = EnviarImagem();
            }
            if (String.IsNullOrEmpty(txtEmail.Text) || String.IsNullOrEmpty(txtNome.Text) || String.IsNullOrEmpty(txtRm.Text))
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Preencha todos os campos</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return;
            }
            UsuarioController usuarioController = new UsuarioController();

            Random randNum = new Random();
            string senha = randNum.Next(999999).ToString();
            Usuario usuario = new Usuario()
            {
                RM = int.Parse(txtRm.Text),
                Nome = txtNome.Text,
                Email = txtEmail.Text,
                Senha = senha,
                ReferenciaImagem = nmImagem,
                TipoUsuario = new TipoUsuario() { Codigo = 2 },
            };
            try
            {
                usuarioController.Cadastrar(usuario);
                txtEmail.Text = "";
                txtRm.Text = "";
                txtNome.Text = "";
                string html = $"<p>Olá {usuario.Nome.Split(' ')[0]}, sua nova senha no sistema do CPD é: <b>{usuario.Senha}</b></p> <p>Faça uma reserva agora mesmo clicando <a href='{APPCONFIG.BASE_URL}/login.aspx'>aqui</a>!</p>";
                Email.Enviar(usuario.Email, "Senha ETECAF CPD", html);
                litErro.Text = $@"<div class='box1'>
				    <p>Usuário cadastrado</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
            catch (Exception ex)
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>{ex.Message}</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
        }

        private string EnviarImagem()
        {
            string NomeOriginalArq = Path.GetFileName(txtFoto.PostedFile.FileName);
            string NomeArq = txtRm.Text + "." + NomeOriginalArq.Split('.')[NomeOriginalArq.Split('.').Length - 1];

            string TipoArq = txtFoto.PostedFile.ContentType;
            if (TipoArq != "image/jpeg" && TipoArq != "image/png" && TipoArq != "image/jpg")
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Formato de arquivo não permitido!</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return null;
            }
            int TamanhoArq = txtFoto.PostedFile.ContentLength;

            if (TamanhoArq <= 0)
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>A tentativa de upLoad do arquivo {NomeOriginalArq} falhou!</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return null;
            }
            else
            {
                txtFoto.PostedFile.SaveAs(Request.PhysicalApplicationPath + @"\Estatico\imagens\usuarios\" + NomeArq);
                litErro.Text = $@"<div class='box1'>
				    <p>Imagem Cadastrada</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return NomeArq;
            }
        }
    }
}