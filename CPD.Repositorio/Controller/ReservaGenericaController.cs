using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using CPD.Repositorio.Util;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Controller
{
    public class ReservaGenericaController : ConexaoBanco
    {
        public List<ReservaEquipamento> ListarReservasEquipamentosComFiltro(int rm, DateTime dataSaidaPrevista)
        {
            List<ReservaEquipamento> list = new List<ReservaEquipamento>();
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDataSaidaPrevista", dataSaidaPrevista.ToString("yyyy-MM-dd HH:mm")),
                new Parametro("pRM", rm.ToString())
            };
            MySqlDataReader reader = Executar("listarReservaParaEnviarEmail", parametros);

            while (reader.Read())
            {
                ReservaEquipamento da = new ReservaEquipamento()
                {
                    Equipamento = new Equipamento { Nome = reader["nm_equipamento"].ToString() },
                    DataSaidaPrevista = Data.DateTimeParse(reader["dt_saida_prevista"].ToString()),
                    DataDevolucaoPrevista = Data.DateTimeParse(reader["dt_devolucao_prevista"].ToString())
                };

                list.Add(da);
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }
    }
}
