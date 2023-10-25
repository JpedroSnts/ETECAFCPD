﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="reserva.aspx.cs" Inherits="CPD.Site.reserva" EnableEventValidation="false" %>
<%@ Register Src="~/Partial/Header.ascx" TagPrefix="uc" TagName="Header" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml" lang="pt-br">
<head runat="server">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="Estatico/css/estiloTodos.css" />
    <link rel="stylesheet" href="Estatico/css/estiloHeader.css" />
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
        <uc:Header ID="PartialHeader" runat="server" />
        <main>
            <div class="caixa-flutuante-erros"><asp:Literal ID="litErro" runat="server"></asp:Literal></div>
            <h1>Realizar Reserva</h1>
            <div id="inputs">
                <asp:TextBox ID="txtInputData" runat="server" TextMode="SingleLine" placeholder="Data" onfocus="this.type='date'" onblur="if (!this.value) this.type='text'" class="input-text-date"></asp:TextBox>
                <asp:TextBox ID="txtHorarioInicio" runat="server" TextMode="SingleLine" placeholder="Início" onfocus="this.type='time'" onblur="if (!this.value) this.type='text'" class="inputsHorario input-text-time"></asp:TextBox>
                <asp:TextBox ID="txtHorarioFim" runat="server" TextMode="SingleLine" placeholder="Fim" onfocus="this.type='time'" onblur="if (!this.value) this.type='text'" class="inputsHorario input-text-time"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" OnClick="btnBuscar_Click" />
                <asp:ImageButton ID="btnBuscarResponsivo" runat="server" OnClick="btnBuscar_Click" ImageUrl="~/Estatico/imagens/lupa.png"/>
             </div>

            <p class="pMensagemReserva">Selecione a <strong>data</strong>, o <strong>horário de início</strong> e o <strong>horário de fim</strong> para fazer uma reserva!</p>

            <asp:Panel ID="pnlBodyReservar" runat="server">   
                <div id="tipoReserva">
                    <div id="pnlEquipamentos">
                        <h1>Equipamentos</h1>
                        <asp:Panel ID="pnlEquipamentosItens" runat="server"></asp:Panel>
                    </div>
                    <div id="pnlAmbientes">
                        <h1>Ambientes</h1>
                        <asp:Panel ID="pnlAmbientesItens" runat="server"></asp:Panel>
                    </div>
                </div>
                <div style="display: none;">
                    <asp:TextBox ID="txtNmProf" runat="server"></asp:TextBox>
                </div>
                <div class="reservar">
                    <div>
                    <asp:Literal ID="litDdlNmProf" runat="server">
                        <select id="ddlNmProf">
                        </select>
                    </asp:Literal>
                    </div>
                    <asp:Button ID="btnReservar" runat="server" Text="Reservar" OnClick="btnReservar_Click"/>
                </div>
            </asp:Panel> 
        </main>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/i18n/pt-BR.min.js" integrity="sha512-H1yBoUnrE7X+NeWpeZvBuy2RvrbvLEAEjX/Mu8L2ggUBja62g1z49fAboGidE5YEQyIVMCWJC9krY4/KEqkgag==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="Estatico/js/reserva.js"></script>
        <script src="Estatico/js/menuSanduiche.js"></script>
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
            $("#ddlNmProf").on('select2:select', function (e) {
                $("#txtNmProf").attr("value", e.target.value);
            });
        </script>
    </form>
</body>
</html>
