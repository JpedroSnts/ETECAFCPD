<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="relatorio.aspx.cs" Inherits="CPD.Site.relatorio" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="UTF-8" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloRelatorioFunc.css" />
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet" />
    <link rel="icon" href="Estatico/imagens/QuadradoLogoCPD.png" type="image/png" />
    <title>Relatório</title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />

        <main>
            <div class="caixa-flutuante-erros"><asp:Literal ID="litErro" runat="server"></asp:Literal></div>
            <h1>Gerar Relatório</h1>

            <div id="displayRelatorio">

                <div id="gerarRelatorio">
                    <asp:DropDownList runat="server" ID="ddlRelatorio">
                        <asp:ListItem Text="Tipo Relatório"></asp:ListItem>
                        <asp:ListItem Text="Ocorrências" Value="ocorrencias"></asp:ListItem>
                        <asp:ListItem Text="Reservas canceladas" Value="reservasC"></asp:ListItem>
                        <asp:ListItem Text="Reservas atrasadas" Value="reservasA"></asp:ListItem>
                        <asp:ListItem Text="Reservas não realizadas" Value="reservasNR"></asp:ListItem>
                    </asp:DropDownList>

                    <div id="inputsRelatorio">
                        <asp:TextBox runat="server" ID="txtDataInicio" TextMode="SingleLine" placeholder="Data Inicial" onfocus="this.type='date'" onblur="if (!this.value) this.type='text'" class="input-text-date"></asp:TextBox>
                        <asp:TextBox runat="server" ID="txtDataFinal" TextMode="SingleLine" placeholder="Data Final" onfocus="this.type='date'" onblur="if (!this.value) this.type='text'" class="input-text-date"></asp:TextBox>
                    </div>

                    <div id="alignBtn">
                        <p></p>
                        <asp:Button ID="btnGerarRelatorio" runat="server" Text="Gerar Relatório" OnClick="btnGerarRelatorio_Click"/>
                    </div>
                </div>

            </div>
        </main>

        <script src="Estatico/js/menuSanduiche.js"></script>
    </form>
    <script>
        const dataInicio = document.querySelector("#dataInicio");
        const dataFinal = document.querySelector("#dataFinal");
        if (txtDataInicio.value) {
            txtDataInicio.type = "date";
        }
        if (txtDataFinal.value) {
            txtDataFinal.type = "date";
        }
    </script>
</body>
</html>
