package ClassePerguntaResposta;

use strict;
use ClasseUsuario;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClassePerguntaResposta
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controlam respostas de perguntas
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
      codigoResposta => undef,
      codigoPergunta => undef,
      titulo => undef,
      texto => undef,
      data => undef,
      nomeAnexo => undef,
      anexo => undef,
      nota => undef,
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
# m�todo para atributos receberem valores default
#################################################################################
sub clear {
   my $self = shift;
   $self->{codigoResposta} = 0;
   $self->{codigoPergunta} = 0;
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
# setCodigoResposta e getCodigoResposta
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo codigoResposta
#################################################################################
sub setCodigoResposta {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoResposta} = int($_[0]);
      } else {
         die "C�digo da resposta deve ser inteiro e positivo!\n";
      }
   } else {
      die "C�digo da resposta � inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoResposta {
   my $self = shift;
   return $self->{codigoResposta};
}
#################################################################################










#################################################################################
# setCodigoPergunta e getCodigoPergunta
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo codigoPergunta
#################################################################################
sub setCodigoPergunta {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoPergunta} = int($_[0]);
      } else {
         die "C�digo da pergunta deve ser inteiro e positivo!\n";
      }
   } else {
      die "C�digo da pergunta � inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCodigoPergunta {
   my $self = shift;
   return $self->{codigoPergunta};
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
            die "T�tulo da resposta pode conter no m�ximo 60 caracteres!\n";
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
      die "Texto est� inv�lido!\n";
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
      die "Data est� inv�lida!\n";
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
# setNomeAnexo e getNomeAnexo
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo nomeAnexo
#################################################################################
sub setNomeAnexo {
   my $self = shift;
   if (@_) {
      $self->{nomeAnexo} = shift;
   } else {
      die "Nome do anexo est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNomeAnexo {
   my $self = shift;
   return $self->{nomeAnexo};
}
#################################################################################









#################################################################################
# setAnexo e getAnexo
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo anexo
#################################################################################
sub setAnexo {
   my $self = shift;
   if (@_) {
      $self->{anexo} = shift;
   }
}
#--------------------------------------------------------------------------------
sub getAnexo {
   my $self = shift;
   return $self->{anexo};
}
#################################################################################










#################################################################################
# setNota e getNota
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo nota
#################################################################################
sub setNota {
   my $self = shift;
   if (@_) {
      if ($_[0] >= -1) {
         $self->{nota} = $_[0];
      } else {
         die "Nota deve ser inteiro e positivo!\n";
      }
   } else {
      die "Nota � inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNota {
   my $self = shift;
   return $self->{nota};
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
# setDados
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos
# 0-codigoResposta, 1-codigoPergunta, 2-titulo, 3-Texto, 4-data, 5-nomeAnexo,
# 6-nota, 7-codigoUsuario
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoResposta($_[0]);
      $self->setCodigoPergunta($_[1]);
      $self->setTitulo($_[2]);
      $self->setTexto($_[3]);
      $self->setData($_[4]);
      $self->setNomeAnexo($_[5]);
      $self->setNota($_[6]);
      $self->setCodigoUsuario($_[7]);
   } else {
      die "Nenhum argumento foi enviado para a resposta da pergunta!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos que vir�o diretamente da base de dados
# 0-codigoResposta, 1-codigoPergunta, 2-titulo, 3-texto, 4-data, 5-nomeAnexo
# 6-nota, 7-codigoUsuario
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoResposta} = $_[0];
      $self->{codigoPergunta} = $_[1];
      $self->{titulo} = $_[2];
      $self->{texto} = $_[3];
      $self->setDataBD($_[4]);
      $self->{nomeAnexo} = $_[5];
      $self->{nota} = $_[6];
      $self->{codigoUsuario} = $_[7];
   } else {
      die "Nenhum argumento foi enviado nas informa��es da resposta!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos exceto a data que � gerada automaticamente
# 0-codigoResposta, 1-codigoPergunta, 2-titulo, 3-texto, 4-nomeAnexo,,
# 5-codigoUsuario
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoResposta($_[0]);
      $self->setCodigoPergunta($_[1]);
      $self->setTitulo($_[2]);
      $self->setTexto($_[3]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setNomeAnexo($_[4]);
      $self->setNota(-1);
      $self->setCodigoUsuario($_[5]);
   } else {
      die "Nenhum argumento foi enviado para a resposta!";
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
   print "codigoResposta = ".$self->getCodigoResposta()."\n";
   print "codigoPergunta = ".$self->getCodigoPergunta()."\n";
   print "titulo = ".$self->getTitulo()."\n";
   print "texto = ".$self->getTexto()."\n";
   print "data = ".$self->getData()."\n";
   print "nomeAnexo = ".$self->getNomeAnexo()."\n";
   print "nota = ".$self->getNota()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
}
#################################################################################












1;
