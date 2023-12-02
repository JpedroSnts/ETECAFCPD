using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;

namespace CPD.Repositorio.Controller
{
    public class EquipamentoController : ConexaoBanco
    {
        public List<Equipamento> ListarEquipamentosDisponiveis(DateTime inicio, DateTime fim)
        {
            List<Equipamento> list = new List<Equipamento>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDTSaidaPrevista", inicio.ToString("yyyy-MM-dd HH:mm:ss")),
                new Parametro("pDTDevolucaoPrevista", fim.ToString("yyyy-MM-dd HH:mm:ss"))
            };
            MySqlDataReader reader = Executar("listarEquipamentosDisponiveis", parametros);

            while (reader.Read())
            {
                list.Add(new Equipamento { Sigla = reader["sg_equipamento"].ToString(), Nome = reader["nm_equipamento"].ToString() });
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }

        public List<Equipamento> ListarEquipamentosDisponiveisSigla(string sigla, DateTime inicio, DateTime fim)
        {
            List<Equipamento> list = new List<Equipamento>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSigla", sigla),
                new Parametro("pDTSaidaPrevista", inicio.ToString("yyyy-MM-dd HH:mm:ss")),
                new Parametro("pDTDevolucaoPrevista", fim.ToString("yyyy-MM-dd HH:mm:ss"))
            };
            MySqlDataReader reader = Executar("listarEquipamentosDisponiveisSigla", parametros);

            while (reader.Read())
            {
                list.Add(new Equipamento { Sigla = reader["sg_equipamento"].ToString(), Nome = reader["nm_equipamento"].ToString() });
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }

        public Equipamento ListarEquipamento(Equipamento equipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSigla", equipamento.Sigla)
            };
            MySqlDataReader reader = Executar("listarEquipamento", parametros);
            Equipamento e = null;
            while (reader.Read())
            {
                e = new Equipamento { Sigla = reader["sg_equipamento"].ToString(), Nome = reader["nm_equipamento"].ToString() };
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return e;
        }

        public bool AdicionarEquipamento(string sigla, string nome)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", sigla),
                new Parametro("pNomeEquipamento", nome)
            };

            try
            {
                MySqlDataReader reader = Executar("adicionarEquipamento", parametros);
            }
            catch
            {
                Desconectar();
                return false;
            }

            Desconectar();
            return true;
        }
    }
}
