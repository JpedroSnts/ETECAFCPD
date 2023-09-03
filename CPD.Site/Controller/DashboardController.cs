using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site.Controller
{
    public class DashboardController
    {
        public List<ReservaGenerica> ListarReservas(string filtro, EStatusReserva status, DateTime data)
        {
            var list = new List<ReservaGenerica>();
            var raController = new ReservaAmbienteController();
            var reController = new ReservaEquipamentoController();
            foreach (var ra in raController.ListarReservasAmbientesComFiltro(filtro, data, status))
            {
                list.Add(new ReservaGenerica(ra));
            }
            foreach (var re in reController.ListarReservasEquipamentosComFiltro(filtro, data, status))
            {
                list.Add(new ReservaGenerica(re));
            }
            return list;
        }

        public List<ItemLivreDTO> ListarItensDisponiveis()
        {
            throw new NotImplementedException();
        }
    }
}