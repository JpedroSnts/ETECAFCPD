<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="CPD.Site.index" %>
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
	<title>Home</title>
	<link rel="icon" href="Estatico/imagens/QuadradoLogoCPD.png" type="image/png" />
</head>
<body>
    <form id="form1" runat="server">
		<uc:Header ID="PartialHeader" runat="server" />

		<main id="mainReload">
			<div id="tdReload">
				<img class="reloadAnimacao" id="iconeReload" src="/Estatico/imagens/refresh.svg">
				Carregando...
			</div>
		</main>
        
            <!-- ----------------------- CARDS RESERVA ----------------------- -->

		<main id="mainHome" style="display: none">
			<div>
				<img id="cardSemReserva" src="Estatico/imagens/semReserva.png" />
				<p><strong>Você não possui reservas!</strong></p>
			</div>
			<div>
				<a href="/reserva.aspx" id="btnNovaReserva"><i class="fa-solid fa-plus"></i>Nova Reserva</a>
			</div>
		</main>
		<main id="mainComReserva" style="display: none">
			<h1>Suas reservas</h1>
			<!------------------------ CARDS RESERVA ----------------------- -->

			<div id="displayCardsReserva"> 
				<div id="reservas"></div>
			</div>

			<!-- ----------------------- CARD NOVA RESERVA ----------------------- -->

			<a href="/reserva.aspx" id="btnNovaReservaComReserva"><i class="fa-solid fa-plus"></i>Nova Reserva</a>
		</main>

		<!-- ----------------------- CARD ----------------------- -->

		<div id="divCardCancelar" class="cardFlutuante escondido">
			<div id="cardCancelar">
			</div>
		</div>
		<script src="Estatico/js/menuSanduiche.js"></script>
		<script src="Estatico/js/indexProfessor.js"></script>
		<script src="https://kit.fontawesome.com/8e814353c3.js" crossorigin="anonymous"></script>
    </form>
</body>
</html>
