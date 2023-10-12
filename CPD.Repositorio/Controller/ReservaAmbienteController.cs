using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using CPD.Repositorio.Util;

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

        public List<ReservaAmbiente> ListarReservasAmbientesComFiltro(string filtro, DateTime data, EStatusReserva status)
        
        {
            int statusParam = (int)status;
            string dataParam = data == default ? null : data.ToString("yyyy-MM-dd");
            List<ReservaAmbiente> list = new List<ReservaAmbiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pFiltro", filtro),
                new Parametro("pData", dataParam),
                new Parametro("pCodigoStatus", statusParam.ToString())
            };
            MySqlDataReader reader = Executar("listarReservasAmbientes", parametros);

            while (reader.Read())
            {
                ReservaAmbiente da = new ReservaAmbiente()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString() },
                    Ambiente = new Ambiente { Sigla = reader["sg_ambiente"].ToString() },
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

        public List<ReservaAmbiente> ListarReservasAmbientesProfessor(int rm)
        {
            List<ReservaAmbiente> list = new List<ReservaAmbiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRm", rm.ToString()),
            };
            MySqlDataReader reader = Executar("listarReservasAmbientesProfessor", parametros);

            while (reader.Read())
            {
                ReservaAmbiente da = new ReservaAmbiente()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString() },
                    Ambiente = new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() },
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
    }
}
