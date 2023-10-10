package DadosAvisos;

use strict;
use ConexaoMySQL;
use ClasseAviso;
use FuncoesCronologicas;







#################################################################################
# DadosAvisos
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de avisos.
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
# Método que verifica se a tabela Aviso existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de avisos!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Aviso") {
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
# Método que verifica se a tabela Aviso existe, se não existir irá tentar 
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Aviso (";
      $tSQL = $tSQL."CodigoAviso int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."DataCalendario date not null,";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de avisos na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava um aviso na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umAviso = $_[0];
      if ($umAviso->getCodigoAviso() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Aviso set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Aviso set ";
         $fSQL = "WHERE CodigoAviso = ".$umAviso->getCodigoAviso()." ";
      }
      $tSQL = $tSQL."Titulo = \'".$umAviso->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umAviso->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umAviso->getDataBD()."\', ";
      $tSQL = $tSQL."DataCalendario = \'".$umAviso->getDataCalendarioBD()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umAviso->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar aviso!\n";
      if ($linhas == 0) { 
         #die "Aviso não foi gravado!\n";
      }
   } else {
      die "Nenhum aviso foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita os avisos da base de dados sem suas fotos, em ordem
# de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Aviso order by Data Desc ";
   my @colecaoAvisos = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar avisos!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAvisos[$i] = new ClasseAviso;
      $colecaoAvisos[$i]->setDadosBD($r->{'CodigoAviso'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAvisos;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui o aviso da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoAviso = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Aviso WHERE CodigoAviso = ".$codigoAviso." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir o aviso!";
}
#################################################################################










#################################################################################
# selecionarAviso
#--------------------------------------------------------------------------------
# Método que seleciona um aviso a partir de seu código
#################################################################################
sub selecionarAviso {
   my $self = shift;
   my $codigoAviso = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Aviso AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoAviso = ".$codigoAviso." ";
   my $umAviso = new ClasseAviso;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar o aviso!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umAviso->setDadosBD($r->{'CodigoAviso'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
       $umAviso->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umAviso->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umAviso;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de avisos na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Aviso ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de avisos!\n";
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
# Método que solicita parcialmente os avisos da base de dados.
#################################################################################
sub solicitarParcial {
   my $self = shift;
   my $indicePagina = $_[0];
   my $quantosPagina = $_[1];
   my $ultimoAcesso = $_[2];
   my $posicao = ($indicePagina-1) * $quantosPagina;
   my $tSQL = "SELECT *, (Data < \'$ultimoAcesso\') AS Lido ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Aviso as A ";
   $tSQL = $tSQL."INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL = $tSQL."ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "ORDER BY A.Data Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoAvisos = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar avisos!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAvisos[$i] = new ClasseAviso;
      $colecaoAvisos[$i]->setDadosBD($r->{'CodigoAviso'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $colecaoAvisos[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAvisos[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoAvisos[$i]->setLido($r->{'Lido'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAvisos;
}
#################################################################################










#################################################################################
# quantosNaoLido
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de avisos não lidos
#################################################################################
sub quantosNaoLido {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Aviso ";
   $tSQL .= "WHERE (Data >= \'$ultimoAcesso\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de avisos não lidos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# quantosHoje
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de avisos agendados para hoje
#################################################################################
sub quantosHoje {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $dataHoje = "$ano-$mes-$dia";
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Aviso ";
   $tSQL .= "WHERE (DataCalendario = \'$dataHoje\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de avisos agendados para hoje!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# solicitarAvisos
#--------------------------------------------------------------------------------
# Método que solicita parcialmente os avisos da base de dados.
#################################################################################
sub solicitarAvisos {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT *, (Data < \'$ultimoAcesso\') AS Lido ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Aviso as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.DataCalendario > \'0000-00-00\' ";
   $tSQL .= "ORDER BY A.DataCalendario ";
   my @colecaoAvisos;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar avisos!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAvisos[$i] = new ClasseAviso;
      $colecaoAvisos[$i]->setDadosBD($r->{'CodigoAviso'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $colecaoAvisos[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAvisos[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoAvisos[$i]->setLido($r->{'Lido'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAvisos;
}
#################################################################################










#################################################################################
# solicitarAvisosCalendario
#--------------------------------------------------------------------------------
# Método que solicita parcialmente os avisos da base de dados.
#################################################################################
sub solicitarAvisosCalendario {
   my $self = shift;
   my $dataLimiteBD = $_[0];
   my $ultimoAcesso = $_[1];
   my $tSQL = "SELECT *, (Data < \'$ultimoAcesso\') AS Lido ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Aviso as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.DataCalendario = \'$dataLimiteBD\' ";
   $tSQL .= "ORDER BY A.Data DESC ";
   my @colecaoAvisos;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar avisos!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAvisos[$i] = new ClasseAviso;
      $colecaoAvisos[$i]->setDadosBD($r->{'CodigoAviso'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $colecaoAvisos[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAvisos[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoAvisos[$i]->setLido($r->{'Lido'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAvisos;
}
#################################################################################











1;
