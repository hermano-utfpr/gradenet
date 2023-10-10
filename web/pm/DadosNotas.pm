package DadosNotas;

use strict;
use ConexaoMySQL;
use ClasseNotas;







#################################################################################
# DadosNotas
# criado  : 08/2016
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de informações das notas
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
      umaConexao => ConexaoMySQL->new,
   };
   bless ($self,$class);
   return $self;
}
#################################################################################









#################################################################################
# umaConexao
#--------------------------------------------------------------------------------
# Método para manipulador de conexão.
#################################################################################
sub umaConexao {
   my $self = shift;
   if (@_) {
      $self->{umaConexao} = shift;
   }
   return $self->{umaConexao};
}
#################################################################################







#################################################################################
# selecionar
#--------------------------------------------------------------------------------
# Método que seleciona as notas
#################################################################################
sub selecionarNotas {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT SUM(TU.NotaCorrigida) AS testes ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS TU ON U.CodigoUsuario = TU.CodigoUsuario ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Teste AS T ON T.CodigoTeste = TU.CodigoTeste ";
   $tSQL .= "WHERE TU.Status = \'E\' AND T.HabRanking = 1 AND U.CodigoUsuario = $codigoUsuario ";
   my $umNotas = new ClasseNotas;
   $umNotas->setAtividades(0);
   $umNotas->setTestes(0);
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar as notas!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
      $umNotas->setTestes($r->{'testes'});
   }
   $SQL->finish;
   my $tSQL = "SELECT SUM(AR.Nota) AS atividades ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeResposta AS AR ON U.CodigoUsuario = AR.CodigoUsuario AND AR.Nota > 0 ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Atividade AS A ON A.CodigoAtividade = AR.CodigoAtividade ";
   $tSQL .= "WHERE U.CodigoUsuario = $codigoUsuario AND A.ValorNota > 0 ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar as notas!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
      $umNotas->setAtividades($r->{'atividades'});
   }
   $SQL->finish;
   return $umNotas;
}
#################################################################################












1;
