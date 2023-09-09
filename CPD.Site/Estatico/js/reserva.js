window.addEventListener("load", () => {
	const btnAmbiente = document.querySelector("#Ambiente");
	const btnEquipamento = document.querySelector("#Equipamento");
	const pnlAmbientes = document.querySelector("#pnlAmbientes");
	const pnlEquipamentos = document.querySelector("#pnlEquipamentos");

	pnlEquipamentos.childNodes.forEach(e => {
		if (e.tagName == "DIV") {
			const qts = e.querySelector("input.numQtEquip");
			e.querySelector(".iconMais").addEventListener("click", e => {
				qts.value = Number(qts.value) == Number(qts.getAttribute("maxlength")) ? Number(qts.getAttribute("maxlength")) : Number(qts.value) + 1;
			});
			e.querySelector(".iconMenos").addEventListener("click", e => {
				qts.value = Number(qts.value) == 0 ? 0 : Number(qts.value) - 1;
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
});