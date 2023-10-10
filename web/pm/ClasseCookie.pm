package ClasseCookie;

use strict;
use ClasseUsuario;
use DadosUsuarios;
use ClasseSessao;
use DadosSessoes;
use CGI;
use CGI::Cookie;








#################################################################################
# ClasseCookie
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe criada para trabalhar com cookies/sessoes/usuários
#################################################################################










#################################################################################
# new
#--------------------------------------------------------------------------------
# Construtor
#################################################################################
sub new {
   my $proto = shift;
   my $class = ref($proto) || $proto;
   my $self = { 
      query => new CGI,
      umUsuario => new ClasseUsuario,
      umaSessao => new ClasseSessao,                          
   };
   bless ($self, $class);
   return ($self);
}
#################################################################################









#################################################################################
# query
#--------------------------------------------------------------------------------
# Método que permite manipular o atributo query;
#################################################################################
sub query {
   my $self = shift;
   if (@_) {
      $self->{query} = shift;
   }
   return $self->{query};
}
#################################################################################









#################################################################################
# umUsuario
#--------------------------------------------------------------------------------
# Método que permite manipular o atributo umUsuario;
#################################################################################
sub umUsuario {
   my $self = shift;
   if (@_) {
      $self->{umUsuario} = shift;
   }
   return $self->{umUsuario};
}
#################################################################################









#################################################################################
# umaSessao
#--------------------------------------------------------------------------------
# Método que permite manipular o atributo umaSessao;
#################################################################################
sub umaSessao {
   my $self = shift;
   if (@_) {
      $self->{umaSessao} = shift;
   }
   return $self->{umaSessao};
}
#################################################################################










#################################################################################
# existeCookie
#--------------------------------------------------------------------------------
# Método que verifica a existência de cookies.
#################################################################################
sub existeCookie {
   my $self = shift;
   my $existe = 0;
   my %cookies = fetch CGI::Cookie;
   if (length($cookies{'sessaoID'}) > 0) {
      $existe = 1;
   }
   return $existe;
}
#################################################################################










#################################################################################
# existeSessao
#--------------------------------------------------------------------------------
# Método que verifica a existência de cookies e da sessão
#################################################################################
sub existeSessao {
   my $self = shift;
   my $existe = 0;
   my %cookies = fetch CGI::Cookie;
   if ($self->existeCookie()) {
      my $sessaoID = $cookies{'sessaoID'}->value;
      my $dadosUsuarios = new DadosUsuarios;
      my $dadosSessoes = new DadosSessoes;
      $self->umaSessao($dadosSessoes->selecionarSessao($sessaoID));
      $self->umUsuario($dadosUsuarios->selecionarUsuarioCodigo($self->umaSessao->getCodigoUsuario()));
      if ($self->umaSessao->getValido()) {
         $existe = 1;
      }
   } 
   return $existe;
}
#################################################################################










#################################################################################
# criarSessao
#--------------------------------------------------------------------------------
# Método que cria uma sessão vinculado a um cookie
#################################################################################
sub criarSessao {
   my $self = shift;
   my $existe = 0;
   my %cookies = fetch CGI::Cookie;
   my $dadosUsuarios = new DadosUsuarios;
   my $dadosSessoes = new DadosSessoes;
   my $login = $self->query->param('login');
   my $password = $self->query->param('password');
   $dadosUsuarios->verificarSenha($login,$password);
   $self->umUsuario($dadosUsuarios->selecionarUsuarioLogin($login));
   $self->umaSessao->setDadosAutomatico($self->umUsuario->getCodigoUsuario(),1);
   my $cookie = new CGI::Cookie(-name=>'sessaoID',-value=>$self->umaSessao->getSessaoID());
   print $self->query->header(-cookie=>$cookie);
   $dadosSessoes->gravar($self->umaSessao,0);
}
#################################################################################










#################################################################################
# fecharSessao
#--------------------------------------------------------------------------------
# Método que fecha uma sessão invalidando o cookie
#################################################################################
sub fecharSessao {
   my $self = shift;
   my $dadosSessoes = new DadosSessoes;
   $dadosSessoes->invalidarSessao($self->umaSessao->getSessaoID());   
}
#################################################################################











#################################################################################
# marcarPresenca
#--------------------------------------------------------------------------------
# Método que marca a presenca do usuário na sessao, indicando-o como on-line
#################################################################################
sub marcarPresenca {
   my $self = shift;
   my $dadosSessoes = new DadosSessoes;
   $dadosSessoes->marcarPresenca($self->umaSessao->getSessaoID());   
}
#################################################################################










1;
