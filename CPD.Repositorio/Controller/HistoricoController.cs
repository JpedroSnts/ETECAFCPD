using System;
using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Controller
{
    public class HistoricoController: Banco.ConexaoBanco
    {
        public List<ReservaAmbiente> listarRA(string rm)
        {
            List<ReservaAmbiente> lista = new List<ReservaAmbiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRm", rm)
            };
            MySqlDataReader reader = Executar("historicoProfessorAmbiente", parametros);
            while (reader.Read())
            {
                ReservaAmbiente reservaAmbiente = new ReservaAmbiente();
                {
                    reservaAmbiente.Ambiente = new Ambiente { Sigla = reader.GetString("sg_ambiente") };
                    reservaAmbiente.DataSaida = DateTime.Parse(reader.GetString("dt_saida"));
                    reservaAmbiente.DataDevolucao = DateTime.Parse(reader.GetString("dt_devolucao"));
                }
                lista.Add(reservaAmbiente);
            }
            return lista;
        }

        public List<ReservaEquipamento> listarRE(string rm)
        {
            List<ReservaEquipamento> lista = new List<ReservaEquipamento>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRm", rm)
            };
            MySqlDataReader reader = Executar("historicoProfessorEquipamento", parametros);
            while (reader.Read())
            {
                ReservaEquipamento reservaEquipamento = new ReservaEquipamento();
                {
                    reservaEquipamento.Equipamento = new Equipamento { Sigla = reader.GetString("sg_equipamento") };
                    reservaEquipamento.DataSaida = DateTime.Parse(reader.GetString("dt_saida"));
                    reservaEquipamento.DataDevolucao = DateTime.Parse(reader.GetString("dt_devolucao"));
                }
                lista.Add(reservaEquipamento);
            }
            return lista;
        }
    }
}
