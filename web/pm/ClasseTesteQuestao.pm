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
# Classe para criar e manipular objetos que controla quest�es de um teste.
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
# m�todo para atributos receberem valores default
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
# m�todos para manipular o atributo codigoQuestao
#################################################################################
sub setCodigoQuestao {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoQuestao} = int($_[0]);
      } else {
         die "C�digo da quest�o deve ser inteiro e positivo!\n";
      }
   } else {
      die "C�digo da quest�o � inv�lido!\n";
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
# m�todos para manipular o atributo codigoTeste
#################################################################################
sub setCodigoTeste {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoTeste} = int($_[0]);
      } else {
         die "C�digo do teste deve ser inteiro e positivo!\n";
      }
   } else {
      die "C�digo do teste � inv�lido!\n";
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
# m�todos para manipular o atributo texto
#################################################################################
sub setTexto {
   my $self = shift;
   if (@_) {
      my $texto = &setTextoHTML($_[0]);
      $self->{texto} = $texto;
   } else {
      die "Texto da quest�o � inv�lido!\n";
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
# m�todos para manipular todos os atributos
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
# m�todos para manipular todos os atributos que vir�o diretamente da base de dados
# 0-codigoQuestao, 1-codigoTeste, 2-texto
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoQuestao} = $_[0];
      $self->{codigoTeste} = $_[1];
      $self->{texto} = $_[2];
   } else {
      die "Nenhum argumento foi enviado nas informa��es do quest�o!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos exceto a data que � gerada automaticamente
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
# m�todos que apenas lista as informa��es de cada atributo
#################################################################################
sub getDados {
   my $self = shift;
   print "codigoQuestao = ".$self->getCodigoQuestao()."\n";
   print "codigoTeste = ".$self->getCodigoTeste()."\n";
   print "texto = ".$self->getTexto()."\n";
}
#################################################################################












1;
