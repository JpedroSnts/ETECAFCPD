﻿using System;

namespace CPD.Repositorio.Model
{
    public class OcorrenciaAmbiente
    {
        public ReservaAmbiente ReservaAmbiente { get; set; }
        public DateTime Data { get; set; }
        public Ambiente Ambiente { get; set; }
        public Usuario Usuario { get; set; }
        public TipoOcorrenciaAmbiente TipoOcorrencia { get; set; }
        public string Descricao { get; set; }
    }
}
