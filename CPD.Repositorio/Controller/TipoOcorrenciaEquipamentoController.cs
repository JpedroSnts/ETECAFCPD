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
    public class TipoOcorrenciaEquipamentoController : ConexaoBanco
    {
        public List<TipoOcorrenciaEquipamento> Listar()
        {
            List<TipoOcorrenciaEquipamento> list = new List<TipoOcorrenciaEquipamento>();
            MySqlDataReader reader = Executar("listarTipoOcorrenciaEquipamento", null);
            while (reader.Read())
            {
                list.Add(new TipoOcorrenciaEquipamento() { Codigo = reader.GetInt16("cd_tipo_ocorrencia"), Nome = reader["nm_tipo_ocorrencia"].ToString() });
            }
            Desconectar();
            return list;
        }
    }
}
