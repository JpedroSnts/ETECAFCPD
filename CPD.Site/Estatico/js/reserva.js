window.addEventListener("load", () => {
    const data7dias = new Date(new Date().setDate(new Date().getDate() + 7));
    const txtInputData = document.querySelector("#txtInputData");
    const txtHorarioInicio = document.querySelector("#txtHorarioInicio");
    const txtHorarioFim = document.querySelector("#txtHorarioFim");
    const btnReservar = document.querySelector("#btnReservar");
    const mensagemReserva = document.querySelector(".pMensagemReserva");
    txtInputData.max = data7dias.toISOString().split("T")[0];

    const pnlAmbientes = document.querySelector("#pnlAmbientesItens");
    const pnlEquipamentos = document.querySelector("#pnlEquipamentosItens");
    if (pnlAmbientes) {
        pnlEquipamentos.childNodes.forEach(e => {
            if (e.tagName == "DIV") {
                const qts = e.querySelector("input.numQtEquip");
                qts.setAttribute("readonly", "readonly");
                e.querySelector(".iconMais").addEventListener("click", e => {
                    qts.setAttribute("value", Number(qts.value) == Number(qts.getAttribute("maxlength")) ? Number(qts.getAttribute("maxlength")) : Number(qts.value) + 1);
                });
                e.querySelector(".iconMenos").addEventListener("click", e => {
                    qts.setAttribute("value", Number(qts.value) == 0 ? 0 : Number(qts.value) - 1);
                });
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

    }
    txtHorarioInicio.addEventListener("change", (e) => {
        let dt = new Date("2023-12-12 " + e.target.value);
        dt = new Date(dt.setMinutes(dt.getMinutes() + 50));
        txtHorarioFim.value = dt.toLocaleTimeString("pt-BR").replace(":00", "");
    });

    if (txtInputData.value) {
        txtInputData.type = "date";
    }
});