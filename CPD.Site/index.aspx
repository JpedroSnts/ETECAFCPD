<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="CPD.Site.index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<link rel="stylesheet" href="Estatico/css/estiloGeral.css" />
	<link rel="preconnect" href="https://fonts.googleapis.com" />
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
	<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
	<title>Home</title>
	<link rel="icon" href="Estatico/imagens/logoCPD.png" type="image/png" />
</head>
<body>
    <form id="form1" runat="server">
			<header>
			<a href="/index.aspx"><img id="logoCPD" src="Estatico/imagens/logoCPD.png" /></a>
			<div id="opMenu">
				<div id="displayOpMenu">
					<a href="/index.aspx">Suas Reservas</a>
					<a href="/reserva.aspx">Nova Reserva</a>
					<a href="/alterarSenha.aspx">Alterar Senha</a>
				</div>
			</div>
			<img id="iconMenuSanduiche" src="Estatico/Estatico/imagens/menuSanduiche.png" />
			<div id="divUserLogoutDesktop">
				<div id="divUserDesktop">
					<div id="displayDivUserDesktop">
						<%--<img id="userProfDesktop" src="Estatico/imagens/userProf.png" />--%>
						<asp:Literal ID="litImagemDesktop" runat="server"></asp:Literal>
						<div id="displayInfoUserDesktop">
							<p><asp:Literal ID="litNomeDesktop" runat="server"></asp:Literal></p>
							<p id="rm_usuario"><asp:Literal ID="litRmDesktop" runat="server"></asp:Literal></p>
						</div>
					</div>
				</div>
				<a href="/logout.aspx"><img id="iconLogout" src="Estatico/imagens/deslogar.svg" /></a>
			</div>
		</header>
		<main id="mainHome" style="display: none">
			<div>
				<img id="cardSemReserva" src="Estatico/imagens/semReserva.png" />
				<p><strong>Você não possui reservas!</strong></p>
			</div>
			<div>
				<a href="/reserva.aspx"><button id="btnNovaReserva"><i class="fa-solid fa-plus"></i>Nova Reserva</button></a>
			</div>
		</main>
		<main id="mainComReserva" style="display: none">
			<p><strong>Suas reservas</strong></p>

			<!-- ----------------------- CARDS RESERVA ----------------------- -->
			<div id="reservas"></div>

			<!-- ----------------------- CARD NOVA RESERVA ----------------------- -->

			<a href="/reserva.aspx"
				><button id="btnNovaReservaComReserva"><i class="fa-solid fa-plus"></i>Nova Reserva</button></a
			>
		</main>

		<!-- ----------------------- MENU ----------------------- -->

		<div class="bloqueio escondido" id="escondido"></div>
		<div id="divMenu" class="caixaFlutuante escondido">
			<form id="menuSanduiche">
				<div id="divUser">
					<%--<img id="userProf" src="Estatico/imagens/userProf.png" />--%>
					<asp:Literal ID="litImagem" runat="server"></asp:Literal>
					<div>
						<p><asp:Literal ID="litNome" runat="server"></asp:Literal></p>
						<p><asp:Literal ID="litRm" runat="server"></asp:Literal></p>
					</div>
				</div>
				<div id="divItemsMenu">
					<div class="itemsMenu">
						<a href="/index.aspx"><p>Suas Reservas</p></a>
						<img class="iconsMenu" src="Estatico/imagens/suasReservas.png" />
					</div>
					<div class="itemsMenu">
						<a href="/reserva.aspx"><p>Nova Reserva</p></a>
						<img class="iconsMenu" src="Estatico/imagens/novaReserva.png" />
					</div>
					<div class="itemsMenu">
						<a href="/alterarSenha.aspx"><p>Alterar Senha</p></a>
						<img class="iconsMenu" src="Estatico/imagens/alterarSenha.png" />
					</div>
					<div class="itemsMenu">
						<a href="/logout.aspx"><p>Sair</p></a>
						<img class="iconsMenu" src="Estatico/imagens/sair.png" />
					</div>
				</div>
			</form>
		</div>

		<!-- ----------------------- CARD ----------------------- -->

		<div id="divCardCancelar" class="cardFlutuante escondido">
			<div id="cardCancelar">
			</div>
		</div>
		<script src="Estatico/js/menuSanduiche.js"></script>
		<script src="Estatico/js/cardReserva.js"></script>
		<script src="Estatico/js/cardCancelarReserva.js"></script>
		<script src="Estatico/js/indexProfessor.js"></script>
		<script src="https://kit.fontawesome.com/8e814353c3.js" crossorigin="anonymous"></script>
	
    </form>
</body>
</html>
