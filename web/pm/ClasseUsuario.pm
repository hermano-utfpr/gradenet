package ClasseUsuario;

use strict;
use FuncoesUteis;
use FuncoesCronologicas;
use ClasseUsuarioInfo;







#################################################################################
# ClasseUsuario
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para criar e manipular objetos que controla usu�rios como alunos e
# professores.
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
      codigoUsuario => undef, 
      nome => undef,
      login => undef,
      password => undef,
      privilegios => undef,
      email => undef,
      sexo => undef,
      dataNascimento => undef,
      perfil => undef,
      foto => undef,
      ativo => undef,
      info => new ClasseUsuarioInfo,
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
   $self->{codigoUsuario} = 0;
   $self->{nome} = "";
   $self->{login} = "";
   $self->{password} = "";
   $self->{privilegios} = 0;
   $self->{email} = "";
   $self->{sexo} = 0;
   $self->{dataNascimento} = "00/00/0000";
   $self->{perfil} = "";
   $self->{foto} = undef;
   $self->{ativo} = 0;
   $self->{info}->clear;
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
# setNome e getNome
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo nome
#################################################################################
sub setNome {
   my $self = shift;
   if (@_) {
      my $nome = &TiraEspacos($_[0]);
      $nome = &RetiraTags($nome);
      if (length($nome) > 0) {
         if (length($nome) <= 60) {
            $self->{nome} = $nome;
         } else {
            die "Nome do usu�rio pode conter no m�ximo 60 caracteres!\n";
         }
      } else {
         die "Nome do usu�rio n�o pode estar vazio!\n";
      }
   } else {
      die "Nome do usu�rio est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getNome {
   my $self = shift;
   return $self->{nome};
}
#################################################################################









#################################################################################
# setLogin e getLogin
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo login
#################################################################################
sub setLogin {
   my $self = shift;
   if (@_) {
      my $login = &TiraEspacos($_[0]);
      $login = &RetiraTags($login);
      if (length($login) > 0) {
         if (length($login) <= 20) {
            $self->{login} = $login;
         } else {
            die "Login do usu�rio pode conter no m�ximo 20 caracteres!\n";
         }
      } else {
         die "Login do usu�rio n�o pode estar vazio!\n";
      }
   } else {
      die "Login do usu�rio est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getLogin {
   my $self = shift;
   return $self->{login};
}
#################################################################################









#################################################################################
# setPassword e getPassword
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo password
#################################################################################
sub setPassword {
   my $self = shift;
   if (@_) {
    my $password = &TiraEspacos($_[0]);
    $password = &RetiraTags($password);
     if (length($password) > 0) {
         if (length($password) <= 20) {
            $self->{password} = $password;
         } else {
            die "Password do usu�rio pode conter no m�ximo 20 caracteres!\n";
         }
      } else {
         die "Password do usu�rio n�o pode estar vazio!\n";
      }
   } else {
      die "Password do usu�rio est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getPassword {
   my $self = shift;
   return $self->{password};
}
#################################################################################









#################################################################################
# conferePassword
#--------------------------------------------------------------------------------
# m�todos para conferir se as passwords s�o iguais
#################################################################################
sub conferePassword {
   my $self = shift;
   if (@_) {
      my $password = &TiraEspacos($_[0]);
      my $confPassword = &TiraEspacos($_[1]);
      if ($password eq $confPassword) {
         $self->setPassword($password);
      } else {
         die "Passwords n�o conferem!\n";
      }
   } else {
      die "Password do usu�rio est� inv�lido!\n";
   }
}
#################################################################################











#################################################################################
# setPrivilegios e getPrivilegios
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo privilegios
#################################################################################
sub setPrivilegios {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{privilegios} = $_[0];
      } else {
         die "O usu�rio pode ter apenas privil�gios de  (0 - Aluno) ou (1 - Professor)!\n";
      }
   } else {
      die "Privil�gios do usu�rio est�o inv�lidos!\n";
   }
}
#--------------------------------------------------------------------------------
sub getPrivilegios {
   my $self = shift;
   return $self->{privilegios};
}
#################################################################################









#################################################################################
# setEmail e getEmail
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo email
#################################################################################
sub setEmail {
   my $self = shift;
   if (@_) {
      my $email = &TiraEspacos($_[0]);
      $email = &RetiraTags($email);
      if (length($email) <= 200) {
         $self->{email} = $email;
      } else {
         die "E-mail do usu�rio pode conter no m�ximo 200 caracteres!\n";
      }
   } else {
      die "E-mail do usu�rio est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getEmail {
   my $self = shift;
   return $self->{email};
}
#################################################################################










#################################################################################
# setSexo e getSexo
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo sexo
#################################################################################
sub setSexo {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{sexo} = $_[0];
      } else {
         die "O usu�rio pode ter apenas sexo (0 - Feminino) ou (1 - Masculino)!\n";
      }
   } else {
      die "Sexo do usu�rio est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getSexo {
   my $self = shift;
   return $self->{sexo};
}
#################################################################################









#################################################################################
# setDataNascimento e getDataNascimento
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo dataNascimento
#################################################################################
sub setDataNascimento {
   my $self = shift;
   if (@_) {
      my $dataNascimento = &TiraEspacos($_[0]);
      if (length($dataNascimento) > 0) {
         if (length($dataNascimento) == 10) {
            $self->{dataNascimento} = $dataNascimento;
         } else {
            die "Data de Nascimento do usu�rio deve estar no formato [dd/mm/aaaa] !\n";
         }
      } else {
         $self->{dataNascimento} = "00/00/0000";
      }
   } else {
      die "Data de Nascimento do usu�rio est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getDataNascimento {
   my $self = shift;
   return $self->{dataNascimento};
}
#################################################################################










#################################################################################
# setDataNascimentoBD e getDataNascimentoBD
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo dataNascimento
#################################################################################
sub setDataNascimentoBD {
   my $self = shift;
   my $ano = substr($_[0],0,4);
   my $mes = substr($_[0],5,2);
   my $dia = substr($_[0],8,2);
   $self->{dataNascimento} = "$dia/$mes/$ano";
}
#--------------------------------------------------------------------------------
sub getDataNascimentoBD {
   my $self = shift;
   my $ano = substr($self->{dataNascimento},6,4);
   my $mes = substr($self->{dataNascimento},3,2);
   my $dia = substr($self->{dataNascimento},0,2);
   return "$ano-$mes-$dia";
}
#################################################################################









#################################################################################
# getIdade
#--------------------------------------------------------------------------------
# m�todos verifica a idade do usu�rio
#################################################################################
sub getIdade {
   my $self = shift;
 
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

   my $diaU = substr($self->getDataNascimento(),0,2);
   my $mesU = substr($self->getDataNascimento(),3,2);
   my $anoU = substr($self->getDataNascimento(),6,4);

   my $idade = $ano - $anoU;

   if ($mes < $mesU || ($mes == $mesU && $dia < $diaU)) {   
      $idade--;
   } 
   
   if ($anoU <= 1800) {
      $idade = 0;
   }

   return $idade;
}
#################################################################################









#################################################################################
# setPerfil e getPerfil
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo perfil
#################################################################################
sub setPerfil {
   my $self = shift;
   if (@_) {
      my $perfil = $_[0];
      $perfil = setTextoHTML($perfil);
      $self->{perfil} = $perfil;
   } else {
      die "Perfil do usu�rio est� inv�lido!\n";
   }
}
#--------------------------------------------------------------------------------
sub getPerfil {
   my $self = shift;
   return $self->{perfil};
}
#################################################################################









#################################################################################
# setFoto e getFoto
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo foto
#################################################################################
sub setFoto {
   my $self = shift;
   if (@_) {
      $self->{foto} = shift;
   } else {
      die "Foto do usu�rio est� inv�lida!\n";
   }
}
#--------------------------------------------------------------------------------
sub getFoto {
   my $self = shift;
   return $self->{foto};
}
#################################################################################










#################################################################################
# setAtivo e getAtivo
#--------------------------------------------------------------------------------
# m�todos para manipular o atributo ativo
#################################################################################
sub setAtivo {
   my $self = shift;
   if (@_) {
      if ($_[0] == 0 || $_[0] == 1) {
         $self->{ativo} = $_[0];
      } else {
         die "O usu�rio pode ser apenas (0 - inativo) ou (1 - ativo)!\n";
      }
   } else {
      die "O usu�rio n�o foi configurado para ser (des)ativado!\n";
   }
}
#--------------------------------------------------------------------------------
sub getAtivo {
   my $self = shift;
   return $self->{ativo};
}
#################################################################################










#################################################################################
# info
#--------------------------------------------------------------------------------
# m�todos para manipular informa�oes sobre o usu�rio
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
# m�todos para manipular todos os atributos
# 0-codigoUsuario, 1-nome, 2-login, 3-password, 4-privilegio, 5-email, 6-sexo, 
# 7-dataNascimento, 8-perfil, 9-foto, 10-ativo
#################################################################################
sub setDados {
   my $self = shift;
   if (@_) {
      $self->setCodigoUsuario($_[0]);
      $self->setNome($_[1]);
      $self->setLogin($_[2]);
      $self->setPassword($_[3]);
      $self->setPrivilegios($_[4]);
      $self->setEmail($_[5]);
      $self->setSexo($_[6]);
      $self->setDataNascimento($_[7]);
      $self->setPerfil($_[8]);
      $self->setFoto($_[9]);
      $self->setAtivo($_[10]);
   } else {
      die "Nenhum argumento foi enviado nas informa��es do usu�rio!";
   }
}
#################################################################################









#################################################################################
# setDadosBD
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos que vir�o diretamente da base de dados
# 0-codigoUsuario, 1-nome, 2-login, 3-privilegio, 4-email, 5-sexo, 
# 6-dataNascimento, 7-perfil, 8-ativo
#################################################################################
sub setDadosBD {
   my $self = shift;
   if (@_) {
      $self->{codigoUsuario} = $_[0];
      $self->{nome} = $_[1];
      $self->{login} = $_[2];
      $self->{privilegios} = $_[3];
      $self->{email} = $_[4];
      $self->{sexo} = $_[5];
      $self->setDataNascimentoBD($_[6]);
      $self->{perfil} = $_[7];
      $self->{ativo} = $_[8];
   } else {
      die "Nenhum argumento foi enviado nas informa��es do usu�rio!";
   }
}
#################################################################################










#################################################################################
# setDadosIU
#--------------------------------------------------------------------------------
# m�todos para manipular todos os atributos que vem da interface exceto a foto
# 0-codigoUsuario, 1-nome, 2-login, 3-password, 4-confPassword, 5-privilegios, 
# 6-email, 7-sexo, 8-dataNascimento, 9-perfil, 10-ativo
#################################################################################
sub setDadosIU {
   my $self = shift;
   if (@_) {
      $self->setCodigoUsuario($_[0]);
      $self->setNome($_[1]);
      $self->setLogin($_[2]);
      $self->conferePassword($_[3],$_[4]);
      $self->setPrivilegios($_[5]);
      $self->setEmail($_[6]);
      $self->setSexo($_[7]);
      $self->setDataNascimento($_[8]);
      $self->setPerfil($_[9]);
      $self->setAtivo($_[10]);
   } else {
      die "Nenhum argumento foi enviado nas informa��es do usu�rio!";
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
   print "codigoUsuario = ".$self->getCodigoUsuario()."\n";
   print "nome = ".$self->getNome()."\n";
   print "login = ".$self->getLogin()."\n";
   print "password = ".$self->getPassword()."\n";
   print "privilegios = ".$self->getPrivilegios()."\n";
   print "email = ".$self->getEmail()."\n";
   print "sexo = ".$self->getSexo()."\n";
   print "dataNascimento = ".$self->getDataNascimento()."\n";
   print "perfil = ".$self->getPerfil()."\n";
   print "foto = ".$self->getFoto()."\n";
   print "ativo = ".$self->getAtivo()."\n";
}
#################################################################################












1;
