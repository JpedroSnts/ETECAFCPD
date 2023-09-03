<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="CPD.Site.home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <link rel="stylesheet" href="../Estatico/css/estilo.css"/>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin=""/>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet"/>
    <link rel="icon" href="../Estatico/imagens/logoCPD.png" type="image/png" />
    <title>Home</title>
</head>
<body>
    <form id="form1" runat="server">
			<header>
				<img id="logoCPD" src="../Estatico/imagens/logoCPD.png" href="index.html" />
				<img id="iconMenuSanduiche" src="../Estatico/imagens/menuSanduiche.png" />
			</header>
			<main>
				<div>
					<img id="cardSemReserva" src="../Estatico/imagens/semReserva.png" />
					<p><strong>Você não possui reservas!</strong></p>
				</div>
				<div>
					<a href="reserva.html"
						><button id="btnNovaReserva"><i class="fa-solid fa-plus"></i>Nova Reserva</button></a
					>
				</div>
			</main>

		<div class="bloqueio escondido" id="escondido"></div>
		<div id="divMenu" class="caixaFlutuante escondido">
			<div id="menuSanduiche">
				<div id="divUser">
					<asp:Literal ID="litImagem" runat="server"></asp:Literal>
					<%--<img id="userProf" src="../Estatico/imagens/userProf.png" />--%>
					<div>
						<p><asp:Literal ID="litNome" runat="server"></asp:Literal></p>
						<p><asp:Literal ID="litRm" runat="server"></asp:Literal></p>
					</div>
				</div>
				<div id="divItemsMenu">
					<div class="itemsMenu">
						<a href="index.html"><p>Suas Reservas</p></a>
						<img class="iconsMenu" src="Estatico/imagens/suasReservas.png" />
					</div>
					<div class="itemsMenu">
						<a href="reserva.html"><p>Nova Reserva</p></a>
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
			</div>
		</div>
		<script src="../Estatico/js/menuSanduiche.js"></script>
		<script src="https://kit.fontawesome.com/8e814353c3.js" crossorigin="anonymous"></script>
    </form>
</body>
</html>
