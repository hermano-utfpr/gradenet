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
# Classe de acesso à base da dados dos usuários.
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
# Método que verifica se a tabela Usuario existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de usuários!\n";
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
# Método que verifica se a tabela Usuario existe, se não existir irá tentar 
# criá-la.
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
      $SQL->execute or die "Problemas ao criar tabelas de usuários na base de dados!\n";
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
# Método que grava um usuário na base de dados, sem sua foto.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umUsuario = $_[0];
      if ($umUsuario->getCodigoUsuario() == 0) {
         if ($self->existeNome($umUsuario->getNome(),$umUsuario->getCodigoUsuario())) {
            die "Usuário não pode ser incluído, nome já existe!";
         }
         if ($self->existeLogin($umUsuario->getLogin(),$umUsuario->getCodigoUsuario())) {
            die "Usuário não pode ser incluído, login já existe!";
         }
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Usuario set ";
      } else {
         if ($self->existeNome($umUsuario->getNome(),$umUsuario->getCodigoUsuario())) {
            die "Usuário não pode ser alterado, nome já existe!";
         }
         if ($self->existeLogin($umUsuario->getLogin(),$umUsuario->getCodigoUsuario())) {
            die "Usuário não pode ser alterado, login já existe!";
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
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar usuário!\n";
      if ($linhas == 0) { 
         #die "Usuário não foi gravado!\n";
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
         my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar usuário e sessão!\n";
         if ($linhas == 0) {
            #die "Primeira sessão do usuário não foi gravada!\n";
         }
      }

      if (!$umUsuario->getAtivo()) {
         my $dadosSessoes = new DadosSessoes;
         $dadosSessoes->invalidarSessoesAnteriores("",$umUsuario->getCodigoUsuario());
      }


   } else {
      die "Nenhum usuário foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita os usuários da base de dados sem suas fotos, em ordem
# alfabética.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Usuario order by Nome ";
   my @colecaoUsuarios = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar usuários!\n";
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
# Método que exclui o usuário da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Usuario WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir o usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Sessao WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as sessões do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Aviso WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir os avisos do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Atividade WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as atividades do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeResposta WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as respostas de atividades do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeCorrecao WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as correções de atividades do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Calendario WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as informações de calendário do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."CadernoAnotacao WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as anotações do caderno do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."CadernoPasta WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as pastas do caderno do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."CadernoArquivo WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir os arquivos do caderno do usuário!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Teste WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir o teste!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteUsuario WHERE CodigoUsuario = ".$codigoUsuario." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir o teste!";

}
#################################################################################









#################################################################################
# verificarSenha
#--------------------------------------------------------------------------------
# Método que verifica a senha do usuário
# 0-login 1-password
#################################################################################
sub verificarSenha {
   my $self = shift;
   my $login = $_[0];
   my $password = $_[1];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Usuario where Login = \'".$login."\' and Password = SHA2(\'".$password."\',384) ";
   $tSQL = $tSQL."AND Ativo = 1";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível verificar a senha do usuário!\n";
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
# Método que seleciona um usuário a partir de seu login
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
   $SQL->execute or die "Não foi possível selecionar o usuário a partir do login!\n";    
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
# Método que seleciona um usuário a partir de seu código
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
   $SQL->execute or die "Não foi possível selecionar o usuário a partir do código!\n";    
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
# Método que solicita os usuários da base de dados sem suas fotos, em ordem
# alfabética de login.
#################################################################################
sub solicitarLogins {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Usuario WHERE Ativo = 1 ORDER BY Privilegios,Login ";
   my @colecaoUsuarios = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar usuários em ordem de logins!\n";
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
# Método que solicita a quantidade de usuários na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de usuários!\n";
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
# Método que verifica se já existe o nome na base de dados
# 0-nome 1-login
#################################################################################
sub existeNome {
   my $self = shift;
   my $nome = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario where Nome = \'".$nome."\' AND CodigoUsuario != ".$codigoUsuario." ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao verificar se o nome do usuário já existe!\n";
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
# Método que verifica se já existe o login na base de dados
# 0-login 1-codigoUsuario
#################################################################################
sub existeLogin {
   my $self = shift;
   my $login = $_[0];
   my $codigoUsuario = $_[1];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Usuario where Login = \'".$login."\' AND CodigoUsuario != ".$codigoUsuario." ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao verificar se o login do usuário já existe!\n";
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
# Método que solicita a quantidade de usuários online na base de dados
#################################################################################
sub quantidadeUsuariosOnline {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Sessao ";
   $tSQL = $tSQL."WHERE DATE_SUB(\'$ano-$mes-$dia $hor:$min:$seg\', INTERVAL ".$self->{minutosOnline}." MINUTE) <= DataPresenca ";
   $tSQL = $tSQL."AND Valido = 1 ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de usuários on-line!\n";
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
# Método que solicita os usuários da base de dados sem suas fotos, em ordem
# alfabética (privilégios) e suas informações.
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
   $SQL->execute or die "Problemas ao selecionar usuários e suas informações!\n";
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
# Método que seleciona a foto do usuário
#################################################################################
sub selecionarFotoUsuario {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $tSQL = "SELECT Foto FROM ".$self->umaConexao->getTab()."Usuario where CodigoUsuario = \'".$codigoUsuario."\' ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a foto do usuário!\n";
   my ($foto) = $SQL->fetchrow_array;
   $SQL->finish;
   return $foto;
}
#################################################################################









#################################################################################
# selecionarUsuarioInformacoes
#--------------------------------------------------------------------------------
# Método que seleciona um usuário e suas informações.
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
   $SQL->execute or die "Problemas ao selecionar o usuário e suas informações!\n";
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
# Método que grava uma foto do usuário na base de dados
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
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar foto do usuário!\n";
      if ($linhas == 0) {
         #die "Usuário não foi gravado!\n";
      }
   } else {
      die "Nenhum usuário foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# gravarSenha
#--------------------------------------------------------------------------------
# Método que grava a senha do usuário na base de dados
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
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar senha do usuário!\n";
      if ($linhas == 0) {
         #die "Usuário não foi gravado!\n";
      }
   } else {
      die "Nenhum usuário foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# quantidadeAlunos
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de alunos na base de dados
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
# Método que solicita a quantidade de alunos online na base de dados
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
# Método que solicita a quantidade de alunos ativos na base de dados
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
