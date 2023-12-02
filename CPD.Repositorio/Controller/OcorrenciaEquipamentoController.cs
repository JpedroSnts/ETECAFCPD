using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static System.Net.Mime.MediaTypeNames;

namespace CPD.Repositorio.Controller
{
    public class OcorrenciaEquipamentoController : ConexaoBanco
    {
        public void Registrar(OcorrenciaEquipamento ocorrenciaEquipamento)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaEquipamento", ocorrenciaEquipamento.Equipamento.Sigla),
                new Parametro("pRm", ocorrenciaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDataSaidaPrevista", ocorrenciaEquipamento.ReservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pTipoOcorrencia", ocorrenciaEquipamento.TipoOcorrencia.Codigo.ToString()),
                new Parametro("pDescricao", ocorrenciaEquipamento.Descricao)
            };
            Executar("registrarOcorrenciaEquipamento", parametros);
            Desconectar();
        }

        public bool AdicionarOcorrencia(string codigo, string nome)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pCodigo", codigo),
                new Parametro("pNome", nome)
            };

            try
            {
                MySqlDataReader reader = Executar("adicionarOcorrenciaEquipamento", parametros);
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
