package DadosPastas;

use strict;
use ConexaoMySQL;
use ClassePasta;
use FuncoesCronologicas;







#################################################################################
# DadosPastas
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de pastas
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
# Método que verifica se a tabela Pasta existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de pastas!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Pasta") {
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
# Método que verifica se a tabela Pasta existe, se não existir irá tentar 
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Pasta (";
      $tSQL = $tSQL."CodigoPasta int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."NomePasta varchar(100) not null,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de pastas na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma pasta na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaPasta = $_[0];
      if ($umaPasta->getCodigoPasta() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Pasta set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Pasta set ";
         $fSQL = "WHERE CodigoPasta = ".$umaPasta->getCodigoPasta()." ";
      }
      $tSQL = $tSQL."NomePasta = \'".$umaPasta->getNomePasta()."\', ";
      $tSQL = $tSQL."Data = \'".$umaPasta->getDataBD()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umaPasta->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar pasta!\n";
      if ($linhas == 0) { 
         #die "Pasta não foi gravada!\n";
      }
   } else {
      die "Nenhuma pasta foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as pastas da base de dados em ordem alfabética
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Pasta order by NomePasta ";
   my @colecaoPastas;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar pastas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoPastas[$i] = new ClassePasta;
      $colecaoPastas[$i]->setDadosBD($r->{'CodigoPasta'},$r->{'NomePasta'},$r->{'Data'},$r->{'CodigoUsuario'});
      $i++;
   }
   $SQL->finish;
   return @colecaoPastas;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui a pasta da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoPasta = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Pasta WHERE CodigoPasta = ".$codigoPasta." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a pasta!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Arquivo WHERE CodigoPasta = ".$codigoPasta." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir os arquivos da pasta!";
}
#################################################################################










#################################################################################
# selecionarPasta
#--------------------------------------------------------------------------------
# Método que seleciona uma pasta a partir de seu código
#################################################################################
sub selecionarPasta {
   my $self = shift;
   my $codigoPasta = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Pasta AS P ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON P.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE P.CodigoPasta = ".$codigoPasta." ";
   my $umaPasta = new ClassePasta;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a pasta!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umaPasta->setDadosBD($r->{'CodigoPasta'},$r->{'NomePasta'},$r->{'Data'},$r->{'CodigoUsuario'});
       $umaPasta->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaPasta->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umaPasta;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de pastas na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Pasta ";
   $tSQL .= "WHERE CodigoUsuario = $codigoUsuario ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de pastas!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# solicitarPastas
#--------------------------------------------------------------------------------
# Método que solicita as pastas da base de dados de acordo com o código do
# usuário
#################################################################################
sub solicitarPastas {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT *, P.CodigoPasta as CodigoDaPasta, P.Data as DataPasta, COUNT(A.CodigoArquivo) AS QtdeArquivos ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Pasta as P ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON P.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."Arquivo AS A ";
   $tSQL .= "ON P.CodigoPasta = A.CodigoPasta ";
   $tSQL .= "WHERE P.CodigoUsuario = $codigoUsuario ";
   $tSQL .= "GROUP BY P.CodigoPasta ";
   $tSQL .= "ORDER BY P.NomePasta ";
   my @colecaoPastas;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar pastas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoPastas[$i] = new ClassePasta;
      $colecaoPastas[$i]->setDadosBD($r->{'CodigoDaPasta'},$r->{'NomePasta'},$r->{'DataPasta'},$r->{'CodigoUsuario'});
      $colecaoPastas[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoPastas[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoPastas[$i]->setQtdeArquivos($r->{'QtdeArquivos'});
      $i++;
   }
   $SQL->finish;
   return @colecaoPastas;
}
#################################################################################











1;
