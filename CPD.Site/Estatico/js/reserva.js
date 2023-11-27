window.addEventListener("load", () => {
    const EQP_SELECIONADOS = {};
    let AMB_SELECIONADO = "";

    const data7dias = new Date(new Date().setDate(new Date().getDate() + 7));
    const txtInputData = document.querySelector("#txtInputData");
    const txtHorarioInicio = document.querySelector("#txtHorarioInicio");
    const txtHorarioFim = document.querySelector("#txtHorarioFim");
    const btnReservar = document.querySelector("#btnReservar");
    const mensagemReserva = document.querySelector(".pMensagemReserva");

    // BLOQUEAR DATAS CALENDARIO
    txtInputData.max = data7dias.toISOString().split("T")[0];
    var today = new Date();
    var dd = String(today.getDate()).padStart(2, '0');
    var mm = String(today.getMonth() + 1).padStart(2, '0');
    var yyyy = today.getFullYear();

    today = yyyy + '-' + mm + '-' + dd;
    txtInputData.setAttribute("min", today);

    // CONFIGURAR INPUTS DE DATA
    txtHorarioInicio.addEventListener("change", (e) => {
        let dt = new Date("2023-12-12 " + e.target.value);
        dt = new Date(dt.setMinutes(dt.getMinutes() + 50));
        txtHorarioFim.value = dt.toLocaleTimeString("pt-BR").replace(":00", "");
    });

    if (txtInputData.value) {
        txtInputData.type = "date";
    }

    // Configuração Select2
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

    // ADICIONAR E REMOVER QUANTIDADE EQUIPAMENTOS
    const pnlAmbientes = document.querySelector("#pnlAmbientesItens");
    const pnlEquipamentos = document.querySelector("#pnlEquipamentosItens");
    if (pnlAmbientes) {
        pnlEquipamentos.childNodes.forEach(e => {
            if (e.tagName == "DIV") {
                const qts = e.querySelector("input.numQtEquip");
                qts.setAttribute("readonly", "readonly");
                e.querySelector(".iconMais").addEventListener("click", e => {
                    let qt = Number(qts.value) == Number(qts.getAttribute("maxlength")) ? Number(qts.getAttribute("maxlength")) : Number(qts.value) + 1; 
                    qts.setAttribute("value", qt);
                    EQP_SELECIONADOS[qts.parentNode.parentNode.id.replace("pnl", "")] = qt;
                });
                e.querySelector(".iconMenos").addEventListener("click", e => {
                    let qt = Number(qts.value) == 0 ? 0 : Number(qts.value) - 1;
                    qts.setAttribute("value", qt);
                    EQP_SELECIONADOS[qts.parentNode.parentNode.id.replace("pnl", "")] = qt;
                });
                if (qts.value != 0) {
                    EQP_SELECIONADOS[qts.parentNode.parentNode.id.replace("pnl", "")] = qts.value;
                }
            }
        });

        if (txtInputData.value == "" || txtHorarioInicio.value == "" || txtHorarioFim.fim == "") {
            btnReservar.setAttribute("disabled", "disabled");
        } else {
            mensagemReserva.remove();
        }

        function limparItensEBloquearBotao() {
            btnReservar.setAttribute("disabled", "disabled");
            pnlAmbientes.innerHTML = "";
            pnlEquipamentos.innerHTML = "";
        }

        txtInputData.addEventListener("keyup", limparItensEBloquearBotao);
        txtHorarioInicio.addEventListener("keyup", limparItensEBloquearBotao);
        txtHorarioFim.addEventListener("keyup", limparItensEBloquearBotao);
        txtInputData.addEventListener("change", limparItensEBloquearBotao);
        txtHorarioInicio.addEventListener("change", limparItensEBloquearBotao);
        txtHorarioFim.addEventListener("change", limparItensEBloquearBotao);

        document.querySelectorAll(".rdbAmb input").forEach((e) => {
            e.addEventListener("change", (e) => {
                AMB_SELECIONADO = e.target.id.replace("rdb", "");
            });
            if (e.checked) {
                AMB_SELECIONADO = e.id.replace("rdb", "");
            }
        });
    }

    // CARD CONFIRMAR RESERVA

    const formsCardLixeira = document.querySelector("#divModalItensReserva");
    const cardCentro = document.querySelector("#cardCentro");

    const btnCancelar = document.querySelector("#btnCancelar");
    const telaBloqueio = document.querySelector(".bloqueio");

    btnReservar?.addEventListener("click", abrirModalItensReserva);
    btnCancelar.addEventListener("click", fecharModalItensReserva);
    telaBloqueio.addEventListener("click", fecharModalItensReserva);

    const lblItensReserva = document.querySelector("#lblItensReserva");
    const lblDiaEHora = document.querySelector("#lblDiaEHora");

    function abrirModalItensReserva(event) {
        event.preventDefault();
        const data = document.querySelector("#txtInputData").value;
        const inicio = `${data} ${document.querySelector("#txtHorarioInicio").value}`;
        const fim = `${data} ${document.querySelector("#txtHorarioFim").value}`;

        if (JSON.stringify(EQP_SELECIONADOS) == "{}" && AMB_SELECIONADO == "") {
            document.querySelector(".caixa-flutuante-erros").innerHTML = `
                <div class='box1'>
				    <p class='erro'>Selecione um equipamento ou ambiente</p>
				    <img src='Estatico/imagens/close.svg' class='close-box' onclick='this.parentNode.remove()' />
			    </div>
            `;
            return;
        }

        let amb_reservar = "";
        let amb_qt_reservar = "";
        if (AMB_SELECIONADO != "") {
            amb_reservar = "," + AMB_SELECIONADO;
            if (Object.keys(EQP_SELECIONADOS).length == 0) {
                amb_reservar = AMB_SELECIONADO;
            }
            amb_qt_reservar = amb_reservar != "" ? (Object.keys(EQP_SELECIONADOS).length == 0 ? "1" : ",1") : "";
        }

        fetch(`/api/listarItensLivres.aspx?inicio=${inicio}&fim=${fim}&itens=${Object.keys(EQP_SELECIONADOS)}${amb_reservar}&quantidades=${Object.values(EQP_SELECIONADOS)}${amb_qt_reservar}`)
            .then((res) => res.json())
            .then((itens) => {
                const qt = itens.length;
                for (let i = 0; i < itens.length; i++) {
                    const item = itens[i];
                    lblItensReserva.innerHTML += item.Nome;
                    if (i != qt - 1) {
                        lblItensReserva.innerHTML += ", ";
                    }
                }
            });
        const newDt = new Date(data);
        const dd_mm = new Date(newDt.setDate(new Date(data).getDate() + 1)).toLocaleDateString("pt-BR").substring(0, 5);
        lblDiaEHora.textContent = `${dd_mm} (${document.querySelector("#txtHorarioInicio").value} - ${document.querySelector("#txtHorarioFim").value})`;

        telaBloqueio.classList.remove("escondido");
        formsCardLixeira.classList.remove("escondido");
        cardCentro.classList.remove("escondido");
    }

    function fecharModalItensReserva(event) {
        event.preventDefault();
        lblItensReserva.innerHTML = "";
        lblDiaEHora.innerHTML = "";
        telaBloqueio.classList.add("escondido");
        formsCardLixeira.classList.add("escondido");
        cardCentro.classList.add("escondido");
    }

});