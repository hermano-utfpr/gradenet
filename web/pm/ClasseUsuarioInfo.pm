package ClasseUsuarioInfo;

use strict;
use ClasseUsuario;







#################################################################################
# ClasseUsuarioInfo
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos com informa��es din�micas e complementares
# dos usu�rios
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
      acessos => undef,
      online => undef,
      ultimoAcesso => undef,
      testesRank => undef,
      mediaRank => undef,
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
   $self->{acessos} = 0;
   $self->{online} = 0;
   $self->{ultimoAcesso} = "00/00/0000 00:00:00";
   $self->{testesRank} = 0;
   $self->{mediaRank} = 0;
}
#################################################################################









#################################################################################
# setAcessos e setAcessos
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo acessos
#################################################################################
sub setAcessos {
   my $self = shift;
   if (@_) {
      $self->{acessos} = $_[0];
   } else {
      die "Informa��es de acessos do usu�rio s�o inv�lidas!\n";
   }
}
#--------------------------------------------------------------------------------
sub getAcessos {
   my $self = shift;
   return $self->{acessos};
}
#################################################################################









#################################################################################
# setOnline e getOnline
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo online
#################################################################################
sub setOnline {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{online} = $_[0];
      } else {
         die "O usu�rio pode estar apenas (0 - Off-line) ou (1 - On-line)!\n";
      }
   } else {
      die "Informa��es de on/off-line do usu�rio inv�lidas!\n";
   }
}
#--------------------------------------------------------------------------------
sub getOnline {
   my $self = shift;
   return $self->{online};
}
#################################################################################









#################################################################################
# setUltimoAcesso e getUltimoAcesso
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo ultimoAcesso
#################################################################################
sub setUltimoAcesso {
   my $self = shift;
   if (@_) {
      $self->{ultimoAcesso} = $_[0];
   }
}
#--------------------------------------------------------------------------------
sub getUltimoAcesso {
   my $self = shift;
   return $self->{ultimoAcesso};
}
#################################################################################









#################################################################################
# setUltimoAcessoBD e getUltimoAcessoBD
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo ultimoAcesso
#################################################################################
sub setUltimoAcessoBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   my $hor = substr($_[0],11,2);
   my $min = substr($_[0],14,2);
   my $seg = substr($_[0],17,2);
   $self->{ultimoAcesso} = "$dia/$mes/$ano $hor:$min:$seg";
}
#--------------------------------------------------------------------------------
sub getUltimoAcessoBD {
   my $self = shift;
   my $ano = substr($self->{ultimoAcesso},6,4);
   my $mes = substr($self->{ultimoAcesso},3,2);
   my $dia = substr($self->{ultimoAcesso},0,2);
   my $hor = substr($self->{ultimoAcesso},11,2);
   my $min = substr($self->{ultimoAcesso},14,2);
   my $seg = substr($self->{ultimoAcesso},17,2);
   return "$ano-$mes-$dia $hor:$min:$seg";
}
#################################################################################









#################################################################################
# setTestesRank e setTestesRank
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo testesRank
#################################################################################
sub setTestesRank {
   my $self = shift;
   if (@_) {
      $self->{testesRank} = $_[0];
   } else {
      die "Informa��es de testes feitos pelo usu�rio para ranking s�o inv�lidas\n";
   }
}
#--------------------------------------------------------------------------------
sub getTestesRank {
   my $self = shift;
   return $self->{testesRank};
}
#################################################################################









#################################################################################
# setMediaRank e setMediaRank
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo mediaRank
#################################################################################
sub setMediaRank {
   my $self = shift;
   if (@_) {
      $self->{mediaRank} = $_[0];
   } else {
      die "Informa��es de m�dia de nota no ranking do usu�rio s�o inv�lidas!\n";
   }
}
#--------------------------------------------------------------------------------
sub getMediaRank {
   my $self = shift;
   return $self->{mediaRank};
}
#################################################################################








#################################################################################
# getDados
#--------------------------------------------------------------------------------
# m�todos que apenas lista as informa��es de cada atributo
#################################################################################
sub getDados {
   my $self = shift;
   print "acessos = ".$self->getAcessos()."\n";
   print "online = ".$self->getOnline()."\n";
   print "ultimoAcesso = ".$self->getUltimoAcesso()."\n";
   print "testesRank = ".$self->getTestesRank()."\n";
   print "mediaRank = ".$self->getMediaRank()."\n";
}
#################################################################################












1;
