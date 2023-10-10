package DadosPerguntasRespostas;

use strict;
use ConexaoMySQL;
use ClassePergunta;
use ClassePerguntaResposta;








#################################################################################
# DadosPerguntasRespostas
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de respostas de perguntas.
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
# Método que verifica se a tabela PerguntaResposta existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de respostas de perguntas!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."PerguntaResposta") {
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
# Método que verifica se a tabela PerguntaResposta existe, se não existir irá 
# tentar criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."PerguntaResposta (";
      $tSQL = $tSQL."CodigoResposta int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."CodigoPergunta int not null, ";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."NomeAnexo varchar(200),";
      $tSQL = $tSQL."Anexo mediumblob,";
      $tSQL = $tSQL."Nota float(5,2), ";
      $tSQL = $tSQL."CodigoUsuario int not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de respostas de perguntas na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma resposta de pergunta na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaResposta = $_[0];
      if ($umaResposta->getCodigoResposta() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."PerguntaResposta set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."PerguntaResposta set ";
         $fSQL = "WHERE CodigoResposta = ".$umaResposta->getCodigoResposta()." ";
      }
      $tSQL = $tSQL."CodigoPergunta = \'".$umaResposta->getCodigoPergunta()."\', ";
      $tSQL = $tSQL."Titulo = \'".$umaResposta->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umaResposta->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umaResposta->getDataBD()."\', ";
      $tSQL = $tSQL."Nota = \'".$umaResposta->getNota()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umaResposta->getCodigoUsuario()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar resposta de pergunta!\n";
      if ($linhas == 0) { 
         #die "Resposta não foi gravada!\n";
      }
   } else {
      die "Nenhuma resposta foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as respostas da base de dados em ordem de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."PerguntaResposta AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ";  
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ORDER BY A.Data Desc ";
   my @colecaoRespostas = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar respostas de perguntas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoRespostas[$i] = new ClassePerguntaResposta;
      $colecaoRespostas[$i]->setDadosBD($r->{'CodigoResposta'},$r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'NomeAnexo'},$r->{'Nota'},$r->{'CodigoUsuario'});
      $colecaoRespostas[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoRespostas[$i]->umUsuario->setNome($r->{'Nome'});
      $i++;
   }
   $SQL->finish;
   return @colecaoRespostas;
}
#################################################################################









#################################################################################
# solicitarRespostas
#--------------------------------------------------------------------------------
# Método que solicita as respostas da base de dados em ordem de data, de acordo
# com o código de sua pergunta
#################################################################################
sub solicitarRespostas {
   my $self = shift;
   my $codigoPergunta = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."PerguntaResposta AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoPergunta = ".$codigoPergunta." ORDER BY A.Data Desc ";
   my @colecaoRespostas = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar respostas de perguntas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoRespostas[$i] = new ClassePerguntaResposta;
      $colecaoRespostas[$i]->setDadosBD($r->{'CodigoResposta'},$r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'NomeAnexo'},$r->{'Nota'},$r->{'CodigoUsuario'});
      $colecaoRespostas[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoRespostas[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoRespostas[$i]->setAnexo($r->{'Anexo'});
      $i++;
   }
   $SQL->finish;
   return @colecaoRespostas;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui a resposta da pergunta da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoResposta = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."PerguntaResposta WHERE CodigoResposta = ".$codigoResposta." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a resposta da pergunta!";
}
#################################################################################










#################################################################################
# selecionarResposta
#--------------------------------------------------------------------------------
# Método que seleciona uma resposta a partir de seu código
#################################################################################
sub selecionarResposta {
   my $self = shift;
   my $codigoResposta = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."PerguntaResposta AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoResposta = ".$codigoResposta." ";
   my $umaResposta = new ClassePerguntaResposta;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a resposta da pergunta!\n";
   while (my $r = $SQL->fetchrow_hashref) {
       $umaResposta->setDadosBD($r->{'CodigoResposta'},$r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'NomeAnexo'},$r->{'Nota'},$r->{'CodigoUsuario'});
       $umaResposta->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaResposta->umUsuario->setNome($r->{'Nome'});
       $umaResposta->setAnexo($r->{'Anexo'});
   }
   $SQL->finish;
   return $umaResposta;
}
#################################################################################










#################################################################################
# selecionarRespostaUsuario
#--------------------------------------------------------------------------------
# Método que seleciona uma resposta de um usuário a partir do código da pergunta
# e do usuário
#################################################################################
sub selecionarRespostaUsuario {
   my $self = shift;
   my $codigoUsuario = $_[0];
   my $codigoPergunta = $_[1];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."PerguntaResposta AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE U.CodigoUsuario = ".$codigoUsuario." AND A.CodigoPergunta = ".$codigoPergunta." ";
   my $umaResposta = new ClassePerguntaResposta;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a resposta da pergunta!\n";
   while (my $r = $SQL->fetchrow_hashref) {
       $umaResposta->setDadosBD($r->{'CodigoResposta'},$r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'NomeAnexo'},$r->{'Nota'},$r->{'CodigoUsuario'});
       $umaResposta->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaResposta->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umaResposta;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de perguntas na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."PerguntaResposta ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de respostas das perguntas!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# quantidadeRespostas
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de respostas de perguntas na base de dados
#################################################################################
sub quantidadeRespostas {
   my $self = shift;
   my $codigoPergunta = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."PerguntaResposta AS A ";
   $tSQL .= "WHERE A.CodigoPergunta = ".$codigoPergunta." ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de respostas da pergunta!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# selecionarAnexo
#--------------------------------------------------------------------------------
# Método que seleciona o anexo
#################################################################################
sub selecionarAnexo {
   my $self = shift;
   my $codigoResposta = $_[0];
   my $tSQL = "SELECT Anexo FROM ".$self->umaConexao->getTab()."PerguntaResposta where CodigoResposta = \'".$codigoResposta."\' ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar o anexo da resposta!\n";    
   my ($anexo) = $SQL->fetchrow_array;
   $SQL->finish;
   return $anexo;
}
#################################################################################










#################################################################################
# gravarAnexo
#--------------------------------------------------------------------------------
# Método que grava um anexo na base de dados
#################################################################################
sub gravarAnexo {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaResposta = $_[0];
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."PerguntaResposta set ";
      $tSQL = $tSQL."NomeAnexo = \'".$umaResposta->getNomeAnexo()."\', ";
      $tSQL = $tSQL."Anexo = ".$self->umaConexao->executar->quote($umaResposta->getAnexo())." ";
      $fSQL = "WHERE CodigoResposta = ".$umaResposta->getCodigoResposta()." ";
      $tSQL = $tSQL.$fSQL;
#      die $tSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar anexo da resposta!\n";
      if ($linhas == 0) { 
         #die "Anexo não foi gravado!\n";
      }
   } else {
      die "Nenhum anexo foi enviado para ser gravado!\n";
   }
}
#################################################################################









1;
