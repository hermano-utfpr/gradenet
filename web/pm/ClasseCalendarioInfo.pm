package ClasseCalendarioInfo;

use strict;







#################################################################################
# ClasseCalendarioInfo
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos com informa��es din�micas e complementares
# do calend�rio
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
      qtdeAtividades => undef,
      qtdeAvisos => undef,    
      qtdeAniversarios => undef,        
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
   $self->{qtdeAtividades} = 0;
   $self->{qtdeAvisos} = 0;
   $self->{qtdeAniversarios} = 0;
}
#################################################################################









#################################################################################
# setQtdeAtividades e getQtdeAtividades
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo qtdeAtividades
#################################################################################
sub setQtdeAtividades {
   my $self = shift;
   if (@_) {
      $self->{qtdeAtividades} = $_[0];
   } else {
      die "Quantidade de atividades � inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getQtdeAtividades {
   my $self = shift;
   return $self->{qtdeAtividades};
}
#################################################################################









#################################################################################
# setQtdeAvisos e getQtdeAvisos
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo qtdeAvisos
#################################################################################
sub setQtdeAvisos {
   my $self = shift;
   if (@_) {
      $self->{qtdeAvisos} = $_[0];
   } else {
      die "Quantidade de avisos � inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getQtdeAvisos {
   my $self = shift;
   return $self->{qtdeAvisos};
}
#################################################################################









#################################################################################
# setQtdeAniversarios e getQtdeAniversarios
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo qtdeAniversarios
#################################################################################
sub setQtdeAniversarios {
   my $self = shift;
   if (@_) {
      $self->{qtdeAniversarios} = $_[0];
   } else {
      die "Quantidade de anivers�rios � inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getQtdeAniversarios {
   my $self = shift;
   return $self->{qtdeAniversarios};
}
#################################################################################










#################################################################################
# getDados
#--------------------------------------------------------------------------------
# m�todos que apenas lista as informa��es de cada atributo
#################################################################################
sub getDados {
   my $self = shift;
   print "qtdeAtividades = ".$self->getQtdeAtividades()."\n";
   print "qtdeAvisos = ".$self->getQtdeAvisos()."\n";
   print "qtdeAniversarios = ".$self->getQtdeAniversarios()."\n";
}
#################################################################################












1;
