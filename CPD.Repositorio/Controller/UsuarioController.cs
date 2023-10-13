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
    public class UsuarioController : ConexaoBanco
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
                usuarioLogado.TipoUsuario = new TipoUsuario
                {
                    Codigo = reader.GetInt32("cd_tipo_usuario"),
                    Nome = reader.GetString("nm_tipo_usuario")
                };
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

        public List<Usuario> BuscarProfessores(string filtro)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pFiltro", filtro),
            };
            MySqlDataReader reader = Executar("buscarProfessores", parametros);
            List<Usuario> usuarios = new List<Usuario>();
            while (reader.Read())
            {
                usuarios.Add(new Usuario { RM = reader.GetInt32("cd_rm"), Nome = reader["nm_usuario"].ToString() });
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return usuarios;
        }

        public Usuario BuscarUsuarioPorRM(int rm)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRM", rm.ToString()),
            };
            MySqlDataReader reader = Executar("buscarUsuarioPorRM", parametros);
            Usuario usuario = null;
            if (reader.Read())
            {
                usuario = new Usuario { RM = rm, Nome = reader["nm_usuario"].ToString(), Email = reader["nm_email"].ToString() };
            }
            if (!reader.IsClosed) reader.Close();
            Desconectar();
            return usuario;
        }
    }
}
