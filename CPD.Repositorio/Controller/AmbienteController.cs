using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace CPD.Repositorio.Controller
{
    public class AmbienteController : ConexaoBanco
    {
        public List<Ambiente> ListarAmbientesDisponiveis()
        {
            List<Ambiente> list = new List<Ambiente>();
            MySqlDataReader reader = Executar("listarAmbientesDisponiveis", null);

            while (reader.Read())
            {
                list.Add(new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() });
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }
    }
}
