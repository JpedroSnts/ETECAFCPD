﻿using CPD.Repositorio.Controller;
using CPD.Repositorio.Model;
using CPD.Site.ViewModel;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace CPD.Site.Controller
{
    public class ReservaController
    {
        public List<ItemLivreDTO> ListarItensLivres(DateTime inicio, DateTime fim)
        {
            EquipamentoController equipamentoController = new EquipamentoController();
            AmbienteController ambienteController = new AmbienteController();
            List<Equipamento> equipamentos = equipamentoController.ListarEquipamentosDisponiveis(inicio, fim);
            List<Ambiente> ambientes = ambienteController.ListarAmbientesDisponiveis(inicio, fim);
            List<ItemGenerico> itensGenericos = ItemGenerico.GerarListaItemGenerico(equipamentos, ambientes);
            return ItemLivreDTO.GerarListaItemLivreDTO(itensGenericos);
        }

        public List<ItemGenerico> ListarItensLivres(List<ItemLivreDTO> itens, DateTime inicio, DateTime fim)
        {
            string[][] siglas = new string[itens.Count][];
            string[][] nomes = new string[itens.Count][];
            ETipoItem[] tiposReservas = new ETipoItem[itens.Count];
            for (int i = 0; i < itens.Count; i++)
            {
                tiposReservas[i] = ETipoItem.Ambiente;
            }
            for (int i = 0; i < itens.Count; i++)
            {
                nomes[i] = new string[itens[i].Quantidade];
            }
            for (int i = 0; i < itens.Count; i++)
            {
                siglas[i] = new string[itens[i].Quantidade];
            }

            AmbienteController ambienteController = new AmbienteController();
            EquipamentoController equipamentoController = new EquipamentoController();

            for (int i = 0; i < itens.Count; i++)
            {
                var ambientesLivres = ambienteController.ListarAmbientesDisponiveisSigla(itens[i].Sigla, inicio, fim);
                var equipamentosLivres = equipamentoController.ListarEquipamentosDisponiveisSigla(itens[i].Sigla, inicio, fim);
                if (itens[i].Quantidade == siglas[i].Length)
                {
                    for (int j = 0; j < siglas[i].Length; j++)
                    {
                        if (ambientesLivres.Count == 0)
                        {
                            siglas[i][j] = equipamentosLivres[j].Sigla;
                            nomes[i][j] = equipamentosLivres[j].Nome;
                            tiposReservas[i] = ETipoItem.Equipamento;
                        }
                        else
                        {
                            siglas[i][j] = ambientesLivres[j].Sigla;
                            nomes[i][j] = ambientesLivres[j].Nome;
                            tiposReservas[i] = ETipoItem.Ambiente;
                        }
                    }
                }
            }
            List<ItemGenerico> novaLista = new List<ItemGenerico>();
            for (int i = 0; i < siglas.Length; i++)
            {
                for (int j = 0; j < siglas[i].Length; j++)
                {
                    novaLista.Add(new ItemGenerico(siglas[i][j], nomes[i][j], tiposReservas[i]));
                }
            }
            return novaLista;
        }

        public void ReservarItens(List<ItemLivreDTO> itens, int rm, DateTime inicio, DateTime fim)
        {
            string[][] siglas = new string[itens.Count][];
            string[] tiposReservas = new string[siglas.Length];
            for (int i = 0; i < itens.Count; i++)
            {
                siglas[i] = new string[itens[i].Quantidade];
            }

            AmbienteController ambienteController = new AmbienteController();
            EquipamentoController equipamentoController = new EquipamentoController();

            for (int i = 0; i < itens.Count; i++)
            {
                var ambientesLivres = ambienteController.ListarAmbientesDisponiveisSigla(itens[i].Sigla, inicio, fim);
                var equipamentosLivres = equipamentoController.ListarEquipamentosDisponiveisSigla(itens[i].Sigla, inicio, fim);
                if (itens[i].Quantidade == siglas[i].Length)
                {
                    for (int j = 0; j < siglas[i].Length; j++)
                    {
                        if (ambientesLivres.Count == 0)
                        {
                            siglas[i][j] = equipamentosLivres[j].Sigla;
                            tiposReservas[i] = "EQUIPAMENTO";
                        }
                        else
                        {
                            siglas[i][j] = ambientesLivres[j].Sigla;
                            tiposReservas[i] = "AMBIENTE";
                        }
                    }
                }
            }

            var reservaAmbienteController = new ReservaAmbienteController();
            var reservaEquipamentoController = new ReservaEquipamentoController();
            for (int i = 0; i < tiposReservas.Length; i++)
            {
                if (tiposReservas[i] == "AMBIENTE")
                {
                    for (int j = 0; j < siglas[i].Length; j++)
                    {
                        var reserva = new ReservaAmbiente() 
                        {
                            Ambiente = new Ambiente { Sigla = siglas[i][j] }, 
                            Usuario = new Usuario { RM = rm },
                            DataSaidaPrevista = inicio, 
                            DataDevolucaoPrevista = fim
                        };
                        reservaAmbienteController.Reservar(reserva);
                    }
                }
                else
                {
                    for (int j = 0; j < siglas[i].Length; j++)
                    {
                        var reserva = new ReservaEquipamento()
                        {
                            Equipamento = new Equipamento { Sigla = siglas[i][j] },
                            Usuario = new Usuario { RM = rm },
                            DataSaidaPrevista = inicio,
                            DataDevolucaoPrevista = fim
                        };
                        reservaEquipamentoController.Reservar(reserva);
                    }
                }
            }

        }
    }
}