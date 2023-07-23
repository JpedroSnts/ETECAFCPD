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
    public class UsuarioController : Conexao
    {
        public void Cadastrar(Usuario usuario)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRM", usuario.RM.ToString()),
                new Parametro("pNome", usuario.Nome),
                new Parametro("pEmail", usuario.Email),
                new Parametro("pSenha", usuario.Senha),
                new Parametro("pImg", usuario.ReferenciaImagem),
                new Parametro("pTipoUsuario", usuario.TipoUsuario.Codigo.ToString())
            };
            Executar("adicionarUsuario", parametros);
            Desconectar();
        }

        public Usuario Login(Usuario usuario)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRM", usuario.RM.ToString()),
                new Parametro("pSenha", usuario.Senha)
            };
            MySqlDataReader reader = Executar("loginUsuario", parametros);
            Usuario usuarioLogado = null;
            if (reader.Read())
            {
                usuarioLogado = new Usuario
                {
                    RM = reader.GetInt32("cd_rm"),
                    Nome = reader.GetString("nm_usuario"),
                    Email = reader.GetString("nm_email"),
                    ReferenciaImagem = reader.GetString("nm_referencia_imagem")
                };
                usuarioLogado.TipoUsuario.Codigo = reader.GetInt32("cd_tipo_usuario");
                usuarioLogado.TipoUsuario.Nome = reader.GetString("nm_tipo_usuario");
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return usuarioLogado;
        }

        public void AlterarSenha(Usuario usuario, string novaSenha, string confirmacaoSenha)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRM", usuario.RM.ToString()),
                new Parametro("pSenha", usuario.Senha),
                new Parametro("pNovaSenha", novaSenha),
                new Parametro("pConfirmacaoSenha", confirmacaoSenha)
            };
            Executar("alterarSenhaUsuario", parametros);
            Desconectar();
        }
    }
}
