using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Controller
{
    public class TipoOcorrenciaAmbienteController : ConexaoBanco
    {
        public List<TipoOcorrenciaAmbiente> Listar()
        {
            List<TipoOcorrenciaAmbiente> list = new List<TipoOcorrenciaAmbiente>();
            MySqlDataReader reader = Executar("listarTipoOcorrenciaAmbiente", null);
            while (reader.Read())
            {
                list.Add(new TipoOcorrenciaAmbiente() { Codigo = reader.GetInt16("cd_tipo_ocorrencia"), Nome = reader["nm_tipo_ocorrencia"].ToString() });
            }
            Desconectar();
            return list;
        }
    }
}
