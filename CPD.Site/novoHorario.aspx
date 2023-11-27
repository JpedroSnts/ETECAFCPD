<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="novoHorario.aspx.cs" Inherits="CPD.Site.novoHorario" %>
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
    <title>Novo horário</title>
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />
        <main>
            <div class="caixa-flutuante-erros"><asp:Literal ID="litErro" runat="server"></asp:Literal></div>
            <h1>Adicionar Novo Horário</h1>
            <div id="divNovoHorario">
                <div class="divLabels">
                    <div class="itemDisplay">
                        <label for="txtAmbiente">Ambiente</label><br />
                        <div class="display">
                            <asp:DropDownList ID="ddlAmbiente" runat="server">
                                <asp:ListItem Text="Ambiente" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <br />
                            <br />
                        </div>
                    </div>
                    <div class="itemDisplay">
                        <label for="txtDiaSemana">Dia da Semana</label><br />
                        <div class="display">
                            <asp:DropDownList ID="ddlDiaSemana" runat="server">
                                <asp:ListItem Text="Dia da Semana" Value="0"></asp:ListItem>
                                <asp:ListItem Text="Segunda" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Terça" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Quarta" Value="3"></asp:ListItem>
                                <asp:ListItem Text="Quinta" Value="4"></asp:ListItem>
                                <asp:ListItem Text="Sexta" Value="5"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="divLabels">
                    <div class="itemDisplay">
                        <label for="txtNome">Horários</label><br />
                        <div class="display">
                            <asp:TextBox ID="txtHorarioInicio" runat="server" TextMode="SingleLine" placeholder="Início" onfocus="this.type='time'" onblur="if (!this.value) this.type='text'" class="inputsHorario input-text-time"></asp:TextBox>
                        </div>
                    </div>
                    <div class="itemDisplay">
                        <br />
                        <div class="display">
                            <asp:TextBox ID="txtHorarioFim" runat="server" TextMode="SingleLine" placeholder="Fim" onfocus="this.type='time'" onblur="if (!this.value) this.type='text'" class="inputsHorario input-text-time"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div id="divBtn">
                    <asp:Button ID="btnAdicionar" runat="server" Text="Adicionar" OnClick="btnAdicionar_Click"/>
                </div>

            </div>

        </main>
        <script src="/Estatico/js/menuSanduiche.js"></script>
    </form>
</body>
</html>
