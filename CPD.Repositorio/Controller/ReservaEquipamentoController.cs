using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using CPD.Repositorio.Util;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;

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

        public List<ReservaEquipamento> ListarReservasEquipamentosComFiltro(string filtro, DateTime data, EStatusReserva status)
        {
            int statusParam = (int)status;
            string dataParam = data == default ? null : data.ToString("yyyy-MM-dd");
            List<ReservaEquipamento> list = new List<ReservaEquipamento>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pFiltro", filtro),
                new Parametro("pData", dataParam),
                new Parametro("pCodigoStatus", statusParam.ToString())
            };
            MySqlDataReader reader = Executar("listarReservasEquipamentos", parametros);

            while (reader.Read())
            {
                ReservaEquipamento da = new ReservaEquipamento()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString() },
                    Equipamento = new Equipamento { Sigla = reader["sg_equipamento"].ToString() },
                    DataSaidaPrevista = Data.DateTimeParse(reader["dt_saida_prevista"].ToString()),
                    DataDevolucaoPrevista = Data.DateTimeParse(reader["dt_devolucao_prevista"].ToString()),
                    DataSaida = Data.DateTimeParse(reader["dt_saida"].ToString()),
                    DataDevolucao = Data.DateTimeParse(reader["dt_devolucao"].ToString()),
                    DataCancelamento = Data.DateTimeParse(reader["dt_cancelamento"].ToString()),
                    StatusReserva = (EStatusReserva) reader.GetInt16("cd_status")
                };

                list.Add(da);
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }

        public List<ReservaEquipamento> ListarReservasEquipamentosProfessor(int rm)
        {
            List<ReservaEquipamento> list = new List<ReservaEquipamento>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRm", rm.ToString()),
            };
            MySqlDataReader reader = Executar("listarReservasEquipamentosProfessor", parametros);

            while (reader.Read())
            {
                ReservaEquipamento da = new ReservaEquipamento()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString() },
                    Equipamento = new Equipamento { Sigla = reader["sg_equipamento"].ToString(), Nome = reader["nm_equipamento"].ToString() },
                    DataSaidaPrevista = Data.DateTimeParse(reader["dt_saida_prevista"].ToString()),
                    DataDevolucaoPrevista = Data.DateTimeParse(reader["dt_devolucao_prevista"].ToString()),
                    DataSaida = Data.DateTimeParse(reader["dt_saida"].ToString()),
                    DataDevolucao = Data.DateTimeParse(reader["dt_devolucao"].ToString()),
                    DataCancelamento = Data.DateTimeParse(reader["dt_cancelamento"].ToString()),
                    StatusReserva = (EStatusReserva)reader.GetInt16("cd_status")
                };

                list.Add(da);
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }
    }
}
