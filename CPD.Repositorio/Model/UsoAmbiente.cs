using System;

namespace CPD.Repositorio.Model
{
    public class UsoAmbiente
    {
        public DateTime Inicio { get; set; }
        public DateTime Termino { get; set; }
        public DiaSemana DiaSemana { get; set; }
        public Ambiente Ambiente { get; set; }
    }
}
