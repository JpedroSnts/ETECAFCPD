using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Repositorio.Util;
using CPD.Site.ViewModel;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Web;

namespace CPD.Site.Controller
{
    public class HomeController
    {
        public List<ReservaGenerica> ListarReservas(int rm, bool todas)
        {
            var list = new List<ReservaGenerica>();
            var raController = new ReservaAmbienteController();
            var reController = new ReservaEquipamentoController();
            foreach (var ra in raController.ListarReservasAmbientesProfessor(rm, todas))
            {
                list.Add(new ReservaGenerica(ra));
            }
            foreach (var re in reController.ListarReservasEquipamentosProfessor(rm, todas))
            {
                list.Add(new ReservaGenerica(re));
            }
            return list.OrderBy(e => e.DataSaidaPrevista).ToList();
        }

        public void CancelarReservas(string itens, int rm, DateTime data)
        {
            if (int.Parse(data.ToString().Substring(0, 2)) != int.Parse(DateTime.Now.ToString().Substring(0, 2)))
            {
                #region reservar
                var siglas = itens.Split(',');
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
                        reservaController.CancelarReserva(reserva);
                    }
                    if (tipoReserva[i] == "EQUIPAMENTO")
                    {
                        var reserva = new ReservaEquipamento() { Equipamento = new Equipamento { Sigla = siglas[i] }, DataSaidaPrevista = data, Usuario = new Usuario() { RM = rm } };
                        var reservaController = new ReservaEquipamentoController();
                        reservaController.CancelarReserva(reserva);
                    }
                }
                #endregion
            }
            else
            {
                if (int.Parse(data.ToString().Substring(11, 2)) - int.Parse(DateTime.Now.ToString().Substring(11, 2)) > 1)
                {
                    #region reservar
                    var siglas = itens.Split(',');
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
                            reservaController.CancelarReserva(reserva);
                        }
                        if (tipoReserva[i] == "EQUIPAMENTO")
                        {
                            var reserva = new ReservaEquipamento() { Equipamento = new Equipamento { Sigla = siglas[i] }, DataSaidaPrevista = data, Usuario = new Usuario() { RM = rm } };
                            var reservaController = new ReservaEquipamentoController();
                            reservaController.CancelarReserva(reserva);
                        }
                    }
                    #endregion
                }
                else
                {
                    if (int.Parse(data.ToString().Substring(11, 2)) - int.Parse(DateTime.Now.ToString().Substring(11, 2)) == 1)
                    {
                        if (int.Parse(data.ToString().Substring(14, 2)) > int.Parse(DateTime.Now.ToString().Substring(14, 2)))
                        {
                            #region reservar
                            var siglas = itens.Split(',');
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
                                    reservaController.CancelarReserva(reserva);
                                }
                                if (tipoReserva[i] == "EQUIPAMENTO")
                                {
                                    var reserva = new ReservaEquipamento() { Equipamento = new Equipamento { Sigla = siglas[i] }, DataSaidaPrevista = data, Usuario = new Usuario() { RM = rm } };
                                    var reservaController = new ReservaEquipamentoController();
                                    reservaController.CancelarReserva(reserva);
                                }
                            }
                            #endregion
                        }
                        else
                        {
                            return;
                        }
                    }

                }
            }
        }
    }
}