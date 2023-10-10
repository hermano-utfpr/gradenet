package ClasseArquivo;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseArquivo
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla arquivos.
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
      codigoArquivo => undef,
      nomeArquivo => undef,
      data => undef,
      arquivo => undef,
      permissao => undef,
      codigoPasta => undef,
      codigoUsuario => undef,
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
   $self->{codigoArquivo} = 0;
   $self->{nomeArquivo} = "";
   $self->{data} = "00/00/0000 00:00:00";
   $self->{arquivo} = undef;
   $self->{permissao} = 0;
   $self->{codigoPasta} = 0;
   $self->{codigoUsuario} = "";
   $self->{umUsuario}->clear;
}
#################################################################################










#################################################################################
# setCodigoArquivo e getCodigoArquivo
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoArquivo
#################################################################################
sub setCodigoArquivo {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoArquivo} = int($_[0]);
      } else {
         die "Código do arquivo deve ser inteiro e positivo!\n";
      }
   } else {
      die "Código do arquivo é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoArquivo {
   my $self = shift;
   return $self->{codigoArquivo};
}
#################################################################################









#################################################################################
# setNomeArquivo e getNomeArquivo
#--------------------------------------------------------------------------------
# métodos para manipular o atributo nomeArquivo
#################################################################################
sub setNomeArquivo {
   my $self = shift;
   if (@_) {
      my $nomeTemp = &TiraEspacos($_[0]);
      $nomeTemp =~ s/ /_/ig;
      $nomeTemp =~ s/\:/_/ig;
      $nomeTemp =~ s/@/_/ig;
      my @grvNome = split(/\\/,$nomeTemp);
      my $nomeArquivo;
      foreach my $parteNome (@grvNome) {
         $nomeArquivo = $parteNome;
      }  
      if (length($nomeArquivo) > 0) {
         if (length($nomeArquivo) <= 200) {
            $self->{nomeArquivo} = $nomeArquivo;
         } else {
            die "Nome do arquivo pode conter no máximo 200 caracteres!\n";
         }
      } else {
         die "Nome do arquivo não pode estar vazio!\n";
      }
   } else {
      die "Nome do arquivo está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNomeArquivo {
   my $self = shift;
   return $self->{nomeArquivo};
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
      die "Data do arquivo está inválida!\n";
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
# setArquivo e getArquivo
#--------------------------------------------------------------------------------
# Métodos para manipular o arquivo
#################################################################################
sub setArquivo {
   my $self = shift;
   if (@_) {
      $self->{arquivo} = shift;
   }
}
#--------------------------------------------------------------------------------
sub getArquivo {
   my $self = shift;
   return $self->{arquivo};
}
#################################################################################










#################################################################################
# setPermissao e getPermissao
#--------------------------------------------------------------------------------
# métodos para manipular o atributo permissao
#################################################################################
sub setPermissao {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{permissao} = $_[0];
      } else {
         die "Permissão deve ser 0-privada ou 1-pública!\n";
      }
   } else {
      die "Permissão é inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getPermissao {
   my $self = shift;
   return $self->{permissao};
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
# setDados
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos
# 0-codigoArquivo, 1-nomeArquivo, 2-data, 3-arquivo, 4-permissao, 5-codigoPasta,
# 6-codigoUsuario
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoArquivo($_[0]);
      $self->setNomeArquivo($_[1]);
      $self->setData($_[2]);
      $self->setArquivo($_[3]);
      $self->setPermissao($_[4]);
      $self->setCodigoPasta($_[5]);
      $self->setCodigoUsuario($_[6]);
   } else {
      die "Nenhum argumento foi enviado para o arquivo!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-codigoArquivo, 1-nomeArquivo, 2-data, 3-arquivo, 4-permissao, 5-codigoPasta, 
# 6-codigoUsuario
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoArquivo} = $_[0];
      $self->{nomeArquivo} = $_[1];
      $self->setDataBD($_[2]);
      $self->{arquivo} = $_[3];
      $self->{permissao} = $_[4];
      $self->{codigoPasta} = $_[5];
      $self->{codigoUsuario} = $_[6];
   } else {
      die "Nenhum argumento foi enviado nas informações do arquivo!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-codigoArquivo, 1-nomeArquivo, 2-arquivo, 3-permissao, 4-codigoPasta, 
# 5-codigoUsuario
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoPasta($_[0]);
      $self->setNomeArquivo($_[1]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setArquivo($_[2]);
      $self->setPermissao($_[3]);
      $self->setCodigoPasta($_[4]);
      $self->setCodigoUsuario($_[5]);
   } else {
      die "Nenhum argumento foi enviado para o arquivo!";
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
   print "codigoArquivo = ".$self->getCodigoArquivo()."\n";
   print "nomeArquivo = ".$self->getNomeArquivo()."\n";
   print "data = ".$self->getData()."\n";
   print "permissao = ".$self->getPermissao()."\n";
   print "codigoPasta = ".$self->getCodigoPasta()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
}
#################################################################################












1;
