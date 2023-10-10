package DadosAnotacoes;

use strict;
use ConexaoMySQL;
use ClasseAnotacao;
use FuncoesCronologicas;







#################################################################################
# DadosAnotacoes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso � base da dados de anota��es.
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
# M�todo que verifica se a tabela Anotacao existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de anota��es!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Anotacao") {
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
# M�todo que verifica se a tabela Anotacao existe, se n�o existir ir� tentar 
# cri�-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Anotacao (";
      $tSQL = $tSQL."CodigoAnotacao int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de anota��es na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# M�todo que grava uma anota��o na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaAnotacao = $_[0];
      if ($umaAnotacao->getCodigoAnotacao() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Anotacao set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Anotacao set ";
         $fSQL = "WHERE CodigoAnotacao = ".$umaAnotacao->getCodigoAnotacao()." ";
      }
      $tSQL = $tSQL."Titulo = \'".$umaAnotacao->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umaAnotacao->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umaAnotacao->getDataBD()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umaAnotacao->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar anota��o!\n";
      if ($linhas == 0) { 
         #die "Anota��o n�o foi gravada!\n";
      }
   } else {
      die "Nenhuma anota��o foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# M�todo que solicita as anota��es da base de dados, em ordem
# de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Anotacao order by Data Desc ";
   my @colecaoAnotacoes;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar anota��es!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAnotacoes[$i] = new ClasseAnotacao;
      $colecaoAnotacoes[$i]->setDadosBD($r->{'CodigoAnotacao'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAnotacoes;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# M�todo que exclui a anota��o da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoAnotacao = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Anotacao WHERE CodigoAnotacao = ".$codigoAnotacao." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir a anota��o!";
}
#################################################################################










#################################################################################
# selecionarAnotacao
#--------------------------------------------------------------------------------
# M�todo que seleciona uma anota��o a partir de seu c�digo
#################################################################################
sub selecionarAnotacao {
   my $self = shift;
   my $codigoAnotacao = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Anotacao AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoAnotacao = ".$codigoAnotacao." AND U.CodigoUsuario = $codigoUsuario ";
   my $umaAnotacao = new ClasseAnotacao;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel selecionar a anota��o!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umaAnotacao->setDadosBD($r->{'CodigoAnotacao'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
       $umaAnotacao->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaAnotacao->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umaAnotacao;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de anota��es na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Anotacao ";
   $tSQL .= "WHERE CodigoUsuario = $codigoUsuario";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de anota��es!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# solicitarParcial
#--------------------------------------------------------------------------------
# M�todo que solicita parcialmente as anota�oes da base de dados.
#################################################################################
sub solicitarParcial {
   my $self = shift;
   my $indicePagina = $_[0];
   my $quantosPagina = $_[1];
   my $codigoUsuario = $_[2];
   my $posicao = ($indicePagina-1) * $quantosPagina;
   my $tSQL = "SELECT * ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Anotacao as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE U.CodigoUsuario = $codigoUsuario ";
   $tSQL .= "ORDER BY A.Data Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoAnotacoes;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar anota��es!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAnotacoes[$i] = new ClasseAnotacao;      
      $colecaoAnotacoes[$i]->setDadosBD($r->{'CodigoAnotacao'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
      $colecaoAnotacoes[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAnotacoes[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAnotacoes;
}
#################################################################################











1;
