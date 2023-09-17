<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="relatorio.aspx.cs" Inherits="CPD.Site.relatorio" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="UTF-8" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="Estatico/css/estiloRelatorioFunc.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon">
    <link rel="shortcut icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon">
    <title>CPD - Reserva</title>
</head>
<body>
    <form id="form1" runat="server">
    <header>
            <a id="aLogo" href="dashboard.aspx"><img id="logoCPD" src="Estatico/imagens/logoCPD.png"></a>
            <div id="opcaoHeader">
                <a href="reservas.html">Reservas</a>
                <a href="relatorios.html">Relatórios</a>
                <a href="horarios.html">Grade de horários</a>
            </div>
            <div id="usuario">
                <img id="iconeUsuario" src="imagens/usuario.svg">
                <div id="menuUsuario">
                    <img id="perfilUsuario" src="imagens/usuario.svg">
                    <div id="informacaoUsuario">
                        <p>CPD</p>
                        <p>0001</p>
                    </div>
                    <div id="alterarSenha">
                        <p>Alterar Senha</p>
                        <a href="alterarSenha.html"><img src="imagens/alterarSenha.svg"></a>
                    </div>
                    <div id="sair">
                        <p>Sair</p>
                        <a href="index.html"><img src="imagens/sair.svg"></a>
                    </div>
                </div>
            </div>
        </header>

        <main>
            <h1>Gerar Relatório</h1>
            <div id="gerarRelatorio">
                <asp:DropDownList runat="server" ID="ddlRelatorio">
                    <asp:ListItem Text="Tipo Relatório"></asp:ListItem>
                    <asp:ListItem Text="Ocorrências" Value="ocorrencias"></asp:ListItem>
                    <asp:ListItem Text="Reservas canceladas" Value="reservasC"></asp:ListItem>
                    <asp:ListItem Text="Reservas atrasadas" Value="reservasA"></asp:ListItem>
                    <asp:ListItem Text="Reservas não realizadas" Value="reservasNA"></asp:ListItem>
                </asp:DropDownList>

                <asp:TextBox runat="server" ID="dataInicio" TextMode="Date"></asp:TextBox>
                <asp:TextBox runat="server" ID="dataFim" TextMode="Date"></asp:TextBox>

                <button>Buscar</button>
            </div>
        </main>


        <script src="Estatico/js/relatorio.js"></script>
    </form>
</body>
</html>
