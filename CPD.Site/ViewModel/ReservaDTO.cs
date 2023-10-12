using CPD.Repositorio.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site.ViewModel
{
    public class ReservaDTO
    {
        public DateTime DataSaidaPrevista { get; set; }
        private DateTime DataCancelamento { get; set; }
        public int RM { get; set; }
        public string Horario { get; set; }
        public string Itens { get; set; }
        public string ItensNome { get; set; }
        public string Professor { get; set; }
        public EStatusReserva StatusReserva { get; set; }

        public ReservaDTO(List<ReservaGenerica> reservas, DateTime data, int rm, DateTime dataCancelamento)
        {
            DataCancelamento = dataCancelamento;
            DataSaidaPrevista = data;
            RM = rm;
            List<ReservaGenerica> novaLista = new List<ReservaGenerica>();
            foreach (var reserva in reservas)
            {
                if (reserva.DataSaidaPrevista == DataSaidaPrevista && reserva.Usuario.RM == rm && reserva.DataCancelamento == DataCancelamento)
                {
                    novaLista.Add(reserva);
                } 
            }
            Horario = novaLista[0].DataSaidaPrevista.ToString("HH:mm") + " - " + novaLista[0].DataDevolucaoPrevista.ToString("HH:mm");
            Professor = novaLista[0].Usuario.Nome;
            StatusReserva = novaLista[0].StatusReserva;
            foreach (var reserva in novaLista)
            {
                Itens += reserva.SiglaItem + ", ";
                ItensNome += reserva.NomeItem + ", ";
            }
            Itens = Itens.Substring(0, Itens.Length - 2);
            ItensNome = ItensNome.Substring(0, ItensNome.Length - 2);
        }

        public static List<ReservaDTO> OrdenarReservas(List<ReservaGenerica> reservas)
        {
            List<ReservaDTO> reservaDTOs = new List<ReservaDTO>();
            foreach (var l in reservas)
            {
                reservaDTOs.Add(new ReservaDTO(reservas, l.DataSaidaPrevista, l.Usuario.RM, l.DataCancelamento));
            }
            return reservaDTOs.Distinct().ToList();
        }

        public override bool Equals(object obj)
        {
            return obj is ReservaDTO dTO &&
                   DataSaidaPrevista == dTO.DataSaidaPrevista &&
                   RM == dTO.RM &&
                   Itens == dTO.Itens;
        }

        public override int GetHashCode()
        {
            int hashCode = -928365875;
            hashCode = hashCode * -1521134295 + DataSaidaPrevista.GetHashCode();
            hashCode = hashCode * -1521134295 + RM.GetHashCode();
            hashCode = hashCode * -1521134295 + EqualityComparer<string>.Default.GetHashCode(Itens);
            return hashCode;
        }
    }
}