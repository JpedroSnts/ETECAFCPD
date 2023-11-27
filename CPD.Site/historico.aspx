<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="historico.aspx.cs" Inherits="CPD.Site.Histórico" %>

<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloGeral.css" />
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <title>Histórico</title>
    <link rel="icon" href="Estatico/imagens/QuadradoLogoCPD.png" type="image/png" />
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />

        <main id="mainComReserva" style="display: none">
            <h1>Histórico</h1>
            <!------------------------ CARDS RESERVA ----------------------- -->

            <div id="inputsRelatorio">
                <input name="txtDataInicio" type="text" id="txtDataInicio" placeholder="Data Inicial" onfocus="this.type='date'" onblur="if (!this.value) this.type='text'" class="input-text-date" />
                <input name="txtDataFinal" type="text" id="txtDataFinal" placeholder="Data Final" onfocus="this.type='date'" onblur="if (!this.value) this.type='text'" class="input-text-date" />
                <input type="submit" name="btnBuscarHistorico" value="Buscar" id="btnBuscarHistorico" />
                <input type="image" name="btnBuscarHistoricoResponsivo" id="btnBuscarHistoricoResponsivo" src="Estatico/imagens/lupa.svg" />
            </div>

            <div id="displayCardsReserva">
                <div id="reservas"></div>
            </div>

            <!-- ----------------------- CARD NOVA RESERVA ----------------------- -->

        </main>

        <main id="mainReload">
            <div id="tdReload">
                <img class="reloadAnimacao" id="iconeReload" src="/Estatico/imagens/refresh.svg" />
                Carregando...
            </div>
        </main>

        <script src="/Estatico/js/historico.js"></script>
        <script src="Estatico/js/menuSanduiche.js"></script>
        <script src="https://kit.fontawesome.com/8e814353c3.js" crossorigin="anonymous"></script>
    </form>
</body>
</html>
