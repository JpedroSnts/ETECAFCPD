window.addEventListener("load", async () => {
	function cardReserva() {
		var coll = document.getElementsByClassName("collapsible");
		var i;

		for (i = 0; i < coll.length; i++) {
			coll[i].addEventListener("click", function (e) {
				e.preventDefault();
				this.classList.toggle("active");
				var content = this.nextElementSibling;
				if (content.style.maxHeight) {
					content.style.maxHeight = null;
				} else {
					content.style.maxHeight = content.scrollHeight + "px";
				}
			});
		}

		function cancelarReserva(itens, rm, data) {
			fetch(`/api/reservasProfessor.aspx?rm=${rm}&data=${data}&itens=${itens}`).then();
		}

		const rm = document.querySelector("#rm_usuario").textContent;

		const btnsCancelarReservas = document.querySelectorAll("#btnCardReserva");
		const lixeiras = document.querySelectorAll("#iconLixeira");
		for (let i = 0; i < btnsCancelarReservas.length; i++) {
			btnsCancelarReservas[i].addEventListener("click", async (e) => {
				e.preventDefault();
				const itens = e.target.getAttribute("itens");
				const data = e.target.getAttribute("data");
				cancelarReserva(itens, rm, data);
				await listarReservas();
			});
		}
		for (let i = 0; i < lixeiras.length; i++) {
			lixeiras[i].addEventListener("click", async (e) => {
				e.preventDefault();
				const itens = e.target.getAttribute("itens");
				const data = e.target.getAttribute("data");
				cancelarReserva(itens, rm, data);
				await listarReservas();
			});
		}
	}
	cardReserva();

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
	async function listarReservas() {
		$reservas.innerHTML = "";
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
					<img id="iconLixeira" src="Estatico/imagens/lixeira.png" itens="${e}" data="${el.DataSaidaPrevista}" />
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
				<button id="btnCardReserva" itens="${el.Itens.replace(" ", "")}" data="${el.DataSaidaPrevista}">Cancelar todas</button>
			</div>
			`;
			}
			cardReserva();
		} else {
			mainComReserva.style.display = "none";
			mainHome.style.display = "flex";
		}
	}

	await listarReservas();
});
