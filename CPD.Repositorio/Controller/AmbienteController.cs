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

        public List<Ambiente> ListarAmbientesDisponiveisSigla(string sigla, DateTime inicio, DateTime fim)
        {
            List<Ambiente> list = new List<Ambiente>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSigla", sigla),
                new Parametro("pDTSaidaPrevista", inicio.ToString("yyyy-MM-dd HH:mm:ss")),
                new Parametro("pDTDevolucaoPrevista", fim.ToString("yyyy-MM-dd HH:mm:ss"))
            };
            MySqlDataReader reader = Executar("listarAmbientesDisponiveisSigla", parametros);

            while (reader.Read())
            {
                list.Add(new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() });
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }

        public Ambiente ListarAmbiente(Ambiente ambiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSigla", ambiente.Sigla)
            };
            MySqlDataReader reader = Executar("listarAmbiente", parametros);
            Ambiente a = null;
            if (reader.Read())
            {
                a = new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() };
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return a;
        }

        public List<Ambiente> ListarAmbientes()
        {
            MySqlDataReader reader = Executar("listarAmbientes", null);
            List<Ambiente> list = new List<Ambiente>();
            while (reader.Read())
            {
                list.Add(new Ambiente { Sigla = reader["sg_ambiente"].ToString(), Nome = reader["nm_ambiente"].ToString() });
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }

        public bool AdicionarAmbiente(string sigla, string nome )
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", sigla),
                new Parametro("pNomeAmbiente", nome)
            };

            try
            {
                MySqlDataReader reader = Executar("adicionarAmbiente", parametros);
            }
            catch
            {
                return false;
            }

            Desconectar();
            return true;
        }
    }
}
