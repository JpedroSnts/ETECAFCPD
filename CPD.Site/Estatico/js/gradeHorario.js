window.addEventListener("load", () => {
    const btns = document.querySelectorAll(".btnExcluirUsoAmbiente");
    btns.forEach((el) => {
        el.addEventListener("click", (e) => {
            e.preventDefault();
            const dia = e.target.getAttribute("dia");
            const inicio = e.target.getAttribute("inicio");
            const fim = e.target.getAttribute("fim");
            fetch(`/Api/excluirGradeHorario.aspx?dia=${dia}&inicio=${inicio}&fim=${fim}`).then(() => {
                location.reload();
            });
        });
    });
});
