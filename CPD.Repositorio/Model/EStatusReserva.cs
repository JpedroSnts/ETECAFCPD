using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CPD.Repositorio.Model
{
    public enum EStatusReserva
    {
        Reservadp = 1,
        EmAndamento = 2,
        EntregaAtrasada = 3,
        AguardandoRetirada = 4,
        NaoRetirado = 5,
        Cancelada = 6,
        Concluida = 7
    }
}