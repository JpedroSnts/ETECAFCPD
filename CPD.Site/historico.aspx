<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="historico.aspx.cs" Inherits="CPD.Site.Histórico" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="css/estiloGeral.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
    <title>Home</title>
    <link rel="icon" href="imagens/QuadradoLogoCPD.png" type="image/png">
</head>
<body>
    <form id="form1" runat="server">
        <uc:Header ID="PartialHeader" runat="server" />
        <main id="mainComReserva">

            <p><strong>Suas reservas</strong></p>
        
            <!-- ----------------------- CARDS RESERVA ----------------------- -->

            <div id="displayCardsReserva"> 

                <div class="cardReserva">
                    <h1>SEGUNDA-FEIRA (02/10)</h1>

                    <div class="divReservas">
                        <div class="divTipoReserva">
                            <h1 id="h1Equipamentos">Equipamentos</h1>
                            <div>
                                <p>Tripé RingLight (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                            <div>
                                <p>Cabo HDMI (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                            <div>
                                <p>Cabo HDMI (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                            <div>
                                <p>Cabo HDMI (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                            <div>
                                <p>Cabo HDMI (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                        </div>
                        <div class="divTipoReserva">
                            <h1>Ambientes</h1>
                            <div>
                                <p>INFO 1 (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                        </div>
                    </div>

                    <div class="displayBtn">
                        <button id="btnCardReserva">Cancelar todas</button>
                    </div>
                </div>

                <div class="cardReserva">
                    <h1>TERÇA-FEIRA (03/10)</h1>

                    <div class="divReservas">
                        <div class="divTipoReserva">
                            <h1 id="h1Equipamentos">Equipamentos</h1>
                            <div>
                                <p>Extensão (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                        </div>
                        <div class="divTipoReserva">
                            <h1>Ambientes</h1>
                            <div>
                                <p>Sala Maker (00:00 - 00:00)</p>
                                <img id="iconLixeira" src="imagens/lixeira.png">
                            </div>
                        </div>
                    </div>

                    <div class="displayBtn">
                        <button id="btnCardReserva">Cancelar todas</button>
                    </div>
                </div>

            </div>
            <!-- ----------------------- CARD NOVA RESERVA ----------------------- -->

            <a href="reserva.html"><button id="btnNovaReservaComReserva"><i class="fa-solid fa-plus"></i>Nova Reserva</button></a>

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

        <!-- ----------------------- CARD LIXEIRA ----------------------- -->

        <div id="divCardCancelar" class="cardFlutuante escondido">
            <form id="cardCancelar">
                <p>Você está cancelando a reserva do <strong>Tripé RingLight</strong> nos seguintes horários:</p>
                <p class="pHorarios">00:00 - 00:00</p>
                <p>Deseja cancelar sua reserva?</p>
                <div>
                    <button id="btnNao">Não</button>
                    <button id="btnSim">Sim</button>
                </div>
            </form>
        </div>

        <!-- ----------------------- CARD CANCELAR TODAS ----------------------- -->

        <div id="divCardCancelarTodas" class="cardFlutuanteTodas escondido">
            <form id="cardCancelar">
                <p>Deseja cancelar todas as reservas de <strong>Ambientes</strong> da Dia da Semana (00/00)?</p>
                <div>
                    <button id="btnNao">Não</button>
                    <button id="btnSim">Sim</button>
                </div>
            </form>
        </div>

        <!-- ----------------------- CARD RESERVA CANCELADA ----------------------- -->

        <div id="divCardAvisoCancelar" class="cardAviso escondido">
            <form id="cardAviso">
                <p>Reserva(s) Cancelada(s) <img src="imagens/check.png"></p>
            </form>
        </div>
    </form>
</body>
</html>
