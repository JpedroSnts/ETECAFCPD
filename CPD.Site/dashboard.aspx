<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="CPD.Site.dashboard" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="Estatico/css/dashboard.css" />
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
	<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
	<title>Dashboard</title>
	<link rel="icon" href="Estatico/imagens/QuadradoLogoCPD.png" type="image/png" /></head>
<body>
    <form id="form1" runat="server">
		<uc:Header ID="PartialHeader" runat="server" />
        <main>
            <div id="dashboard">
                <div id="tabelaReserva">
                    <div>
                        <div id="tituloTabela">
                            <h1>Reservas de Hoje</h1>
                            <img src="/Estatico/imagens/refresh.svg" alt="icone de reload" id="iconeReload"/>
                        </div>
                        <div id="inputsBusca">
                            <input type="text" id="txtFiltro" placeholder="Professor/Equipamento/Ambiente" />
                            <select id="ddlStatus" placeholder="Status">
                                <option value="">Status</option>
                            </select>
                        </div>
                    </div>
                    <table>
                        <thead>
                            <tr>
                                <th class="th-data">Data</th>
                                <th class="th-horario">Horário</th>
                                <th class="th-itens">Itens</th>
                                <th class="th-professor">Professor</th>
                                <th class="th-status">Status</th>
                                <th class="th-acao">Ação</th>
                                <th class="th-acao">Ocorrência</th>
                            </tr>
                        </thead>
                        <tbody id="tbodyReservas"></tbody>
                    </table>
                </div>

                <div id="tabelaDisponivel">
                    <h1>Disponíveis</h1>
                    <table id="itens-livres">
                        <thead>
                            <tr>
                                <th colspan="2">Itens</th>
                            </tr>
                        </thead>
                        <tbody id="tbodyItensLivres"></tbody>
                    </table>
                </div>
            </div>
            <div id="displayOcorrencia" class="escondido">
			    <div id="gerarOcorrencia" class="escondido">
				    <div class="gerarOcorrencia-head">
					    <h2>Gerar Ocorrência</h2>
					    <img id="btnFecharJanelaOcorrencia" src="/Estatico/imagens/close.svg" alt="ícone para fechar a janela" />
				    </div>
				    <div class="gerarOcorrencia-body">
					    <h4>ÍTENS</h4>
					    <div class="ckbs-group"></div>
					    <div id="itensOcorrencia"></div>

					    <div id="alignBtn">
						    <button id="btnGerarOcorrencia" disabled>Gerar Ocorrência</button>
					    </div>
				    </div>
			    </div>
		    </div>
        </main>
        <script src="Estatico/js/menuSanduiche.js"></script>
		<script src="Estatico/js/dashboard.js"></script>
    </form>
</body>
</html>
