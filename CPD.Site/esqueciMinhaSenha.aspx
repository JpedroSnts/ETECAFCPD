<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="esqueciMinhaSenha.aspx.cs" Inherits="CPD.Site.esqueciMinhaSenha" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloGeral.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <title>Esqueci minha senha</title>
    <link rel="icon" href="Estatico/imagens/QuadradoLogoCPD.png" type="image/png" />
</head>
<body id="bodyEsqueciSenha">
    <form id="form1" runat="server">
        <div class="caixa-flutuante-erros"><asp:Literal ID="litErro" runat="server"></asp:Literal></div>
        <asp:Panel ID="pnlAlterarSenha" runat="server">
            <main id="mainAlterarSenha">
                <h1>Alterar senha</h1>
                <div class="divLabels">
                    <label for="novaSenhaUsuario">Nova Senha</label><br />
                    <div class="display">
                        <img class="iconInput" src="Estatico/imagens/senha.png" />
                        <asp:TextBox ID="txtNovaSenha" placeholder="Insira sua nova senha" runat="server" TextMode="Password"></asp:TextBox>
                        <br />
                        <br />
                    </div>
                </div>
                <div class="divLabels">
                    <label for="confirmarNovaSenhaUsuario">Confirmar Nova Senha</label><br />
                    <div class="display">
                        <img class="iconInput" src="Estatico/imagens/senha.png" />
                        <asp:TextBox ID="txtConfirmarSenha" placeholder="Confirme sua nova senha" runat="server" TextMode="Password"></asp:TextBox>
                        <br />
                        <br />
                    </div>
                </div>
                <asp:Button ID="btnAlterarSenha" runat="server" Text="Alterar Senha" OnClick="btnAlterarSenha_Click"/>
                <p><a class="loginEsqueciSenha" href="/login.aspx">Fazer Login</a></p>
                <p id="pVersao">Versão 1.0 - 2023</p>
            </main>
        </asp:Panel>
        <asp:Panel ID="pnlRm" runat="server">
             <main id="mainAlterarSenha">
                 <h1>Esqueci minha senha</h1>
                 <div class="divLabels">
                     <label for="txtEmail">E-mail</label><br />
                     <div class="display">
                         <img class="iconInput" src="Estatico/imagens/user.png" />
                         <asp:TextBox ID="txtEmail" placeholder="Insira seu e-mail" runat="server" TextMode="Email"></asp:TextBox>
                         <br />
                         <br />
                     </div>
                 </div>
                 <asp:Button ID="btnRecuperar" runat="server" Text="Enviar email de recuperação" OnClick="btnRecuperar_Click"/>
                 <p><a class="loginEsqueciSenha" href="/login.aspx">Fazer Login</a></p>
                 <p id="pVersao">Versão 1.0 - 2023</p>
             </main>
        </asp:Panel>
    </form>
</body>
</html>
