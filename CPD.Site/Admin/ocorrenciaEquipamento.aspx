﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ocorrenciaEquipamento.aspx.cs" Inherits="CPD.Site.Admin.ocorrenciaEquipamento" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="/Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="/Estatico/css/estiloHeader.css" />
	<link rel="stylesheet" href="/Estatico/css/estiloGerenciamentoTabelas.css" />
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
	<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
	<title>Cadastrar Ocorrência Equipamento</title>
	<link rel="icon" href="/Estatico/imagens/logoCPD.png" type="image/png" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />
        <main>
            <div class="caixa-flutuante-erros"><asp:Literal ID="litErro" runat="server"></asp:Literal></div>
            <h1>Cadastrar Ocorrência Equipamento</h1>
            <div class="divLabels">
                <label for="txtCodigo">Código</label><br />
                <div class="display">
                    <img class="iconInput iconCodigio" src="../Estatico/imagens/codigo.svg" />
                    <asp:TextBox ID="txtCodigo" placeholder="Insira o Código" runat="server" TextMode="SingleLine"></asp:TextBox>
                    <br />
                    <br />
                </div>
            </div>
            <div class="divLabels">
                <label for="txtNome">Nome</label><br />
                <div class="display">
                    <img class="iconInput iconNome" src="../Estatico/imagens/nomeItem.svg" />
                    <asp:TextBox ID="txtNome" placeholder="Insira o nome" runat="server" TextMode="SingleLine"></asp:TextBox>
                    <br />
                    <br />
                </div>
            </div>
            <asp:Button ID="btnCadastrar" runat="server" Text="Cadastrar" OnClick="btnCadastrar_Click"/>
        </main>
        <script src="/Estatico/js/menuSanduiche.js"></script>
    </form>
</body>
</html>
