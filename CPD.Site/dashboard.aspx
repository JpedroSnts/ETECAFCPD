<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="dashboard.aspx.cs" Inherits="CPD.Site.dashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
		<meta charset="UTF-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<link rel="stylesheet" href="Estatico/css/dashboard.css" />
		<link rel="preconnect" href="https://fonts.googleapis.com" />
		<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
		<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
		<title>Dashboard</title>
		<link rel="icon" href="Estatico/imagens/logo.png" type="image/png" /></head>
<body>
    <form id="form1" runat="server">
		<header>
			<img id="imagem" src="Estatico/imagens/logoCPD.png" />
			<nav>
				<ul>
					<li class="dropdown">
						<a class="dropbtn">Reserva</a>
						<div class="dropdown-content">
							<a href="#">Inserir</a>
						</div>
					</li>
					<li class="dropdown">
						<a href="#" class="dropbtn">Relatórios</a>
					</li>
					<li class="dropdown">
						<a class="dropbtn">Grade de horários</a>
						<div class="dropdown-content">
							<a href="#">Listar</a>
							<a href="#">Cadastrar</a>
						</div>
					</li>
				</ul>
			</nav>
			<div><img id="user" src="Estatico/imagens/user.png" /></div>
		</header>
		<main>
			<div id="inputsBusca">
				<select id="ddlStatus" placeholder="Status">
					<option value="">Status</option>
				</select>
				<input type="date" id="txtData" />
				<input type="text" id="txtFiltro" placeholder="Professor/Equipamento/Ambiente" />
			</div>
			<div class="tabelas">
				<table id="reservas">
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

				<table id="itens-livres">
					<thead>
						<tr>
							<th colspan="2">Itens Livres</th>
						</tr>
					</thead>
					<tbody id="tbodyItensLivres"></tbody>
				</table>
			</div>
		</main>
		<script src="Estatico/js/dashboard.js"></script>
    </form>
</body>
</html>
