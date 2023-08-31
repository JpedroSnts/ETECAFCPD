using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CPD.Site
{
    public partial class home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["rm_usuario"] == null)
            {
                Response.Redirect("~/login.aspx");
            }
            litImagem.Text = $"<img id=\"userProf\" src=\"../Estatico/imagens/{Session["foto_usuario"]}\" />";
            litNome.Text = Session["nome_usuario"].ToString();
            litNome.Text = Session["rm_usuario"].ToString();
        }
    }
}