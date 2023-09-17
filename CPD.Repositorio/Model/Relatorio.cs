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
        public List<ReservaAmbiente> ReservaAmbiente { get; set; }
        public List<ReservaEquipamento> ReservaEquipamento { get; set; }
        public List<OcorrenciaAmbiente> OcorrenciaAmbiente { get; set; }
        public List<OcorrenciaEquipamento> OcorrenciaEquipamento { get; set; }

        public Relatorio(DateTime dataInicio, DateTime dataFim, string tipoRelatorio, List<ReservaAmbiente> reservaAmbiente, List<OcorrenciaAmbiente> ocorrenciaAmbiente, List<ReservaEquipamento> reservaEquipamento, List<OcorrenciaEquipamento> ocorrenciaEquipamento)
        {
            DataInicio = dataInicio;
            DataFim = dataFim;
            TipoRelatorio = tipoRelatorio;
            ReservaAmbiente = reservaAmbiente;
            OcorrenciaAmbiente = ocorrenciaAmbiente;
            ReservaEquipamento = reservaEquipamento;
            OcorrenciaEquipamento = ocorrenciaEquipamento;
        }

        public Relatorio(DateTime dataInicio, DateTime dataFim, string tipoRelatorio, List<ReservaAmbiente> reservaAmbiente, List<ReservaEquipamento> reservaEquipamento)
        {
            DataInicio = dataInicio;
            DataFim = dataFim;
            TipoRelatorio = tipoRelatorio;
            ReservaAmbiente = reservaAmbiente;
            ReservaEquipamento = reservaEquipamento;
        }
    }
}
