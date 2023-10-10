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
# Classe de acesso à base da dados de correcoes de atividades.
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
# Método que verifica se a tabela AtividadeCorrecao existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de correções de atividades!\n";
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
# Método que verifica se a tabela AtividadeCorrecao existe, se não existir irá 
# tentar criá-la.
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
      $SQL->execute or die "Problemas ao criar tabelas de correções de atividades na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma correção de atividade na base de dados.
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
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar correção de atividade!\n";
      if ($linhas == 0) { 
         #die "Correção não foi gravada!\n";
      }
   } else {
      die "Nenhuma correção foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as correções da base de dados em ordem de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."AtividadeCorrecao AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ";  
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ORDER BY A.Data Desc ";
   my @colecaoCorrecoes = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar correções de atividades!\n";
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
# Método que exclui a correção da atividade da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoCorrecao = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeCorrecao WHERE CodigoCorrecao = ".$codigoCorrecao." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a correção da atividade!";
}
#################################################################################










#################################################################################
# selecionarCorrecao
#--------------------------------------------------------------------------------
# Método que seleciona uma correção a partir de seu código
#################################################################################
sub selecionarCorrecao {
   my $self = shift;
   my $codigoCorrecao = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."AtividadeCorrecao AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoCorrecao = ".$codigoCorrecao." ";
   my $umaCorrecao = new ClasseAtividadeCorrecao;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a correção da atividade!\n";    
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
# Método que seleciona uma correção a partir do código da atividade
#################################################################################
sub selecionarCorrecaoAtividade {
   my $self = shift;
   my $codigoAtividade = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."AtividadeCorrecao AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoAtividade = ".$codigoAtividade." ";
   my $umaCorrecao = new ClasseAtividadeCorrecao;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);   
   $SQL->execute or die "Não foi possível selecionar a correção da atividade!\n";    
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
