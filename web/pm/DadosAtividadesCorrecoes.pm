package DadosAtividadesCorrecoes;

use strict;
use ConexaoMySQL;
use ClasseAtividade;
use ClasseAtividadeCorrecao;








#################################################################################
# DadosAtividadesCorrecoes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso � base da dados de correcoes de atividades.
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
# M�todo para manipulador de conex�o.
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
# M�todo que verifica se a tabela AtividadeCorrecao existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de corre��es de atividades!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."AtividadeCorrecao") {
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
# M�todo que verifica se a tabela AtividadeCorrecao existe, se n�o existir ir� 
# tentar cri�-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."AtividadeCorrecao (";
      $tSQL = $tSQL."CodigoCorrecao int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."CodigoAtividade int not null, ";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de corre��es de atividades na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# M�todo que grava uma corre��o de atividade na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaCorrecao = $_[0];
      if ($umaCorrecao->getCodigoCorrecao() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."AtividadeCorrecao set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."AtividadeCorrecao set ";
         $fSQL = "WHERE CodigoCorrecao = ".$umaCorrecao->getCodigoCorrecao()." ";
      }
      $tSQL = $tSQL."CodigoAtividade = \'".$umaCorrecao->getCodigoAtividade()."\', ";
      $tSQL = $tSQL."Titulo = \'".$umaCorrecao->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umaCorrecao->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umaCorrecao->getDataBD()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umaCorrecao->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar corre��o de atividade!\n";
      if ($linhas == 0) { 
         #die "Corre��o n�o foi gravada!\n";
      }
   } else {
      die "Nenhuma corre��o foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# M�todo que solicita as corre��es da base de dados em ordem de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."AtividadeCorrecao AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ";  
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ORDER BY A.Data Desc ";
   my @colecaoCorrecoes = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar corre��es de atividades!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoCorrecoes[$i] = new ClasseAtividadeCorrecao;
      $colecaoCorrecoes[$i]->setDadosBD($r->{'CodigoCorrecao'},$r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
      $colecaoCorrecoes[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoCorrecoes[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoCorrecoes;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# M�todo que exclui a corre��o da atividade da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoCorrecao = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeCorrecao WHERE CodigoCorrecao = ".$codigoCorrecao." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir a corre��o da atividade!";
}
#################################################################################










#################################################################################
# selecionarCorrecao
#--------------------------------------------------------------------------------
# M�todo que seleciona uma corre��o a partir de seu c�digo
#################################################################################
sub selecionarCorrecao {
   my $self = shift;
   my $codigoCorrecao = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."AtividadeCorrecao AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoCorrecao = ".$codigoCorrecao." ";
   my $umaCorrecao = new ClasseAtividadeCorrecao;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel selecionar a corre��o da atividade!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umaCorrecao->setDadosBD($r->{'CodigoCorrecao'},$r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
       $umaCorrecao->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaCorrecao->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umaCorrecao;
}
#################################################################################










#################################################################################
# selecionarCorrecaoAtividade
#--------------------------------------------------------------------------------
# M�todo que seleciona uma corre��o a partir do c�digo da atividade
#################################################################################
sub selecionarCorrecaoAtividade {
   my $self = shift;
   my $codigoAtividade = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."AtividadeCorrecao AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoAtividade = ".$codigoAtividade." ";
   my $umaCorrecao = new ClasseAtividadeCorrecao;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);   
   $SQL->execute or die "N�o foi poss�vel selecionar a corre��o da atividade!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umaCorrecao->setDadosBD($r->{'CodigoCorrecao'},$r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
       $umaCorrecao->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaCorrecao->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
#   $umaCorrecao->getDados();
   return $umaCorrecao;
}
#################################################################################










1;
