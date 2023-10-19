using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using CPD.Repositorio.Util;
using Google.Protobuf.Collections;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Controller
{
    public class RelatorioController : ConexaoBanco
    {
        public Relatorio relatorioOcorrencia(DateTime dataInicio, DateTime dataFinal)
        {
            List<ReservaAmbiente> listRa = new List<ReservaAmbiente>();
            List<OcorrenciaAmbiente> listOa = new List<OcorrenciaAmbiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDataInicio", dataInicio.ToString("yyyy-MM-dd")),
                new Parametro("pDataFinal", dataFinal.ToString("yyyy-MM-dd"))
            };

            MySqlDataReader reader = Executar("relatorioOcorrencia", parametros);

            Relatorio relatorio = null;
            while (reader.Read())
            {
                OcorrenciaAmbiente oa = new OcorrenciaAmbiente()
                {
                    Data = Data.DateTimeParse(reader["dt_ocorrencia"].ToString()),
                    Descricao = reader["ds_ocorrencia"].ToString(),
                    TipoOcorrencia = new TipoOcorrenciaAmbiente()
                    {
                        Nome = reader["nm_tipo_ocorrencia"].ToString()
                    }
                };
                listOa.Add(oa);

                ReservaAmbiente ra = new ReservaAmbiente()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString(), Email = reader["nm_email"].ToString() },
                    Ambiente = new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() },
                    DataSaidaPrevista = Data.DateTimeParse(reader["dt_saida_prevista"].ToString()),
                    DataDevolucaoPrevista = Data.DateTimeParse(reader["dt_devolucao_prevista"].ToString()),
                    DataSaida = Data.DateTimeParse(reader["dt_saida"].ToString()),
                    DataDevolucao = Data.DateTimeParse(reader["dt_devolucao"].ToString()),
                };
                listRa.Add(ra);
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            relatorio = new Relatorio(dataInicio, dataFinal, "Ocorrências", listRa, listOa);

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return relatorio;
        }

        public Relatorio relatorioReservasCanceladas(DateTime dataInicio, DateTime dataFinal)
        {
            Relatorio relatorio = null;
            List<ReservaAmbiente> listRa = new List<ReservaAmbiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDataInicio", dataInicio.ToString("yyyy-MM-dd")),
                new Parametro("pDataFinal", dataFinal.ToString("yyyy-MM-dd"))
            };
            MySqlDataReader reader = Executar("relatorioReservasCanceladas", parametros);

            while (reader.Read())
            {
                ReservaAmbiente ra = new ReservaAmbiente()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString(), Email = reader["nm_email"].ToString()},
                    Ambiente = new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() },
                    DataSaidaPrevista = Data.DateTimeParse(reader["dt_saida_prevista"].ToString()),
                    DataDevolucaoPrevista = Data.DateTimeParse(reader["dt_devolucao_prevista"].ToString()),
                    DataSaida = Data.DateTimeParse(reader["dt_saida"].ToString()),
                    DataDevolucao = Data.DateTimeParse(reader["dt_devolucao"].ToString()),
                    DataCancelamento = Data.DateTimeParse(reader["dt_cancelamento"].ToString()),
                };
                listRa.Add(ra);
            }
            relatorio = new Relatorio(dataInicio, dataFinal, "Reservas Canceladas", listRa);

            return relatorio;
        }

        public Relatorio relatorioReservasAtrasadas(DateTime dataInicio, DateTime dataFinal)
        {
            Relatorio relatorio = null;
            List<ReservaAmbiente> listRa = new List<ReservaAmbiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDataInicio", dataInicio.ToString("yyyy-MM-dd")),
                new Parametro("pDataFinal", dataFinal.ToString("yyyy-MM-dd"))
            };
            MySqlDataReader reader = Executar("relatorioReservasAtrasadas", parametros);

            while (reader.Read())
            {
                ReservaAmbiente ra = new ReservaAmbiente()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString(), Email = reader["nm_email"].ToString() },
                    Ambiente = new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() },
                    DataSaidaPrevista = Data.DateTimeParse(reader["dt_saida_prevista"].ToString()),
                    DataDevolucaoPrevista = Data.DateTimeParse(reader["dt_devolucao_prevista"].ToString()),
                    DataSaida = Data.DateTimeParse(reader["dt_saida"].ToString()),
                    DataDevolucao = Data.DateTimeParse(reader["dt_devolucao"].ToString()),
                };
                listRa.Add(ra);
            }

            relatorio = new Relatorio(dataInicio, dataFinal, "Reservas Atrasadas", listRa);

            return relatorio;
        }

        public Relatorio relatorioReservasNaoRealizadas(DateTime dataInicio, DateTime dataFinal)
        {
            Relatorio relatorio = null;
            List<ReservaAmbiente> listRa = new List<ReservaAmbiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDataInicio", dataInicio.ToString("yyyy-MM-dd")),
                new Parametro("pDataFinal", dataFinal.ToString("yyyy-MM-dd"))
            };
            MySqlDataReader reader = Executar("relatorioReservasNaoRealizadas", parametros);

            while (reader.Read())
            {
                ReservaAmbiente ra = new ReservaAmbiente()
                {
                    Usuario = new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString(), Email = reader["nm_email"].ToString() },
                    Ambiente = new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString()},
                    DataSaidaPrevista = Data.DateTimeParse(reader["dt_saida_prevista"].ToString()),
                    DataDevolucaoPrevista = Data.DateTimeParse(reader["dt_devolucao_prevista"].ToString()),
                    DataSaida = Data.DateTimeParse(reader["dt_saida"].ToString()),
                    DataDevolucao = Data.DateTimeParse(reader["dt_devolucao"].ToString()),
                };
                listRa.Add(ra);
            }
            relatorio = new Relatorio(dataInicio, dataFinal, "Reservas Não Realizadas", listRa);

            return relatorio;
        }
    }
}
