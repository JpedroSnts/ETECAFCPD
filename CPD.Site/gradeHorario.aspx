<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="gradeHorario.aspx.cs" Inherits="CPD.Site.gradeHorario" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloGradeHorarios.css" />
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet" />
    <link rel="icon" href="Estatico/imagens/QuadradoLogoCPD.png" type="image/png" />
    <title>CPD - Grade de horário</title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />
        <main>
            <h1>Grade de horários</h1>
            <div id="InfoGrade">
                <asp:DropDownList ID="ddlPeriodos" runat="server">
                    <asp:ListItem Text="Período" Value=""></asp:ListItem>
                    <asp:ListItem Text="Manhã" Value="manha"></asp:ListItem>
                    <asp:ListItem Text="Tarde" Value="tarde"></asp:ListItem>
                    <asp:ListItem Text="Noite" Value="noite"></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList ID="ddlAmbiente" runat="server">
                    <asp:ListItem Text="Ambiente" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList ID="ddlDiaSemana" runat="server">
                    <asp:ListItem Text="Dia da Semana" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Segunda" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Terça" Value="2"></asp:ListItem>
                    <asp:ListItem Text="Quarta" Value="3"></asp:ListItem>
                    <asp:ListItem Text="Quinta" Value="4"></asp:ListItem>
                    <asp:ListItem Text="Sexta" Value="5"></asp:ListItem>
                </asp:DropDownList>
                <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" OnClick="btnFiltrar_Click" />
            </div>
            <div id="tabelaHorarios">
                <table>
                    <thead>
                        <tr>
                            <th class="th-data">Dia da Semana</th>
                            <th class="th-horario">Horário</th>
                            <th class="th-ambiente">Ambiente</th>
                            <th class="th-acao">Ação</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Literal ID="litHorarios" runat="server"></asp:Literal>
                    </tbody>
                </table>
            </div>
            <asp:Button ID="btnAdcHorario" runat="server" Text="Adicionar horário" OnClick="btnAdcHorario_Click" />
        </main>
        <script src="Estatico/js/menuSanduiche.js"></script>
        <script src="Estatico/js/gradeHorario.js"></script>
    </form>
</body>
</html>
