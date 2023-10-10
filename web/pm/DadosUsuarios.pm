package DadosUsuarios;

use strict;
use ConexaoMySQL;
use ClasseUsuario;
use ClasseSessao;
use DadosSessoes;
use FuncoesCronologicas;








#################################################################################
# DadosUsuarios
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso � base da dados dos usu�rios.
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
      minutosOnline => 10,
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
# M�todo que verifica se a tabela Usuario existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de usu�rios!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Usuario") {
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
# M�todo que verifica se a tabela Usuario existe, se n�o existir ir� tentar 
# cri�-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Usuario (";
      $tSQL = $tSQL."CodigoUsuario int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."Nome varchar(60) not null,";
      $tSQL = $tSQL."Login varchar(20) not null,";
      $tSQL = $tSQL."Password varchar(100) not null,";
      $tSQL = $tSQL."Privilegios bool,";
      $tSQL = $tSQL."Email varchar(200),";
      $tSQL = $tSQL."Sexo bool,";
      $tSQL = $tSQL."DataNascimento date,";
      $tSQL = $tSQL."Perfil text,";
      $tSQL = $tSQL."Foto blob,";
      $tSQL = $tSQL."Ativo bool)";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de usu�rios na base de dados!\n";
      my $umUsuario = new ClasseUsuario;
      $umUsuario->setDadosIU(0,"Professor","Professor","123456","123456",1,"",1,"00/00/0000","",1);
      $self->gravar($umUsuario);
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# M�todo que grava um usu�rio na base de dados, sem sua foto.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umUsuario = $_[0];
      if ($umUsuario->getCodigoUsuario() == 0) {
         if ($self->existeNome($umUsuario->getNome(),$umUsuario->getCodigoUsuario())) {
            die "Usu�rio n�o pode ser inclu�do, nome j� existe!";
         }
         if ($self->existeLogin($umUsuario->getLogin(),$umUsuario->getCodigoUsuario())) {
            die "Usu�rio n�o pode ser inclu�do, login j� existe!";
         }
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Usuario set ";
      } else {
         if ($self->existeNome($umUsuario->getNome(),$umUsuario->getCodigoUsuario())) {
            die "Usu�rio n�o pode ser alterado, nome j� existe!";
         }
         if ($self->existeLogin($umUsuario->getLogin(),$umUsuario->getCodigoUsuario())) {
            die "Usu�rio n�o pode ser alterado, login j� existe!";
         }
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Usuario set ";
         $fSQL = "WHERE CodigoUsuario = ".$umUsuario->getCodigoUsuario()." ";
      }
      $tSQL = $tSQL."Nome = \'".$umUsuario->getNome()."\', ";
      $tSQL = $tSQL."Login = \'".$umUsuario->getLogin()."\', ";
      if ($umUsuario->getCodigoUsuario() == 0) {
         $tSQL = $tSQL."Password = SHA2(\'".$umUsuario->getPassword()."\',384), ";
      }
      $tSQL = $tSQL."Privilegios = \'".$umUsuario->getPrivilegios()."\', ";
      $tSQL = $tSQL."Email = \'".$umUsuario->getEmail()."\', ";
      $tSQL = $tSQL."Sexo = \'".$umUsuario->getSexo()."\', ";
      $tSQL = $tSQL."DataNascimento = \'".$umUsuario->getDataNascimentoBD()."\', ";
      $tSQL = $tSQL."Perfil = \'".$umUsuario->getPerfil()."\', ";
      $tSQL = $tSQL."Ativo = \'".$umUsuario->getAtivo()."\'  ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar usu�rio!\n";
      if ($linhas == 0) { 
         #die "Usu�rio n�o foi gravado!\n";
      }

      if ($umUsuario->getCodigoUsuario() == 0) {
         my $selUsuario = new ClasseUsuario;
         $selUsuario = $self->selecionarUsuarioLogin($umUsuario->getLogin());
         my $umaSessao = new ClasseSessao;
         $umaSessao->setDadosAutomatico($selUsuario->getCodigoUsuario(),0);
         $umaSessao->setDataFinal($umaSessao->getDataInicial());
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Sessao set ";
         $tSQL = $tSQL."SessaoID = \'".$umaSessao->getSessaoID()."\', ";
         $tSQL = $tSQL."CodigoUsuario = \'".$umaSessao->getCodigoUsuario()."\', ";
         $tSQL = $tSQL."IP = \'".$umaSessao->getIP()."\', ";
         $tSQL = $tSQL."Browser = \'".$umaSessao->getBrowser."\', ";
         $tSQL = $tSQL."DataInicial = \'".$umaSessao->getDataInicialBD()."\', ";
         $tSQL = $tSQL."DataFinal = \'".$umaSessao->getDataInicialBD()."\', ";
         $tSQL = $tSQL."DataPresenca = \'".$umaSessao->getDataInicialBD()."\', ";
         $tSQL = $tSQL."Valido = 0 ";
         my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar usu�rio e sess�o!\n";
         if ($linhas == 0) {
            #die "Primeira sess�o do usu�rio n�o foi gravada!\n";
         }
      }

      if (!$umUsuario->getAtivo()) {
         my $dadosSessoes = new DadosSessoes;
         $dadosSessoes->invalidarSessoesAnteriores("",$umUsuario->getCodigoUsuario());
      }


   } else {
      die "Nenhum usu�rio foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# M�todo que solicita os usu�rios da base de dados sem suas fotos, em ordem
# alfab�tica.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Usuario order by Nome ";
   my @colecaoUsuarios = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar usu�rios!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoUsuarios[$i] = new ClasseUsuario;
      $colecaoUsuarios[$i]->setDadosBD($r->{'CodigoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      $i++;
   }
   $SQL->finish;
   return @colecaoUsuarios;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# M�todo que exclui o usu�rio da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Usuario WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir o usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Sessao WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir as sess�es do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Aviso WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir os avisos do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Atividade WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir as atividades do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeResposta WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir as respostas de atividades do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeCorrecao WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir as corre��es de atividades do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Calendario WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir as informa��es de calend�rio do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."CadernoAnotacao WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir as anota��es do caderno do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."CadernoPasta WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir as pastas do caderno do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."CadernoArquivo WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir os arquivos do caderno do usu�rio!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Teste WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir o teste!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteUsuario WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "N�o foi poss�vel excluir o teste!";

}
#################################################################################









#################################################################################
# verificarSenha
#--------------------------------------------------------------------------------
# M�todo que verifica a senha do usu�rio
# 0-login 1-password
#################################################################################
sub verificarSenha {
   my $self = shift;
   my $login = $_[0];
   my $password = $_[1];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Usuario where Login = \'".$login."\' and Password = SHA2(\'".$password."\',384) ";
   $tSQL = $tSQL."AND Ativo = 1";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel verificar a senha do usu�rio!\n";
   my $encontrou = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $encontrou = 1;
   }
   $SQL->finish;
   if (!$encontrou) {
      die "Acesso negado! Login/password incorretos!\n";
   }
}
#################################################################################










#################################################################################
# selecionarUsuarioLogin
#--------------------------------------------------------------------------------
# M�todo que seleciona um usu�rio a partir de seu login
#################################################################################
sub selecionarUsuarioLogin {
   my $self = shift;
   my $login = $_[0];
   my $tSQL = "SELECT U.*, MAX(S.DataFinal) AS UltimoAcesso FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."Sessao AS S ";
   $tSQL .= "ON U.CodigoUsuario = S.CodigoUsuario ";
   $tSQL .= " WHERE U.Login = \'".$login."\' GROUP BY U.CodigoUsuario";
   my $umUsuario = new ClasseUsuario;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel selecionar o usu�rio a partir do login!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
      $umUsuario->setDadosBD($r->{'CodigoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      $umUsuario->info->setUltimoAcesso($r->{'UltimoAcesso'});
   }
   $SQL->finish;
   return $umUsuario;
}
#################################################################################










#################################################################################
# selecionarUsuarioCodigo
#--------------------------------------------------------------------------------
# M�todo que seleciona um usu�rio a partir de seu c�digo
#################################################################################
sub selecionarUsuarioCodigo {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT U.*, MAX(S.DataFinal) AS UltimoAcesso FROM ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Sessao AS S ";
   $tSQL .= "ON U.CodigoUsuario = S.CodigoUsuario ";
   $tSQL .= " WHERE U.CodigoUsuario = \'".$codigoUsuario."\' GROUP BY U.CodigoUsuario";
   my $umUsuario = new ClasseUsuario;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel selecionar o usu�rio a partir do c�digo!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
      $umUsuario->setDadosBD($r->{'CodigoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      $umUsuario->info->setUltimoAcesso($r->{'UltimoAcesso'});
   }
   $SQL->finish;
   return $umUsuario;
}
#################################################################################









#################################################################################
# solicitarLogins
#--------------------------------------------------------------------------------
# M�todo que solicita os usu�rios da base de dados sem suas fotos, em ordem
# alfab�tica de login.
#################################################################################
sub solicitarLogins {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Usuario WHERE Ativo = 1 ORDER BY Privilegios,Login ";
   my @colecaoUsuarios = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar usu�rios em ordem de logins!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoUsuarios[$i] = new ClasseUsuario;
      $colecaoUsuarios[$i]->setDadosBD($r->{'CodigoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      $i++;
   }
   $SQL->finish;
   return @colecaoUsuarios;
}
#################################################################################









#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de usu�rios na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de usu�rios!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# existeNome
#--------------------------------------------------------------------------------
# M�todo que verifica se j� existe o nome na base de dados
# 0-nome 1-login
#################################################################################
sub existeNome {
   my $self = shift;
   my $nome = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario where Nome = \'".$nome."\' AND CodigoUsuario != ".$codigoUsuario." ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao verificar se o nome do usu�rio j� existe!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# existeLogin
#--------------------------------------------------------------------------------
# M�todo que verifica se j� existe o login na base de dados
# 0-login 1-codigoUsuario
#################################################################################
sub existeLogin {
   my $self = shift;
   my $login = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario where Login = \'".$login."\' AND CodigoUsuario != ".$codigoUsuario." ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao verificar se o login do usu�rio j� existe!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# quantidadeUsuariosOnline
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de usu�rios online na base de dados
#################################################################################
sub quantidadeUsuariosOnline {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Sessao ";
   $tSQL = $tSQL."WHERE DATE_SUB(\'$ano-$mes-$dia $hor:$min:$seg\', INTERVAL ".$self->{minutosOnline}." MINUTE) <= DataPresenca ";
   $tSQL = $tSQL."AND Valido = 1 ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de usu�rios on-line!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# solicitarUsuariosInformacoes
#--------------------------------------------------------------------------------
# M�todo que solicita os usu�rios da base de dados sem suas fotos, em ordem
# alfab�tica (privil�gios) e suas informa��es.
#################################################################################
sub solicitarUsuariosInformacoes {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT U.*, MAX(S.Valido = 1 AND DATE_SUB(\'$ano-$mes-$dia $hor:$min:$seg\', INTERVAL ".$self->{minutosOnline}." MINUTE) <= S.DataPresenca) AS Online, ";
   $tSQL = $tSQL."COUNT(CASE WHEN (UNIX_TIMESTAMP(S.DataInicial) != UNIX_TIMESTAMP(S.DataFinal)) THEN 1 END) AS Acessos FROM ".$self->umaConexao->getTab()."Usuario AS U INNER JOIN ".$self->umaConexao->getTab()."Sessao AS S ";
#   $tSQL = $tSQL."ON U.CodigoUsuario = S.CodigoUsuario GROUP BY U.CodigoUsuario ORDER BY U.Privilegios,U.Nome ";
   $tSQL = $tSQL."ON U.CodigoUsuario = S.CodigoUsuario GROUP BY U.CodigoUsuario ORDER BY U.Privilegios,U.Nome ";
   my @colecaoUsuarios = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar usu�rios e suas informa��es!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoUsuarios[$i] = new ClasseUsuario;
      $colecaoUsuarios[$i]->setDadosBD($r->{'CodigoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      $colecaoUsuarios[$i]->info->setAcessos($r->{'Acessos'});
      $colecaoUsuarios[$i]->info->setOnline($r->{'Online'});
      $colecaoUsuarios[$i]->setFoto($r->{'Foto'});
      $i++;
   }
   $SQL->finish;
   return @colecaoUsuarios;
}
#################################################################################










#################################################################################
# selecionarFotoUsuario
#--------------------------------------------------------------------------------
# M�todo que seleciona a foto do usu�rio
#################################################################################
sub selecionarFotoUsuario {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT Foto FROM ".$self->umaConexao->getTab()."Usuario where CodigoUsuario = \'".$codigoUsuario."\' ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "N�o foi poss�vel selecionar a foto do usu�rio!\n";
   my ($foto) = $SQL->fetchrow_array;
   $SQL->finish;
   return $foto;
}
#################################################################################









#################################################################################
# selecionarUsuarioInformacoes
#--------------------------------------------------------------------------------
# M�todo que seleciona um usu�rio e suas informa��es.
#################################################################################
sub selecionarUsuarioInformacoes {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT U.*, MAX(S.Valido = 1 AND DATE_SUB(\'$ano-$mes-$dia $hor:$min:$seg\', INTERVAL ".$self->{minutosOnline}." MINUTE) <= S.DataPresenca) AS Online, ";
   $tSQL = $tSQL."MAX(S.DataInicial) as UltimoAcesso, ";
   $tSQL = $tSQL."COUNT(CASE WHEN (UNIX_TIMESTAMP(S.DataInicial) != UNIX_TIMESTAMP(S.DataFinal)) THEN 1 END) AS Acessos FROM ".$self->umaConexao->getTab()."Usuario AS U INNER JOIN ".$self->umaConexao->getTab()."Sessao AS S ";
   $tSQL = $tSQL."ON U.CodigoUsuario = S.CodigoUsuario AND U.CodigoUsuario = ".$codigoUsuario." GROUP BY U.CodigoUsuario";
   my $umUsuario = new ClasseUsuario;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar o usu�rio e suas informa��es!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $umUsuario->setDadosBD($r->{'CodigoUsuario'},$r->{'Nome'},$r->{'Login'},$r->{'Privilegios'},$r->{'Email'},$r->{'Sexo'},$r->{'DataNascimento'},$r->{'Perfil'},$r->{'Ativo'});
      $umUsuario->setFoto($r->{'Foto'});
      $umUsuario->info->setAcessos($r->{'Acessos'});
      $umUsuario->info->setOnline($r->{'Online'});
      $umUsuario->info->setUltimoAcessoBD($r->{'UltimoAcesso'});
   }
   $SQL->finish;
   return $umUsuario;
}
#################################################################################









#################################################################################
# gravarFoto
#--------------------------------------------------------------------------------
# M�todo que grava uma foto do usu�rio na base de dados
#################################################################################
sub gravarFoto {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umUsuario = $_[0];
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."Usuario set ";
      $fSQL = "WHERE CodigoUsuario = ".$umUsuario->getCodigoUsuario()." ";
      $tSQL = $tSQL."Foto = ".$self->umaConexao->executar->quote($umUsuario->getFoto())." ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar foto do usu�rio!\n";
      if ($linhas == 0) {
         #die "Usu�rio n�o foi gravado!\n";
      }
   } else {
      die "Nenhum usu�rio foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# gravarSenha
#--------------------------------------------------------------------------------
# M�todo que grava a senha do usu�rio na base de dados
#################################################################################
sub gravarSenha {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umUsuario = $_[0];
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."Usuario set ";
      $fSQL = "WHERE CodigoUsuario = ".$umUsuario->getCodigoUsuario()." ";
      $tSQL = $tSQL."Password = password(\'".$umUsuario->getPassword()."\') ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar senha do usu�rio!\n";
      if ($linhas == 0) {
         #die "Usu�rio n�o foi gravado!\n";
      }
   } else {
      die "Nenhum usu�rio foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# quantidadeAlunos
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de alunos na base de dados
#################################################################################
sub quantidadeAlunos {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario ";
   $tSQL .= "WHERE Privilegios = 0 ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de alunos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# quantidadeAlunosOnline
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de alunos online na base de dados
#################################################################################
sub quantidadeAlunosOnline {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Sessao AS S ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "ON S.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE DATE_SUB(\'$ano-$mes-$dia $hor:$min:$seg\', INTERVAL ".$self->{minutosOnline}." MINUTE) <= S.DataPresenca ";
   $tSQL .= "AND S.Valido = 1 AND U.Privilegios = 0 ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de alunos on-line!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









#################################################################################
# quantidadeAlunosAtivos
#--------------------------------------------------------------------------------
# M�todo que solicita a quantidade de alunos ativos na base de dados
#################################################################################
sub quantidadeAlunosAtivos {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario ";
   $tSQL .= "WHERE Privilegios = 0 AND Ativo = 1 ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de alunos!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################









1;
