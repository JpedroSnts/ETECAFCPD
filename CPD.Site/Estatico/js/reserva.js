window.addEventListener("load", () => {
    const btnAmbiente = document.querySelector("#Ambiente");
    const btnEquipamento = document.querySelector("#Equipamento");
    const pnlAmbientes = document.querySelector("#pnlAmbientesItens");
    const pnlEquipamentos = document.querySelector("#pnlEquipamentosItens");

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

    if (document.documentElement.clientWidth < 800) {
        btnEquipamento.style.color = "#114a55";

        btnAmbiente.addEventListener("click", e => {
            pnlAmbientes.style.display = "flex";
            pnlEquipamentos.style.display = "none";
            btnEquipamento.style.color = "#000";
            btnAmbiente.style.color = "#114a55";
        });

        btnEquipamento.addEventListener("click", e => {
            pnlAmbientes.style.display = "none";
            pnlEquipamentos.style.display = "flex";
            btnEquipamento.style.color = "#114a55";
            btnAmbiente.style.color = "#000";
        });
    }

    const txtInputData = document.querySelector("#txtInputData");
    const txtHorarioInicio = document.querySelector("#txtHorarioInicio");
    const txtHorarioFim = document.querySelector("#txtHorarioFim");
    const btnReservar = document.querySelector("#btnReservar");

    const data7dias = new Date(new Date().setDate(new Date().getDate() + 7));
    txtInputData.max = data7dias.toISOString().split("T")[0];
    btnReservar.setAttribute("disabled", "disabled");

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
});
