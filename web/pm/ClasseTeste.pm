package ClasseTeste;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;
use ClasseTesteInfo;







#################################################################################
# ClasseTeste
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla testes.
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
      titulo => undef,
      texto => undef,
      data => undef,
      habRanking => undef,
      numQuestoes => undef,
      codigoUsuario => undef,
      codigoAtividade => undef,
      umUsuario => new ClasseUsuario,
      info => new ClasseTesteInfo,
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
   $self->{titulo} = "";
   $self->{texto} = "";
   $self->{data} = "00/00/0000 00:00:00";
   $self->{habRanking} = 0;
   $self->{numQuestoes} = 0;
   $self->{codigoUsuario} = "";
   $self->{codigoAtividade} = "";
   $self->{umUsuario}->clear;
   $self->{info}->clear;   
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
            die "Título do teste pode conter no máximo 60 caracteres!\n";
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
      die "Texto do teste está inválido!\n";
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
# setHabRanking e getHabRanking
#--------------------------------------------------------------------------------
# métodos para manipular o atributo habRanking
#################################################################################
sub setHabRanking {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habRanking} = $_[0];
      } else {
         die "Ranking deve estar 0-Habilitado ou 1-Desabilitado!\n";
      }
   } else {
      die "Habilitação do ranking está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabRanking {
   my $self = shift;
   return $self->{habRanking};
}
#################################################################################









#################################################################################
# setNumQuestoes e getNumQuestoes
#--------------------------------------------------------------------------------
# métodos para manipular o atributo numQuestoes
#################################################################################
sub setNumQuestoes {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 1) {
         $self->{numQuestoes} = $_[0];
      } else {
         die "Deve haver pelo menos uma questão no teste!\n";
      }
   } else {
      die "Número de questões está inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNumQuestoes {
   my $self = shift;
   return $self->{numQuestoes};
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
# setCodigoAtividade e getCodigoAtividade
#--------------------------------------------------------------------------------
# métodos para manipular o atributo codigoUsuario
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
# métodos para manipular informaçoes sobre o teste
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
# setDados
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos
# 0-codigoTeste, 1-titulo, 2-texto, 3-data, 4-habRanking, 5-numQuestoes, 
# 6-codigoUsuario
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoTeste($_[0]);
      $self->setTitulo($_[1]);
      $self->setTexto($_[2]);
      $self->setData($_[3]);
      $self->setHabRanking($_[4]);
      $self->setNumQuestoes($_[5]);
      $self->setCodigoUsuario($_[6]);
      $self->setCodigoAtividade($_[7]);
   } else {
      die "Nenhum argumento foi enviado para o teste!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-codigoTeste, 1-titulo, 2-texto, 3-data, 4-habRanking, 5-numQuestoes,
# 6-codigoUsuario
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoTeste} = $_[0];
      $self->{titulo} = $_[1];
      $self->{texto} = $_[2];
      $self->setDataBD($_[3]);
      $self->{habRanking} = $_[4];
      $self->{numQuestoes} = $_[5];
      $self->{codigoUsuario} = $_[6];
      $self->{codigoAtividade} = $_[7];
   } else {
      die "Nenhum argumento foi enviado nas informações do teste!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-codigoTeste, 1-titulo, 2-texto, 3-habRanking, 4-numQuestoes, 5-codigoUsuario
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoTeste($_[0]);
      $self->setTitulo($_[1]);
      $self->setTexto($_[2]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setHabRanking($_[3]);
      $self->setNumQuestoes($_[4]);
      $self->setCodigoUsuario($_[5]);
      $self->setCodigoAtividade($_[6]);
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
   print "titulo = ".$self->getTitulo()."\n";
   print "texto = ".$self->getTexto()."\n";
   print "data = ".$self->getData()."\n";
   print "habRanking = ".$self->getHabRanking()."\n";
   print "numQuestoes = ".$self->getNumQuestoes()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
   print "codigoAtividade = ".$self->getCodigoAtividade()."\n";
}
#################################################################################












1;
