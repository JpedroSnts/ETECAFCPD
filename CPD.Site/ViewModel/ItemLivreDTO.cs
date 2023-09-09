using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Site.ViewModel
{
    public class ItemLivreDTO
    {
        public string Sigla { get; set; }
        public string Nome { get; set; }
        public ETipoItem Tipo { get; set; }
        public int Quantidade { get; set; }

        public ItemLivreDTO(string sigla, string nome, int quantidade, ETipoItem tipo)
        {
            Sigla = sigla;
            Nome = nome;
            Quantidade = quantidade;
            Tipo = tipo;
        }

        public ItemLivreDTO(string sigla, string nome, int quantidade)
        {
            Sigla = sigla;
            Nome = nome;
            Quantidade = quantidade;
        }

        public static List<ItemLivreDTO> GerarListaItemLivreDTO(List<ItemGenerico> itensGenericos)
        {
            Dictionary<string, (string Nome, int Quantidade, ETipoItem Tipo)> novaLista = new Dictionary<string, (string, int, ETipoItem)>();

            foreach (var x in itensGenericos)
            {
                string sigla = ExtrairSigla(x.Sigla);
                if (novaLista.ContainsKey(sigla))
                {
                    var (nome, quantidade, Tipo) = novaLista[sigla];
                    novaLista[sigla] = (nome, quantidade + 1, Tipo);
                }
                else
                {
                    novaLista[sigla] = (ExtrairNome(x.Nome), 1, x.Tipo);
                }
            }

            List<ItemLivreDTO> equipamentosLivres = novaLista
                .Select(item => new ItemLivreDTO(item.Key, item.Value.Nome, item.Value.Quantidade, item.Value.Tipo))
                .ToList();

            return equipamentosLivres;
        }

        private static string ExtrairSigla(string sigla)
        {
            string str = "";
            foreach (char c in sigla)
            {
                if (!Char.IsDigit(c)) str += c;
            }
            return str;
        }

        private static string ExtrairNome(string nome)
        {
            var str = new string(nome.Where(c => !Char.IsDigit(c)).ToArray());
            if (str.EndsWith(" ")) str = str.Substring(0, str.Length - 1);
            return str;
        }
    }
}