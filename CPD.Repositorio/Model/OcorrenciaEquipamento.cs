using System;

namespace CPD.Repositorio.Model
{
    public class OcorrenciaEquipamento
    {
        public DateTime Data { get; set; }
        public Equipamento Equipamento { get; set; }
        public Usuario Usuario { get; set; }
        public TipoOcorrenciaEquipamento TipoOcorrencia { get; set; }
        public string Descricao { get; set; }
    }
}
