﻿using CPD.Site.Util;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Logado.Usuario(Session))
            {
                Response.Redirect("~/login.aspx");
            }
            litImagem.Text = $"<img id=\"userProf\" src=\"Estatico/imagens/{Session["foto_usuario"]}\" />";
            litImagemDesktop.Text = $"<img id=\"userProfDesktop\" src=\"Estatico/imagens/{Session["foto_usuario"]}\" />";
            litNome.Text = Session["nome_usuario"].ToString();
            litNomeDesktop.Text = Session["nome_usuario"].ToString();
            litRm.Text = Session["rm_usuario"].ToString();
            litRmDesktop.Text = Session["rm_usuario"].ToString();
        }
    }
}