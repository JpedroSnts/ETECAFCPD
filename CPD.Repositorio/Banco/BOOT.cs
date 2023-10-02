using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Banco
{
    public static class BOOT
    {
        public static void Run(string path)
        {
            try
            {
                string dbName = StringConexao.GetStringConexao().Split('=')[4];
                bool dbExiste = false;
                string linhaConexao = StringConexao.GetStringConexao().Replace(dbName, "mysql");
                using (MySqlConnection conn = new MySqlConnection(linhaConexao))
                {
                    conn.Open();
                    using (MySqlCommand cmd = new MySqlCommand("SHOW DATABASES", conn))
                    {
                        using (MySqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                dbExiste = reader.GetString(0).ToLower() == dbName.ToLower();
                                if (dbExiste) break;
                            }
                        }
                    }
                    if (!dbExiste)
                    {
                        MySqlScript script = new MySqlScript(conn, File.ReadAllText(path + "\\DOCS\\BOOT.sql"));
                        script.Execute();
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Não foi possível realizar o script de inicialização. Erro: " + ex.Message);
            }
        }
    }
}
