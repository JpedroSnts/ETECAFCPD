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
        public List<ItemLivreDTO> ListarItensLivres(DateTime inicio, DateTime fim)
        {
            EquipamentoController equipamentoController = new EquipamentoController();
            AmbienteController ambienteController = new AmbienteController();
            List<Equipamento> equipamentos = equipamentoController.ListarEquipamentosDisponiveis(inicio, fim);
            List<Ambiente> ambientes = ambienteController.ListarAmbientesDisponiveis(inicio, fim);
            List<ItemGenerico> itensGenericos = ItemGenerico.GerarListaItemGenerico(equipamentos, ambientes);
            return ItemLivreDTO.GerarListaItemLivreDTO(itensGenericos);
        }

    }
}