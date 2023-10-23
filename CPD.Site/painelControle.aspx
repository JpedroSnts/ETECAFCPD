<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="painelControle.aspx.cs" Inherits="CPD.Site.painelControle" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link rel="stylesheet" href="Estatico/css/painelControle.css" />
        <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
        <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
		<link rel="preconnect" href="https://fonts.googleapis.com" />
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
		<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
		<title>Dashboard</title>
		<link rel="icon" href="Estatico/imagens/logoCPD.png" type="image/png" /></head>
<body>
    <form id="form1" runat="server">
		<uc:Header ID="PartialHeader" runat="server" />
        <main>
            <div id="tabelaReserva">
                <div>
                    <h1>Painel de Controle</h1>
                    <div id="inputsBusca">
                        <input type="text" id="txtFiltro" placeholder="Professor/Equipamento/Ambiente" />
                        <input type="date" id="txtData"/>
                        <select id="ddlStatus" placeholder="Status">
                            <option value="">Status</option>
                        </select>
                    </div>
                </div>
                <table id="tblReservas" class="escondido">
                    <thead>
                        <tr>
                            <th class="th-data">Data</th>
                            <th class="th-horario">Horário</th>
                            <th class="th-itens">Itens</th>
                            <th class="th-professor">Professor</th>
                            <th class="th-status">Status</th>
                            <th class="th-acao">Ação</th>
                        </tr>
                    </thead>
                    <tbody id="tbodyReservas"></tbody>
                </table>
            </div>
        </main>
        <script src="Estatico/js/menuSanduiche.js"></script>
		<script src="Estatico/js/painelControle.js"></script>
    </form>
</body>
</html>
