package ClasseAtividadeCorrecao;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseAtividadeCorrecao
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controlam correções de atividades
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
      codigoCorrecao => undef,
      codigoAtividade => undef,
      titulo => undef,
      texto => undef,
      data => undef,
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
   $self->{codigoCorrecao} = 0;
   $self->{codigoAtividade} = 0;
   $self->{titulo} = "";
   $self->{texto} = "";
   $self->{data} = "00/00/0000 00:00:00";
   $self->{nomeAnexo} = "";
   $self->{anexo} = undef;
   $self->{nota} = 0;
   $self->{codigoUsuario} = "";
   $self->{umUsuario}->clear;
}
#################################################################################










#################################################################################
# setCodigoCorrecao e getCodigoCorrecao
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoCorrecao
#################################################################################
sub setCodigoCorrecao {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoCorrecao} = int($_[0]);
      } else {
         die "Código da correção deve ser inteiro e positivo!\n";
      }
   } else {
      die "Código da correção é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoCorrecao {
   my $self = shift;
   return $self->{codigoCorrecao};
}
#################################################################################










#################################################################################
# setCodigoAtividade e getCodigoAtividade
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoAtividade
#################################################################################
sub setCodigoAtividade {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoAtividade} = int($_[0]);
      } else {
         die "Código da atividade deve ser inteiro e positivo!\n";
      }
   } else {
      die "Código da atividade é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoAtividade {
   my $self = shift;
   return $self->{codigoAtividade};
}
#################################################################################









#################################################################################
# setTitulo e getTitulo
#--------------------------------------------------------------------------------
# métodos para manipular o atributo titulo
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
            die "Título da correção pode conter no máximo 60 caracteres!\n";
         }
      } else {
         die "Título não pode estar vazio!\n";
      }
   } else {
      die "Título está inválido!\n";
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
# métodos para manipular o atributo texto
#################################################################################
sub setTexto {
   my $self = shift;
   if (@_) {
      my $texto = &setTextoHTML($_[0]);
      $self->{texto} = $texto;
   } else {
      die "Texto está inválido!\n";
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
      die "Data está inválida!\n";
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
# setDados
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos
# 0-codigoCorrecao, 1-codigoAtividade, 2-titulo, 3-Texto, 4-data, 5-codigoUsuario
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoCorrecao($_[0]);
      $self->setCodigoAtividade($_[1]);
      $self->setTitulo($_[2]);
      $self->setTexto($_[3]);
      $self->setData($_[4]);
      $self->setCodigoUsuario($_[5]);
   } else {
      die "Nenhum argumento foi enviado para a correcao da atividade!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-codigoCorrecao, 1-codigoAtividade, 2-titulo, 3-texto, 4-data, 5-codigoUsuario
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoCorrecao} = $_[0];
      $self->{codigoAtividade} = $_[1];
      $self->{titulo} = $_[2];
      $self->{texto} = $_[3];
      $self->setDataBD($_[4]);
      $self->{codigoUsuario} = $_[5];
   } else {
      die "Nenhum argumento foi enviado nas informações da correção!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-codigoCorrecao, 1-codigoAtividade, 2-titulo, 3-texto, 4-codigoUsuario
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoCorrecao($_[0]);
      $self->setCodigoAtividade($_[1]);
      $self->setTitulo($_[2]);
      $self->setTexto($_[3]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setCodigoUsuario($_[4]);
   } else {
      die "Nenhum argumento foi enviado para a correção!";
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
   print "codigoCorrecao = ".$self->getCodigoCorrecao()."\n";
   print "codigoAtividade = ".$self->getCodigoAtividade()."\n";
   print "titulo = ".$self->getTitulo()."\n";
   print "texto = ".$self->getTexto()."\n";
   print "data = ".$self->getData()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
}
#################################################################################












1;
