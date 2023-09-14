<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="CPD.Site.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="../Estatico/css/estiloLogin.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <title>Login</title>
    <link rel="icon" href="../Estatico/imagens/logoCPD.png" type="image/png" />
</head>
<body>
    <form id="form1" runat="server">
        <img id="logoETECAF" src="../Estatico/imagens/logoETECAF.png" />
        <main>
            <h1>Login</h1>
            <img id="logoCPD" src="../Estatico/imagens/logoCPD.png" />
            <div>
                <label for="txtEmail">Usuário</label><br />
                <div class="display">
                    <img class="iconInput" src="../Estatico/imagens/user.png" /><asp:TextBox ID="txtRm" type="number" runat="server" placeholder="Insira seu RM"></asp:TextBox>
                    <br />
                    <br />
                </div>
            </div>
            <div>
                <label for="txtSenha">Senha</label><br />
                <div class="display">
                    <img class="iconInput" src="../Estatico/imagens/senha.png" /><asp:TextBox ID="txtSenha" type="password" runat="server" placeholder="Insira sua senha"></asp:TextBox>
                    <br />
                    <br />
                </div>
            </div>
            <p id="mensagemVerificacao"><asp:Literal ID="litErro" runat="server" Text=""></asp:Literal></p>
            <asp:Button ID="btnAcessar" runat="server" Text="Acessar" OnClick="btnAcessar_Click"/>
            <p>Esqueceu sua senha? <a href="esqueciSenha.html">Clique aqui</a></p>
            <p id="pVersao">Versão 1.0 - 2023</p>
        </main>
    </form>
</body>
</html>
