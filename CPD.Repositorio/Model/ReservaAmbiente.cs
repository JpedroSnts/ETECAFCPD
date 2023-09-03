using System;

namespace CPD.Repositorio.Model
{
    public class ReservaAmbiente
    {
        public Ambiente Ambiente { get; set; }
        public Usuario Usuario { get; set; }
        public DateTime DataSaidaPrevista { get; set; }
        public DateTime DataSaida { get; set; }
        public DateTime DataDevolucaoPrevista { get; set; }
        public DateTime DataDevolucao { get; set; }
        public DateTime DataCancelamento { get; set; }
        public EStatusReserva StatusReserva { get; set; }
    }
}
