using CPD.Repositorio.Model;
using System;

namespace CPD.Site.ViewModel
{
    public class ReservaGenerica
    {
        public string SiglaItem { get; set; }
        public string NomeItem { get; set; }
        public Usuario Usuario { get; set; }
        public DateTime DataSaidaPrevista { get; set; }
        public DateTime DataSaida { get; set; }
        public DateTime DataDevolucaoPrevista { get; set; }
        public DateTime DataDevolucao { get; set; }
        public DateTime DataCancelamento { get; set; }

        public ReservaGenerica(ReservaAmbiente reserva)
        {
            AtribuirValores(reserva.Ambiente.Sigla, reserva.Ambiente.Nome,
                            reserva.Usuario, reserva.DataSaidaPrevista, reserva.DataSaida,
                            reserva.DataDevolucaoPrevista, reserva.DataDevolucao, reserva.DataCancelamento);
        }
        public ReservaGenerica(ReservaEquipamento reserva)
        {
            AtribuirValores(reserva.Equipamento.Sigla, reserva.Equipamento.Nome,
                            reserva.Usuario, reserva.DataSaidaPrevista, reserva.DataSaida,
                            reserva.DataDevolucaoPrevista, reserva.DataDevolucao, reserva.DataCancelamento);
        }

        private void AtribuirValores(string sigla, string nome, Usuario usuario, DateTime dataSaidaPrevista, DateTime dataSaida, DateTime dataDevolucaoPrevista, DateTime dataDevolucao, DateTime dataCancelamento)
        {
            SiglaItem = sigla;
            NomeItem = nome;
            Usuario = usuario;
            DataSaidaPrevista = dataSaidaPrevista;
            DataSaida = dataSaida;
            DataDevolucaoPrevista = dataDevolucaoPrevista;
            DataDevolucao = dataDevolucao;
            DataCancelamento = dataCancelamento;
        }
    }
}