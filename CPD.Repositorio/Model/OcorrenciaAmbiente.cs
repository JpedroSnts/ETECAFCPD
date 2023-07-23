using System;

namespace CPD.Repositorio.Model
{
    public class OcorrenciaAmbiente
    {
        public DateTime Data { get; set; }
        public string Sigla { get; set; }
        public Usuario Usuario { get; set; }
        public TipoOcorrenciaAmbiente TipoOcorrencia { get; set; }
        public string Descricao { get; set; }
    }
}
