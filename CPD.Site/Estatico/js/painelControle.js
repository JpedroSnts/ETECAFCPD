window.addEventListener("load", () => {
    let STATUS = null;
    let FILTRO = null;
    let DATA = null;

    const ddlStatus = document.querySelector("#ddlStatus");
    const txtFiltro = document.querySelector("#txtFiltro");
    const txtData = document.querySelector("#txtData");
    const tbodyReservas = document.querySelector("#tbodyReservas");
    const tblReservas = document.querySelector("#tblReservas");

    const status = [
        { codigo: 0, css: "", nome: "Desconhecido", botao: "Ação" },
        { codigo: 1, css: "status-reservado", nome: "Reservado", botao: "" },
        { codigo: 2, css: "status-em-andamento", nome: "Em andamento", botao: "Entregar" },
        { codigo: 3, css: "status-entrega-atrasada", nome: "Entrega atrasada", botao: "Entregar" },
        { codigo: 4, css: "status-aguardando-retirada", nome: "Aguardando Retirada", botao: "Retirar" },
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

    function addEventoBotaoReserva() {
        const btnAcaoReserva = document.querySelectorAll(".btn.btnAcaoReserva");
        btnAcaoReserva.forEach((el) => {
            el.addEventListener("click", () => {
                const rm = el.getAttribute("rm");
                const status = el.getAttribute("status");
                const itens = el.getAttribute("itens");
                const data = el.getAttribute("dt_saida");
                fetch(`/Api/dashboard.aspx?rm=${rm}&dt_saida=${data}&itens=${itens}&status=${status}`)
                    .then((res) => res.json())
                    .then((dados) => {
                        console.log(dados);
                        listarReservas();
                    });
            });
        });
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
		</tr>`;
    }

    function fetchListar(url) {
        tblReservas.classList.remove("escondido");
        tbodyReservas.innerHTML = "<tr><td colspan='6'>Carregando...</td></tr>";
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

    function listarReservas() {
        if (DATA != null && DATA != "" && FILTRO != null && FILTRO.trim() != "" && STATUS != null && STATUS != "") {
            fetchListar(`/Api/dashboard.aspx?status=${STATUS}&filtro=${FILTRO}&data=${DATA}`);
            return;
        }

        if (DATA != null && DATA != "" && FILTRO != null && FILTRO.trim() != "") {
            fetchListar(`/Api/dashboard.aspx?&filtro=${FILTRO}&data=${DATA}`);
            return;
        }
        if (DATA != null && DATA != "" && STATUS != null && STATUS != "") {
            fetchListar(`/Api/dashboard.aspx?status=${STATUS}&data=${DATA}`);
            return;
        }
        if (DATA != null && DATA != "") {
            fetchListar(`/Api/dashboard.aspx?data=${DATA}`);
            return;
        }

        if (FILTRO != null && FILTRO.trim() != "" && STATUS != null && STATUS != "") {
            fetchListar(`/Api/dashboard.aspx?status=${STATUS}&filtro=${FILTRO}`);
            return;
        }
        if (FILTRO != null && FILTRO.trim() != "") {
            fetchListar(`/Api/dashboard.aspx?filtro=${FILTRO}`);
            return;
        }

        if (STATUS != null && STATUS != "") {
            fetchListar(`/Api/dashboard.aspx?status=${STATUS}`);
            return;
        }
    }

    ddlStatus.addEventListener("change", e => {
        STATUS = e.target.value;
        listarReservas();
    });
    let keyupTimer;
    txtFiltro.addEventListener("keyup", e => {
        clearTimeout(keyupTimer);
        FILTRO = e.target.value;

        keyupTimer = setTimeout(function () {
            listarReservas();
        }, 800);
    });
    txtData.addEventListener("change", e => {
        DATA = e.target.value;
        listarReservas();
    })

    const form = document.querySelector("#form1");
    form.addEventListener("submit", (e) => {
        e.preventDefault();
    });

    listarReservas();
});
