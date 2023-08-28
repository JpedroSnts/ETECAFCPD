using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace CPD.Repositorio.Controller
{
    public class EquipamentoController : ConexaoBanco
    {
        public List<Equipamento> ListarEquipamentosDisponiveis()
        {
            List<Equipamento> list = new List<Equipamento>();
            MySqlDataReader reader = Executar("listarEquipamentosDisponiveis", null);

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
