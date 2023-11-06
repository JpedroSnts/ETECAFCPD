<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="historico.aspx.cs" Inherits="CPD.Site.Histórico" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
    <link rel="stylesheet" href="Estatico/css/estiloGeral.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHistorico.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <title>Home</title>
    <link rel="icon" href="imagens/QuadradoLogoCPD.png" type="image/png" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />
        <main id="mainComReserva">

            <h1>Seu Histórcio</h1>
        
            <div id="tabelaHistorico" style="width: 100%">
                    <table>
                        <thead>
                            <tr>
                                <th class="th-data">Data</th>
                                <th class="th-data">Horário Início</th>
                                <th class="th-data">Horário Fim</th>
                                <th class="th-horario">Item</th>
                                <th class="th-data">Status de entrega</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Literal ID="litHorarios" runat="server"></asp:Literal>
                            <%--<tr>
                                <td>Segunda</td>
                                <td>10:09 - 15:09</td>
                                <td>Lab02</td>
                            </tr>--%>
                        </tbody>
                    </table>
                </div>

           

        </main>

        <!-- ----------------------- MENU ----------------------- -->

        <div class="bloqueio escondido" id="escondido"></div>
        <div id="divMenu" class="caixaFlutuante escondido">
            <form id="menuSanduiche">
                <div id="divUser">
                    <img id="userProf" src="imagens/userProf.png">
                    <div>
                        <p>Carla Bassan</p>
                        <p>00001</p>
                    </div>
                </div>
                <div id="divItemsMenu">
                    <div class="itemsMenu">
                        <a href="index.html"><p>Suas Reservas</p></a>
                        <img class="iconsMenu" src="imagens/suasReservas.png">
                    </div>
                    <div class="itemsMenu">
                        <a href="reserva.html"><p>Nova Reserva</p></a>
                        <img class="iconsMenu" src="imagens/novaReserva.png">
                    </div>
                    <div class="itemsMenu">
                        <a href="alterarSenha.html"><p>Alterar Senha</p></a>
                        <img class="iconsMenu" src="imagens/alterarSenha.png">
                    </div>
                    <div class="itemsMenu">
                        <a href="login.html"><p>Sair</p></a>
                        <img class="iconsMenu" src="imagens/sair.png">
                    </div>
                </div>
            </form>
        </div>

        <script src="Estatico/js/menuSanduiche.js"></script>
    </form>
</body>
</html>
