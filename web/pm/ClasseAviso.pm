package ClasseAviso;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseAviso
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla avisos.
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
      codigoAviso => undef,
      titulo => undef,
      texto => undef,
      data => undef,
      dataCalendario => undef,
      codigoUsuario => undef,
      umUsuario => new ClasseUsuario,
      lido => undef,
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
   $self->{codigoAviso} = 0;
   $self->{titulo} = "";
   $self->{texto} = "";
   $self->{data} = "00/00/0000 00:00:00";
   $self->{dataCalendario} = "00/00/0000";
   $self->{codigoUsuario} = "";
   $self->{umUsuario}->clear;
   $self->{lido} = 0;
}
#################################################################################










#################################################################################
# setCodigoAviso e getCodigoAviso
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo codigoAviso
#################################################################################
sub setCodigoAviso {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoAviso} = int($_[0]);
      } else {
         die "C�digo do aviso deve ser inteiro e positivo!\n";
      }
   } else {
      die "C�digo do aviso � inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoAviso {
   my $self = shift;
   return $self->{codigoAviso};
}
#################################################################################









#################################################################################
# setTitulo e getTitulo
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo titulo
#################################################################################
sub setTitulo {
   my $self = shift;
   if (@_) {
      my $titulo = &TiraEspacos($_[0]);
      $titulo = &RetiraTags($titulo);
      if (length($titulo) > 0) {
         if (length($titulo) <= 60) {
            $self->{titulo} = $titulo;
         } else {
            die "T�tulo do aviso pode conter no m�ximo 60 caracteres!\n";
         }
      } else {
         die "T�tulo n�o pode estar vazio!\n";
      }
   } else {
      die "T�tulo est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getTitulo {
   my $self = shift;
   return $self->{titulo};
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
      die "Texto do aviso est� inv�lido!\n";
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
# m�todos para manipular o atributo data
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
      die "Data do aviso est� inv�lida!\n";
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
# m�todos para manipular o atributo data
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
# setDataCalendario e getDataCalendario
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo dataCalendario
#################################################################################
sub setDataCalendario {
   my $self = shift;
   if (@_) {
      my $dataCalendario = &TiraEspacos($_[0]);
      if (length($dataCalendario) > 0) {
         if (length($dataCalendario) == 10) {
            $self->{dataCalendario} = $dataCalendario;
         } else {
            die "Data do calend�rio deve estar no formato [dd/mm/aaaa] !\n";
         }
      } else {
         $self->{dataCalendario} = "00/00/0000";
      }
   } else {
      die "Data do calend�rio est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getDataCalendario {
   my $self = shift;
   return $self->{dataCalendario};
}
#################################################################################










#################################################################################
# setDataCalendarioBD e getDataCalendarioBD
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo dataCalendario
#################################################################################
sub setDataCalendarioBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   $self->{dataCalendario} = "$dia/$mes/$ano";
}
#--------------------------------------------------------------------------------
sub getDataCalendarioBD {
   my $self = shift;
   my $ano = substr($self->{dataCalendario},6,4);
   my $mes = substr($self->{dataCalendario},3,2);
   my $dia = substr($self->{dataCalendario},0,2);
   return "$ano-$mes-$dia";
}
#################################################################################










#################################################################################
# setCodigoUsuario e getCodigoUsuario
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo codigoUsuario
#################################################################################
sub setCodigoUsuario {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoUsuario} = int($_[0]);
      } else {
         die "C�digo do usu�rio deve ser inteiro e positivo!\n";
      }
   } else {
      die "C�digo do usu�rio � inv�lido!\n";
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
# m�todos para manipular informa�oes sobre o usu�rio
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
# setLido e getLido
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo lido
#################################################################################
sub setLido {
   my $self = shift;
   if (@_) {
      $self->{lido} = shift;
   } else {
      die "Lido est� inv�lido!\n";
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
# m�todos para manipular todos os atributos
# 0-codigoAviso, 1-titulo, 2-texto, 3-data, 4-dataCalendario, 5-codigoUsuario
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoAviso($_[0]);
      $self->setTitulo($_[1]);
      $self->setTexto($_[2]);
      $self->setData($_[3]);
      $self->setDataCalendario($_[4]);
      $self->setCodigoUsuario($_[5]);
   } else {
      die "Nenhum argumento foi enviado para o aviso!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos que vir�o diretamente da base de dados
# 0-codigoAviso, 1-titulo, 2-texto, 3-data, 4-dataCalendario, 5-codigoUsuario
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoAviso} = $_[0];
      $self->{titulo} = $_[1];
      $self->{texto} = $_[2];
      $self->setDataBD($_[3]);
      $self->setDataCalendarioBD($_[4]);
      $self->{codigoUsuario} = $_[5];
   } else {
      die "Nenhum argumento foi enviado nas informa��es do aviso!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos exceto a data que � gerada automaticamente
# 0-codigoAviso, 1-titulo, 2-texto, 3-dataCalendario, 4-codigoUsuario
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoAviso($_[0]);
      $self->setTitulo($_[1]);
      $self->setTexto($_[2]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setDataCalendario($_[3]);
      $self->setCodigoUsuario($_[4]);
   } else {
      die "Nenhum argumento foi enviado para o aviso!";
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
   print "codigoAviso = ".$self->getCodigoAviso()."\n";
   print "titulo = ".$self->getTitulo()."\n";
   print "texto = ".$self->getTexto()."\n";
   print "data = ".$self->getData()."\n";
   print "dataCalendario = ".$self->getDataCalendario()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
}
#################################################################################












1;
