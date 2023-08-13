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
        private ReservaEquipamento InstanciarReservaEquipamento(MySqlDataReader reader)
        {
            return new ReservaEquipamento
            {
                Equipamento = new Equipamento
                {
                    Sigla = reader["sg_equipamento"].ToString(),
                    Nome = reader["nm_equipamento"].ToString(),
                    Danificado = reader.GetBoolean("ic_danificado"),
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

        public ReservaEquipamento Reservar(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pDTDevolucaoPrevista", reservaEquipamento.DataDevolucaoPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("reservarEquipamento", parametros);
            ReservaEquipamento reservaEquipamentoInsert = null;
            if (reader.Read())
            {
                reservaEquipamentoInsert = InstanciarReservaEquipamento(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaEquipamentoInsert;
        }

        public ReservaEquipamento AtualizarDevolucao(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("atualizarDevolucaoReservaEquipamento", parametros);
            ReservaEquipamento reservaEquipamentoInsert = null;
            if (reader.Read())
            {
                reservaEquipamentoInsert = InstanciarReservaEquipamento(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaEquipamentoInsert;
        }

        public ReservaEquipamento AtualizarSaida(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("atualizarSaidaReservaEquipamento", parametros);
            ReservaEquipamento reservaEquipamentoInsert = null;
            if (reader.Read())
            {
                reservaEquipamentoInsert = InstanciarReservaEquipamento(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaEquipamentoInsert;
        }

        public ReservaEquipamento CancelarReserva(ReservaEquipamento reservaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", reservaEquipamento.Equipamento.Sigla),
                new Parametro("pRM", reservaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDTSaidaPrevista", reservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss"))
            };
            MySqlDataReader reader = Executar("cancelarReservaEquipamento", parametros);
            ReservaEquipamento reservaEquipamentoInsert = null;
            if (reader.Read())
            {
                reservaEquipamentoInsert = InstanciarReservaEquipamento(reader);
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return reservaEquipamentoInsert;
        }
    }
}
