using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site.ViewModel
{
    public class EquipamentoLivre
    {
        public string CodigoBase { get; set; }
        public string Nome { get; set; }
        public int Quantidade { get; set; }

        public EquipamentoLivre(string codigoBase, string nome, int quantidade)
        {
            CodigoBase = codigoBase;
            Nome = nome;
            Quantidade = quantidade;
        }
    }
}