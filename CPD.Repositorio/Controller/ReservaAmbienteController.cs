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
    public class ReservaAmbienteController : ConexaoBanco
    {
        public void Reservar(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pDTDevolucaoPrevista", reservaAmbiente.DataDevolucaoPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("reservarAmbiente", parametros);
            Desconectar();
        }

        public void AtualizarDevolucao(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("atualizarDevolucaoReservaAmbiente", parametros);
            Desconectar();
        }

        public void AtualizarSaida(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("atualizarSaidaReservaAmbiente", parametros);
            Desconectar();
        }

        public void CancelarReserva(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            Executar("cancelarReservaAmbiente", parametros);
            Desconectar();
        }
    }
}
