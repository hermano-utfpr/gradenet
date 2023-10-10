package DadosTestesRespostas;

use strict;
use ConexaoMySQL;
use ClasseTesteResposta;
use FuncoesCronologicas;







#################################################################################
# DadosTestesRespostas
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de respostas de testes.
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
# Método que verifica se a tabela Resposta existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de respostas!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."TesteResposta") {
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
# Método que verifica se a tabela Resposta existe, se não existir irá tentar 
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."TesteResposta (";
      $tSQL = $tSQL."CodigoResposta int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."CodigoQuestao int not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Correta bool) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de respostas na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma resposta na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaResposta = $_[0];
      if ($umaResposta->getCodigoResposta() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."TesteResposta set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."TesteResposta set ";
         $fSQL = "WHERE CodigoResposta = ".$umaResposta->getCodigoResposta()." ";
      }
      $tSQL = $tSQL."CodigoQuestao = \'".$umaResposta->getCodigoQuestao()."\', ";
      $tSQL = $tSQL."Texto = \'".$umaResposta->getTexto()."\', ";
      $tSQL = $tSQL."Correta = \'".$umaResposta->getCorreta()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar resposta!\n";
      if ($linhas == 0) { 
         #die "Resposta não foi gravada!\n";
      }
   } else {
      die "Nenhuma resposta foi enviada para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as respostas da base de dados, em ordem de codigo
# 
# 2018/02/23 - Adicionei: "ORDER BY Correta DESC"
#################################################################################
sub solicitar {
   my $self = shift;
   my $codigoQuestao = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."TesteResposta ";
   $tSQL .= "WHERE CodigoQuestao = $codigoQuestao ORDER BY Correta DESC";
   my @colecaoRespostas = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar respostas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoRespostas[$i] = new ClasseTesteResposta;
      $colecaoRespostas[$i]->setDadosBD($r->{'CodigoResposta'},$r->{'CodigoQuestao'},$r->{'Texto'},$r->{'Correta'});
      $i++;
   }
   $SQL->finish;
   return @colecaoRespostas;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui a resposta da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoResposta = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteResposta WHERE CodigoResposta = ".$codigoResposta." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a resposta!";
}
#################################################################################









#################################################################################
# excluirRespostas
#--------------------------------------------------------------------------------
# Método que exclui as respostas pelo código da questão da base de dados.
#################################################################################
sub excluirRespostas {
   my $self = shift;
   my $codigoQuestao = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."TesteResposta WHERE CodigoQuestao = ".$codigoQuestao." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as respostas!";
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de respostas de uma questão na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $codigoQuestao = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."TesteResposta ";
   $tSQL .= "WHERE CodigoQuestao = $codigoQuestao";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de respostas!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# sortearRespostas
#--------------------------------------------------------------------------------
# Método que sortea respostas para iniciar um teste
#################################################################################
sub sortearRespostas {
   my $self = shift;
   my $codigoQuestao = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."TesteResposta ";
   $tSQL .= "WHERE CodigoQuestao = $codigoQuestao ";
   $tSQL .= "ORDER BY CodigoQuestao ";
   my @colecaoRespostas;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar respostas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoRespostas[$i] = new ClasseTesteResposta;
      $colecaoRespostas[$i]->setDadosBD($r->{'CodigoResposta'},$r->{'CodigoQuestao'},$r->{'Texto'},$r->{'Correta'});
      $i++;
   }
   my $numRespostas = $i;
   $SQL->finish;

   my %tabsort;
   $i = 0;
   my $umaResposta = new ClasseTesteResposta;
   foreach $umaResposta (@colecaoRespostas) {
      $tabsort{$i} = new ClasseTesteResposta;
      $tabsort{$i}->setDadosBD($umaResposta->getCodigoResposta(),$umaResposta->getCodigoQuestao(),$umaResposta->getTexto(),$umaResposta->getCorreta());
      $i++;
   }

   my @codtab;
   my $sorteado = 0;
   my $codSorteado = 0;
   my @colecaoRespostasSort;
   for ($i = 0; $i < $numRespostas; $i++) {
      @codtab = keys %tabsort;
      $sorteado = int(rand(scalar(@codtab)-0.01));
      $codSorteado = $codtab[$sorteado];
      $colecaoRespostasSort[$i] = new ClasseTesteResposta;
 $colecaoRespostasSort[$i]->setDadosBD($tabsort{$codSorteado}->getCodigoResposta(),$tabsort{$codSorteado}->getCodigoQuestao(),$tabsort{$codSorteado}->getTexto(),$tabsort{$codSorteado}->getCorreta());
      delete $tabsort{$codSorteado};
   }

   return (@colecaoRespostasSort);
}
#################################################################################










#################################################################################
# qtdeCorretas
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de respostas corretas
#################################################################################
sub qtdeCorretas {
   my $self = shift;
   my @selecionadas = @_;
   my $tSQL = "SELECT SUM(Correta) as qtde FROM ".$self->umaConexao->getTab()."TesteResposta ";
   $tSQL .= "WHERE ( ";
   foreach my $s (@selecionadas) {
      $tSQL .= "CodigoResposta = $s OR ";
   }
   $tSQL .= " 1=2) ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
#   die $tSQL;
   $SQL->execute or die "Problemas ao selecionar a quantidade de respostas corretas!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################











1;
