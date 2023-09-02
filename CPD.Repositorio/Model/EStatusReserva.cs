using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Repositorio.Model
{
    public enum EStatusReserva
    {
        EmAndamento = 1,
        EntregaAtrasada = 2,
        AguardandoRetirada = 3,
        NaoRetirado = 4,
        Cancelada = 5,
    }
}