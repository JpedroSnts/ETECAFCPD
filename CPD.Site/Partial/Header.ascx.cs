﻿using CPD.Site.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site.Partial
{
    public partial class Header : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Logado.Admin(Session))
            {
                pnlHeaderProf.Visible = false;
            }
            else
            {
                pnlHeaderFunc.Visible = false;
            }

            litImagemDesktopFunc.Text = $"<img id=\"userProfDesktop\" src=\"/Estatico/imagens/usuarios/{Session["foto_usuario"]}\" onerror=\"this.onerror=null; this.src='/Estatico/imagens/usuarios/default.png'\" />";
            litImagem.Text = $"<img id=\"userProf\" src=\"/Estatico/imagens/usuarios/{Session["foto_usuario"]}\" onerror=\"this.onerror=null; this.src='/Estatico/imagens/usuarios/default.png'\" />";
            litImagemDesktop.Text = $"<img id=\"userProfDesktop\" src=\"/Estatico/imagens/usuarios/{Session["foto_usuario"]}\" onerror=\"this.onerror=null; this.src='/Estatico/imagens/usuarios/default.png'\" />";
            litNome.Text = Session["nome_usuario"].ToString();
            litNomeDesktop.Text = Session["nome_usuario"].ToString();
            litRm.Text = Session["rm_usuario"].ToString();
            litRmfunc.Text = Session["rm_usuario"].ToString();
            litNomefunc.Text = Session["nome_usuario"].ToString();
            litRmDesktop.Text = Session["rm_usuario"].ToString();
            litRmfunc2.Text = Session["rm_usuario"].ToString();
            litImgFunc.Text = $"<img id=\"userProfDesktop\" src=\"/Estatico/imagens/usuarios/{Session["foto_usuario"]}\" onerror=\"this.onerror=null; this.src='/Estatico/imagens/usuarios/default.png'\" />";
        }
    }
}