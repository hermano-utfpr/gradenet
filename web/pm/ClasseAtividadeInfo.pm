package ClasseAtividadeInfo;

use strict;







#################################################################################
# ClasseAtividadeInfo
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos com informações dinâmicas e complementares
# das atividades
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
      qtdeRespostas => undef, #para o professor
      respondida => undef,    #para o aluno
      nota => undef,          #para o aluno
      corrigida => undef,     #para ambos 
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
   $self->{qtdeRespostas} = 0;
   $self->{respondida} = 0;
   $self->{nota} = 0;
   $self->{corrigida} = 0;
}
#################################################################################









#################################################################################
# setQtdeRespostas e getQtdeRespostas
#--------------------------------------------------------------------------------
# métodos para manipular o atributo qtdeRespostas
#################################################################################
sub setQtdeRespostas {
   my $self = shift;
   if (@_) {
      $self->{qtdeRespostas} = $_[0];
   } else {
      die "Quantidade de respostas é inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getQtdeRespostas {
   my $self = shift;
   return $self->{qtdeRespostas};
}
#################################################################################









#################################################################################
# setRespondida e getRespondida
#--------------------------------------------------------------------------------
# métodos para manipular o atributo respondida
#################################################################################
sub setRespondida {
   my $self = shift;
   if (@_) {
      $self->{respondida} = $_[0];
   } else {
      die "Respondida é inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getRespondida {
   my $self = shift;
   return $self->{respondida};
}
#################################################################################









#################################################################################
# setNota e getNota
#--------------------------------------------------------------------------------
# métodos para manipular o atributo nota
#################################################################################
sub setNota {
   my $self = shift;
   if (@_) {
      $self->{nota} = $_[0];
   } else {
      die "Nota é inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNota {
   my $self = shift;
   return $self->{nota};
}
#################################################################################









#################################################################################
# setCorrigida e getCorrigida
#--------------------------------------------------------------------------------
# métodos para manipular o atributo corrigida
#################################################################################
sub setCorrigida {
   my $self = shift;
   if (@_) {
      $self->{corrigida} = $_[0];
   } else {
      die "Corrigida é inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCorrigida {
   my $self = shift;
   return $self->{corrigida};
}
#################################################################################










#################################################################################
# getDados
#--------------------------------------------------------------------------------
# métodos que apenas lista as informações de cada atributo
#################################################################################
sub getDados {
   my $self = shift;
   print "qtdeRespostas = ".$self->getQtdeRespostas()."\n";
   print "respondida = ".$self->getRespondida()."\n";
   print "nota = ".$self->getNota()."\n";
   print "corrigida= ".$self->getCorrigida()."\n";
}
#################################################################################












1;
