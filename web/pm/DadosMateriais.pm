package DadosMateriais;

use strict;
use ConexaoMySQL;
use ClasseMaterial;
use FuncoesCronologicas;







#################################################################################
# DadosMateriais
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso � base da dados de materiais.
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
# M�todo que verifica se a tabela Material existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de materiais!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Material") {
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
# M�todo que verifica se a tabela Material existe, se n�o existir ir� tentar 
# cri�-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Material (";
      $tSQL = $tSQL."CodigoMaterial int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."DataCalendario date not null,";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de materiais na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# M�todo que grava um material na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umMaterial = $_[0];
      if ($umMaterial->getCodigoMaterial() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Material set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Material set ";
         $fSQL = "WHERE CodigoMaterial = ".$umMaterial->getCodigoMaterial()." ";
      }
      $tSQL = $tSQL."Titulo = \'".$umMaterial->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umMaterial->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umMaterial->getDataBD()."\', ";
      $tSQL = $tSQL."DataCalendario = \'".$umMaterial->getDataCalendarioBD()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umMaterial->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar material!\n";
      if ($linhas == 0) { 
         #die "Material n�o foi gravado!\n";
      }
   } else {
      die "Nenhum material foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# M�todo que solicita os materiais da base de dados sem suas fotos, em ordem
# de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Material order by Data Desc ";
   my @colecaoMateriais = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar materiais!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoMateriais[$i] = new ClasseMaterial;
      $colecaoMateriais[$i]->setDadosBD($r->{'CodigoMaterial'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $i++;
   }
   $SQL->finish;
   return @colecaoMateriais;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# M�todo que exclui o material da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoMaterial = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Material WHERE CodigoMaterial = ".$codigoMaterial." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir o material!";
}
#################################################################################










#################################################################################
# selecionarMaterial
#--------------------------------------------------------------------------------
# M�todo que seleciona um material a partir de seu c�digo
#################################################################################
sub selecionarMaterial {
   my $self = shift;
   my $codigoMaterial = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Material AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoMaterial = ".$codigoMaterial." ";
   my $umMaterial = new ClasseMaterial;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel selecionar o material!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
       $umMaterial->setDadosBD($r->{'CodigoMaterial'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
       $umMaterial->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umMaterial->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umMaterial;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de materiais na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Material ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de materiais!\n";
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
# M�todo que solicita parcialmente os materiais da base de dados.
#################################################################################
sub solicitarParcial {
   my $self = shift;
   my $indicePagina = $_[0];
   my $quantosPagina = $_[1];
   my $ultimoAcesso = $_[2];
   my $posicao = ($indicePagina-1) * $quantosPagina;
   my $tSQL = "SELECT *, (Data < \'$ultimoAcesso\') AS Lido ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Material as A ";
   $tSQL = $tSQL."INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL = $tSQL."ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "ORDER BY A.Data Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoMateriais = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar materiais!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoMateriais[$i] = new ClasseMaterial;
      $colecaoMateriais[$i]->setDadosBD($r->{'CodigoMaterial'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $colecaoMateriais[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoMateriais[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoMateriais[$i]->setLido($r->{'Lido'});
      $i++;
   }
   $SQL->finish;
   return @colecaoMateriais;
}
#################################################################################










#################################################################################
# quantosNaoLido
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de materiais n�o lidos
#################################################################################
sub quantosNaoLido {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Material ";
   $tSQL .= "WHERE (Data >= \'$ultimoAcesso\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de materiais n�o lidos!\n";
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
# M�todo que solicita a quantidade de materiais agendados para hoje
#################################################################################
sub quantosHoje {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $dataHoje = "$ano-$mes-$dia";
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Material ";
   $tSQL .= "WHERE (DataCalendario = \'$dataHoje\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de materiais agendados para hoje!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# solicitarMateriais
#--------------------------------------------------------------------------------
# M�todo que solicita parcialmente os materiais da base de dados.
#################################################################################
sub solicitarMateriais {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT *, (Data < \'$ultimoAcesso\') AS Lido ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Material as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.DataCalendario > \'0000-00-00\' ";
   $tSQL .= "ORDER BY A.DataCalendario ";
   my @colecaoMateriais;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar materiais!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoMateriais[$i] = new ClasseMaterial;
      $colecaoMateriais[$i]->setDadosBD($r->{'CodigoMaterial'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $colecaoMateriais[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoMateriais[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoMateriais[$i]->setLido($r->{'Lido'});
      $i++;
   }
   $SQL->finish;
   return @colecaoMateriais;
}
#################################################################################










#################################################################################
# solicitarMateriaisCalendario
#--------------------------------------------------------------------------------
# M�todo que solicita parcialmente os materiais da base de dados.
#################################################################################
sub solicitarMateriaisCalendario {
   my $self = shift;
   my $dataLimiteBD = $_[0];
   my $ultimoAcesso = $_[1];
   my $tSQL = "SELECT *, (Data < \'$ultimoAcesso\') AS Lido ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Material as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.DataCalendario = \'$dataLimiteBD\' ";
   $tSQL .= "ORDER BY A.Data DESC ";
   my @colecaoMateriais;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar materiais!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoMateriais[$i] = new ClasseMaterial;
      $colecaoMateriais[$i]->setDadosBD($r->{'CodigoMaterial'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataCalendario'},$r->{'CodigoUsuario'});
      $colecaoMateriais[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoMateriais[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoMateriais[$i]->setLido($r->{'Lido'});
      $i++;
   }
   $SQL->finish;
   return @colecaoMateriais;
}
#################################################################################











1;
