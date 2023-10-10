package ClasseTesteUsuario;

use strict;
use ClasseUsuario;
use ClasseTeste;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseTesteUsuario
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla testes de usuários.
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
      codigoTeste => undef,
      codigoUsuario => undef,
      historico => undef,
      nota => undef,
      notaCorrigida => undef,
      data => undef,
      status => undef,
      umTeste => new ClasseTeste,
      umUsuario => new ClasseUsuario,
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
   $self->{codigoTeste} = 0;
   $self->{codigoUsuario} = 0;
   $self->{historico} = "";
   $self->{nota} = 0;
   $self->{notaCorrigida} = 0;
   $self->{data} = "00/00/0000 00:00:00";
   $self->{status} = "";
   $self->{umTeste}->clear;
   $self->{umUsuario}->clear;
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
# setHistorico e getHistorico
#--------------------------------------------------------------------------------
# métodos para manipular o atributo historico
#################################################################################
sub setHistorico {
   my $self = shift;
   if (@_) {
      my $historico = $_[0];
      $self->{historico} = $historico;
   } else {
      die "Histórico do teste está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHistorico {
   my $self = shift;
   return $self->{historico};
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
      die "Data do teste está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getData {
   my $self = shift;
   return $self->{data};
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
      die "Nota está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNota {
   my $self = shift;
   return $self->{nota};
}
#################################################################################









#################################################################################
# setNotaCorrigida e getNotaCorrigida
#--------------------------------------------------------------------------------
# métodos para manipular o atributo notaCorrigida
#################################################################################
sub setNotaCorrigida {
   my $self = shift;
   if (@_) {
      $self->{notaCorrigida} = $_[0];
   } else {
      die "Nota corrigida está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNotaCorrigida {
   my $self = shift;
   return $self->{notaCorrigida};
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
# setStatus e getStatus
#--------------------------------------------------------------------------------
# métodos para manipular o atributo status
#################################################################################
sub setStatus {
   my $self = shift;
   if (@_) {
      $self->{status} = $_[0];
   } else {
      die "Status está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getStatus {
   my $self = shift;
   return $self->{status};
}
#################################################################################









#################################################################################
# umTeste
#--------------------------------------------------------------------------------
# métodos para manipular o atributo umTeste
#################################################################################
sub umTeste {
   my $self = shift;
   if (@_) {
      $self->{umTeste} = shift;
   }
   return $self->{umTeste};
}
#################################################################################









#################################################################################
# umUsuario
#--------------------------------------------------------------------------------
# métodos para manipular o atributo umUsuario
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
# setDados
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos
# 0-codigoTeste, 1-codigoUsuario, 2-historico, 3-nota, 4-notaCorrigida,
# 5-data, 6-status
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoTeste($_[0]);
      $self->setCodigoUsuario($_[1]);
      $self->setHistorico($_[2]);
      $self->setNota($_[3]);
      $self->setNotaCorrigida($_[4]);
      $self->setData($_[5]);
      $self->setStatus($_[6]);
   } else {
      die "Nenhum argumento foi enviado para o teste!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-codigoTeste, 1-codigoUsuario, 2-historico, 3-nota, 4-notaCorrigida,
# 5-data, 6-status
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoTeste} = $_[0];
      $self->{codigoUsuario} = $_[1];
      $self->{historico} = $_[2];
      $self->{nota} = $_[3];
      $self->{notaCorrigida} = $_[4];
      $self->setDataBD($_[5]);
      $self->{status} = $_[6];
   } else {
      die "Nenhum argumento foi enviado nas informações do teste!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-codigoTeste, 1-codigoUsuario, 2-historico, 3-nota, 4-notaCorrigida,
# 5-status
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoTeste($_[0]);
      $self->setCodigoUsuario($_[1]);
      $self->setHistorico($_[2]);
      $self->setNota($_[3]);
      $self->setNotaCorrigida($_[4]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setStatus($_[5]);
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
   print "codigoTeste = ".$self->getCodigoTeste()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
   print "historico = ".$self->getHistorico()."\n";
   print "nota = ".$self->getNota()."\n";
   print "notaCorrigida = ".$self->getNotaCorrigida()."\n";
   print "data = ".$self->getData()."\n";
   print "status = ".$self->getStatus()."\n";
}
#################################################################################












1;
