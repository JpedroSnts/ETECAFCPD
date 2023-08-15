using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Controller
{
    public class ReservaEquipamentoController : ConexaoBanco
    {
        public void Reservar(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pDTDevolucaoPrevista", reservaEquipamento.DataDevolucaoPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("reservarEquipamento", parametros);
            Desconectar();
        }

        public void AtualizarDevolucao(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("atualizarDevolucaoReservaEquipamento", parametros);
            Desconectar();
        }

        public void AtualizarSaida(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("atualizarSaidaReservaEquipamento", parametros);
            Desconectar();
        }

        public void CancelarReserva(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("cancelarReservaEquipamento", parametros);
            Desconectar();
        }
    }
}
