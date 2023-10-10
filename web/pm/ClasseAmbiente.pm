package ClasseAmbiente;

use strict;
use FuncoesUteis;







#################################################################################
# ClasseAmbiente
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular o objeto que cont�m informa��es sobre o ambiente
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
      nomeDisciplina => undef, 
      turma => undef,
      link => undef,
      sobre => undef,
      corDeFundo => undef,
      cartaz => undef,
      titulo => undef,
      linha1 => undef,
      linha2 => undef,
      linha3 => undef,
      habCalendario => undef,
      habAtividades => undef,
      habAnotacoes => undef,
      habArquivos => undef,
      habMateriais => undef,
      habDesafios => undef,
      habPerguntas => undef,
      habTestes => undef,
      kBytesArquivo => undef,
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
   $self->{nomeDisciplina} = "";
   $self->{turma} = "";
   $self->{link} = "";
   $self->{sobre} = "";
   $self->{corDeFundo} = "";
   $self->{cartaz} =  undef;
   $self->{titulo} = "";
   $self->{linha1} = "";
   $self->{linha2} = "";
   $self->{linha3} = "";
   $self->{habCalendario} = 0;
   $self->{habAtividades} = 0;
   $self->{habAnotacoes} = 0;
   $self->{habArquivos} = 0;
   $self->{habMateriais} = 0;
   $self->{habDesafios} = 0;
   $self->{habPerguntas} = 0;
   $self->{habTestes} = 0;
   $self->{kBytesArquivo} = 0;
}
#################################################################################









#################################################################################
# setNomeDisciplina e getNomeDisciplina
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo nome da disciplina
#################################################################################
sub setNomeDisciplina {
   my $self = shift;
   if (@_) {
      my $nomeDisciplina = &TiraEspacos($_[0]);
      $nomeDisciplina = &RetiraTags($nomeDisciplina);
      if (length($nomeDisciplina) >= 0) {
         if (length($nomeDisciplina) <= 100) {
            $self->{nomeDisciplina} = $nomeDisciplina;
         } else {
            die "Nome da disciplina pode conter no m�ximo 100 caracteres!\n";
         }
      }
   } else {
      die "Nome da disciplina est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNomeDisciplina {
   my $self = shift;
   return $self->{nomeDisciplina};
}
#################################################################################









#################################################################################
# setTurma e getTurma
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo turma
#################################################################################
sub setTurma {
   my $self = shift;
   if (@_) {
      my $turma = &TiraEspacos($_[0]);
      $turma = &RetiraTags($turma);
      if (length($turma) >= 0) {
         if (length($turma) <= 100) {
            $self->{turma} = $turma;
         } else {
            die "Turma pode conter no m�ximo 100 caracteres!\n";
         }
      }
   } else {
      die "Turma est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getTurma {
   my $self = shift;
   return $self->{turma};
}
#################################################################################









#################################################################################
# setLink e getLink
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo link
#################################################################################
sub setLink {
   my $self = shift;
   if (@_) {
      my $link = &TiraEspacos($_[0]);
      $link = &RetiraTags($link);
      if (length($link) >= 0) {
         if (length($link) <= 100) {
            $self->{link} = $link;
         } else {
            die "Link pode conter no m�ximo 100 caracteres!\n";
         }
      }
   } else {
      die "Link est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getLink {
   my $self = shift;
   return $self->{link};
}
#################################################################################









#################################################################################
# setSobre e getSobre
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo sobre
#################################################################################
sub setSobre {
   my $self = shift;
   if (@_) {
      my $sobre = $_[0];
      $sobre = &setTextoHTML($sobre);
      $self->{sobre} = $sobre;
   } else {
      die "Sobre a disciplina est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getSobre {
   my $self = shift;
   return $self->{sobre};
}
#################################################################################









#################################################################################
# setCorDeFundo e getCorDeFundo
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo corDeFundo
#################################################################################
sub setCorDeFundo {
   my $self = shift;
   if (@_) {
      my $corDeFundo = &TiraEspacos($_[0]);
      $corDeFundo = &RetiraTags($corDeFundo);
      if (length($corDeFundo) >= 0) {
         if (length($corDeFundo) <= 6) {
            $self->{corDeFundo} = $corDeFundo;
         } else {
            die "Cor de fundo pode conter no m�ximo 6 caracteres!\n";
         }
      }
   } else {
      die "Cor de fundo est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getCorDeFundo {
   my $self = shift;
   return $self->{corDeFundo};
}
#################################################################################









#################################################################################
# setCartaz e getCartaz
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo cartaz
#################################################################################
sub setCartaz {
   my $self = shift;
   if (@_) {
      $self->{cartaz} = shift;
   }
}
#--------------------------------------------------------------------------------
sub getCartaz {
   my $self = shift;
   return $self->{cartaz};
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
      my $titulo = &RetiraTags($_[0]);
      $self->{titulo} = $titulo;
   } else {
      die "T�tulo do do ambiente est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getTitulo {
   my $self = shift;
   return $self->{titulo};
}
#################################################################################









#################################################################################
# setLinha1 e getLinha1
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo linha1
#################################################################################
sub setLinha1 {
   my $self = shift;
   if (@_) {
      my $linha1 = &RetiraTags($_[0]);
      $self->{linha1} = $linha1;
   } else {
      die "Linha 1 do cabe�alho est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getLinha1 {
   my $self = shift;
   return $self->{linha1};
}
#################################################################################









#################################################################################
# setLinha2 e getLinha2
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo linha2
#################################################################################
sub setLinha2 {
   my $self = shift;
   if (@_) {
      my $linha2 = &RetiraTags($_[0]);
      $self->{linha2} = $linha2;
   } else {
      die "Linha 2 do cabe�alho est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getLinha2 {
   my $self = shift;
   return $self->{linha2};
}
#################################################################################









#################################################################################
# setLinha3 e getLinha3
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo linha3
#################################################################################
sub setLinha3 {
   my $self = shift;
   if (@_) {
      my $linha3 = &RetiraTags($_[0]);
      $self->{linha3} = $linha3;
   } else {
      die "Linha 3 do cabe�alho est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getLinha3 {
   my $self = shift;
   return $self->{linha3};
}
#################################################################################










#################################################################################
# setHabCalendario e getHabCalendario
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habCalendario
#################################################################################
sub setHabCalendario {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habCalendario} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabCalendario {
   my $self = shift;
   return $self->{habCalendario};
}
#################################################################################










#################################################################################
# setHabAtividades e getHabAtividades
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habAtividades
#################################################################################
sub setHabAtividades {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habAtividades} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabAtividades {
   my $self = shift;
   return $self->{habAtividades};
}
#################################################################################










#################################################################################
# setHabAnotacoes e getHabAnotacoes
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habAnotacoes
#################################################################################
sub setHabAnotacoes {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habAnotacoes} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabAnotacoes {
   my $self = shift;
   return $self->{habAnotacoes};
}
#################################################################################






#################################################################################
# setHabArquivos e getHabArquivos
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habArquivos
#################################################################################
sub setHabArquivos {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habArquivos} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabArquivos {
   my $self = shift;
   return $self->{habArquivos};
}
#################################################################################







#################################################################################
# setHabMateriais e getHabMateriais
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habMateriais
#################################################################################
sub setHabMateriais {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habMateriais} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabMateriais {
   my $self = shift;
   return $self->{habMateriais};
}
#################################################################################










#################################################################################
# setHabDesafios e getHabDesafios
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habDesafios
#################################################################################
sub setHabDesafios {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habDesafios} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabDesafios {
   my $self = shift;
   return $self->{habDesafios};
}
#################################################################################










#################################################################################
# setHabPerguntas e getHabPerguntas
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habPerguntas
#################################################################################
sub setHabPerguntas {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habPerguntas} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabPerguntas {
   my $self = shift;
   return $self->{habPerguntas};
}
#################################################################################
















#################################################################################
# setHabTestes e getHabTestes
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo habTestes
#################################################################################
sub setHabTestes {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{habTestes} = $_[0];
      } else {
         die "O item pode ser apenas (0 - desabilitado) ou (1 - habilitado)!\n";
      }
   } else {
      die "O item n�o foi configurado para ser (des)habilitado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getHabTestes {
   my $self = shift;
   return $self->{habTestes};
}
#################################################################################










#################################################################################
# setKBytesArquivo e getKBytesArquivo
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo kBytesArquivo
#################################################################################
sub setKBytesArquivo {
   my $self = shift;
   if (@_) {
      if ($_[0] >= 0) {
         $self->{kBytesArquivo} = $_[0];
      } else {
         die "KB de arquivo est� inv�lido!\n";
      }
   } else {
      die "KB de arquivo inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getKBytesArquivo {
   my $self = shift;
   return $self->{kBytesArquivo};
}
#################################################################################










#################################################################################
# setDados
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setNomeDisciplina($_[0]);
      $self->setTurma($_[1]);
      $self->setLink($_[2]);
      $self->setSobre($_[3]);
      $self->setCorDeFundo($_[4]);
      $self->setCartaz($_[5]);
      $self->setTitulo($_[6]);
      $self->setLinha1($_[7]);
      $self->setLinha2($_[8]);
      $self->setLinha3($_[9]);
      $self->setHabCalendario($_[10]);
      $self->setHabAtividades($_[11]);
      $self->setHabAnotacoes($_[12]);
      $self->setHabArquivos($_[13]);
      $self->setHabMateriais($_[14]);
      $self->setHabDesafios($_[15]);
      $self->setHabPerguntas($_[16]);
      $self->setHabTestes($_[17]);
      $self->setKBytesArquivo($_[18]);
   } else {
      die "Nenhum argumento foi enviado nas informa��es do ambiente!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos que vir�o diretamente da base de dados
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{nomeDisciplina} = $_[0];
      $self->{turma} = $_[1];
      $self->{link} = $_[2];
      $self->{sobre} = $_[3];
      $self->{corDeFundo} = $_[4];
      $self->{titulo} = $_[5];
      $self->{linha1} = $_[6];
      $self->{linha2} = $_[7];
      $self->{linha3} = $_[8];
      $self->{habCalendario} = $_[9];
      $self->{habAtividades} = $_[10];
      $self->{habAnotacoes} = $_[11];
      $self->{habArquivos} = $_[12];
      $self->{habMateriais} = $_[13];
      $self->{habDesafios} = $_[14];
      $self->{habPerguntas} = $_[15];
      $self->{habTestes} = $_[16];
      $self->{kBytesArquivo} = $_[17];
   } else {
      die "Nenhum argumento foi enviado nas informa��es do ambiente!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos repassando-os da IU
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setNomeDisciplina($_[0]);
      $self->setTurma($_[1]);
      $self->setLink($_[2]);
      $self->setSobre($_[3]);
      $self->setCorDeFundo($_[4]);
      $self->setTitulo($_[5]);
      $self->setLinha1($_[6]);
      $self->setLinha2($_[7]);
      $self->setLinha3($_[8]);
      $self->setHabCalendario($_[9]);
      $self->setHabAtividades($_[10]);
      $self->setHabAnotacoes($_[11]);
      $self->setHabArquivos($_[12]);
      $self->setHabMateriais($_[13]);
      $self->setHabDesafios($_[14]);
      $self->setHabPerguntas($_[15]);
      $self->setHabTestes($_[16]);
      $self->setKBytesArquivo($_[17]);
   } else {
      die "Nenhum argumento foi enviado nas informa��es do ambiente!";
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
   print "nomeDisciplina = ".$self->getNomeDisciplina()."\n";
   print "turma = ".$self->getTurma()."\n";
   print "link = ".$self->getLink()."\n";
   print "sobre = ".$self->getSobre()."\n";
   print "corDeFundo = ".$self->getCorDeFundo()."\n";
   print "titulo = ".$self->getTitulo()."\n";
   print "linha1 = ".$self->getLinha1()."\n";
   print "linha2 = ".$self->getLinha2()."\n";
   print "linha3 = ".$self->getLinha3()."\n";
   print "habCalendario = ".$self->getHabCalendario()."\n";
   print "habAtividades = ".$self->getHabAtividades()."\n";
   print "habAnotacoes = ".$self->getHabAnotacoes()."\n";
   print "habArquivos = ".$self->getHabArquivos()."\n";
   print "habMateriais = ".$self->getHabMateriais()."\n";
   print "habDesafios = ".$self->getHabDesafios()."\n";
   print "habPerguntas = ".$self->getHabPerguntas()."\n";
   print "habTestes = ".$self->getHabTestes()."\n";
   print "kBytesArquivo = ".$self->getKBytesArquivo()."\n";
}
#################################################################################












1;
