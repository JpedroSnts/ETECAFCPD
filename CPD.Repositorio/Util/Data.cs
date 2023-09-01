using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Util
{
    public class Data
    {
        public static DateTime DateTimeParse(string data)
        {
            try
            {
                return DateTime.Parse(data);
            } 
            catch 
            {
                return DateTime.MinValue;
            }
        }
    }
}
