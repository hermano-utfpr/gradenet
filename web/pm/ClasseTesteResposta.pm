package ClasseTesteResposta;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseTesteResposta
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla respostas de um teste.
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
      codigoResposta => undef,
      codigoQuestao => undef,
      texto => undef,
      correta => undef,
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
   $self->{codigoResposta} = 0;
   $self->{codigoQuestao} = 0;
   $self->{texto} = "";
   $self->{correta} = 0;
}
#################################################################################










#################################################################################
# setCodigoResposta e getCodigoResposta
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo codigoResposta
#################################################################################
sub setCodigoResposta {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoResposta} = int($_[0]);
      } else {
         die "C�digo da resposta deve ser inteiro e positivo!\n";
      }
   } else {
      die "C�digo da resposta � inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoResposta {
   my $self = shift;
   return $self->{codigoResposta};
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
      die "Texto da resposta � inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getTexto {
   my $self = shift;
   return $self->{texto};
}
#################################################################################










#################################################################################
# setCorreta e getCorreta
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo correta
#################################################################################
sub setCorreta {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{correta} = $_[0];
      } else {
         die "A resposta deve ser 0-errada 1-correta!\n";
      }
   } else {
      die "Resposta (in)correta � inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCorreta {
   my $self = shift;
   return $self->{correta};
}
#################################################################################









#################################################################################
# setDados
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos
# 0-codigoResposta, 1-codigoQuestao, 2-texto, 3-correta
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoResposta($_[0]);
      $self->setCodigoQuestao($_[1]);
      $self->setTexto($_[2]);
      $self->setCorreta($_[3]);
   } else {
      die "Nenhum argumento foi enviado para a resposta!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos que vir�o diretamente da base de dados
# 0-codigoResposta, 1-codigoQuestao, 2-texto, 3-correta
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoResposta} = $_[0];
      $self->{codigoQuestao} = $_[1];
      $self->{texto} = $_[2];
      $self->{correta} = $_[3];
   } else {
      die "Nenhum argumento foi enviado nas informa��es da resposta!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos exceto a data que � gerada automaticamente
# 0-codigoResposta, 1-codigoTeste, 2-texto, 3-correta
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoResposta($_[0]);
      $self->setCodigoQuestao($_[1]);
      $self->setTexto($_[2]);
      $self->setCorreta($_[3]);
   } else {
      die "Nenhum argumento foi enviado para a resposta!";
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
   print "codigoResposta = ".$self->getCodigoResposta()."\n";
   print "codigoTeste = ".$self->getCodigoTeste()."\n";
   print "texto = ".$self->getTexto()."\n";
   print "correta = ".$self->getCorreta()."\n";
}
#################################################################################












1;
