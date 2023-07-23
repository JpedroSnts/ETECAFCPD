using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;


namespace CPD.Repositorio.Banco
{
    public abstract class Conexao
    {
        string linhaConexao = "";
        MySqlConnection conexao = null;
        MySqlCommand cSQL = null;

        public Conexao()
        {
            linhaConexao = StringConexao.GetStringConexao();
        }

        protected void Conectar()
        {
            try
            {
                conexao = new MySqlConnection(linhaConexao);
                conexao.Open();
            }
            catch (Exception ex)
            {
                throw new Exception("Não foi possível conectar no Servidor. Erro: " + ex.Message);
            }
        }

        protected void Desconectar()
        {
            try
            {
                if (conexao.State == System.Data.ConnectionState.Open)
                    conexao.Close();
            }
            catch (Exception ex)
            {
                throw new Exception("Não foi possível desconectar do Servidor. Erro: " + ex.Message);
            }
        }

        protected MySqlDataReader Executar(string nomeSP, List<Parametro> parametros)
        {
            Conectar();
            try
            {
                cSQL = new MySqlCommand(nomeSP, conexao);
                cSQL.CommandType = System.Data.CommandType.StoredProcedure;
                cSQL.Parameters.Clear();
                if (parametros != null)
                {
                    foreach (var param in parametros)
                    {
                        cSQL.Parameters.AddWithValue(param.Nome, param.Valor);
                    }
                }

                return cSQL.ExecuteReader();
            }
            catch (MySqlException ex)
            {
                if (ex.Number == 1644) throw new SPException(ex.Message);
                throw new Exception("Ocorreu um erro na execução da procedure. Erro: " + ex.Message);
            }
            catch (Exception ex)
            {
                throw new Exception("Ocorreu um erro desconhecido. Erro: " + ex.Message);
            }
        }
    }
}