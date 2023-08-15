using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Model
{
    public class Notificacao
    {
        public int Codigo { get; set; }
        public string Titulo { get; set; }
        public string Conteudo { get; set; }
        public DateTime Data { get; set; }
        public List<UsuarioNotificacao> Usuarios { get; set; }
    }
}
