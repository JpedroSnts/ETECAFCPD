window.addEventListener("load", async () => {
	const diasSemana = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"];
	const mainHome = document.querySelector("#mainHome");
	const rmUsuario = document.querySelector("#rm_usuario").textContent;
	const mainComReserva = document.querySelector("#mainComReserva");
	const $reservas = document.querySelector("#reservas");

	async function buscarReservas() {
		const res = await fetch(`/api/reservasProfessor.aspx?rm=${rmUsuario}`);
		const json = await res.json();
		return json;
	}
	const reservas = await buscarReservas();
	if (reservas != null && reservas.length != 0) {
		mainHome.style.display = "none";
		mainComReserva.style.display = "flex";

		for (let i = 0; i < reservas.length; i++) {
			const el = reservas[i];
			const dt = new Date(el.DataSaidaPrevista);
			const diaSemana = diasSemana[dt.getDay()];
			const dd_mm = `${dt.getDate()}/${(dt.getMonth() + 1).length == 2 ? dt.getMonth() + 1 : "0" + (dt.getMonth() + 1)}`;
			const codigos = el.Itens.split(", ").map(e => e);
			const itens = codigos
				.map(e => {
					return `
				<div style="margin-bottom: 5px;">
					<p>${e} (${el.Horario})</p>
					<img id="iconLixeira" src="Estatico/imagens/lixeira.png" codigo="${e}" data="${el.DataSaidaPrevista}" />
				</div>
				`;
				})
				.join(" ");
			$reservas.innerHTML += `
			<button class="collapsible">${diaSemana} (${dd_mm}) <img src="Estatico/imagens/seta_baixo.png" /></button>
			<div class="content">
				<div class="divTipoReserva">
					<h1 id="h1Equipamentos">Itens</h1>
					${itens}
				</div>
				<button id="btnCardReserva" codigos="${el.Itens.replace(" ", "")}" data="${el.DataSaidaPrevista}">Cancelar todas</button>
			</div>
			`;
		}
		cardReserva();
	} else {
		mainComReserva.style.display = "none";
		mainHome.style.display = "flex";
	}
});
