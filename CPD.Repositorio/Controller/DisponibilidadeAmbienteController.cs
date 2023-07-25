using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;

namespace CPD.Repositorio.Controller
{
    public class DisponibilidadeAmbienteController : Banco.Conexao
    {
        public List<DisponibilidadeAmbiente> Listar()
        {
            List<DisponibilidadeAmbiente> list = new List<DisponibilidadeAmbiente>();
            MySqlDataReader reader = Executar("listarDisponibilidadeAmbiente", null);

            while (reader.Read())
            {
                DisponibilidadeAmbiente da = new DisponibilidadeAmbiente()
                {
                    Ambiente = new Ambiente { Sigla = reader.GetString("sg_ambiente"), Nome = reader.GetString("nm_ambiente") },
                    DiaSemana = new DiaSemana { Codigo = reader.GetInt16("cd_dia_semana"), Nome = reader.GetString("nm_dia_semana") },
                    Inicio = DateTime.Parse(reader.GetString("hr_inicio_disponibilidade")),
                    Termino = DateTime.Parse(reader.GetString("hr_termino_disponibilidade"))
                };

                list.Add(da);
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return list;
        }

        public DisponibilidadeAmbiente Buscar(DisponibilidadeAmbiente disponibilidadeAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pTerminoDisponibilidade", disponibilidadeAmbiente.Termino.ToString("HH:mm:ss")),
                new Parametro("pInicioDisponibilidade", disponibilidadeAmbiente.Inicio.ToString("HH:mm:ss")),
                new Parametro("pDiaSemana", disponibilidadeAmbiente.DiaSemana.Codigo.ToString())
            };
            MySqlDataReader reader = Executar("buscarDisponibilidadeAmbiente", parametros);
            DisponibilidadeAmbiente da = null;

            if (reader.Read())
            {
                da = new DisponibilidadeAmbiente()
                {
                    Ambiente = new Ambiente { Sigla = reader.GetString("sg_ambiente"), Nome = reader.GetString("nm_ambiente") },
                    DiaSemana = new DiaSemana { Codigo = reader.GetInt16("cd_dia_semana"), Nome = reader.GetString("nm_dia_semana") },
                    Inicio = DateTime.Parse(reader.GetString("hr_inicio_disponibilidade")),
                    Termino = DateTime.Parse(reader.GetString("hr_termino_disponibilidade"))
                };
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return da;
        }

        public DisponibilidadeAmbiente Adicionar(DisponibilidadeAmbiente disponibilidadeAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pTerminoDisponibilidade", disponibilidadeAmbiente.Termino.ToString("HH:mm:ss")),
                new Parametro("pInicioDisponibilidade", disponibilidadeAmbiente.Inicio.ToString("HH:mm:ss")),
                new Parametro("pDiaSemana", disponibilidadeAmbiente.DiaSemana.Codigo.ToString()),
                new Parametro("pSiglaAmbiente", disponibilidadeAmbiente.Ambiente.Sigla)
            };
            MySqlDataReader reader = Executar("criarDisponibilidadeAmbiente", parametros);
            DisponibilidadeAmbiente da = null;

            if (reader.Read())
            {
                da = new DisponibilidadeAmbiente()
                {
                    Ambiente = new Ambiente { Sigla = reader.GetString("sg_ambiente"), Nome = reader.GetString("nm_ambiente") },
                    DiaSemana = new DiaSemana { Codigo = reader.GetInt16("cd_dia_semana"), Nome = reader.GetString("nm_dia_semana") },
                    Inicio = DateTime.Parse(reader.GetString("hr_inicio_disponibilidade")),
                    Termino = DateTime.Parse(reader.GetString("hr_termino_disponibilidade"))
                };
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return da;
        }

        public DisponibilidadeAmbiente Editar(DisponibilidadeAmbiente disponibilidadeAmbiente, DisponibilidadeAmbiente novaDisponibilidadeAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pTerminoDisponibilidade", disponibilidadeAmbiente.Termino.ToString("HH:mm:ss")),
                new Parametro("pInicioDisponibilidade", disponibilidadeAmbiente.Inicio.ToString("HH:mm:ss")),
                new Parametro("pDiaSemana", disponibilidadeAmbiente.DiaSemana.Codigo.ToString()),
                new Parametro("pSiglaAmbiente", novaDisponibilidadeAmbiente.Ambiente.Sigla)
            };
            MySqlDataReader reader = Executar("alterarDisponibilidadeAmbiente", parametros);
            DisponibilidadeAmbiente da = null;

            if (reader.Read())
            {
                da = new DisponibilidadeAmbiente()
                {
                    Ambiente = new Ambiente { Sigla = reader.GetString("sg_ambiente"), Nome = reader.GetString("nm_ambiente") },
                    DiaSemana = new DiaSemana { Codigo = reader.GetInt16("cd_dia_semana"), Nome = reader.GetString("nm_dia_semana") },
                    Inicio = DateTime.Parse(reader.GetString("hr_inicio_disponibilidade")),
                    Termino = DateTime.Parse(reader.GetString("hr_termino_disponibilidade"))
                };
            }

            if (reader.IsClosed) reader.Close();
            Desconectar();

            return da;
        }

        public void Excluir(DisponibilidadeAmbiente disponibilidadeAmbiente)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pTerminoDisponibilidade", disponibilidadeAmbiente.Termino.ToString("HH:mm:ss")),
                new Parametro("pInicioDisponibilidade", disponibilidadeAmbiente.Inicio.ToString("HH:mm:ss")),
                new Parametro("pDiaSemana", disponibilidadeAmbiente.DiaSemana.Codigo.ToString())
            };
            Executar("excluirDisponibilidadeAmbiente", parametros);
            Desconectar();
        }
    }
}
