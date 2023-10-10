package DadosTestes;

use strict;
use ConexaoMySQL;
use ClasseTeste;
use FuncoesCronologicas;







#################################################################################
# DadosTestes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de teste.
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
# Método que verifica se a tabela Teste existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;
   $SQL->execute or die "Problemas ao consultar tabelas de testes!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) {
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Teste") {
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
# Método que verifica se a tabela Teste existe, se não existir irá tentar
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Teste (";
      $tSQL = $tSQL."CodigoTeste int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."HabRanking bool,";
      $tSQL = $tSQL."NumQuestoes int,";
      $tSQL = $tSQL."CodigoUsuario int not null, ";
      $tSQL = $tSQL."CodigoAtividade int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de testes na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava um teste na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umTeste = $_[0];
      if ($umTeste->getCodigoTeste() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Teste set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Teste set ";
         $fSQL = "WHERE CodigoTeste = ".$umTeste->getCodigoTeste()." ";
      }
      $tSQL = $tSQL."Titulo = \'".$umTeste->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umTeste->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umTeste->getDataBD()."\', ";
      $tSQL = $tSQL."HabRanking = \'".$umTeste->getHabRanking()."\', ";
      $tSQL = $tSQL."NumQuestoes = \'".$umTeste->getNumQuestoes()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umTeste->getCodigoUsuario()."\', ";
      $tSQL = $tSQL."CodigoAtividade = \'".$umTeste->getCodigoAtividade()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar teste!\n";
      if ($linhas == 0) {
         #die "Teste não foi gravado!\n";
      }
   } else {
      die "Nenhum teste foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita os testes da base de dados, em ordem
# de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Teste AS T ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON T.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "ORDER BY Data DESC";
   my @colecaoTestes = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar testes!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoTestes[$i] = new ClasseTeste;
      $colecaoTestes[$i]->setDadosBD($r->{'CodigoTeste'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'HabRanking'},$r->{'NumQuestoes'},$r->{'CodigoUsuario'},$r->{'CodigoAtividade'});
      $colecaoTestes[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoTestes[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoTestes;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui o teste da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Teste WHERE CodigoTeste = ".$codigoTeste." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir o teste!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteUsuario WHERE CodigoTeste = ".$codigoTeste." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir o teste!";
}
#################################################################################










#################################################################################
# selecionarTeste
#--------------------------------------------------------------------------------
# Método que seleciona um teste a partir de seu código
#################################################################################
sub selecionarTeste {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Teste AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoTeste = ".$codigoTeste." ";
   my $umTeste = new ClasseTeste;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar o teste!\n";
   while (my $r = $SQL->fetchrow_hashref) {
       $umTeste->setDadosBD($r->{'CodigoTeste'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'HabRanking'},$r->{'NumQuestoes'},$r->{'CodigoUsuario'},$r->{'CodigoAtividade'});
       $umTeste->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umTeste->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umTeste;
}
#################################################################################




#################################################################################
# selecionarTesteAtividade
#--------------------------------------------------------------------------------
# Método que seleciona um teste a partir do código da Atividade
#################################################################################
sub selecionarTesteAtividade {
   my $self = shift;
   my $codigoAtividade = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Teste AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoAtividade = ".$codigoAtividade." ";
   my $umTeste = new ClasseTeste;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar o teste!\n";
   while (my $r = $SQL->fetchrow_hashref) {
       $umTeste->setDadosBD($r->{'CodigoTeste'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'HabRanking'},$r->{'NumQuestoes'},$r->{'CodigoUsuario'},$r->{'CodigoAtividade'});
       $umTeste->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umTeste->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umTeste;
}
#################################################################################





#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de testes na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Teste ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de testes!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# solicitarTestes
#--------------------------------------------------------------------------------
# Método que solicita os testes da base de dados, em ordem
# de data.
#################################################################################
sub solicitarTestes {
   my $self = shift;
   my $tSQL = "SELECT *, COUNT(Q.CodigoQuestao) AS QtdeQuestoes, T.CodigoTeste AS CodigoDoTeste ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Teste AS T ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON T.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteQuestao AS Q ";
   $tSQL .= "ON T.CodigoTeste = Q.CodigoTeste ";
   $tSQL .= "GROUP BY T.CodigoTeste ";
   $tSQL .= "ORDER BY Data DESC ";
   my @colecaoTestes = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
#   die $tSQL;
   $SQL->execute or die "Problemas ao selecionar testes!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoTestes[$i] = new ClasseTeste;
      $colecaoTestes[$i]->setDadosBD($r->{'CodigoDoTeste'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'HabRanking'},$r->{'NumQuestoes'},$r->{'CodigoUsuario'},$r->{'CodigoAtividade'});
      $colecaoTestes[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoTestes[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoTestes[$i]->info->setQtdeQuestoes($r->{'QtdeQuestoes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoTestes;
}
#################################################################################











1;
