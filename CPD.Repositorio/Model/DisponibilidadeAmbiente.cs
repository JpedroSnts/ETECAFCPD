using System;

namespace CPD.Repositorio.Model
{
    internal class DisponibilidadeAmbiente
    {
        public DateTime Inicio { get; set; }
        public DateTime Termino { get; set; }
        public DiaSemana DiaSemana { get; set; }
        public Ambiente Ambiente { get; set; }
    }
}
