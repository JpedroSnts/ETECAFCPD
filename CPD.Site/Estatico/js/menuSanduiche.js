var menuSanduiche = document.querySelector("#iconMenuSanduiche");
var menuSanduicheFunc = document.querySelector("#iconMenuSanduicheFunc");
var menu = document.querySelector("#menuSanduiche");

var telaBloqueio = document.querySelector(".bloqueio");
var formsMenu = document.querySelector("#divMenu");

menuSanduiche?.addEventListener("click", TelaMenuSanduiche);
menuSanduicheFunc?.addEventListener("click", TelaMenuSanduiche);
telaBloqueio?.addEventListener("click", FecharTelaMenuSanduiche);

function TelaMenuSanduiche(event) {
	event.preventDefault();
	telaBloqueio.classList.remove("escondido");
	formsMenu.classList.remove("escondido");
}

function FecharTelaMenuSanduiche(event) {
	event.preventDefault();
	telaBloqueio.classList.add("escondido");
	formsMenu.classList.add("escondido");
}