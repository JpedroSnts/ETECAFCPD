﻿using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
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
                new Parametro("pDataOcorrencia", ocorrenciaEquipamento.Data.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pSiglaEquipamento", ocorrenciaEquipamento.Equipamento.Sigla),
                new Parametro("pRm", ocorrenciaEquipamento.Usuario.RM.ToString()),
                new Parametro("pDataSaidaPrevista", ocorrenciaEquipamento.ReservaEquipamento.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pTipoOcorrencia", ocorrenciaEquipamento.TipoOcorrencia.Codigo.ToString()),
                new Parametro("pDescricao", ocorrenciaEquipamento.Descricao)
            };
            Executar("registrarOcorrenciaEquipamento", parametros);
            Desconectar();
        }
    }
}