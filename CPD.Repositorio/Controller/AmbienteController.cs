using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;

namespace CPD.Repositorio.Controller
{
    public class AmbienteController : ConexaoBanco
    {
        public List<Ambiente> ListarAmbientesDisponiveis(DateTime inicio, DateTime fim)
        {
            List<Ambiente> list = new List<Ambiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDTSaidaPrevista", inicio.ToString("yyyy-MM-dd HH:mm:ss")),
                new Parametro("pDTDevolucaoPrevista", fim.ToString("yyyy-MM-dd HH:mm:ss"))
            };
            MySqlDataReader reader = Executar("listarAmbientesDisponiveis", parametros);

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
