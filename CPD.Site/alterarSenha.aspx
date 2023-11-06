<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="alterarSenha.aspx.cs" Inherits="CPD.Site.alterarSenha" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="Estatico/css/estiloGeral.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <title>Alterar Senha</title>
    <link rel="icon" href="Estatico/imagens/QuadradoLogoCPD.png" type="image/png" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />

        <div id="displayPerfil">

            <div id="editarImg">
                <div style="padding-right: 10px;">
                    <asp:Literal ID="litImgEdit" runat="server"></asp:Literal>
                    <label for="txtImagemEditarFoto"><img id="btnEditarFoto" src="/Estatico/imagens/alterarSenha.svg" /></label>
                    <asp:FileUpload ID="txtImagemEditarFoto" runat="server" style="display: none;" />
                </div>
                <div>
                    <asp:Button ID="btnSalvarImagem" runat="server" Text="Salvar Imagem" OnClick="btnSalvarImagem_Click"/>
                </div>
            </div>

            <main id="mainAlterarSenha">
                <div class="caixa-flutuante-erros"><asp:Literal ID="litErro" runat="server"></asp:Literal></div>
                <h1>Alterar Senha</h1>
                <div class="labelAtual">
                    <label for="atualSenhaUsuario">Senha Atual</label><br />
                    <div class="display">
                        <img class="iconInput iconRm" src="Estatico/imagens/usuario.svg" />
                        <asp:TextBox ID="txtSenhaAtual" placeholder="Insira sua senha atual" runat="server" TextMode="Password"></asp:TextBox>
                        <br />
                        <br />
                    </div>
                </div>
                <div class="labelsNovaSenha">
                    <div class="divLabelsSenha">
                        <label for="novaSenhaUsuario">Nova Senha</label><br />
                        <div class="display">
                            <img class="iconInput" src="Estatico/imagens/senha.png" />
                            <asp:TextBox ID="txtNovaSenha" placeholder="Insira sua nova senha" runat="server" TextMode="Password"></asp:TextBox>
                            <br />
                            <br />
                        </div>
                    </div>
                    <div class="divLabelsSenha">
                        <label for="confirmarNovaSenhaUsuario">Confirmar Nova Senha</label><br />
                        <div class="display">
                            <img class="iconInput" src="Estatico/imagens/senha.png" />
                            <asp:TextBox ID="txtConfirmarSenha" placeholder="Confirme sua nova senha" runat="server" TextMode="Password"></asp:TextBox>
                            <br />
                            <br />
                        </div>
                    </div>
                </div>
                <asp:Button ID="btnAlterarSenha" runat="server" Text="Alterar Senha" OnClick="btnAlterarSenha_Click" />
                <p id="pVersao">Versão 1.0 - 2023</p>
            </main>
        </div>

        <div id="bloqueio" class="bloqueio escondido"></div>
        <div id="resultado" class="cardSucesso escondido"></div>

        <div class="bloqueio escondido" id="escondido"></div>
        <div id="divMenu" class="caixaFlutuante escondido">
            <div id="menuSanduiche">
                <div id="divUser">
                    <asp:Literal ID="litImagem" runat="server"></asp:Literal>
                    <div>
                        <p>
                            <asp:Literal ID="litNome" runat="server"></asp:Literal>
                        </p>
                        <p>
                            <asp:Literal ID="litRm" runat="server"></asp:Literal>
                        </p>
                    </div>
                </div>
                <div id="divItemsMenu">
                    <div class="itemsMenu">
                        <a href="index.html">
                            <p>Suas Reservas</p>
                        </a>
                        <img class="iconsMenu" src="Estatico/imagens/suasReservas.png" />
                    </div>
                    <div class="itemsMenu">
                        <a href="reserva.html">
                            <p>Nova Reserva</p>
                        </a>
                        <img class="iconsMenu" src="Estatico/imagens/novaReserva.png" />
                    </div>
                    <div class="itemsMenu">
                        <a href="/alterarSenha.aspx">
                            <p>Alterar Senha</p>
                        </a>
                        <img class="iconsMenu" src="Estatico/imagens/alterarSenha.png" />
                    </div>
                    <div class="itemsMenu">
                        <a href="/logout.aspx">
                            <p>Sair</p>
                        </a>
                        <img class="iconsMenu" src="Estatico/imagens/sair.png" />
                    </div>
                </div>
            </div>
        </div>
        <script src="Estatico/js/menuSanduiche.js"></script>
        <script>
            const btnSalvarImagem = document.querySelector("#btnSalvarImagem");
            btnSalvarImagem.setAttribute("disabled", "disabled");
            document.querySelector("#txtImagemEditarFoto").addEventListener("change", (e) => {
                if (e.target.files[0]) {
                    const img = document.querySelector("#imgEditar");
                    const file = event.target.files[0];
                    let url = window.URL.createObjectURL(file);
                    img.src = url;
                    btnSalvarImagem.removeAttribute("disabled");
                }
            });
        </script>
    </form>
</body>
</html>
