package ClasseSessao;

use strict;
use FuncoesCronologicas;
use FuncoesUteis;
use ClasseUsuario;








#################################################################################
# ClasseSessao
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Esta é a classe é utilizada para criar e manipular objetos de Sessões
#################################################################################










#################################################################################
# new
#--------------------------------------------------------------------------------
# Construtor
#################################################################################
sub new {
   my $proto = shift;
   my $class = ref ($proto) || $proto;
   my $self = {
      sessaoID => undef, 
      codigoUsuario => undef,
      ip => undef,
      browser => undef,
      dataInicial => undef,
      dataFinal => undef,
      dataPresenca => undef,
      valido => undef,      
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
# Método que inicializa os atributos com valores default
#################################################################################
sub clear {
   my $self = shift;
   $self->{sessaoID} = "";
   $self->{codigoUsuario} = 0;
   $self->{ip} = "";
   $self->{browser} = "";
   $self->{dataInicial} = "00/00/0000 00:00:00";
   $self->{dataFinal} = "00/00/0000 00:00:00";
   $self->{dataPresenca} = "00/00/0000 00:00:00";
   $self->{valido} = 0;
   $self->{umUsuario}->clear();   
}
#################################################################################









#################################################################################
# setSessaoID e getSessaoID
#--------------------------------------------------------------------------------
# Método que manipula o atributo sessaoID
#################################################################################
sub setSessaoID {
   my $self = shift;
   if (@_) {
      if (length($_[0]) > 0) {
         $self->{sessaoID} = $_[0];
      } else {
         die "Identificador de sessão não pode estar vazio!\n";
      }
   } else {
      die "Identificador de sessão inválido!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getSessaoID {
   my $self = shift;
   return $self->{sessaoID};
}
#################################################################################










#################################################################################
# setCodigoUsuario e getCodigoUsuario
#--------------------------------------------------------------------------------
# Método que manipula o atributo codigoUsuario
#################################################################################
sub setCodigoUsuario {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{codigoUsuario} = $_[0];
      } else {
         die "Código do usuário na sessão deve ser um número inteiro e positivo!\n";
      }
   } else {
      die "Código do usuário na sessão é inválido!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getCodigoUsuario {
   my $self = shift;
   return $self->{codigoUsuario};
}
#################################################################################










#################################################################################
# setIP e getIP
#--------------------------------------------------------------------------------
# Método que manipula o atributo ip
#################################################################################
sub setIP {
   my $self = shift;
   if (@_) {
      $self->{ip} = $_[0];
   } else {
      die "IP da sessão é inválido!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getIP {
   my $self = shift;
   return $self->{ip};
}
#################################################################################










#################################################################################
# setBrowser e getBrowser
#--------------------------------------------------------------------------------
# Método que manipula o atributo browser
#################################################################################
sub setBrowser {
   my $self = shift;
   if (@_) {
      $self->{browser} = $_[0];
   } else {
      die "Browser da sessão é inválido!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getBrowser {
   my $self = shift;
   return $self->{browser};
}
#################################################################################










#################################################################################
# setDataInicial e getDataInicial
#--------------------------------------------------------------------------------
# Método que manipula o atributo dataInicial
#################################################################################
sub setDataInicial {
   my $self = shift;
   if (@_) {
      my $dataInicial = &TiraEspacos($_[0]);
      if (length($dataInicial) > 0) {
         if (length($dataInicial) == 19) {
            $self->{dataInicial} = $dataInicial;
         } else {
            die "Data inicial deve estar no formato [dd/mm/aaaa hh:mm:ss]!\n";
         }
      } else {
         die "Data inicial da sessão não pode estar vazia!\n";
      }
   } else {
      die "Data inicial da sessão é inválida!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getDataInicial {
   my $self = shift;
   return $self->{dataInicial};
}
#################################################################################










#################################################################################
# setDataInicialBD e getDataInicialBD
#--------------------------------------------------------------------------------
# Método que manipula o atributo dataInicial para banco de dados
#################################################################################
sub setDataInicialBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   my $hor = substr($_[0],11,2);
   my $min = substr($_[0],14,2);
   my $seg = substr($_[0],17,2);
   $self->{dataInicial} = "$dia/$mes/$ano $hor:$min:$seg";
}
#--------------------------------------------------------------------------------
sub getDataInicialBD {
   my $self = shift;
   my $ano = substr($self->{dataInicial},6,4);
   my $mes = substr($self->{dataInicial},3,2);
   my $dia = substr($self->{dataInicial},0,2);
   my $hor = substr($self->{dataInicial},11,2);
   my $min = substr($self->{dataInicial},14,2);
   my $seg = substr($self->{dataInicial},17,2);
   return "$ano-$mes-$dia $hor:$min:$seg";
}
#################################################################################










#################################################################################
# setDataFinal e getDataFinal
#--------------------------------------------------------------------------------
# Método que manipula o atributo dataFinal
#################################################################################
sub setDataFinal {
   my $self = shift;
   if (@_) {
      my $dataFinal = &TiraEspacos($_[0]);
      if (length($dataFinal) > 0) {
         if (length($dataFinal) == 19) {
            $self->{dataFinal} = $dataFinal;
         } else {
            die "Data final deve estar no formato [dd/mm/aaaa hh:mm:ss]!\n";
         }
      } else {
         die "Data final da sessão não pode estar vazia!\n";
      }
   } else {
      die "Data final da sessão é inválida!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getDataFinal {
   my $self = shift;
   return $self->{dataFinal};
}
#################################################################################










#################################################################################
# setDataFinalBD e getDataFinalBD
#--------------------------------------------------------------------------------
# Método que manipula o atributo dataFinal para banco de dados
#################################################################################
sub setDataFinalBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   my $hor = substr($_[0],11,2);
   my $min = substr($_[0],14,2);
   my $seg = substr($_[0],17,2);
   $self->{dataFinal} = "$dia/$mes/$ano $hor:$min:$seg";
}
#--------------------------------------------------------------------------------
sub getDataFinalBD {
   my $self = shift;
   my $ano = substr($self->{dataFinal},6,4);
   my $mes = substr($self->{dataFinal},3,2);
   my $dia = substr($self->{dataFinal},0,2);
   my $hor = substr($self->{dataFinal},11,2);
   my $min = substr($self->{dataFinal},14,2);
   my $seg = substr($self->{dataFinal},17,2);
   return "$ano-$mes-$dia $hor:$min:$seg";
}
#################################################################################










#################################################################################
# setDataPresenca e getDataPresenca
#--------------------------------------------------------------------------------
# Método que manipula o atributo dataPresenca
#################################################################################
sub setDataPresenca {
   my $self = shift;
   if (@_) {
      my $dataPresenca = &TiraEspacos($_[0]);
      if (length($dataPresenca) > 0) {
         if (length($dataPresenca) == 19) {
            $self->{dataPresenca} = $dataPresenca;
         } else {
            die "Data de presença deve estar no formato [dd/mm/aaaa hh:mm:ss]!\n";
         }
      } else {
         die "Data de presença da sessão não pode estar vazia!\n";
      }
   } else {
      die "Data de presença da sessão é inválida!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getDataPresenca {
   my $self = shift;
   return $self->{dataPresenca};
}
#################################################################################










#################################################################################
# setDataPresencaBD e getDataPresencaBD
#--------------------------------------------------------------------------------
# Método que manipula o atributo dataPresenca para banco de dados
#################################################################################
sub setDataPresencaBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   my $hor = substr($_[0],11,2);
   my $min = substr($_[0],14,2);
   my $seg = substr($_[0],17,2);
   $self->{dataPresenca} = "$dia/$mes/$ano $hor:$min:$seg";
}
#--------------------------------------------------------------------------------
sub getDataPresencaBD {
   my $self = shift;
   my $ano = substr($self->{dataPresenca},6,4);
   my $mes = substr($self->{dataPresenca},3,2);
   my $dia = substr($self->{dataPresenca},0,2);
   my $hor = substr($self->{dataPresenca},11,2);
   my $min = substr($self->{dataPresenca},14,2);
   my $seg = substr($self->{dataPresenca},17,2);
   return "$ano-$mes-$dia $hor:$min:$seg";
}
#################################################################################










#################################################################################
# setValido e getValido
#--------------------------------------------------------------------------------
# Método que manipula o atributo valido
#################################################################################
sub setValido {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{valido} = $_[0];
      } else {
         die "Validação de sessão incorreta!";
      }
   } else {
      die "Validação de sessão incorreta!\n";
   }   
}
#--------------------------------------------------------------------------------
sub getValido {
   my $self = shift;
   return $self->{valido};
}
#################################################################################










#################################################################################
# umUsuario
#--------------------------------------------------------------------------------
# Método que manipula o atributo umUsuario
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
# Método que permite inserir valores em todos os atributos da sessão.
# 0-sessaoID 1-codigoUsuario 2-ip 3-browser 4-dataInicial 5-dataFinal 
# 6-dataPresenca 7-valido
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setSessaoID($_[0]);
      $self->setCodigoUsuario($_[1]);
      $self->setIP($_[2]);
      $self->setBrowser($_[3]);
      $self->setDataInicial($_[4]);
      $self->setDataFinal($_[5]);
      $self->setDataPresenca($_[6]);
      $self->setValido($_[7]);
   } else {
      die "Problemas ao passar valores para a sessão!\n";
   }
}
#################################################################################










#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# Método que permite inserir valores da base em todos os atributos da sessão.
# 0-sessaoID 1-codigoUsuario 2-ip 3-browser 4-dataInicial 5-dataFinal 
# 6-dataPresenca 7-valido
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{sessaoID} = $_[0];
      $self->{codigoUsuario} = $_[1];
      $self->{ip} = $_[2];
      $self->{browser} = $_[3];
      $self->setDataInicialBD($_[4]);
      $self->setDataFinalBD($_[5]);
      $self->setDataPresencaBD($_[6]);
      $self->{valido} = $_[7];
   } else {
      die "Problemas ao passar valores armazenados para a sessão!\n";
   }
}
#################################################################################










#################################################################################
# getDados
#--------------------------------------------------------------------------------
# Método que apenas visualiza os valores de uma sessão.
#################################################################################
sub getDados {
   my $self = shift;
   print "sessaoID = ".$self->getSessaoID()."\n";
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
   print "ip = ".$self->getIP()."\n";
   print "browser = ".$self->getBrowser()."\n";
   print "dataInicial = ".$self->getDataInicial()."\n";
   print "dataFinal = ".$self->getDataFinal()."\n";
   print "dataPresenca = ".$self->getDataPresenca()."\n";
   print "valido = ".$self->getValido()."\n";
}
#################################################################################










#################################################################################
# gerarSessaoID
#--------------------------------------------------------------------------------
# Método que gera um ID para a sessão
# 0-ip ou seja $ENV{'REMOTE_ADDR'}
#################################################################################
sub gerarSessaoID {
   my $self = shift;
   my $ipremoto = $_[0];
   my $segundos = sprintf("%X",time());
   my $rand1 = sprintf("%X",int(rand(15)));
   my $rand2 = sprintf("%X",int(rand(15)));
   my $rand3 = sprintf("%X",int(rand(15)));
   my @bytesip = split(/\./,$ipremoto);
   $bytesip[0] = sprintf("%X",$bytesip[0]);
   $bytesip[1] = sprintf("%X",$bytesip[1]);
   $bytesip[2] = sprintf("%X",$bytesip[2]);
   $bytesip[3] = sprintf("%X",$bytesip[3]);
   $self->setSessaoID($bytesip[0].$rand1.$bytesip[1].$rand2.$bytesip[2].$rand3.$bytesip[3].$segundos);
}
#################################################################################










#################################################################################
# setDadosAutomatico
#--------------------------------------------------------------------------------
# Método que permite inserir valores em todos os atributos da sessão.
# 0-codigoUsuario 1-valido
#################################################################################
sub setDadosAutomatico {
   my $self = shift;
   if (@_) {
      $self->gerarSessaoID($ENV{'REMOTE_ADDR'});
      $self->setCodigoUsuario($_[0]);
      $self->setIP($ENV{'REMOTE_ADDR'});
      $self->setBrowser($ENV{'HTTP_USER_AGENT'});
      my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
      $self->setDataInicial("$dia/$mes/$ano $hor:$min:$seg");
      $self->setDataFinal("00/00/0000 00:00:00");
      $self->setDataPresenca("$dia/$mes/$ano $hor:$min:$seg");
      $self->setValido($_[1]);
   } else {
      die "Problemas ao passar valores para a sessão!\n";
   }
}
#################################################################################











1;
