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
# Classe de acesso à base da dados de anotações.
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
# Método que verifica se a tabela Anotacao existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de anotações!\n";
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
# Método que verifica se a tabela Anotacao existe, se não existir irá tentar 
# criá-la.
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
      $SQL->execute or die "Problemas ao criar tabelas de anotações na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma anotação na base de dados.
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
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar anotação!\n";
      if ($linhas == 0) { 
         #die "Anotação não foi gravada!\n";
      }
   } else {
      die "Nenhuma anotação foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as anotações da base de dados, em ordem
# de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Anotacao order by Data Desc ";
   my @colecaoAnotacoes;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar anotações!\n";
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
# Método que exclui a anotação da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoAnotacao = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Anotacao WHERE CodigoAnotacao = ".$codigoAnotacao." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a anotação!";
}
#################################################################################










#################################################################################
# selecionarAnotacao
#--------------------------------------------------------------------------------
# Método que seleciona uma anotação a partir de seu código
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
   $SQL->execute or die "Não foi possível selecionar a anotação!\n";    
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
# Método que solicita a quantidade de anotações na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Anotacao ";
   $tSQL .= "WHERE CodigoUsuario = $codigoUsuario";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de anotações!\n";
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
# Método que solicita parcialmente as anotaçoes da base de dados.
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
   $SQL->execute or die "Problemas ao selecionar anotações!\n";
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
