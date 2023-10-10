using CPD.Repositorio.Banco;
using CPD.Repositorio.Model;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CPD.Repositorio.Controller
{
    public class TokenController : ConexaoBanco
    {
        public Token GerarToken(string Email)
        {
            string token = Guid.NewGuid().ToString().Replace("-", "");
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pEmailUsuario", Email),
                new Parametro("pCodigoToken", token)
            };
            Executar("gerarToken", parametros);
            Desconectar();

            return new Token() { Email = Email, Codigo = token };
        }

        public Token BuscarToken(string token)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pCodigoToken", token)
            };
            MySqlDataReader reader = Executar("buscarToken", parametros);

            Token tkn = new Token();
            if (reader.Read())
            {
                tkn.Email = reader.GetString("nm_email");
                tkn.Codigo = reader.GetString("cd_token");
                tkn.Data = DateTime.Parse(reader.GetString("dt_token"));
            }

            if (!reader.IsClosed) reader.Close();
            Desconectar();

            return tkn;
        }

        public void AlterarSenha(string token, string novaSenha, string confirmacaoSenha)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pCodigoToken", token),
                new Parametro("pNovaSenha", novaSenha),
                new Parametro("pConfirmacaoSenha", confirmacaoSenha)
            };
            Executar("alterarSenhaToken", parametros);
            Desconectar();
        }
    }
}
