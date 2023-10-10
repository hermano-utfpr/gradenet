package DadosTestesUsuarios;

use strict;
use ConexaoMySQL;
use ClasseTeste;
use FuncoesCronologicas;
use ClasseTesteUsuario;






#################################################################################
# DadosTestesUsuarios
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso � base da dados de teste.
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
# M�todo que verifica se a tabela TesteUsuario existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de testes dos usu�rios!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."TesteUsuario") {
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
# M�todo que verifica se a tabela TesteUsuario existe, se n�o existir ir� tentar
# cri�-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."TesteUsuario (";
      $tSQL = $tSQL."CodigoTeste int not null,";
      $tSQL = $tSQL."CodigoUsuario int not null,";
      $tSQL = $tSQL."Historico text,";
      $tSQL = $tSQL."Nota float(5,2),";
      $tSQL = $tSQL."NotaCorrigida float(5,2),";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."Status char) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de testes na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# solicitarTestesDoUsuario
#--------------------------------------------------------------------------------
# M�todo que solicita os testes dos usu�rios
#################################################################################
sub solicitarTestesDoUsuario {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT T.*,TU.*,T.Data AS DataTeste, TU.Data AS DataTesteUsuario, TU.CodigoUsuario AS CodigoDoUsuario, T.CodigoUsuario AS TCodigoUsuario, T.CodigoTeste AS CodigoDoTeste ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Teste AS T ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS TU ";
   $tSQL .= "ON T.CodigoTeste = TU.CodigoTeste ";
   $tSQL .= "WHERE TU.CodigoUsuario = $codigoUsuario OR TU.CodigoUsuario IS NULL ";
   $tSQL .= "ORDER BY T.Data DESC ";
#   die $tSQL;
   my @colecaoTestes;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar testes do usu�rio!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoTestes[$i] = new ClasseTesteUsuario;
      $colecaoTestes[$i]->setDadosBD($r->{'CodigoDoTeste'},$r->{'CodigoDoUsuario'},$r->{'Historico'},$r->{'Nota'},$r->{'NotaCorrigida'},$r->{'DataTesteUsuario'},$r->{'Status'});
      $colecaoTestes[$i]->umTeste->setDadosBD($r->{'CodigoDoTeste'},$r->{'Titulo'},$r->{'Texto'},$r->{'DataTeste'},$r->{'HabRanking'},$r->{'NumQuestoes'},$r->{'TCodigoUsuario'});
      $i++;
   }
   $SQL->finish;
   return @colecaoTestes;
}
#################################################################################









#################################################################################
# solicitarUsuariosDoTeste
#--------------------------------------------------------------------------------
# M�todo que solicita os alunos de um teste
#################################################################################
sub solicitarUsuariosDoTeste {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $tSQL = "SELECT U.*,TU.*,TU.Data AS DataTesteUsuario, TU.CodigoUsuario AS CodigoDoUsuario, U.CodigoUsuario AS UCodigoUsuario ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS TU ";
   $tSQL .= "ON U.CodigoUsuario = TU.CodigoUsuario ";
   $tSQL .= "WHERE (TU.CodigoTeste = $codigoTeste OR TU.CodigoTeste IS NULL) ";
   $tSQL .= "AND U.Privilegios = 0 ";
   $tSQL .= "ORDER BY U.Nome ";
#   die $tSQL;
   my @colecaoTestes;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar alunos dos testes!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoTestes[$i] = new ClasseTesteUsuario;
      $colecaoTestes[$i]->setDadosBD($r->{'CodigoDoTeste'},$r->{'CodigoDoUsuario'},$r->{'Historico'},$r->{'Nota'},$r->{'NotaCorrigida'},$r->{'DataTesteUsuario'},$r->{'Status'});
      $colecaoTestes[$i]->umUsuario->setCodigoUsuario($r->{'UCodigoUsuario'});
      $colecaoTestes[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoTestes;
}
#################################################################################











#################################################################################
# solicitarGerenciar
#--------------------------------------------------------------------------------
# M�todo que solicita os alunos da base de dados, para gerenciamento do teste.
#################################################################################
sub solicitarGerenciar {
   my $self = shift;
   my $codigoTeste = $_[0];

   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

   my $tSQL = "SELECT U.*, T.*, MAX(S.Valido = 1 AND DATE_SUB(\'$ano-$mes-$dia $hor:$min:$seg\', INTERVAL 10 MINUTE) <= S.DataPresenca) AS Online, ";
   $tSQL .= "U.CodigoUsuario AS CodigoDoUsuario, ";
   $tSQL .= "T.CodigoTeste AS CodigoDoTeste ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Sessao AS S ON U.CodigoUsuario = S.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS T ";
   $tSQL .= "ON U.CodigoUsuario = T.CodigoUsuario AND T.CodigoTeste = $codigoTeste ";
   $tSQL .= "WHERE U.Privilegios = 0 AND U.Ativo = 1 ";
   $tSQL .= "GROUP BY U.CodigoUsuario ";
   $tSQL .= "ORDER BY U.Nome ";
   my @colecaoTestesUsuarios = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   #die $tSQL;
   $SQL->execute or die "Problemas ao selecionar testes para serem gerenciados!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoTestesUsuarios[$i] = new ClasseTesteUsuario;
     $colecaoTestesUsuarios[$i]->setDadosBD($r->{'CodigoDoTeste'},$r->{'CodigoDoUsuario'},$r->{'Historico'},$r->{'Nota'},$r->{'NotaCorrigida'},$r->{'Data'},$r->{'Status'});
      $colecaoTestesUsuarios[$i]->umUsuario->setCodigoUsuario($r->{'CodigoDoUsuario'});
      $colecaoTestesUsuarios[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoTestesUsuarios[$i]->umUsuario->setSexo($r->{'Sexo'});
      $colecaoTestesUsuarios[$i]->umUsuario->setAtivo($r->{'Ativo'});
      $colecaoTestesUsuarios[$i]->umUsuario->info->setOnline($r->{'Online'});
      $i++;
   }
   $SQL->finish;
   return @colecaoTestesUsuarios;
}
#################################################################################











#################################################################################
# abrirTeste
#--------------------------------------------------------------------------------
# M�todo para abrir teste.
#################################################################################
sub abrirTeste {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $codigoTeste = $_[0];
      my $codigoUsuario = $_[1];
      my $umTesteUsuario = $self->selecionarTeste($codigoTeste,$codigoUsuario);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."TesteUsuario set ";
      $tSQL .= "CodigoTeste = $codigoTeste, CodigoUsuario=$codigoUsuario, Data=\'$ano-$mes-$dia $hor:$min:$seg\', Status=\'A\' ";
      my $status = $umTesteUsuario->getStatus();
      if ($status eq "") {
         my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao abrir teste!\n";
      }
   } else {
      die "O teste n�o pode ser aberto!\n";
   }
}
#################################################################################











#################################################################################
# fecharTeste
#--------------------------------------------------------------------------------
# M�todo para fechar o teste.
#################################################################################
sub fecharTeste {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $codigoTeste = $_[0];
      my $codigoUsuario = $_[1];
      $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteUsuario ";
      $tSQL .= "WHERE CodigoTeste = $codigoTeste AND CodigoUsuario=$codigoUsuario ";
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao fechar teste!\n";
   } else {
      die "O teste n�o pode ser fechado!\n";
   }
}
#################################################################################











#################################################################################
# zerarTeste
#--------------------------------------------------------------------------------
# M�todo para zerar o teste.
#################################################################################
sub zerarTeste {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $codigoTeste = $_[0];
      my $codigoUsuario = $_[1];
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."TesteUsuario SET ";
      $tSQL .= "Historico=\'\', Nota=0, NotaCorrigida=0, Data=\'$ano-$mes-$dia $hor:$min:$seg\', Status=\'E\' ";
      $tSQL .= "WHERE CodigoTeste = $codigoTeste AND CodigoUsuario=$codigoUsuario ";
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao zerar teste!\n";
   } else {
      die "O teste n�o pode ser zerado!\n";
   }
}
#################################################################################











#################################################################################
# iniciarTeste
#--------------------------------------------------------------------------------
# M�todo para iniciar o teste.
#################################################################################
sub iniciarTeste {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $codigoTeste = $_[0];
      my $codigoUsuario = $_[1];
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."TesteUsuario SET ";
      $tSQL .= "Data=\'$ano-$mes-$dia $hor:$min:$seg\', Status=\'F\' ";
      $tSQL .= "WHERE CodigoTeste = $codigoTeste AND CodigoUsuario=$codigoUsuario ";
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao iniciar teste!\n";
   } else {
      die "O teste n�o pode ser iniciado!\n";
   }
}
#################################################################################











#################################################################################
# encerrarTeste
#--------------------------------------------------------------------------------
# M�todo para encerrar o teste.
#################################################################################
sub encerrarTeste {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $umTeste = $_[0];
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."TesteUsuario SET ";
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $tSQL .= "Historico=\'".$umTeste->getHistorico()."\', ";
      $tSQL .= "Nota=".$umTeste->getNota().", ";
      $tSQL .= "NotaCorrigida=".$umTeste->getNotaCorrigida().", ";
      $tSQL .= "Data=\'$ano-$mes-$dia $hor:$min:$seg\', ";
      $tSQL .= "Status=\'E\' ";
      $tSQL .= "WHERE CodigoTeste = ".$umTeste->getCodigoTeste()." AND CodigoUsuario=".$umTeste->getCodigoUsuario()." ";
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao encerrar teste!\n";
   } else {
      die "O teste n�o pode ser encerrado!\n";
   }
}
#################################################################################











#################################################################################
# selecionarTeste
#--------------------------------------------------------------------------------
# M�todo que seleciona um teste da base de dados.
#################################################################################
sub selecionarTeste {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $codigoUsuario = $_[1];

   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

   my $tSQL = "SELECT U.*, T.*, MAX(S.Valido = 1 AND DATE_SUB(\'$ano-$mes-$dia $hor:$min:$seg\', INTERVAL 10 MINUTE) <= S.DataPresenca) AS Online, ";
   $tSQL .= "U.CodigoUsuario AS CodigoDoUsuario, ";
   $tSQL .= "T.CodigoTeste AS CodigoDoTeste ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Sessao AS S ON U.CodigoUsuario = S.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS T ";
   $tSQL .= "ON U.CodigoUsuario = T.CodigoUsuario AND T.CodigoTeste = $codigoTeste ";
   $tSQL .= "WHERE U.Privilegios = 0 AND U.Ativo = 1 ";
   $tSQL .= "AND U.CodigoUsuario = $codigoUsuario ";
   $tSQL .= "GROUP BY U.CodigoUsuario ";
   $tSQL .= "ORDER BY U.Nome ";
   my $umTesteUsuario = new ClasseTesteUsuario;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar testes para serem gerenciados!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $umTesteUsuario->setDadosBD($r->{'CodigoDoTeste'},$r->{'CodigoDoUsuario'},$r->{'Historico'},$r->{'Nota'},$r->{'NotaCorrigida'},$r->{'Data'},$r->{'Status'});
      $umTesteUsuario->umUsuario->setCodigoUsuario($r->{'CodigoDoUsuario'});
      $umTesteUsuario->umUsuario->setNome($r->{'Nome'});
      $umTesteUsuario->umUsuario->setSexo($r->{'Sexo'});
      $umTesteUsuario->umUsuario->setAtivo($r->{'Ativo'});
      $umTesteUsuario->umUsuario->info->setOnline($r->{'Online'});
      $i++;
   }
   $SQL->finish;
   return $umTesteUsuario;
}
#################################################################################



#################################################################################
# selecionarNotaTeste
#--------------------------------------------------------------------------------
# M�todo que seleciona a nota de um aluno em um teste da base de dados.
# 2018/02/25 - Fun��o nova
#################################################################################
sub selecionarNotaTeste {
   my $self = shift;
   my $codigoTeste = $_[0];
   my $codigoUsuario = $_[1];

   my $tSQL = "SELECT T.* ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."TesteUsuario AS T ";
   $tSQL .= "WHERE T.CodigoUsuario = $codigoUsuario ";
   $tSQL .= "AND T.CodigoTeste = $codigoTeste ";
   my $umTesteUsuario = new ClasseTesteUsuario;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar nota do teste!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $umTesteUsuario->setDadosBD($r->{'CodigoTeste'},$r->{'CodigoUsuario'},$r->{'Historico'},$r->{'Nota'},$r->{'NotaCorrigida'},$r->{'Data'},$r->{'Status'});
      $i++;
   }
   $SQL->finish;
   return $umTesteUsuario;
}
#################################################################################







#################################################################################
# reabrirTeste
#--------------------------------------------------------------------------------
# M�todo para reabrir teste.
#################################################################################
sub reabrirTeste {
   my $self = shift;
   if (@_) {
      my $codigoTeste = $_[0];
      my $codigoUsuario = $_[1];
      $self->fecharTeste($codigoTeste, $codigoUsuario);
      $self->abrirTeste($codigoTeste, $codigoUsuario);
   } else {
      die "O teste n�o pode ser reaberto!\n";
   }
}
#################################################################################











#################################################################################
# solicitarGerenciarAluno
#--------------------------------------------------------------------------------
# M�todo que solicita os testes de um aluno
#################################################################################
sub solicitarGerenciarAluno {
   my $self = shift;
   my $codigoUsuario = $_[0];

   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

   my $tSQL = "SELECT T.*, TU.*, ";
   $tSQL .= "TU.CodigoUsuario AS CodigoDoUsuario, ";
   $tSQL .= "T.CodigoTeste AS CodigoDoTeste, ";
   $tSQL .= "T.Data As DataDoTeste ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Teste AS T ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS TU ";
   $tSQL .= "ON TU.CodigoTeste = T.CodigoTeste ";
   $tSQL .= "AND TU.CodigoUsuario = $codigoUsuario ";
   $tSQL .= "ORDER BY T.Data DESC ";
   my @colecaoTestesUsuarios = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
#   die $tSQL;
   $SQL->execute or die "Problemas ao selecionar testes para serem gerenciados!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoTestesUsuarios[$i] = new ClasseTesteUsuario;
     $colecaoTestesUsuarios[$i]->setDadosBD($r->{'CodigoDoTeste'},$r->{'CodigoDoUsuario'},$r->{'Historico'},$r->{'Nota'},$r->{'NotaCorrigida'},$r->{'Data'},$r->{'Status'});
      $colecaoTestesUsuarios[$i]->umUsuario->setCodigoUsuario($r->{'CodigoDoUsuario'});
      $colecaoTestesUsuarios[$i]->umTeste->setCodigoTeste($r->{'CodigoDoTeste'});
      $colecaoTestesUsuarios[$i]->umTeste->setData($r->{'DataDoTeste'});
      $colecaoTestesUsuarios[$i]->umTeste->setTitulo($r->{'Titulo'});
      $colecaoTestesUsuarios[$i]->umTeste->setHabRanking($r->{'HabRanking'});
      $i++;
   }
   $SQL->finish;
   return @colecaoTestesUsuarios;
}
#################################################################################











#################################################################################
# corrigirNotaTeste
#--------------------------------------------------------------------------------
# M�todo para corrigir a nota do teste
#################################################################################
sub corrigirNotaTeste {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $codigoTeste = $_[0];
      my $codigoUsuario = $_[1];
      my $notaCorrigida = $_[2];
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."TesteUsuario SET ";
      $tSQL .= "NotaCorrigida=$notaCorrigida ";
      $tSQL .= "WHERE CodigoTeste = $codigoTeste AND CodigoUsuario=$codigoUsuario ";
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao corrigir nota do teste!\n";
   } else {
      die "A nota do teste n�o pode ser corrigida!\n";
   }
}
#################################################################################









#################################################################################
# solicitarRanking
#--------------------------------------------------------------------------------
# M�todo que solicita os usu�rios e informa��es do Ranking
#################################################################################
sub solicitarRanking {
   my $self = shift;
   my $tSQL = "SELECT U.*, AVG(TU.NotaCorrigida) AS Media, COUNT(*) AS NumTestes, ";
   $tSQL .= "U.CodigoUsuario AS CodigoDoUsuario ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS TU ON U.CodigoUsuario = TU.CodigoUsuario ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Teste AS T ON T.CodigoTeste = TU.CodigoTeste ";
   $tSQL .= "WHERE TU.Status = \'E\' AND T.HabRanking = 1 ";
   $tSQL .= "GROUP BY U.CodigoUsuario HAVING Media >= 6 ";
   $tSQL .= "ORDER BY NumTestes DESC, Media DESC,Nome ";
#   die $tSQL;
   my @colecaoUsuarios;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar ranking!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoUsuarios[$i] = new ClasseUsuario;
      $colecaoUsuarios[$i]->setDadosBD($r->{'CodigoDoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      my $media = sprintf("%5.2f",$r->{'Media'});
      $colecaoUsuarios[$i]->info->setMediaRank($media);
      $colecaoUsuarios[$i]->info->setTestesRank($r->{'NumTestes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoUsuarios;
}
#################################################################################




#################################################################################
# solicitarRanking
#--------------------------------------------------------------------------------
# M�todo que solicita os usu�rios e informa��es do Ranking
#################################################################################
sub solicitarRankingTodos {
   my $self = shift;
   my $tSQL = "SELECT U.*, AVG(TU.NotaCorrigida) AS Media, COUNT(*) AS NumTestes, ";
   $tSQL .= "U.CodigoUsuario AS CodigoDoUsuario ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."TesteUsuario AS TU ON U.CodigoUsuario = TU.CodigoUsuario ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Teste AS T ON T.CodigoTeste = TU.CodigoTeste ";
   $tSQL .= "WHERE TU.Status = \'E\' AND T.HabRanking = 1 ";
   $tSQL .= "GROUP BY U.CodigoUsuario HAVING Media > 0 ";
   $tSQL .= "ORDER BY NumTestes DESC, Media DESC,Nome ";
#   die $tSQL;
   my @colecaoUsuarios;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar ranking!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoUsuarios[$i] = new ClasseUsuario;
      $colecaoUsuarios[$i]->setDadosBD($r->{'CodigoDoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      my $media = sprintf("%5.2f",$r->{'Media'});
      $colecaoUsuarios[$i]->info->setMediaRank($media);
      $colecaoUsuarios[$i]->info->setTestesRank($r->{'NumTestes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoUsuarios;
}
#################################################################################







#################################################################################
# qtdeTestesAbertos
#--------------------------------------------------------------------------------
# M�todo que seleciona a quantidade de testes abertos para um usu�rio.
#################################################################################
sub qtdeTestesAbertos {
   my $self = shift;
   my $codigoUsuario = $_[0];

   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

   my $tSQL = "SELECT COUNT(*) AS Qtde ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."TesteUsuario AS TU ";
   $tSQL .= "WHERE TU.Status = \'A\' AND TU.CodigoUsuario = $codigoUsuario ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de testes abertos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'Qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################





#################################################################################
# quantidadeMarcadas
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de alunos que marcaram tal resposta
# 2018/02/23 - Fun��o nova
# 2018/07/09 - Corrigida com REGEXP
#################################################################################
sub quantidadeMarcadas {
   my $self = shift;
   my $codigoQuestao = $_[0];
   my $codigoResposta = $_[1];
   my $tSQL = "SELECT COUNT(*) AS Qtde FROM ".$self->umaConexao->getTab()."TesteUsuario AS TU ";
   #$tSQL .= "WHERE TU.Historico LIKE \"\%\\n$codigoQuestao\|$codigoResposta\|\%\" ";
   $tSQL .= "WHERE TU.Historico REGEXP \"(^\|\\n)$codigoQuestao\\\\\|$codigoResposta\\\\\|\" ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de testes abertos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'Qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################





1;
