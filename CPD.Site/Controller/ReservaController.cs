using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace CPD.Site.Controller
{
    public class ReservaController
    {
        public List<EquipamentoLivre> ListarEquipamentosLivres(DateTime inicio, DateTime fim)
        {
            EquipamentoController equipamentoController = new EquipamentoController();
            List<Equipamento> equipamentos = equipamentoController.ListarEquipamentosDisponiveis(inicio, fim);

            // Lógica para transformar List<Equipamento> em List<EquipamentoLivre>

            List<EquipamentoLivre> equipamentosLivres = new List<EquipamentoLivre>();
            return equipamentosLivres;
        }
    }
}