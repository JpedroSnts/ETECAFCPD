using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site.Controller
{
    public class HomeController
    {
        public List<ReservaGenerica> ListarReservas(int rm)
        {
            var list = new List<ReservaGenerica>();
            var raController = new ReservaAmbienteController();
            var reController = new ReservaEquipamentoController();
            foreach (var ra in raController.ListarReservasAmbientesProfessor(rm))
            {
                list.Add(new ReservaGenerica(ra));
            }
            foreach (var re in reController.ListarReservasEquipamentosProfessor(rm))
            {
                list.Add(new ReservaGenerica(re));
            }
            return list;
        }
    }
}