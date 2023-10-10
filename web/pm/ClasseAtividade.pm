package ClasseAtividade;

use strict;
use ClasseUsuario;
use ClasseAtividadeInfo;
use FuncoesUteis;
use FuncoesCronologicas;







#################################################################################
# ClasseAtividade
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controlam atividades
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
      codigoAtividade => undef,
      titulo => undef,
      texto => undef,
      data => undef,
      dataLimite => undef,
      habAnexo => undef,
      valorNota => undef,
      codigoUsuario => undef,
      dataDivulgacao => undef,
      umUsuario => new ClasseUsuario,
      lido => undef,
      info => new ClasseAtividadeInfo,
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
   $self->{codigoAtividade} = 0;
   $self->{titulo} = "";
   $self->{texto} = "";
   $self->{data} = "00/00/0000 00:00:00";
   $self->{dataLimite} = "00/00/0000 00:00";
   $self->{habAnexo} = 0;
   $self->{valorNota} = 0;
   $self->{codigoUsuario} = "";
   $self->{dataDivulgacao} = "00/00/0000 00:00";
   $self->{umUsuario}->clear;
   $self->{lido} = 0;
   $self->{info}->clear;
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
            die "Título da atividade pode conter no máximo 60 caracteres!\n";
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
      die "Texto da atividade está inválido!\n";
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
      die "Data da atividade está inválida!\n";
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
# expirouDataLimite
#--------------------------------------------------------------------------------
# métodos que responde se a data limite expirou ou não
#################################################################################
sub expirouDataLimite {
   my $self = shift;
   my $expirou = 0;
   my $anoL = substr($self->{dataLimite},6,4);
   my $mesL = substr($self->{dataLimite},3,2);
   my $diaL = substr($self->{dataLimite},0,2);
   my $horL = substr($self->{dataLimite},11,2);
   my $minL = substr($self->{dataLimite},14,2);
   my $dataLimite =  "$anoL$mesL$diaL$horL$minL"."00";
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $dataHoje = "$ano$mes$dia$hor$min$seg";
   if ($dataHoje*1 > $dataLimite*1) {
      $expirou = 1;
   }
   return $expirou;
}
#################################################################################









#################################################################################
# setDataLimite e getDataLimite
#--------------------------------------------------------------------------------
# métodos para manipular o atributo dataLimite
#################################################################################
sub setDataLimite {
   my $self = shift;
   if (@_) {
      my $dataLimite = &TiraEspacos($_[0]);
      if (length($dataLimite) > 0) {
         if (length($dataLimite) == 16) {
            $self->{dataLimite} = $dataLimite;
         } else {
            die "Data limite deve estar no formato [dd/mm/aaaa hh:mm] !\n";
         }
      } else {
         $self->{dataLimite} = "00/00/0000 00:00";
      }
   } else {
      die "Data limite da atividade está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getDataLimite {
   my $self = shift;
   return $self->{dataLimite};
}
#################################################################################










#################################################################################
# setDataLimiteBD e getDataLimiteBD
#--------------------------------------------------------------------------------
# métodos para manipular o atributo dataLimite
#################################################################################
sub setDataLimiteBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   my $hor = substr($_[0],11,2);
   my $min = substr($_[0],14,2);
   my $seg = substr($_[0],17,2);
   $self->{dataLimite} = "$dia/$mes/$ano $hor:$min";
}
#--------------------------------------------------------------------------------
sub getDataLimiteBD {
   my $self = shift;
   my $ano = substr($self->{dataLimite},6,4);
   my $mes = substr($self->{dataLimite},3,2);
   my $dia = substr($self->{dataLimite},0,2);
   my $hor = substr($self->{dataLimite},11,2);
   my $min = substr($self->{dataLimite},14,2);
   my $seg = substr($self->{dataLimite},17,2);
   return "$ano-$mes-$dia $hor:$min:00";
}
#################################################################################









#################################################################################
# setDataDivulgacao e getDataDivulgacao
#--------------------------------------------------------------------------------
# métodos para manipular o atributo dataDivulgacao
#################################################################################
sub setDataDivulgacao {
   my $self = shift;
   if (@_) {
      my $dataDivulgacao = &TiraEspacos($_[0]);
      if (length($dataDivulgacao) > 0) {
         if (length($dataDivulgacao) == 16) {
            $self->{dataDivulgacao} = $dataDivulgacao;
         } else {
            die "Data de divulgação deve estar no formato [dd/mm/aaaa hh:mm] !\n";
         }
      } else {
         $self->{dataDivulgacao} = "00/00/0000 00:00";
      }
   } else {
      die "Data divulgação da atividade está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getDataDivulgacao {
   my $self = shift;
   return $self->{dataDivulgacao};
}
#################################################################################










#################################################################################
# setDataDivulgacaoBD e getDataDivulgacaoBD
#--------------------------------------------------------------------------------
# métodos para manipular o atributo dataDivulgacao
#################################################################################
sub setDataDivulgacaoBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   my $hor = substr($_[0],11,2);
   my $min = substr($_[0],14,2);
   my $seg = substr($_[0],17,2);
   $self->{dataDivulgacao} = "$dia/$mes/$ano $hor:$min";
}
#--------------------------------------------------------------------------------
sub getDataDivulgacaoBD {
   my $self = shift;
   my $ano = substr($self->{dataDivulgacao},6,4);
   my $mes = substr($self->{dataDivulgacao},3,2);
   my $dia = substr($self->{dataDivulgacao},0,2);
   my $hor = substr($self->{dataDivulgacao},11,2);
   my $min = substr($self->{dataDivulgacao},14,2);
   my $seg = substr($self->{dataDivulgacao},17,2);
   return "$ano-$mes-$dia $hor:$min:00";
}
#################################################################################










#################################################################################
# expirouDataDivulgacao
#--------------------------------------------------------------------------------
# métodos que responde se a data de divulgação expirou ou não
#################################################################################
sub expirouDataDivulgacao {
   my $self = shift;
   my $expirou = 0;
   my $anoL = substr($self->{dataDivulgacao},6,4);
   my $mesL = substr($self->{dataDivulgacao},3,2);
   my $diaL = substr($self->{dataDivulgacao},0,2);
   my $horL = substr($self->{dataDivulgacao},11,2);
   my $minL = substr($self->{dataDivulgacao},14,2);
   my $dataDivulgacao =  "$anoL$mesL$diaL$horL$minL"."00";
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $dataHoje = "$ano$mes$dia$hor$min$seg";
   if ($dataHoje*1 > $dataDivulgacao*1) {
      $expirou = 1;
   }
   return $expirou;
}
#################################################################################









#################################################################################
# setHabAnexo e getHabAnexo
#--------------------------------------------------------------------------------
# métodos para manipular o atributo habAnexo
#################################################################################
sub setHabAnexo {
   my $self = shift;
   if (@_) {
      $self->{habAnexo} = shift;
   } else {
      die "Habilitação de anexo está inválida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabAnexo {
   my $self = shift;
   return $self->{habAnexo};
}
#################################################################################










#################################################################################
# setValorNota e getValorNota
#--------------------------------------------------------------------------------
# métodos para manipular o atributo valorNota
#################################################################################
sub setValorNota {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{valorNota} = $_[0];
      } else {
         die "Valor da nota deve ser positivo!\n";
      }
   } else {
      die "Valor da nota é inválido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getValorNota {
   my $self = shift;
   return $self->{valorNota};
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
# info
#--------------------------------------------------------------------------------
# métodos complementares de informações sobre a atividade
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
# 0-codigoAtividade, 1-titulo, 2-texto, 3-data, 4-dataLimite, 5-habAnexo,
# 6-valorNota, 7-codigoUsuario, 8-dataDivulgacao
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoAtividade($_[0]);
      $self->setTitulo($_[1]);
      $self->setTexto($_[2]);
      $self->setData($_[3]);
      $self->setDataLimite($_[4]);
      $self->setHabAnexo($_[5]);
      $self->setValorNota($_[6]);
      $self->setCodigoUsuario($_[7]);
      $self->setDataDivulgacao($_[8]);
   } else {
      die "Nenhum argumento foi enviado para a atividade!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos que virão diretamente da base de dados
# 0-codigoAtividade, 1-titulo, 2-texto, 3-data, 4-dataLimite, 5-habAnexo,
# 6-valorNota, 7-codigoUsuario, 8-dataDivulgacao
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoAtividade} = $_[0];
      $self->{titulo} = $_[1];
      $self->{texto} = $_[2];
      $self->setDataBD($_[3]);
      $self->setDataLimiteBD($_[4]);
      $self->{habAnexo} = $_[5];
      $self->{valorNota} = $_[6];
      $self->{codigoUsuario} = $_[7];
      $self->setDataDivulgacaoBD($_[8]);
   } else {
      die "Nenhum argumento foi enviado nas informações da atividade!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# métodos para manipular todos os atributos exceto a data que é gerada automaticamente
# 0-codigoAtividade, 1-titulo, 2-texto, 3-dataLimite, 4-habAnexo, 5-valorNota,
# 6-codigoUsuario, 7-dataDivulgacao
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoAtividade($_[0]);
      $self->setTitulo($_[1]);
      $self->setTexto($_[2]);
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setData("$dia/$mes/$ano $hor:$min:$seg");
      $self->setDataLimite($_[3]);
      $self->setHabAnexo($_[4]);
      $self->setValorNota($_[5]);
      $self->setCodigoUsuario($_[6]);
      $self->setDataDivulgacao($_[7]);
   } else {
      die "Nenhum argumento foi enviado para a atividade!";
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
   print "codigoAtividade = ".$self->getCodigoAtividade()."\n";
   print "titulo = ".$self->getTitulo()."\n";
   print "texto = ".$self->getTexto()."\n";
   print "data = ".$self->getData()."\n";
   print "dataLimite = ".$self->getDataLimite()."\n";
   print "habAnexo = ".$self->getHabAnexo()."\n";
   print "valorNota = ".$self->getValorNota()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
   print "dataDivulgacao = ".$self->getDataDivulgacao()."\n";
}
#################################################################################












1;
