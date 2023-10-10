package DadosSessoes;

use strict;
use ConexaoMySQL;
use ClasseSessao;
use FuncoesCronologicas;









#################################################################################
# DadosSessoes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados das sessões.
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
# Método que verifica se a tabela Sessao existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabela de sessões!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Sessao") {
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
# Método que verifica se a tabela Sessao existe, se não existir irá tentar
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Sessao (";
      $tSQL = $tSQL."SessaoID varchar(20) PRIMARY KEY,";
      $tSQL = $tSQL."CodigoUsuario int NOT NULL,";
      $tSQL = $tSQL."IP varchar(15),";
      $tSQL = $tSQL."Browser varchar(100),";
      $tSQL = $tSQL."DataInicial datetime,";
      $tSQL = $tSQL."DataFinal datetime,";
      $tSQL = $tSQL."DataPresenca datetime,";
      $tSQL = $tSQL."Valido bool)";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabela de sessões na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma sessão na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaSessao = $_[0];
      my $modo = $_[1];
      if ($modo == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Sessao set ";
         $tSQL = $tSQL."SessaoID = \'".$umaSessao->getSessaoID()."\', ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Sessao set ";
         $fSQL = "WHERE SessaoID = \'".$umaSessao->getSessaoID()."\' ";
      }
      $tSQL = $tSQL."CodigoUsuario = \'".$umaSessao->getCodigoUsuario()."\', ";
      $tSQL = $tSQL."IP = \'".$umaSessao->getIP()."\', ";
      $tSQL = $tSQL."Browser = \'".$umaSessao->getBrowser()."\', ";
      $tSQL = $tSQL."DataInicial = \'".$umaSessao->getDataInicialBD()."\', ";
      $tSQL = $tSQL."DataFinal = \'".$umaSessao->getDataFinalBD()."\', ";
      $tSQL = $tSQL."DataPresenca = \'".$umaSessao->getDataPresencaBD()."\', ";
      $tSQL = $tSQL."Valido = \'".$umaSessao->getValido()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar sessão!\n";
      if ($linhas == 0) { 
         #die "Sessão não foi gravada!\n";
      }
      if ($modo == 0) {
         $self->invalidarSessoesAnteriores($umaSessao->getSessaoID(),$umaSessao->getCodigoUsuario());
      }
   } else {
      die "Nenhuma sessão foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita os sessões da base de dados.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Sessao as S ";
   $tSQL = $tSQL."LEFT OUTER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL = $tSQL."ON S.CodigoUsuario = U.CodigoUsuario Desc ";
   my @colecaoSessoes = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar sessões!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoSessoes[$i] = new ClasseSessao;
      $colecaoSessoes[$i]->setDadosBD($r->{'SessaoID'},$r->{'CodigoUsuario'},$r->{'IP'},$r->{'Browser'},$r->{'DataInicial'},$r->{'DataFinal'},$r->{'DataPresenca'},$r->{'Valido'});
      $colecaoSessoes[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoSessoes[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoSessoes;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui a sessão da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $sessaoID = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Sessao WHERE SessaoID = \'".$sessaoID."\' ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a sessão!\n";
}
#################################################################################










#################################################################################
# selecionarSessao
#--------------------------------------------------------------------------------
# Método que seleciona uma sessão pelo seu ID
#################################################################################
sub selecionarSessao {
   my $self = shift;
   my $sessaoID = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Sessao as S ";
   $tSQL = $tSQL."LEFT OUTER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL = $tSQL."ON S.CodigoUsuario = U.CodigoUsuario ";
   $tSQL = $tSQL."WHERE S.SessaoID = \'".$sessaoID."\' ";
   my $umaSessao = new ClasseSessao;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a sessão!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $umaSessao->setDadosBD($r->{'SessaoID'},$r->{'CodigoUsuario'},$r->{'IP'},$r->{'Browser'},$r->{'DataInicial'},$r->{'DataFinal'},$r->{'DataPresenca'},$r->{'Valido'});
      $umaSessao->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $umaSessao->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umaSessao;
}
#################################################################################









#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de sessões já foram criadas
#################################################################################
sub quantidade {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT COUNT(*) AS qtde FROM ".$self->umaConexao->getTab()."Sessao as S ";
   $tSQL = $tSQL."LEFT OUTER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL = $tSQL."ON S.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE UNIX_TIMESTAMP(S.DataInicial) != UNIX_TIMESTAMP(S.DataFinal) ";
   if ($codigoUsuario > 0) {
      $tSQL .= "AND S.CodigoUsuario = $codigoUsuario ";
   }
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de sessões!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# invalidarSessao
#--------------------------------------------------------------------------------
# Método que invalida a sessão na base de dados.
#################################################################################
sub invalidarSessao {
   my $self = shift;
   my $sessaoID = $_[0];
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $dataFinal = "$ano-$mes-$dia $hor:$min:$seg";
   my $tSQL = "UPDATE ".$self->umaConexao->getTab()."Sessao SET Valido = 0, DataFinal = \'".$dataFinal."\' WHERE SessaoID = \'".$sessaoID."\' AND Valido = 1";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível invalidar a sessão!\n";
}
#################################################################################









#################################################################################
# marcarPresenca
#--------------------------------------------------------------------------------
# Método que marca a data de presenca na sessão do usuário.
#################################################################################
sub marcarPresenca {
   my $self = shift;
   my $sessaoID = $_[0];
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $dataPresenca = "$ano-$mes-$dia $hor:$min:$seg";
   my $tSQL = "UPDATE ".$self->umaConexao->getTab()."Sessao SET DataPresenca = \'".$dataPresenca."\' WHERE SessaoID = \'".$sessaoID."\' AND Valido = 1 ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível marcar presença na sessão!\n";
}
#################################################################################









#################################################################################
# invalidarSessoesAnteriores
#--------------------------------------------------------------------------------
# Método que invalida sessões anteriores a nova sessão
#################################################################################
sub invalidarSessoesAnteriores {
   my $self = shift;
   my $sessaoIDAtual = $_[0];
   my $codigoUsuarioAtual = $_[1];
   my $tSQL = "";
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."Sessao SET Valido = 0, DataFinal = DATE_ADD(DataPresenca, INTERVAL 1 SECOND) WHERE SessaoID != \'".$sessaoIDAtual."\' AND CodigoUsuario = ".$codigoUsuarioAtual." AND Valido = 1 ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível invalidar as sessões anteriores!\n";
}
#################################################################################









#################################################################################
# solicitarParcial
#--------------------------------------------------------------------------------
# Método que solicita parcialmente as sessões da base de dados.
#################################################################################
sub solicitarParcial {
   my $self = shift;
   my $indicePagina = $_[0];
   my $quantosPagina = $_[1];
   my $codigoUsuario = $_[2];
   my $posicao = ($indicePagina-1) * $quantosPagina;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Sessao as S ";
   $tSQL = $tSQL."LEFT OUTER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL = $tSQL."ON S.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE UNIX_TIMESTAMP(S.DataInicial) != UNIX_TIMESTAMP(S.DataFinal) ";
   if ($codigoUsuario > 0) {
      $tSQL .= "AND S.CodigoUsuario = $codigoUsuario ";
   }
   $tSQL .= "ORDER BY S.DataInicial Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoSessoes = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar sessões!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoSessoes[$i] = new ClasseSessao;
      $colecaoSessoes[$i]->setDadosBD($r->{'SessaoID'},$r->{'CodigoUsuario'},$r->{'IP'},$r->{'Browser'},$r->{'DataInicial'},$r->{'DataFinal'},$r->{'DataPresenca'},$r->{'Valido'});
      $colecaoSessoes[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoSessoes[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoSessoes;
}
#################################################################################











1;
