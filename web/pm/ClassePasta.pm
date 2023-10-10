package ClassePasta;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClassePasta
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla pastas de arquivos.
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
      codigoPasta => undef,
      nomePasta => undef,
      data => undef,
      codigoUsuario => undef,
      umUsuario => new ClasseUsuario,
      qtdeArquivos => undef,
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
   $self->{codigoPasta} = 0;
   $self->{nomePasta} = "";
   $self->{data} = "00/00/0000 00:00:00";
   $self->{codigoUsuario} = "";
   $self->{umUsuario}->clear;
   $self->{qtdeArquivos} = 0;
}
#################################################################################










#################################################################################
# setCodigoPasta e getCodigoPasta
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoPasta
#################################################################################
sub setCodigoPasta {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoPasta} = int($_[0]);
      } else {
         die "Código da pasta deve ser inteiro e positivo!\n";
      }
   } else {
      die "Código da pasta é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoPasta {
   my $self = shift;
   return $self->{codigoPasta};
}
#################################################################################









#################################################################################
# setNomePasta e getNomePasta
#--------------------------------------------------------------------------------
# métodos para manipular o atributo nomePasta
#################################################################################
sub setNomePasta {
   my $self = shift;
   if (@_) {
      my $nomePasta = &TiraEspacos($_[0]);
      if (length($nomePasta) > 0) {
         if (length($nomePasta) <= 100) {
            $self->{nomePasta} = $nomePasta;
         } else {
            die "Nome da pasta pode conter no máximo 100 caracteres!\n";
         }
      } else {
         die "Nome da pasta não pode estar vazio!\n";
      }
   } else {
      die "Nome da pasta está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNomePasta {
   my $self = shift;
   return $self->{nomePasta};
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
      die "Data da pasta está inválida!\n";
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
# setQtdeArquivos e getQtdeArquivos
#--------------------------------------------------------------------------------
# métodos para manipular o atributo qtdeArquivos
#################################################################################
sub setQtdeArquivos {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{qtdeArquivos} = int($_[0]);
      } else {
         die "Quantidade de arquivos deve ser inteira e positiva!\n";
      }
   } else {
      die "Quantidade de arquivos é inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getQtdeArquivos {
   my $self = shift;
   return $self->{qtdeArquivos};
}
#################################################################################










#################################################################################
# setDados
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos
# 0-codigoPasta, 1-nomePasta, 2-data, 3-codigoUsuario
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoPasta($_[0]);
      $self->setNomePasta($_[1]);
      $self->setData($_[2]);
      $self->setCodigoUsuario($_[3]);
   } else {
      die "Nenhum argumento foi enviado para a pasta!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-codigoPasta, 1-nomePasta, 2-data, 3-codigoUsuario
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoPasta} = $_[0];
      $self->{nomePasta} = $_[1];
      $self->setDataBD($_[2]);
      $self->{codigoUsuario} = $_[3];
   } else {
      die "Nenhum argumento foi enviado nas informações da pasta!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-codigoPasta, 1-nomePasta, 2-codigoUsuario
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoPasta($_[0]);
      $self->setNomePasta($_[1]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setCodigoUsuario($_[2]);
   } else {
      die "Nenhum argumento foi enviado para a pasta!";
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
   print "codigoPasta = ".$self->getCodigoPasta()."\n";
   print "nomePasta = ".$self->getNomePasta()."\n";
   print "data = ".$self->getData()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
}
#################################################################################












1;
