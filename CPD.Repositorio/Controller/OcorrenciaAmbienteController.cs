﻿using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;

namespace CPD.Repositorio.Controller
{
    public class OcorrenciaAmbienteController : ConexaoBanco
    {
        public void Registrar(OcorrenciaAmbiente ocorrenciaAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", ocorrenciaAmbiente.Ambiente.Sigla),
                new Parametro("pRm", ocorrenciaAmbiente.Usuario.RM.ToString()),
                new Parametro("pDataSaidaPrevista", ocorrenciaAmbiente.ReservaAmbiente.DataSaidaPrevista.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pTipoOcorrencia", ocorrenciaAmbiente.TipoOcorrencia.Codigo.ToString()),
                new Parametro("pDescricao", ocorrenciaAmbiente.Descricao)
            };
            Executar("registrarOcorrenciaAmbiente", parametros);
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
                MySqlDataReader reader = Executar("adicionarOcorrenciaAmbiente", parametros);
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
