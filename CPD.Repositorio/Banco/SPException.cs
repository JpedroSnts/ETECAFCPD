using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Banco
{
    internal class SPException : Exception
    {
        public SPException(string message) : base(message)
        {

        }
    }
}
