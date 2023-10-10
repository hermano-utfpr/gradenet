package DadosCalendario;

use strict;
use ConexaoMySQL;
use ClasseCalendario;
use FuncoesCronologicas;







#################################################################################
# DadosCalendario
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso � base da dados de calend�rios.
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
# M�todo que verifica se a tabela Calendario existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de calend�rios!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Calendario") {
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
# M�todo que verifica se a tabela Calendario existe, se n�o existir ir� tentar 
# cri�-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Calendario (";
      $tSQL = $tSQL."DataMarcada date PRIMARY KEY,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de calend�rio na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# M�todo que grava um calend�rio na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umCalendario = $_[0]; 
      if (!$self->existeCalendario($umCalendario->getDataMarcadaBD())) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Calendario set ";
         $tSQL .= "DataMarcada = \'".$umCalendario->getDataMarcadaBD()."\', ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Calendario set ";
         $fSQL = "WHERE DataMarcada = \'".$umCalendario->getDataMarcadaBD()."\' ";
      }
      $tSQL = $tSQL."Texto = \'".$umCalendario->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umCalendario->getDataBD()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umCalendario->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar calend�rio!\n";
      if ($linhas == 0) { 
         #die "Calend�rio n�o foi gravado!\n";
      }
   } else {
      die "Nenhum calend�rio foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# M�todo que solicita o calend�rio da base de dados.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Calendario order by DataMarcada ";
   my @colecaoCalendario = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar calend�rio!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoCalendario[$i] = new ClasseCalendario;
      $colecaoCalendario[$i]->setDadosBD($r->{'DataMarcada'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
      $i++;
   }
   $SQL->finish;
   return @colecaoCalendario;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# M�todo que exclui o calend�rio da base de dados
#################################################################################
sub excluir {
   my $self = shift;
   my $dataMarcada = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Calendario WHERE DataMarcada = \'".$dataMarcada."\' ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir o calend�rio!";
}
#################################################################################










#################################################################################
# selecionarCalendario
#--------------------------------------------------------------------------------
# M�todo que seleciona um calend�rio a partir de sua data
#################################################################################
sub selecionarCalendario {
   my $self = shift;
   my $umCalendario = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Calendario AS C ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON C.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE C.DataMarcada = \'".$umCalendario->getDataMarcadaBD()."\' ";
   my $umCalendario = new ClasseCalendario;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
#   die $tSQL;
   $SQL->execute or die "N�o foi poss�vel selecionar o calend�rio!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umCalendario->setDadosBD($r->{'DataMarcada'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
       $umCalendario->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umCalendario->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umCalendario;
}
#################################################################################










#################################################################################
# solicitarCalendarioAno
#--------------------------------------------------------------------------------
# M�todo que solicita o calendario de determinado ano.
#################################################################################
sub solicitarCalendarioAno {
   my $self = shift;
   my $ano = $_[0];
   my $ultimoAcesso = $_[1];
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta(); 
   my $tSQL = "SELECT *, (C.Data < \'$ultimoAcesso\') AS Lido ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Calendario as C ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON C.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE C.DataMarcada >= \'$ano-01-01\' AND C.DataMarcada <= \'$ano-12-31\' ";
   $tSQL .= "ORDER BY C.Data ";
   my @colecaoCalendario;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar calend�rio!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoCalendario[$i] = new ClasseCalendario;
      $colecaoCalendario[$i]->setDadosBD($r->{'DataMarcada'},$r->{'Texto'},$r->{'Data'},$r->{'CodigoUsuario'});
      $colecaoCalendario[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoCalendario[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoCalendario[$i]->setLido($r->{'Lido'});
      $i++;
   }
   $SQL->finish;
   return @colecaoCalendario;
}
#################################################################################










#################################################################################
# quantosNaoLido
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de calendario n�o lidos
#################################################################################
sub quantosNaoLido {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Calendario ";
   $tSQL .= "WHERE (Data >= \'$ultimoAcesso\' OR (DataMarcada >= \'$ano-$mes-$dia 00:00:00\' AND DataMarcada <= \'$ano-$mes-$dia 23:59:59\')) ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de calend�rio n�o lidos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# existeCalendario
#--------------------------------------------------------------------------------
# M�todo que verifica se a data j� foi inclu�da no calend�rio ou n�o
#################################################################################
sub existeCalendario {
   my $self = shift;
   my $dataMarcada = $_[0];
   my $tSQL = "SELECT count(*) as Existe FROM ".$self->umaConexao->getTab()."Calendario ";
   $tSQL .= "WHERE (DataMarcada = \'$dataMarcada\') ";
   my $existe = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
#   die $tSQL;
   $SQL->execute or die "Problemas ao verificar se o calend�rio j� existe!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $existe = $r->{'Existe'};
   }
   $SQL->finish;
   return $existe;
}
#################################################################################











1;
