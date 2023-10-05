window.addEventListener("load", () => {
    const data7dias = new Date(new Date().setDate(new Date().getDate() + 7));
    txtInputData.max = data7dias.toISOString().split("T")[0];

    const btnAmbiente = document.querySelector("#Ambiente");
    const btnEquipamento = document.querySelector("#Equipamento");
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

        const txtInputData = document.querySelector("#txtInputData");
        const txtHorarioInicio = document.querySelector("#txtHorarioInicio");
        const txtHorarioFim = document.querySelector("#txtHorarioFim");
        const btnReservar = document.querySelector("#btnReservar");

        if (txtInputData.value == "" || txtHorarioInicio.value == "" || txtHorarioFim.fim == "") {
            btnReservar.setAttribute("disabled", "disabled");
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
});
