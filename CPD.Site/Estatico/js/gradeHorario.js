window.addEventListener("load", () => {
    const btns = document.querySelectorAll("#iconLixeira");
    btns.forEach((el) => {
        el.addEventListener("click", (e) => {
            e.preventDefault();
            const dia = e.target.parentNode.getAttribute("dia");
            const inicio = e.target.parentNode.getAttribute("inicio");
            const fim = e.target.parentNode.getAttribute("fim");
            fetch(`/Api/excluirGradeHorario.aspx?dia=${dia}&inicio=${inicio}&fim=${fim}`).then(() => {
                location.reload();
            });
        });
    });
});
