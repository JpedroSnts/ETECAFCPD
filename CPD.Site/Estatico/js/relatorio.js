const select = document.getElementById('relatorioSelect');
select.addEventListener('change', function() {
    if (select.value !== '') {
    select.classList.add('habilitado');
    } else {
    select.classList.remove('habilitado');
    }
});

const inputDateI = document.getElementById('dataInicio');
inputDateI.addEventListener('change', function() {
    if (inputDateI.value !== '') {
    inputDateI.classList.add('habilitado');
    } else {
    inputDateI.classList.remove('habilitado');
    }
});

const inputDateF = document.getElementById('dataFim');
inputDateF.addEventListener('change', function() {
    if (inputDateF.value !== '') {
    inputDateF.classList.add('habilitado');
    } else {
    inputDateF.classList.remove('habilitado');
    }
});

const iconeUsuario = document.getElementById('iconeUsuario');
const menuUsuario = document.getElementById('menuUsuario');

iconeUsuario.addEventListener('click', function() {
    if (menuUsuario.style.display === 'block') {
    menuUsuario.style.display = 'none';
    } else {
    menuUsuario.style.display = 'flex';
    }
});

document.addEventListener('click', function(event) {
    const target = event.target;

if (target !== menuUsuario && target !== iconeUsuario) {
    menuUsuario.style.display = 'none';
    }
});

menuUsuario.addEventListener('click', function(event) {
    event.stopPropagation();
});