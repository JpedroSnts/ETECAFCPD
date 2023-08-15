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
    public class NotificacaoController : ConexaoBanco
    {
        public void Registrar(Notificacao notificacao, Usuario usuario)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pTitulo", notificacao.Data.ToString("yyyy-MM-dd HH-mm-ss")),
                new Parametro("pDescricao", notificacao.Conteudo),
                new Parametro("pRm", usuario.RM.ToString())
            };
            Executar("enviarNotificacao", parametros);
            Desconectar();
        }

        public List<Notificacao> ListarNotificacaoUsuario(Usuario usuario)
        {
            List<Parametro> parametros = new List<Parametro>
            {
                new Parametro("pRm", usuario.RM.ToString())
            };
            MySqlDataReader reader = Executar("exibirNotificacaoUsuario", parametros);
            List<Notificacao> notificacoes = new List<Notificacao>();
            while (reader.Read())
            {
                Notificacao notificacao = new Notificacao();
                notificacao.Codigo = reader.GetInt32("cd_notificacao");
                notificacao.Titulo = reader["nm_notificacao"].ToString();
                notificacao.Conteudo = reader["ds_conteudo"].ToString();
                notificacao.Data = DateTime.Parse(reader["dt_notificacao"].ToString());
                notificacao.Usuarios = new List<UsuarioNotificacao>
                {
                    new UsuarioNotificacao
                    {
                        Usuario = usuario,
                        Lida = reader.GetBoolean("ic_lida")
                    }
                };
                notificacoes.Add(notificacao);
            }
            Desconectar();
            return notificacoes;
        }
    }
}
