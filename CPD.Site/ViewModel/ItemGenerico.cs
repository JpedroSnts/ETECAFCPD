﻿using CPD.Repositorio.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site.ViewModel
{
    public class ItemGenerico
    {
        public string Sigla { get; set; }
        public string Nome { get; set; }

        public static List<ItemGenerico> GerarListaItemGenerico(List<Equipamento> equipamentos, List<Ambiente> ambientes)
        {
            List<ItemGenerico> itensGenericos = new List<ItemGenerico>();
            foreach (var e in equipamentos)
            {
                itensGenericos.Add(new ItemGenerico(e.Sigla, e.Nome));
            }
            foreach (var a in ambientes)
            {
                itensGenericos.Add(new ItemGenerico(a.Sigla, a.Nome));
            }
            return itensGenericos;
        }

        public ItemGenerico(string sigla, string nome)
        {
            Sigla = sigla;
            Nome = nome;
        }
    }
}