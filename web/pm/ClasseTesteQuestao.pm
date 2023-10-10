package ClasseTesteQuestao;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseTesteQuestao
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla questões de um teste.
#################################################################################









#################################################################################
# new
#--------------------------------------------------------------------------------
# construtor
#################################################################################
sub new {
   my $proto = shift;
   my $class = ref($proto) || $proto;
   my $self =  {
      codigoQuestao => undef,
      codigoTeste => undef,
      texto => undef,
   };
   bless ($self,$class);
   $self->clear;
   return $self;
}
#################################################################################









#################################################################################
# clear
#--------------------------------------------------------------------------------
# método para atributos receberem valores default
#################################################################################
sub clear {
   my $self = shift;
   $self->{codigoQuestao} = 0;
   $self->{codigoTeste} = 0;
   $self->{texto} = "";
}
#################################################################################










#################################################################################
# setCodigoQuestao e getCodigoQuestao
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoQuestao
#################################################################################
sub setCodigoQuestao {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoQuestao} = int($_[0]);
      } else {
         die "Código da questão deve ser inteiro e positivo!\n";
      }
   } else {
      die "Código da questão é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoQuestao {
   my $self = shift;
   return $self->{codigoQuestao};
}
#################################################################################










#################################################################################
# setCodigoTeste e getCodigoTeste
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoTeste
#################################################################################
sub setCodigoTeste {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoTeste} = int($_[0]);
      } else {
         die "Código do teste deve ser inteiro e positivo!\n";
      }
   } else {
      die "Código do teste é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoTeste {
   my $self = shift;
   return $self->{codigoTeste};
}
#################################################################################










#################################################################################
# setTexto e getTexto
#--------------------------------------------------------------------------------
# métodos para manipular o atributo texto
#################################################################################
sub setTexto {
   my $self = shift;
   if (@_) {
      my $texto = &setTextoHTML($_[0]);
      $self->{texto} = $texto;
   } else {
      die "Texto da questão é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getTexto {
   my $self = shift;
   return $self->{texto};
}
#################################################################################









#################################################################################
# setDados
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos
# 0-codigoQuestao, 1-codigoTeste, 2-texto
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoQuestao($_[0]);
      $self->setCodigoTeste($_[1]);
      $self->setTexto($_[2]);
   } else {
      die "Nenhum argumento foi enviado para o teste!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-codigoQuestao, 1-codigoTeste, 2-texto
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoQuestao} = $_[0];
      $self->{codigoTeste} = $_[1];
      $self->{texto} = $_[2];
   } else {
      die "Nenhum argumento foi enviado nas informações do questão!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-codigoQuestao, 1-codigoTeste, 2-texto
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoQuestao($_[0]);
      $self->setCodigoTeste($_[1]);
      $self->setTexto($_[2]);
   } else {
      die "Nenhum argumento foi enviado para o teste!";
   }
}
#################################################################################











#################################################################################
# getDados
#--------------------------------------------------------------------------------
# métodos que apenas lista as informações de cada atributo
#################################################################################
sub getDados {
   my $self = shift;
   print "codigoQuestao = ".$self->getCodigoQuestao()."\n";
   print "codigoTeste = ".$self->getCodigoTeste()."\n";
   print "texto = ".$self->getTexto()."\n";
}
#################################################################################












1;
