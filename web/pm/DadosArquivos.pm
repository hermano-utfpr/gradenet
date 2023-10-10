package DadosArquivos;

use strict;
use ConexaoMySQL;
use ClasseArquivo;
use FuncoesCronologicas;







#################################################################################
# DadosArquivos
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso � base da dados de arquivos
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
# M�todo que verifica se a tabela Arquivo existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de arquivos!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Arquivo") {
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
# M�todo que verifica se a tabela Arquivo existe, se n�o existir ir� tentar 
# cri�-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Arquivo (";
      $tSQL = $tSQL."CodigoArquivo int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."NomeArquivo varchar(200) not null,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."Arquivo mediumblob,";
      $tSQL = $tSQL."Permissao bool,";
      $tSQL = $tSQL."CodigoPasta int not null, ";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de arquivos na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# M�todo que grava um arquivo na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umArquivo = $_[0];
      if ($umArquivo->getCodigoArquivo() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Arquivo set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Arquivo set ";
         $fSQL = "WHERE CodigoArquivo = ".$umArquivo->getCodigoArquivo()." ";
      }
      $tSQL = $tSQL."NomeArquivo = \'".$umArquivo->getNomeArquivo()."\', ";
      $tSQL = $tSQL."Data = \'".$umArquivo->getDataBD()."\', ";
      $tSQL = $tSQL."Arquivo = ".$self->umaConexao->executar->quote($umArquivo->getArquivo()).", ";
      $tSQL = $tSQL."Permissao = \'".$umArquivo->getPermissao()."\', ";
      $tSQL = $tSQL."CodigoPasta = \'".$umArquivo->getCodigoPasta()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umArquivo->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar arquivo!\n";
      if ($linhas == 0) { 
         #die "Arquivo n�o foi gravado!\n";
      }
   } else {
      die "Nenhuma arquivo foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# M�todo que solicita os arquivos da base de dados em ordem alfab�tica
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Arquivo order by NomeArquivo ";
   my @colecaoArquivos;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar arquivos!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoArquivos[$i] = new ClasseArquivo;
      $colecaoArquivos[$i]->setDadosBD($r->{'CodigoArquivo'},$r->{'NomeArquivo'},$r->{'Data'},$r->{'Arquivo'},$r->{'Permissao'},$r->{'CodigoPasta'},$r->{'CodigoUsuario'});
      $i++;
   }
   $SQL->finish;
   return @colecaoArquivos;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# M�todo que exclui o arquivo da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoArquivo = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Arquivo WHERE CodigoArquivo = ".$codigoArquivo." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir o arquivo!";
}
#################################################################################










#################################################################################
# selecionarArquivo
#--------------------------------------------------------------------------------
# M�todo que seleciona um arquivo a partir de seu c�digo
#################################################################################
sub selecionarArquivo {
   my $self = shift;
   my $codigoArquivo = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Arquivo AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE (A.CodigoArquivo = $codigoArquivo AND A.CodigoUsuario = $codigoUsuario) ";
   $tSQL .= "OR (A.CodigoArquivo = $codigoArquivo AND A.Permissao=1) ";
   my $umArquivo = new ClasseArquivo;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel selecionar o arquivo!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umArquivo->setDadosBD($r->{'CodigoArquivo'},$r->{'NomeArquivo'},$r->{'Data'},$r->{'Arquivo'},$r->{'Permissao'},$r->{'CodigoPasta'},$r->{'CodigoUsuario'});
       $umArquivo->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umArquivo->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umArquivo;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de arquivos na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $codigoPasta = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Arquivo ";
   $tSQL .= "WHERE CodigoPasta = $codigoPasta AND CodigoUsuario = $codigoUsuario ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de arquivos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# solicitarArquivos
#--------------------------------------------------------------------------------
# M�todo que solicita os arquivos da base de dados de acordo com o c�digo do
# usu�rio
#################################################################################
sub solicitarArquivos {
   my $self = shift;
   my $codigoPasta = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT * ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Arquivo as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoUsuario = $codigoUsuario AND A.CodigoPasta = $codigoPasta ";
   $tSQL .= "ORDER BY A.NomeArquivo ";
   my @colecaoArquivos;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar arquivos!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoArquivos[$i] = new ClasseArquivo;
      $colecaoArquivos[$i]->setDadosBD($r->{'CodigoArquivo'},$r->{'NomeArquivo'},$r->{'Data'},$r->{'Arquivo'},$r->{'Permissao'},$r->{'CodigoPasta'},$r->{'CodigoUsuario'});
      $colecaoArquivos[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoArquivos[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoArquivos;
}
#################################################################################










#################################################################################
# qtdeEspacoUsado
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade em bytes utilizados
#################################################################################
sub qtdeEspacoUsado {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT A.Arquivo ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Arquivo as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoUsuario = $codigoUsuario";
   my $totalBytes = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar arquivos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $totalBytes += length($r->{'Arquivo'});
   }
   $SQL->finish;
   return $totalBytes;
}
#################################################################################











1;
