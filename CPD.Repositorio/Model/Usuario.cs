namespace CPD.Repositorio.Model
{
    public class Usuario
    {
        public int RM { get; set; }
        public string Nome { get; set; }
        public string Email { get; set; }
        public string Senha { get; set; }
        public string ReferenciaImagem { get; set; }
        public TipoUsuario TipoUsuario { get; set; }
    }
}
