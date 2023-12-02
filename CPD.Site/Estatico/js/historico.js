window.addEventListener("load", async () => {
    const rmUsuario = document.querySelector("#rm_usuario").textContent;
    const diasSemana = ["Domingo", "Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado"];
    const mainReload = document.querySelector("#mainReload");
    const mainComReserva = document.querySelector("#mainComReserva");
    const mainHome = document.querySelector("#mainHome");
    const pMensagemReserva = document.querySelector(".pMensagemReserva");
    const $reservas = document.querySelector("#reservas");

    const status = {
        "1": { nome: "Reservado", icone: "reserva_reservado.svg" },
        "2": { nome: "Em andamento", icone: "reserva_em_andamento.svg" },
        "3": { nome: "Entrega Atrasada", icone: "atrasada.svg" },
        "4": { nome: "Aguardando Retirada", icone: "reserva_aguardando_retirada.svg" },
        "5": { nome: "Não Retirados", icone: "naoRetirada.svg" },
        "6": { nome: "Canceladas", icone: "cancelada.svg" },
        "7": { nome: "Concluida", icone: "concluida.svg" }
    };

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

    const txtDataInicio = document.querySelector("#txtDataInicio");
    const txtDataFinal = document.querySelector("#txtDataFinal");
    const btnBuscarHistorico = document.querySelector("#btnBuscarHistorico");
    const btnBuscarHistoricoResponsivo = document.querySelector("#btnBuscarHistoricoResponsivo");

    function eventoBuscar(e) {
        e.preventDefault();
        if (txtDataInicio.value != "" && txtDataFinal.value != "") {
            buscarReservas(txtDataInicio.value, txtDataFinal.value);
            return;
        }
        if (txtDataInicio.value != "") {
            buscarReservas(txtDataInicio.value, null);
        }
    }

    btnBuscarHistorico.addEventListener("click", eventoBuscar);
    btnBuscarHistoricoResponsivo.addEventListener("click", eventoBuscar);

    function buscarReservas(inicio, fim) {
        mainHome.style.display = "none";
        pMensagemReserva.style.display = "none";
        mainReload.style.display = "block";
        let url = `/api/reservasProfessor.aspx?rm=${rmUsuario}&todas=true`;
        if (inicio) url = `/api/reservasProfessor.aspx?rm=${rmUsuario}&todas=true&inicio=${inicio}`;
        if (inicio && fim) url = `/api/reservasProfessor.aspx?rm=${rmUsuario}&todas=true&inicio=${inicio}&fim=${fim}`;
        fetch(url).then((res) => {
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

            $reservas.innerHTML = "";
            if (reservas != null && reservas.length != 0) {
                mainReload.style.display = "none";
                mainComReserva.style.display = "flex";

                for (let i = 0; i < reservasAgrupadas.length; i++) {
                    const el = reservasAgrupadas[i];
                    let equipamentosReserva = ``;
                    let ambientesReserva = ``;
                    for (var j = 0; j < el.length; j++) {
                        const el2 = el[j];
                        let itens = el2.Itens.split(",");

                        for (var k = 0; k < itens.length; k++) {
                            const cd = itens[k];

                            if (el2.TiposItens[k] == 1) {
                                ambientesReserva += `
									<div style="margin-bottom: 5px;">
										<p>${el2.ItensNome.split(",")[k]} (${el2.Horario})</p>
                                        <img src="Estatico/imagens/${status[el2.StatusReserva].icone}" alt="ícone ${status[el2.StatusReserva].nome}" title="${status[el2.StatusReserva].nome}"/>
									</div>
								`;
                            } else if (el2.TiposItens[k] == 2) {
                                equipamentosReserva += `
									<div style="margin-bottom: 5px;">
										<p>${el2.ItensNome.split(",")[k]} (${el2.Horario})</p>
										<img src="Estatico/imagens/${status[el2.StatusReserva].icone}" alt="ícone ${status[el2.StatusReserva].nome}" title="${status[el2.StatusReserva].nome}"/>
									</div>
								`;
                            }
                        }
                    }
                    const dt = new Date(el[0].DataSaidaPrevista);
                    const diaSemana = diasSemana[dt.getDay()];
                    const dd = String(dt.getDate()).length == 2 ? dt.getDate() : "0" + dt.getDate();
                    const mm = String(dt.getMonth() + 1).length == 2 ? dt.getMonth() + 1 : "0" + (dt.getMonth() + 1);
                    const yyyy = dt.getFullYear();
                    const dd_mm_yyyy = `${dd}/${mm}/${yyyy}`;
                    $reservas.innerHTML += `
						<div class="cardReserva">
							<h1>${diaSemana} (${dd_mm_yyyy})</h1>
							<div class="divReservas">
								<div class="divTipoReserva">
									${ambientesReserva != `` ? `<h2 id="h2Equipamentos">Ambientes</h2>` : ""}
									${ambientesReserva}
									${equipamentosReserva != `` ? `<h2 id="h2Equipamentos">Equipamentos</h2>` : ""}
									${equipamentosReserva}
								</div>
							</div>
						</div>
					`;
                }

                cardReserva();
            } else {
                mainReload.style.display = "none";
                if (!inicio && !fim) {
                    mainHome.style.display = "flex";
                } else {
                    document.querySelector(".pMensagemReserva").style.display = "block";
                }
            }
        });
    }
    buscarReservas();
});