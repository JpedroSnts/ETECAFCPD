using CPD.Repositorio.Controller;
using CPD.Site.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site.Controller
{
    public class DashboardController
    {
        public List<ReservaGenerica> ListarReservasDeHoje()
        {
            var list = new List<ReservaGenerica>();
            var raController = new ReservaAmbienteController();
            var reController = new ReservaEquipamentoController();
            foreach (var ra in raController.ListarReservasAmbientesDeHoje())
            {
                list.Add(new ReservaGenerica(ra));
            }
            foreach (var re in reController.ListarReservasEquipamentosDeHoje())
            {
                list.Add(new ReservaGenerica(re));
            }
            return list;
        }
    }
}