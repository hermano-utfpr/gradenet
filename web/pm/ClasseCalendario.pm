package ClasseCalendario;

use strict;
use ClasseUsuario;
use ClasseCalendarioInfo;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseCalendario
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla o calendário.
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
      dataMarcada => undef,
      texto => undef,
      data => undef,
      codigoUsuario => undef,
      umUsuario => new ClasseUsuario,
      lido => undef,
      info => new ClasseCalendarioInfo,
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
   $self->{dataMarcada} = "00/00/0000";
   $self->{texto} = "";
   $self->{data} = "00/00/0000 00:00:00";
   $self->{codigoUsuario} = "";
   $self->{umUsuario}->clear;
   $self->{lido} = 0;
   $self->info->clear;
}
#################################################################################









#################################################################################
# setDataMarcada e getDataMarcada
#--------------------------------------------------------------------------------
# métodos para manipular o atributo dataMarcada
#################################################################################
sub setDataMarcada {
   my $self = shift;
   if (@_) {
      my $dataMarcada = &TiraEspacos($_[0]);
      if (length($dataMarcada) > 0) {
         if (length($dataMarcada) == 10) {
            $self->{dataMarcada} = $dataMarcada;
         } else {
            die "Data deve estar no formato [dd/mm/aaaa] !\n";
         }
      } else {
         $self->{dataMarcada} = "00/00/0000";
      }
   } else {
      die "Data marcada no calendário está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getDataMarcada {
   my $self = shift;
   return $self->{dataMarcada};
}
#################################################################################










#################################################################################
# setDataMarcadaBD e getDataMarcadaBD
#--------------------------------------------------------------------------------
# métodos para manipular o atributo dataMarcada
#################################################################################
sub setDataMarcadaBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   $self->{dataMarcada} = "$dia/$mes/$ano";
}
#--------------------------------------------------------------------------------
sub getDataMarcadaBD {
   my $self = shift;
   my $ano = substr($self->{dataMarcada},6,4);
   my $mes = substr($self->{dataMarcada},3,2);
   my $dia = substr($self->{dataMarcada},0,2);
   return "$ano-$mes-$dia";
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
      die "Texto do calendário está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getTexto {
   my $self = shift;
   return $self->{texto};
}
#################################################################################









#################################################################################
# setData e getData
#--------------------------------------------------------------------------------
# métodos para manipular o atributo data
#################################################################################
sub setData {
   my $self = shift;
   if (@_) {
      my $data = &TiraEspacos($_[0]);
      if (length($data) > 0) {
         if (length($data) == 19) {
            $self->{data} = $data;
         } else {
            die "Data deve estar no formato [dd/mm/aaaa hh:mm:ss] !\n";
         }
      } else {
         $self->{data} = "00/00/0000 00:00:00";
      }
   } else {
      die "Data do calendário está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getData {
   my $self = shift;
   return $self->{data};
}
#################################################################################










#################################################################################
# setDataBD e getDataBD
#--------------------------------------------------------------------------------
# métodos para manipular o atributo data
#################################################################################
sub setDataBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   my $hor = substr($_[0],11,2);
   my $min = substr($_[0],14,2);
   my $seg = substr($_[0],17,2);
   $self->{data} = "$dia/$mes/$ano $hor:$min:$seg";
}
#--------------------------------------------------------------------------------
sub getDataBD {
   my $self = shift;
   my $ano = substr($self->{data},6,4);
   my $mes = substr($self->{data},3,2);
   my $dia = substr($self->{data},0,2);
   my $hor = substr($self->{data},11,2);
   my $min = substr($self->{data},14,2);
   my $seg = substr($self->{data},17,2);
   return "$ano-$mes-$dia $hor:$min:$seg";
}
#################################################################################










#################################################################################
# setCodigoUsuario e getCodigoUsuario
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoUsuario
#################################################################################
sub setCodigoUsuario {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoUsuario} = int($_[0]);
      } else {
         die "Código do usuário deve ser inteiro e positivo!\n";
      }
   } else {
      die "Código do usuário é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoUsuario {
   my $self = shift;
   return $self->{codigoUsuario};
}
#################################################################################










#################################################################################
# umUsuario
#--------------------------------------------------------------------------------
# métodos para manipular informaçoes sobre o usuário
#################################################################################
sub umUsuario {
   my $self = shift;
   if (@_) {
      $self->{umUsuario} = shift;
   }
   return $self->{umUsuario};
}
#################################################################################










#################################################################################
# info
#--------------------------------------------------------------------------------
# métodos para manipular informaçoes sobre o calendário
#################################################################################
sub info {
   my $self = shift;
   if (@_) {
      $self->{info} = shift;
   }
   return $self->{info};
}
#################################################################################









#################################################################################
# setLido e getLido
#--------------------------------------------------------------------------------
# métodos para manipular o atributo lido
#################################################################################
sub setLido {
   my $self = shift;
   if (@_) {
      $self->{lido} = shift;
   } else {
      die "Lido está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getLido {
   my $self = shift;
   return $self->{lido};
}
#################################################################################










#################################################################################
# setDados
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos
# 0-dataMarcada, 1-texto, 2-data, 3-codigoUsuario
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setDataMarcada($_[0]);
      $self->setTexto($_[1]);
      $self->setData($_[2]);
      $self->setCodigoUsuario($_[3]);
   } else {
      die "Nenhum argumento foi enviado para o calendário!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-dataMarcada, 1-texto, 2-data, 3-codigoUsuario
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->setDataMarcadaBD($_[0]);
      $self->{texto} = $_[1];
      $self->setDataBD($_[2]);
      $self->{codigoUsuario} = $_[3];
   } else {
      die "Nenhum argumento foi enviado nas informações do calendário!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-dataMarcada, 1-texto, 2--codigoUsuario
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setDataMarcada($_[0]);
      $self->setTexto($_[1]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setCodigoUsuario($_[2]);
   } else {
      die "Nenhum argumento foi enviado para o calendário!";
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
   print "dataMarcada = ".$self->getDataMarcada()."\n";
   print "texto = ".$self->getTexto()."\n";
   print "data = ".$self->getData()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
}
#################################################################################












1;
