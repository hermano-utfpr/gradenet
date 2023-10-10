package DadosTestesQuestoes;

use strict;
use ConexaoMySQL;
use ClasseTesteQuestao;
use FuncoesCronologicas;







#################################################################################
# DadosTestesQuestoes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de questões de testes.
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
# existeTabela
#--------------------------------------------------------------------------------
# Método que verifica se a tabela Questao existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;
   $SQL->execute or die "Problemas ao consultar tabelas de questões!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) {
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."TesteQuestao") {
         $existe = 1;
      }
   }
   $SQL->finish;
   return $existe;
}
#################################################################################









#################################################################################
# criarTabela
#--------------------------------------------------------------------------------
# Método que verifica se a tabela Questao existe, se não existir irá tentar
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."TesteQuestao (";
      $tSQL = $tSQL."CodigoQuestao int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."CodigoTeste int not null,";
      $tSQL = $tSQL."Texto text) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de questões na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma questão na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   my $codigoQuestao = 0;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaQuestao = $_[0];
      if ($umaQuestao->getCodigoQuestao() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."TesteQuestao set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."TesteQuestao set ";
         $fSQL = "WHERE CodigoQuestao = ".$umaQuestao->getCodigoQuestao()." ";
      }
      $tSQL = $tSQL."CodigoTeste = \'".$umaQuestao->getCodigoTeste()."\', ";
      $tSQL = $tSQL."Texto = \'".$umaQuestao->getTexto()."\' ";
      $tSQL = $tSQL.$fSQL;
#      die $tSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar questao!\n";
      if ($linhas == 0) {
         #die "Questão não foi gravada!\n";
      }
      if ($umaQuestao->getCodigoQuestao() == 0) {
          my $tSQL2 = "SELECT CodigoQuestao FROM ".$self->umaConexao->getTab()."TesteQuestao ";
          $tSQL2 .= "WHERE CodigoTeste = ".$umaQuestao->getCodigoTeste()." ";
          $tSQL2 .= "AND Texto = \'".$umaQuestao->getTexto()."\' ";
          my $SQL2 = $self->umaConexao->executar->prepare($tSQL2);
          $SQL2->execute or die "Problemas ao selecionar questões!\n";
          while (my $r2 = $SQL2->fetchrow_hashref) {
             $codigoQuestao = $r2->{'CodigoQuestao'};
          }
          $SQL2->finish;
      }
   } else {
      die "Nenhuma questão foi enviada para ser gravada!\n";
   }
   return $codigoQuestao;
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as questões da base de dados, em ordem de codigo
#################################################################################
sub solicitar {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."TesteQuestao ";
   $tSQL .= "WHERE CodigoTeste = $codigoTeste ORDER BY CodigoQuestao DESC";
   my @colecaoQuestoes = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar questões!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoQuestoes[$i] = new ClasseTesteQuestao;
      $colecaoQuestoes[$i]->setDadosBD($r->{'CodigoQuestao'},$r->{'CodigoTeste'},$r->{'Texto'});
      $i++;
   }
   $SQL->finish;
   return @colecaoQuestoes;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui a questao da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoQuestao = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteResposta WHERE CodigoQuestao = ".$codigoQuestao." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as respostas!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteQuestao WHERE CodigoQuestao = ".$codigoQuestao." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a questão!";
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de questoes de um teste na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."TesteQuestao ";
   $tSQL .= "WHERE CodigoTeste = $codigoTeste";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de questoes!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# selecionar
#--------------------------------------------------------------------------------
# Método que seleciona uma questão da base de dados
#################################################################################
sub selecionar {
   my $self = shift;
   my $codigoQuestao = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."TesteQuestao ";
   $tSQL .= "WHERE CodigoQuestao = $codigoQuestao ";
   my $umaQuestao = new ClasseTesteQuestao;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar questão!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $umaQuestao = new ClasseTesteQuestao;
      $umaQuestao->setDadosBD($r->{'CodigoQuestao'},$r->{'CodigoTeste'},$r->{'Texto'});
   }
   $SQL->finish;
   return $umaQuestao;
}
#################################################################################










#################################################################################
# sortearQuestoes
#--------------------------------------------------------------------------------
# Método que sortea questões para iniciar um teste
#################################################################################
sub sortearQuestoes {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $numQuestoes = $_[1];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."TesteQuestao ";
   $tSQL .= "WHERE CodigoTeste = $codigoTeste ORDER BY CodigoQuestao ";
   my @colecaoQuestoes;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar questões!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoQuestoes[$i] = new ClasseTesteQuestao;
      $colecaoQuestoes[$i]->setDadosBD($r->{'CodigoQuestao'},$r->{'CodigoTeste'},$r->{'Texto'});
      $i++;
   }
   $SQL->finish;

   my %tabsort;
   $i = 0;
   my $umaQuestao = new ClasseTesteQuestao;
   foreach $umaQuestao (@colecaoQuestoes) {
      $tabsort{$i} = new ClasseTesteQuestao;
      $tabsort{$i}->setDadosBD($umaQuestao->getCodigoQuestao(),$umaQuestao->getCodigoTeste(),$umaQuestao->getTexto());
      $i++;
   }

   my @codtab;
   my $sorteado = 0;
   my $codSorteado = 0;
   my @colecaoQuestoesSort;
   for ($i = 0; $i < $numQuestoes; $i++) {
      @codtab = keys %tabsort;
      $sorteado = int(rand(scalar(@codtab)-0.01));
      $codSorteado = $codtab[$sorteado];
      $colecaoQuestoesSort[$i] = new ClasseTesteQuestao;
 $colecaoQuestoesSort[$i]->setDadosBD($tabsort{$codSorteado}->getCodigoQuestao(),$tabsort{$codSorteado}->getCodigoTeste(),$tabsort{$codSorteado}->getTexto());
      delete $tabsort{$codSorteado};
   }

   return (@colecaoQuestoesSort);
}
#################################################################################











1;
