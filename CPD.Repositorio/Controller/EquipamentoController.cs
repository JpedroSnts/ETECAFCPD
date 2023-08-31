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
    }
}
