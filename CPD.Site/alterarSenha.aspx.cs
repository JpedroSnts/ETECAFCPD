using CPD.Repositorio.Banco;
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

namespace CPD.Site
{
    public partial class alterarSenha : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Usuario(Session))
            {
                Response.Redirect("~/login.aspx");
            }
            litImagem.Text = $"<img id=\"userProf\" src=\"Estatico/imagens/{Session["foto_usuario"]}\" onerror=\"this.onerror=null; this.src='/Estatico/imagens/usuarios/default.png'\" />";
            litImgEdit.Text = $"<img id=\"imgEditar\" src=\"Estatico/imagens/usuarios/{Session["foto_usuario"]}\" onerror=\"this.onerror=null; this.src='/Estatico/imagens/usuarios/default.png'\" />";
            litNome.Text = Session["nome_usuario"].ToString();
            litRm.Text = Session["rm_usuario"].ToString();
        }

        protected void btnAlterarSenha_Click(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtSenhaAtual.Text) || String.IsNullOrEmpty(txtNovaSenha.Text) || String.IsNullOrEmpty(txtConfirmarSenha.Text))
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
                Usuario usuario = new Usuario { RM = int.Parse(Session["rm_usuario"].ToString()), Senha = txtSenhaAtual.Text };
                usuarioController.AlterarSenha(usuario, txtNovaSenha.Text, txtConfirmarSenha.Text);
                if (Logado.Admin(Session))
                {
                    Response.Redirect("~/dashboard.aspx");
                }
                Response.Redirect("index.aspx");
            }
            catch (SPException ex)
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>{ex.Message}</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
            }
        }

        protected void btnSalvarImagem_Click(object sender, EventArgs e)
        {
            if (txtImagemEditarFoto.PostedFile != null && txtImagemEditarFoto.FileContent.Length != 0)
            {
                string nmImagem = EnviarImagem();

                UsuarioController usuarioController = new UsuarioController();
                Usuario usuario = new Usuario()
                {
                    ReferenciaImagem = nmImagem,
                };
                try
                {
                    usuarioController.AlterarImagemProfessor(int.Parse(Session["rm_usuario"].ToString()), nmImagem);
                    Session["foto_usuario"] = nmImagem;
                    Response.Redirect("/alterarSenha.aspx");
                }
                catch (Exception ex)
                {
                    litErro.Text = $@"<div class='box1'>
				        <p class='erro'>{ex.Message}</p>
				        <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			        </div>";
                }
            }
        }

        private string EnviarImagem()
        {
            string NomeOriginalArq = Path.GetFileName(txtImagemEditarFoto.PostedFile.FileName);
            string NomeArq = Session["rm_usuario"] + "." + NomeOriginalArq.Split('.')[NomeOriginalArq.Split('.').Length - 1];
            
            string TipoArq = txtImagemEditarFoto.PostedFile.ContentType;
            if (TipoArq != "image/jpeg" && TipoArq != "image/png" && TipoArq != "image/jpg")
            {
                litErro.Text = $@"<div class='box1'>
				    <p class='erro'>Formato de arquivo não permitido!</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return null;
            }
            int TamanhoArq = txtImagemEditarFoto.PostedFile.ContentLength;

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
                txtImagemEditarFoto.PostedFile.SaveAs(Request.PhysicalApplicationPath + @"\Estatico\imagens\usuarios\" + NomeArq);
                litErro.Text = $@"<div class='box1'>
				    <p>Imagem Cadastrada</p>
				    <img src='/Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>";
                return NomeArq;
            }
        }
    }
}