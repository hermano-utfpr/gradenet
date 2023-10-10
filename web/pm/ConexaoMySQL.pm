package ConexaoMySQL;

use strict;
use DBI();










#################################################################################
# ConexaoMySQL
# criado  : 09/02/2002
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe principal de acesso a dados
#################################################################################










#################################################################################
# new
# criado : 09/02/2002
#--------------------------------------------------------------------------------
# M�todo construtor
#################################################################################
sub new {
   my $proto = shift;
   my $class = ref($proto) || $proto;
   my $self = {
      driver => "mysql",           # Driver do DBI para acesso ao servidor de base de dados
      user => "gradenet",          # Nome do usu�rio do banco de dados
      password => "gradenet_123",        # Senha do usu�rio do banco de dados
      hostName => "db",     # Endere�o do host do banco de dados
      port => "3306",              # Porta do host para acesso ao banco de dados
      dataBase => "gradenet",      # Nome da base de dados
      tab => "gn_",               # Cada ambiente tera nomes diferentes nas tabelas
      conexao => undef,            
   };
   bless($self,$class);
   $self->conectar;
   return $self;
}
#################################################################################










#################################################################################
# conectar
# criado : 09/02/2002
#--------------------------------------------------------------------------------
# M�todo que faz a conex�o com o banco de dados.
#################################################################################
sub conectar {
   my $self = shift;
   $self->{conexao} = DBI->connect($self->dsn,$self->{user},$self->{password})
      or die "Problemas ao conectar com a Base de Dados!";   
}
#################################################################################










#################################################################################
# dsn
# criado : 09/02/2002
#--------------------------------------------------------------------------------
# M�todo que concatena alguns atributos para uso do M�todo Conectar
#################################################################################
sub dsn {
   my $self = shift;
   return 'DBI:'.$self->{driver}.':database='.$self->{dataBase}.';host='.$self->{hostName}.';port='.$self->{port};
}
#################################################################################










#################################################################################
# executar
# criado : 09/02/2002
#--------------------------------------------------------------------------------
# M�todo que permite executar funcoes na conex�o atual
#################################################################################
sub executar {
   my $self = shift;
   if (@_) {
      $self->{conexao} = shift or die "Problemas ao executar na Base de Dados!";
   }
   return $self->{conexao};
}
#################################################################################










#################################################################################
# getTab
# criado : 09/08/2003
#--------------------------------------------------------------------------------
# M�todo que permite as classes dados alocarem um nome para tabelas
#################################################################################
sub getTab {
   my $self = shift;
   return $self->{tab};
}
#################################################################################









1;






























