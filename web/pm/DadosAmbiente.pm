package DadosAmbiente;

use strict;
use ConexaoMySQL;
use ClasseAmbiente;







#################################################################################
# DadosAmbiente
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de informações do ambiente
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
# Método que verifica se a tabela Ambiente existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabela do ambiente!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Ambiente") {
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
# Método que verifica se a tabela Ambiente existe, se não existir irá tentar
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Ambiente (";
      $tSQL = $tSQL."NomeDisciplina varchar(100),";
      $tSQL = $tSQL."Turma varchar(100),";
      $tSQL = $tSQL."Link varchar(100),";
      $tSQL = $tSQL."Sobre text,";
      $tSQL = $tSQL."CorDeFundo varchar(6),";
      $tSQL = $tSQL."Cartaz blob,";
      $tSQL = $tSQL."Titulo text,";
      $tSQL = $tSQL."Linha1 text,";
      $tSQL = $tSQL."Linha2 text,";
      $tSQL = $tSQL."Linha3 text,";
      $tSQL = $tSQL."HabCalendario bool,";
      $tSQL = $tSQL."HabAtividades bool,";
      $tSQL = $tSQL."HabAnotacoes bool,";
      $tSQL = $tSQL."HabArquivos bool,";
      $tSQL = $tSQL."HabMateriais bool,";
      $tSQL = $tSQL."HabDesafios bool,";
      $tSQL = $tSQL."HabPerguntas bool,";
      $tSQL = $tSQL."HabTestes bool, ";
      $tSQL = $tSQL."KBytesArquivo bigint DEFAULT 1500) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas Ambiente na base de dados!\n";
      my $umAmbiente = new ClasseAmbiente;
      $umAmbiente->setDadosIU("Disciplina","Turma","http://","","FFFFFF","Título","Linha 1 do cabeçalho","Linha 2 do cabeçalho","Linha 3 do cabeçalho",1,1,1,1,1,1,1,1,1500);
      $self->gravar($umAmbiente,"insert");
      $SQL->finish;
   }

}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava um ambiente na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $umAmbiente = $_[0];
      my $modo = $_[1];
      if ($modo eq "insert") {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Ambiente set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Ambiente set ";
      }
      $tSQL = $tSQL."NomeDisciplina = \'".$umAmbiente->getNomeDisciplina()."\', ";
      $tSQL = $tSQL."Turma = \'".$umAmbiente->getTurma()."\', ";
      $tSQL = $tSQL."Link = \'".$umAmbiente->getLink()."\', ";
      $tSQL = $tSQL."Sobre = \'".$umAmbiente->getSobre()."\', ";
      $tSQL = $tSQL."CorDeFundo = \'".$umAmbiente->getCorDeFundo()."\', ";
      $tSQL = $tSQL."Titulo = \'".$umAmbiente->getTitulo()."\', ";
      $tSQL = $tSQL."Linha1 = \'".$umAmbiente->getLinha1()."\', ";
      $tSQL = $tSQL."Linha2 = \'".$umAmbiente->getLinha2()."\', ";
      $tSQL = $tSQL."Linha3 = \'".$umAmbiente->getLinha3()."\', ";
      $tSQL = $tSQL."HabCalendario = ".$umAmbiente->getHabCalendario().", ";
      $tSQL = $tSQL."HabAtividades = ".$umAmbiente->getHabAtividades().", ";
      $tSQL = $tSQL."HabAnotacoes = ".$umAmbiente->getHabAnotacoes().", ";
      $tSQL = $tSQL."HabArquivos = ".$umAmbiente->getHabArquivos().", ";
      $tSQL = $tSQL."HabMateriais = ".$umAmbiente->getHabMateriais().", ";
      $tSQL = $tSQL."HabDesafios = ".$umAmbiente->getHabDesafios().", ";
      $tSQL = $tSQL."HabPerguntas = ".$umAmbiente->getHabPerguntas().", ";
      $tSQL = $tSQL."HabTestes = ".$umAmbiente->getHabTestes().", ";
      $tSQL = $tSQL."KBytesArquivo = ".$umAmbiente->getKBytesArquivo()." ";

      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar ambiente!\n";
      if ($linhas == 0) {
         #die "Ambiente não foi gravado!\n";
      }

   } else {
      die "Nenhum ambiente foi enviado para ser gravado!\n";
   }
}
#################################################################################









#################################################################################
# selecionar
#--------------------------------------------------------------------------------
# Método que seleciona as informacoes do ambiente
#################################################################################
sub selecionar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Ambiente ";
   my $umAmbiente = new ClasseAmbiente;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar o ambiente!\n";    
   while (my $r = $SQL->fetchrow_hashref) {
      $umAmbiente->setDadosBD($r->{'NomeDisciplina'},$r->{'Turma'},$r->{'Link'},$r->{'Sobre'},$r->{'CorDeFundo'},$r->{'Titulo'},$r->{'Linha1'},$r->{'Linha2'},$r->{'Linha3'},$r->{'HabCalendario'},$r->{'HabAtividades'},$r->{'HabAnotacoes'},$r->{'HabArquivos'},$r->{'HabMateriais'},$r->{'HabDesafios'},$r->{'HabPerguntas'},$r->{'HabTestes'},$r->{'KBytesArquivo'});
      $umAmbiente->setCartaz($r->{'Cartaz'});
   }
   $SQL->finish;
   return $umAmbiente;
}
#################################################################################










#################################################################################
# selecionarCartaz
#--------------------------------------------------------------------------------
# Método que seleciona a cartaz do ambiente
#################################################################################
sub selecionarCartaz {
   my $self = shift;
   my $tSQL = "SELECT Cartaz FROM ".$self->umaConexao->getTab()."Ambiente ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar o cartaz do ambiente!\n";
   my ($cartaz) = $SQL->fetchrow_array;
   $SQL->finish;
   return $cartaz;
}
#################################################################################









#################################################################################
# gravarCartaz
#--------------------------------------------------------------------------------
# Método que grava o cartaz do ambiente na base de dados
#################################################################################
sub gravarCartaz {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $umAmbiente = $_[0];
      $tSQL = "UPDATE ".$self->umaConexao->getTab()."Ambiente set ";
      $tSQL = $tSQL."Cartaz = ".$self->umaConexao->executar->quote($umAmbiente->getCartaz())." ";
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar cartaz do ambiente!\n";
      if ($linhas == 0) {
         #die "Cartaz não foi gravado!\n";
      }
   } else {
      die "Nenhum ambiente foi enviado para ser gravado!\n";
   }
}
#################################################################################



















#################################################################################
# atualizar01
#--------------------------------------------------------------------------------
# Método que atualiza os dados da tabela ambiente:
# - nova coluna (BytesArquivo = 1500 bigint)
#################################################################################
sub atualizar01 {

   my $self = shift;
   my $tSQL = "DESC ".$self->umaConexao->getTab()."Ambiente ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a tabela ambiente!\n";
   my $coluna = "";
   my $existe = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $coluna = $r->{'Field'};
      if ($coluna eq "KBytesArquivo") {
         $existe = 1;
      }
   }
   $SQL->finish;

   if (!$existe) {
      my $tSQL = "ALTER TABLE ".$self->umaConexao->getTab."Ambiente ADD COLUMN KBytesArquivo bigint DEFAULT 1500 ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao fazer atualização na tabela Ambiente!\n";
      $SQL->finish;
   }

}
#################################################################################










1;
