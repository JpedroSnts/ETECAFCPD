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
        private ReservaAmbiente InstanciarReservaAmbiente(MySqlDataReader reader)
        {
            return new ReservaAmbiente
            {
                Ambiente = new Ambiente
                {
                    Sigla = reader["sg_ambiente"].ToString(),
                    Nome = reader["nm_ambiente"].ToString()
                },
                Usuario = new Usuario
                {
                    RM = reader.GetInt32("cd_rm"),
                    Nome = reader["nm_usuario"].ToString(),
                    Email = reader["nm_email"].ToString(),
                    ReferenciaImagem = reader["nm_referencia_imagem"].ToString(),
                    TipoUsuario = new TipoUsuario
                    {
                        Codigo = reader.GetInt32("cd_tipo_usuario"),
                        Nome = reader["nm_tipo_usuario"].ToString(),
                    }
                },
                DataSaidaPrevista = DateTime.Parse(reader["dt_saida_prevista"].ToString()),
                DataDevolucaoPrevista = DateTime.Parse(reader["dt_devolucao_prevista"].ToString()),
                DataSaida = DateTime.Parse(reader["dt_saida"].ToString()),
                DataDevolucao = DateTime.Parse(reader["dt_devolucao"].ToString()),
                DataCancelamento = DateTime.Parse(reader["dt_cancelamento"].ToString()),
            };
        }

        public ReservaAmbiente Reservar(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pDTDevolucaoPrevista", reservaAmbiente.DataDevolucaoPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("reservarAmbiente", parametros);
            ReservaAmbiente reservaAmbienteInsert = null;
            if (reader.Read())
            {
                reservaAmbienteInsert = InstanciarReservaAmbiente(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaAmbienteInsert;
        }

        public ReservaAmbiente AtualizarDevolucao(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("atualizarDevolucaoReservaAmbiente", parametros);
            ReservaAmbiente reservaAmbienteInsert = null;
            if (reader.Read())
            {
                reservaAmbienteInsert = InstanciarReservaAmbiente(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaAmbienteInsert;
        }

        public ReservaAmbiente AtualizarSaida(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("atualizarSaidaReservaAmbiente", parametros);
            ReservaAmbiente reservaAmbienteInsert = null;
            if (reader.Read())
            {
                reservaAmbienteInsert = InstanciarReservaAmbiente(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaAmbienteInsert;
        }

        public ReservaAmbiente CancelarReserva(ReservaAmbiente reservaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", reservaAmbiente.Ambiente.Sigla),
                new Parametro("pRM", reservaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("cancelarReservaAmbiente", parametros);
            ReservaAmbiente reservaAmbienteInsert = null;
            if (reader.Read())
            {
                reservaAmbienteInsert = InstanciarReservaAmbiente(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaAmbienteInsert;
        }
    }
}
