window.addEventListener("load", () => {
    let STATUS = null;
    let FILTRO = null;

    const ddlStatus = document.querySelector("#ddlStatus");
    const txtFiltro = document.querySelector("#txtFiltro");
    const tbodyReservas = document.querySelector("#tbodyReservas");
    const tbodyItensLivres = document.querySelector("#tbodyItensLivres");

    const status = [
        { codigo: 0, css: "status-em-andamento", nome: "Em andamento", botao: "Devolver" },
        { codigo: 1, css: "status-reservado", nome: "Reservado", botao: "Entregar" },
        { codigo: 2, css: "status-em-andamento", nome: "Em andamento", botao: "Devolver" },
        { codigo: 3, css: "status-entrega-atrasada", nome: "Entrega atrasada", botao: "Devolver" },
        { codigo: 4, css: "status-aguardando-retirada", nome: "Aguardando Retirada", botao: "Entregar" },
        { codigo: 5, css: "status-nao-retirado", nome: "Não Retirado", botao: "Encerrar" },
        { codigo: 6, css: "status-cancelada", nome: "Cancelada", botao: "" },
        { codigo: 7, css: "status-concluida", nome: "Concluída", botao: "" },
    ];

    status.forEach(e => {
        if (e.codigo != 0) ddlStatus.innerHTML += `<option value="${e.codigo}">${e.nome}</option>`;
    });

    function getStatus(statusInt) {
        return status.find(e => e.codigo == statusInt);
    }

    function formatarData(dateTime) {
        const dt = new Date(dateTime);
        return dt.toLocaleDateString();
    }

    function trTabela(reserva) {
        const status = getStatus(reserva.StatusReserva);
        const data = formatarData(reserva.DataSaidaPrevista);
        return `
		<tr>
			<td>${data}</td>
			<td>${reserva.Horario}</td>
			<td>${reserva.Itens}</td>
			<td>${reserva.Professor}</td>
			<td class="${status.css}">${status.nome}</td>
			<td>
				${status.botao == ""
                ? ""
                : `<div class="btn btnAcaoReserva" rm="${reserva.RM}" dt_saida="${reserva.DataSaidaPrevista}" itens="${reserva.Itens.replaceAll(" ", "")}" status="${status.codigo}">${status.botao}</div>`
            }
			</td>
            <td>
            ${status.botao != "" && (status.codigo == 7 || status.codigo == 3 || status.codigo == 2)
            ? `<input type="checkbox" class="ckbOcorrencia" codigos="${reserva.Itens.replaceAll(" ", "")}" dataSaida="${reserva.DataSaidaPrevista}" rm="${reserva.RM}" tiposItens="${reserva.TiposItens.join(",")}" />`
            : ""}
            </td>
		</tr>`;
    }

    function fetchListar(url) {
        tbodyReservas.innerHTML = "<tr><td colspan='7'><div id='tdReload'><img class='reloadAnimacao' id='iconeReload' src='/Estatico/imagens/refresh.svg'>Carregando...</div></td></tr>";
        fetch(`${url}`)
            .then(res => res.json())
            .then(reservas => {
                tbodyReservas.innerHTML = "";
                for (let i = 0; i < reservas.length; i++) {
                    tbodyReservas.innerHTML += trTabela(reservas[i]);
                }
                addEventoBotaoReserva();
            });
    }

    function fetchListarItens() {
        tbodyItensLivres.innerHTML = "<tr><td colspan='2'><div id='tdReload'><img class='reloadAnimacao' id='iconeReload' src='/Estatico/imagens/refresh.svg'>Carregando...</div></td></tr>";
        fetch(`/Api/dashboard.aspx?itens-livres=_`)
            .then(res => res.json())
            .then(itens => {
                tbodyItensLivres.innerHTML = "";
                for (let i = 0; i < itens.length; i++) {
                    tbodyItensLivres.innerHTML += `
						<tr>
							<td>${itens[i].Nome}</td>
							<td>${itens[i].Quantidade}</td>
						</tr>
					`;
                }
            });
    }

    function listarReservas() {
        const dt = new Date();
        const yyyy_mm_dd = `${dt.getFullYear()}-${dt.getMonth() + 1}-${dt.getDate()}`;
        if ((FILTRO == null || FILTRO.trim() == "") && (STATUS == null || STATUS == "")) {
            fetchListar(`/Api/dashboard.aspx?data=${yyyy_mm_dd}`);
            return;
        }

        if (FILTRO != null && FILTRO.trim() != "" && STATUS != null && STATUS != "") {
            fetchListar(`/Api/dashboard.aspx?status=${STATUS}&filtro=${FILTRO}&data=${yyyy_mm_dd}`);
            return;
        }
        if (FILTRO != null && FILTRO.trim() != "") {
            fetchListar(`/Api/dashboard.aspx?filtro=${FILTRO}&data=${yyyy_mm_dd}`);
            return;
        }

        if (STATUS != null && STATUS != "") {
            fetchListar(`/Api/dashboard.aspx?status=${STATUS}&data=${yyyy_mm_dd}`);
            return;
        }
    }

    const iconeReload = document.querySelector("#iconeReload");
    iconeReload.addEventListener("click", () => {
        listarReservas();
        fetchListarItens();
    });

    ddlStatus.addEventListener("change", e => {
        STATUS = e.target.value;
        listarReservas();
    });
    let keyupTimer;
    txtFiltro.addEventListener("keyup", e => {
        clearTimeout(keyupTimer);
        const code = e.keyCode || e.which;
        FILTRO = e.target.value;

        keyupTimer = setTimeout(function () {
            listarReservas();
        }, 800);
    });

    const form = document.querySelector("#form1");
    form.addEventListener("submit", (e) => {
        e.preventDefault();
    });

    listarReservas();
    fetchListarItens();

    let regarregarTabela = setInterval(() => {
        listarReservas();
        fetchListarItens();
    }, 1000 * 15);

    // MODAL OCORRENCIA
    let STATUS_BTN = "";
    let RM_BTN = "";
    let ITENS_BTN = "";
    let DATA_BTN = "";

    const btnGerarOcorrencia = document.querySelector("#btnGerarOcorrencia");
    let tipoOcorrenciaAmbiente = ``;
    let tipoOcorrenciaEquipamento = ``;
    const itensOcorrencia = document.querySelector("#itensOcorrencia");
    let inputTextValues = {};

    btnGerarOcorrencia.addEventListener("click", (e) => {
        const rm = e.target.getAttribute("rm");
        const data = e.target.getAttribute("data");
        const itens = Object.keys(inputTextValues);
        const textareas = [];
        const tipos_ocorrencias = [];
        const tipos_itens = [];
        itens.forEach((i) => {
            textareas.push(inputTextValues[i].textarea);
            tipos_ocorrencias.push(inputTextValues[i].ddl);
            tipos_itens.push(inputTextValues[i].tipo);
        });

        fetch(`/Api/gerarOcorrencia.aspx`, {
            method: "POST",
            body: JSON.stringify({
                rm, data, itens: Object.values(inputTextValues), cd_itens: Object.keys(inputTextValues)
            })
        }).then(() => {
            if (RM_BTN != "" && STATUS_BTN != "" && ITENS_BTN != "" && DATA_BTN != "") {
                fetch(`/Api/dashboard.aspx?rm=${RM_BTN}&dt_saida=${DATA_BTN}&itens=${ITENS_BTN}&status=${STATUS_BTN}`)
                    .then(() => {
                        listarReservas();
                    });

                regarregarTabela = setInterval(() => {
                    listarReservas();
                    fetchListarItens();
                }, 1000 * 15);

                const displayOcorrencia = document.querySelector("#displayOcorrencia");
                const gerarOcorrencia = document.querySelector("#gerarOcorrencia");

                displayOcorrencia.classList.add("escondido");
                gerarOcorrencia.classList.add("escondido");

                document.querySelector(".ckbs-group").innerHTML = "";
                itensOcorrencia.innerHTML = "";
                inputTextValues = {};
                btnGerarOcorrencia.setAttribute("disabled", "");
                document.querySelector("body").style.overflow = "hidden";
            }
        });
    });

    function bloquearBotaoGerarOcorrencia() {
        const arrayCkbs = [];
        const ckbs = document.querySelector(".ckbs-group").querySelectorAll("input[type=checkbox]");
        ckbs.forEach(el => {
            arrayCkbs.push(el.checked);
        });

        const chaves = Object.keys(inputTextValues);
        let ddlVazia = true;
        chaves.forEach(c => {
            if (inputTextValues[c].ddl == "") {
                ddlVazia = true;
            } else {
                ddlVazia = false;
            }
            return;
        });
        if (arrayCkbs.includes(true) && !ddlVazia) {
            btnGerarOcorrencia.removeAttribute("disabled");
        } else {
            btnGerarOcorrencia.setAttribute("disabled", "");
        }
    }

    function abrirFormOcorrencia(rm, data, itens, tipos) {
        clearInterval(regarregarTabela);
        document.querySelector(".ckbs-group").innerHTML = "";
        itensOcorrencia.innerHTML = "";
        inputTextValues = {};
        btnGerarOcorrencia.setAttribute("disabled", "");
        document.querySelector("body").style.overflow = "hidden";

        btnGerarOcorrencia.setAttribute("rm", rm);
        btnGerarOcorrencia.setAttribute("data", data);

        if (tipoOcorrenciaAmbiente == "" || tipoOcorrenciaEquipamento == "") {
            fetch("/Api/listarTipoOcorrencia.aspx")
                .then(res => res.json())
                .then(json => {
                    tipoOcorrenciaAmbiente = `<option value="">Tipo Ocorrência</option>`;
                    tipoOcorrenciaEquipamento = `<option value="">Tipo Ocorrência</option>`;
                    json.TipoOcorrenciaAmbiente.forEach(t => {
                        tipoOcorrenciaAmbiente += `<option value="${t.Codigo}">${t.Nome}</option>`
                    });
                    json.TipoOcorrenciaEquipamento.forEach(t => {
                        tipoOcorrenciaEquipamento += `<option value="${t.Codigo}">${t.Nome}</option>`
                    });
                });
        }

        const btnFecharJanelaOcorrencia = document.querySelector("#btnFecharJanelaOcorrencia");
        const displayOcorrencia = document.querySelector("#displayOcorrencia");
        const gerarOcorrencia = document.querySelector("#gerarOcorrencia");

        displayOcorrencia.classList.remove("escondido");
        gerarOcorrencia.classList.remove("escondido");

        btnFecharJanelaOcorrencia.addEventListener("click", e => {
            e.preventDefault();
            displayOcorrencia.classList.add("escondido");
            gerarOcorrencia.classList.add("escondido");
            document.querySelector("body").style.overflow = "auto";

            regarregarTabela = setInterval(() => {
                listarReservas();
                fetchListarItens();
            }, 1000 * 15);
        });

        itens.forEach((x, i) => {
            document.querySelector(".ckbs-group").innerHTML += `
			<div class="ckbs">
				<input type="checkbox" id="${x}" name="${tipos[i]}" />
				<label for="${x}">${x}</label>
			</div>
			`;
        });
        document
            .querySelector(".ckbs-group")
            .querySelectorAll("input[type=checkbox]")
            .forEach(checkbox => {
                checkbox.addEventListener("change", e => {
                    if (e.target.checked) {
                        let tipo = "AMBIENTE";
                        const id = e.target.id;
                        if (e.target.name == "equipamentos") tipo = "EQUIPAMENTO";

                        const htmlItem = `
							<details class="itens" id="${id}" open>
								<summary>${id}</summary>
								<select name="ddl${id}" tipo="${tipo}" id="ddl${id}" class="ddlOcorrencia">
									${tipo == "AMBIENTE" ? tipoOcorrenciaAmbiente : tipoOcorrenciaEquipamento}
								</select>
								<textarea id="txt${id}" placeholder="Descrição" class="caixaDescricao"></textarea>
							</details>
							`;
                        itensOcorrencia.innerHTML += htmlItem;
                    } else {
                        const id = e.target.id;
                        delete inputTextValues[id];
                        itensOcorrencia.querySelectorAll("details").forEach(d => {
                            if (d.id == id) d.remove();
                        });
                    }

                    const details = document.querySelectorAll("details");
                    details.forEach(d => {
                        const ddl = d.querySelector("select");
                        const txt = d.querySelector("textarea");
                        inputTextValues[d.id] = inputTextValues[d.id] || { textarea: "", ddl: "", tipo: ddl.getAttribute("tipo") == "AMBIENTE" ? 1 : 2 };
                        txt.addEventListener("input", e => {
                            inputTextValues[d.id].textarea = e.target.value;
                            bloquearBotaoGerarOcorrencia();
                        });
                        ddl.addEventListener("change", e => {
                            inputTextValues[d.id].ddl = e.target.value;
                            bloquearBotaoGerarOcorrencia();
                        });
                        txt.value = inputTextValues[d.id].textarea;
                        ddl.value = inputTextValues[d.id].ddl;
                    });
                    bloquearBotaoGerarOcorrencia();
                });
            });
    }

    function addEventoBotaoReserva() {
        const btnAcaoReserva = document.querySelectorAll(".btn.btnAcaoReserva");
        btnAcaoReserva.forEach((el) => {
            const checkbox = el.parentNode.parentNode.querySelector("input[type='checkbox']");
            el.addEventListener("click", () => {
                const rm = el.getAttribute("rm");
                const status = el.getAttribute("status");
                const itens = el.getAttribute("itens");
                const data = el.getAttribute("dt_saida");

                if (checkbox && checkbox.checked) {
                    const rm = checkbox.getAttribute("rm");
                    const data = checkbox.getAttribute("dataSaida");
                    const itens = checkbox.getAttribute("codigos").split(",");
                    const tipos = checkbox.getAttribute("tipositens").split(",").map((i) => i == "1" ? "ambientes" : "equipamentos");

                    STATUS_BTN = status;
                    RM_BTN = rm;
                    ITENS_BTN = itens;
                    DATA_BTN = data;
                    abrirFormOcorrencia(rm, data, itens, tipos);
                } else {
                    fetch(`/Api/dashboard.aspx?rm=${rm}&dt_saida=${data}&itens=${itens}&status=${status}`)
                        .then(() => {
                            listarReservas();
                        });
                }
            });

        });
    }
});
