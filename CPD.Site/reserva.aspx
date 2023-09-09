﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reserva.aspx.cs" Inherits="CPD.Site.reserva" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="pt-br">
<head runat="server">
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloReserva.css" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link rel="icon" href="Estatico/imagens/logoCPD.png" type="image/png" />
    <title>CPD - Reserva</title>
</head>
<body>
    <form id="form1" runat="server">
        <header>
            <div id="headerConteu">
                <img id="imagem" src="Estatico/imagens/logoCPD.png" />
                <div id="opMenu">
                    <a>Suas Reservas</a>
                    <a>Ambientes</a>
                    <a>Equipamentos</a>
                </div>
                <img id="iconeMenu" src="Estatico/imagens/menu.svg" />
            </div>
        </header>
        <main>
            <p class="Titulo">Realizar Reserva</p>
            <div id="Calendario">
                <asp:TextBox ID="txtInputData" runat="server" TextMode="Date"></asp:TextBox>
                <asp:TextBox ID="txtHorarioInicio" runat="server" TextMode="Time" class="InputHorario"></asp:TextBox>
                <asp:TextBox ID="txtHorarioFim" runat="server" TextMode="Time" class="InputHorario"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" OnClick="btnBuscar_Click" />
            </div>

            <div id="TitulosReserva">
                <p id="Equipamento">Equipamentos</p>
                <p id="Ambiente">Ambientes</p>
            </div>

            <div id="reserva">
                <asp:Panel ID="pnlEquipamentos" runat="server"></asp:Panel>
                <asp:Panel ID="pnlAmbientes" runat="server"></asp:Panel>
            </div>
            <div class="reservar">
                <asp:DropDownList ID="ddlNmProf" runat="server"></asp:DropDownList>
                <asp:Button ID="btnReservar" runat="server" Text="Reservar" />
            </div>
        </main>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/i18n/pt-BR.min.js" integrity="sha512-H1yBoUnrE7X+NeWpeZvBuy2RvrbvLEAEjX/Mu8L2ggUBja62g1z49fAboGidE5YEQyIVMCWJC9krY4/KEqkgag==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="Estatico/js/reserva.js"></script>
        <script language="javascript" type="text/javascript">
            function SelectSingleRadiobutton(rdbtnid) {
                var rdBtn = document.getElementById(rdbtnid);
                var rdBtnList = document.getElementsByTagName("input");
                for (i = 0; i < rdBtnList.length; i++) {
                    if (rdBtnList[i].type == "radio" && rdBtnList[i].id != rdBtn.id) {
                        rdBtnList[i].checked = false;
                    }
                }
            }
            $("#ddlNmProf").select2({
                ajax: {
                    url: "/api/buscarProfessor.aspx",
                    dataType: "json"
                },
                placeholder: "Nome ou RM do professor",
                width: "250px",
                language: "pt-BR",
                minimumInputLength: 2
            });
        </script>
    </form>
</body>
</html>
