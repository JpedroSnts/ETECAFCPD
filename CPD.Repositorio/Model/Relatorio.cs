using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Model
{
    public class Relatorio
    {
        public DateTime DataInicio { get; set; }   
        public DateTime DataFim { get; set; }
        public string TipoRelatorio { get; set; }
        public List<ReservaAmbiente> Reserva { get; set; }
        public List<OcorrenciaAmbiente> Ocorrencia { get; set; }

        public Relatorio(DateTime dataInicio, DateTime dataFim, string tipoRelatorio, List<ReservaAmbiente> reservaAmbiente, List<OcorrenciaAmbiente> ocorrenciaAmbiente)
        {
            DataInicio = dataInicio;
            DataFim = dataFim;
            TipoRelatorio = tipoRelatorio;
            Reserva = reservaAmbiente;
            Ocorrencia = ocorrenciaAmbiente;
        }

        public Relatorio(DateTime dataInicio, DateTime dataFim, string tipoRelatorio, List<ReservaAmbiente> reservaAmbiente)
        {
            DataInicio = dataInicio;
            DataFim = dataFim;
            TipoRelatorio = tipoRelatorio;
            Reserva = reservaAmbiente;
        }
    }
}
