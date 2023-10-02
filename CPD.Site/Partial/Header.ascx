<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Header.ascx.cs" Inherits="CPD.Site.Partial.Header" %>
<asp:Panel runat="server" ID="pnlHeaderFunc">
	<div style="display: none" id="rm_usuario"><asp:Literal ID="litRmfunc" runat="server"></asp:Literal></div>
    <header>
        <div id="headerConteu">
            <img id="imagem" src="Estatico/imagens/logoCPD.png" />
            <div id="opMenuFunc">
                <a href="/dashboard.aspx">Dashboard</a>
				<a href="/reserva.aspx">Reservar</a>
                <a href="/relatorio.aspx">Relatórios</a>
                <a href="/gradeHorario.aspx">Grade de horário</a>
            </div>
            <img id="iconMenuSanduicheFunc" src="Estatico/imagens/usuario.svg" />
        </div>
    </header>
    <div class="bloqueio escondido" id="escondido"></div>
    <div id="divMenu" class="caixaFlutuanteFunc escondido">
        <div id="menuSanduicheFunc">
            <div id="divUser">
				<%--<img id="userProfDesktop" src="Estatico/imagens/userProf.png" />--%>
				<asp:Literal ID="litImagemDesktopFunc" runat="server"></asp:Literal>
            </div>
            <div id="divItemsMenu">
                <div class="itemsMenu">
                    <a href="/alterarSenha.aspx">
                        <p>Alterar Senha</p>
                    </a>
                    <img class="iconsMenu" src="Estatico/imagens/alterarSenha.png" />
                </div>
                <div class="itemsMenu">
                    <a href="/logout.aspx">
                        <p>Sair</p>
                    </a>
                    <img class="iconsMenu" src="Estatico/imagens/sair.png" />
                </div>
            </div>
        </div>
    </div>
</asp:Panel>

<asp:Panel runat="server" ID="pnlHeaderProf">
    <header id="headerProf">
		<a href="index.html"><img id="logoCPD" src="Estatico/imagens/logoCPD.png" /></a>
		<div id="opMenu">
			<div id="displayOpMenu">
				<a href="/index.aspx">Suas Reservas</a>
				<a href="/reserva.aspx">Nova Reserva</a>
				<a href="/alterarSenha.aspx">Alterar Senha</a>
			</div>
		</div>
		<img id="iconMenuSanduiche" src="Estatico/imagens/menu.svg" />
		<div id="divUserLogoutDesktop">
			<div id="divUserDesktop">
				<div id="displayDivUserDesktop">
					<%--<img id="userProfDesktop" src="Estatico/imagens/userProf.png" />--%>
					<p><asp:Literal ID="litImagemDesktop" runat="server"></asp:Literal></p>
					<div id="displayInfoUserDesktop">
						<p><asp:Literal ID="litNomeDesktop" runat="server"></asp:Literal></p>
						<p><asp:Literal ID="litRmDesktop" runat="server"></asp:Literal></p>
					</div>
				</div>
			</div>
			<a href="/logout.aspx"><img id="iconLogout" src="Estatico/imagens/deslogar.svg" /></a>
		</div>
	</header>
	<div class="bloqueio escondido" id="escondido"></div>
	<div id="divMenu" class="caixaFlutuante escondido">
		<div id="menuSanduiche">
			<div id="divUser">
				<%--<img id="userProf" src="imagens/userProf.png" />--%>
				<asp:Literal ID="litImagem" runat="server"></asp:Literal>
				<div>
					<p><asp:Literal ID="litNome" runat="server"></asp:Literal></p>
					<p id="rm_usuario"><asp:Literal ID="litRm" runat="server"></asp:Literal></p>
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
		</div>
	</div>
</asp:Panel>