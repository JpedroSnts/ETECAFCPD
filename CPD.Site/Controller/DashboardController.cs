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

        public void ConcluirReserva(int rm, string itens, string status, DateTime data)
        {
            var siglas = itens.Split(',');
            var enumStatus = (EStatusReserva)int.Parse(status);
            var ambienteController = new AmbienteController();
            string[] tipoReserva = new string[siglas.Length];
            for (int i = 0; i < siglas.Length; i++)
            {
                var a = ambienteController.ListarAmbiente(new Ambiente { Sigla = siglas[i] });
                if (a != null)
                    tipoReserva[i] = "AMBIENTE";
                else
                    tipoReserva[i] = "EQUIPAMENTO";
            }
            
            for (int i = 0; i < siglas.Length; i++)
            {
                if (tipoReserva[i] == "AMBIENTE")
                {
                    var reserva = new ReservaAmbiente() { Ambiente = new Ambiente { Sigla = siglas[i] }, DataSaidaPrevista = data, Usuario = new Usuario() { RM = rm } };
                    var reservaController = new ReservaAmbienteController();
                    if (enumStatus == EStatusReserva.AguardandoRetirada) reservaController.AtualizarSaida(reserva);
                    if (enumStatus == EStatusReserva.EmAndamento || enumStatus == EStatusReserva.EntregaAtrasada) reservaController.AtualizarDevolucao(reserva);
                    if (enumStatus == EStatusReserva.NaoRetirado) reservaController.CancelarReserva(reserva);
                }
                if (tipoReserva[i] == "EQUIPAMENTO")
                {
                    var reserva = new ReservaEquipamento() { Equipamento = new Equipamento { Sigla = siglas[i] }, DataSaidaPrevista = data, Usuario = new Usuario() { RM = rm } };
                    var reservaController = new ReservaEquipamentoController();
                    if (enumStatus == EStatusReserva.AguardandoRetirada) reservaController.AtualizarSaida(reserva);
                    if (enumStatus == EStatusReserva.EmAndamento || enumStatus == EStatusReserva.EntregaAtrasada) reservaController.AtualizarDevolucao(reserva);
                    if (enumStatus == EStatusReserva.NaoRetirado) reservaController.CancelarReserva(reserva);
                }
            }

        }
    }
}