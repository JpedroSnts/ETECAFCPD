using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Net.WebSockets;

namespace CPD.Repositorio.Controller
{
    public class UsoAmbienteController : Banco.ConexaoBanco
    {
        public List<UsoAmbiente> Listar()
        {
            List<UsoAmbiente> list = new List<UsoAmbiente>();
            MySqlDataReader reader = Executar("listarUsosAmbientes", null);

            while (reader.Read())
            {
                UsoAmbiente da = new UsoAmbiente()
                {
                    Ambiente = new Ambiente { Sigla = reader.GetString("sg_ambiente"), Nome = reader.GetString("nm_ambiente") },
                    DiaSemana = new DiaSemana { Codigo = reader.GetInt16("cd_dia_semana"), Nome = reader.GetString("nm_dia_semana") },
                    Inicio = DateTime.Parse(reader.GetString("hr_inicio_uso")),
                    Termino = DateTime.Parse(reader.GetString("hr_termino_uso"))
                };

                list.Add(da);
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }

        public void Adicionar(UsoAmbiente usoAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pSiglaAmbiente", usoAmbiente.Ambiente.Sigla),
                new Parametro("pDiaSemana", usoAmbiente.DiaSemana.Codigo.ToString()),
                new Parametro("pHorarioInicio", usoAmbiente.Inicio.ToString("HH:mm:ss")),
                new Parametro("pHorarioFim", usoAmbiente.Termino.ToString("HH:mm:ss")),
            };
            Executar("adicionarUsoAmbiente", parametros);
            Desconectar();
        }

        public void Remover(UsoAmbiente usoAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pDiaSemana", usoAmbiente.DiaSemana.Codigo.ToString()),
                new Parametro("pHorarioInicio", usoAmbiente.Inicio.ToString("HH:mm:ss")),
                new Parametro("pHorarioFim", usoAmbiente.Termino.ToString("HH:mm:ss"))
            };
            Executar("removerUsoAmbiente", parametros);
            Desconectar();
        }
    }
}
