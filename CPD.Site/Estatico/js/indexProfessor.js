window.addEventListener("load", async () => {
	const rmUsuario = document.querySelector("#rm_usuario").textContent;
	const diasSemana = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"];
	const mainHome = document.querySelector("#mainHome");
	const mainComReserva = document.querySelector("#mainComReserva");
	const $reservas = document.querySelector("#reservas");

	function cancelarReserva(itens, rm, data) {
		fetch(`/api/reservasProfessor.aspx?rm=${rm}&data=${data}&itens=${itens}`).then();
	}

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
	}
	cardReserva();

	function buscarReservas() {
		fetch(`/api/reservasProfessor.aspx?rm=${rmUsuario}`).then((res) => {
			return res.json();
		}).then((reservas) => {

			let reservasAgrupadas = {};

			reservas.forEach(reserva => {
				const data = reserva["DataSaidaPrevista"].split("T")[0];

				if (!reservasAgrupadas[data]) {
					reservasAgrupadas[data] = [];
				}

				reservasAgrupadas[data].push(reserva);
			});
			reservasAgrupadas = Object.values(reservasAgrupadas);

			console.log(reservasAgrupadas);

			$reservas.innerHTML = "";
			if (reservas != null && reservas.length != 0) {
				mainHome.style.display = "none";
				mainComReserva.style.display = "flex";

				for (let i = 0; i < reservas.length; i++) {
					const el = reservas[i];
					const dt = new Date(el.DataSaidaPrevista);
					const diaSemana = diasSemana[dt.getDay()];
					const dd = String(dt.getDate()).length == 2 ? dt.getDate() : "0" + dt.getDate();
					const mm = String(dt.getMonth() + 1).length == 2 ? dt.getMonth() + 1 : "0" + (dt.getMonth() + 1);
					const dd_mm = `${dd}/${mm}`;
					const codigos = el.Itens.split(", ").map(e => e);
					const nomes = el.ItensNome.split(", ").map(e => e);
					const itens = codigos
						.map((e, j) => {
							return `
				<div style="margin-bottom: 5px;">
					<p>${nomes[j]} (${el.Horario})</p>
					${el.StatusReserva == 1 ? `<img id="iconLixeira" src="Estatico/imagens/lixeira.png" itens="${e}" data="${el.DataSaidaPrevista}" />` : ""}
				</div>
				`;
						})
						.join(" ");
					$reservas.innerHTML += `
<div id='reservas'>
			<button class="collapsible">${diaSemana} (${dd_mm}) <img src="Estatico/imagens/seta_baixo.png" /></button>
			<div class="content">
				<div class="divTipoReserva">
					<h1 id="h1Equipamentos">Itens</h1>
					${itens}
				</div>
				${el.StatusReserva == 1 ? `<button id="btnCardReserva" itens="${el.Itens.replaceAll(" ", "")}" data="${el.DataSaidaPrevista}">Cancelar todas</button>` : ""}
			</div>
</div>
			`;
				}
				cardReserva();
			} else {
				mainComReserva.style.display = "none";
				mainHome.style.display = "flex";
			}
			const btnsCancelarReservas = document.querySelectorAll("#btnCardReserva");
			const lixeiras = document.querySelectorAll("#iconLixeira");
			for (let i = 0; i < btnsCancelarReservas.length; i++) {
				btnsCancelarReservas[i].addEventListener("click", async (e) => {
					e.preventDefault();
					const itens = e.target.getAttribute("itens");
					const data = e.target.getAttribute("data");
					cancelarReserva(itens, rmUsuario, data);
					btnsCancelarReservas[i].parentElement.parentElement.remove();
					const qtReservas = document.querySelector("#reservas").childElementCount;
					if (qtReservas == 0) {
						mainHome.style.display = "flex";
						mainComReserva.style.display = "none";
					}
				});
			}
			for (let i = 0; i < lixeiras.length; i++) {

				lixeiras[i].addEventListener("click", async (e) => {
					e.preventDefault();
					const itens = e.target.getAttribute("itens");
					const data = e.target.getAttribute("data");
					cancelarReserva(itens, rmUsuario, data);

					let count = 0;
					let els1 = lixeiras[i].parentElement.parentElement.childNodes;
					for (var j = 0; j < els1.length; j++) {
						if (els1[j].tagName == "DIV") {
							count++;
						}
					}
					lixeiras[i].parentElement.parentElement.parentElement.childNodes.forEach((btn) => {
						if (btn.tagName == "BUTTON") {
							let arr = btn.getAttribute("itens").split(",");
							arr = arr.filter((x) => x != itens);
							btn.setAttribute("itens", arr.join(",").replaceAll(" ", ""));
						}
					});
					if (count == 1) {
						lixeiras[i].parentElement.parentElement.parentElement.parentElement.remove();
					} else {
						lixeiras[i].parentElement.remove();
					}
					const qtReservas = document.querySelector("#reservas").childElementCount;
					if (qtReservas == 0) {
						mainHome.style.display = "flex";
						mainComReserva.style.display = "none";
					}
				});
			}
		});
	}
	buscarReservas();
});
