<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="relatorio.aspx.cs" Inherits="CPD.Site.relatorio" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="UTF-8" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloRelatorioFunc.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet" />
    <link rel="icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon">
    <link rel="shortcut icon" href="imagens/QuadradoLogoCPD.png" type="image/x-icon" />
    <title>CPD - Relatorio</title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />

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
                <asp:TextBox runat="server" ID="dataFinal" TextMode="Date"></asp:TextBox>

                <asp:Button ID="btnGerarRelatorio" runat="server" Text="Gerar Relatório" OnClick="btnGerarRelatorio_Click"/>
            </div>
        </main>

        <script src="Estatico/js/menuSanduiche.js"></script>
        <script src="Estatico/js/relatorio.js"></script>
    </form>
</body>
</html>
