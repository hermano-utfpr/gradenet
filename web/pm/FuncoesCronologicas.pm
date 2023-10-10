package FuncoesCronologicas;
require 5.000;
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(HorarioCorrigido HoraCerta TextualizaDiaSemana TextualizaMes HoraCertaConversor GerarHoraConversor);

use strict;
use FuncoesUteis;










#################################################################################
# FuncoesCronologicas
# criado  : 13/02/2002
# projeto : Sala Virtual
# autor   : Hermano Pereira 
#--------------------------------------------------------------------------------
# Funções que manipulam data e hora
#################################################################################










#################################################################################
# HorarioCorrigido
# criado : 13/02/2002
#--------------------------------------------------------------------------------
# Função que retorna em segundos para manipulação do site, o horário correto
# de Brasília
#################################################################################
sub HorarioCorrigido {
#   my $DadosConfiguracoes = DadosConfiguracoes->New;
#   my $UmaConfiguracao = $DadosConfiguracoes->Solicitar;
#   my $CorrecaoTime = $UmaConfiguracao->CorrecaoTime;
   return time; 
}
#################################################################################










#################################################################################
# HoraCerta
# criado : 13/02/2002
#--------------------------------------------------------------------------------
# Retorna a hora certa com meses e dias de semanas em português
#################################################################################
sub HoraCerta {
   my $segtime = &HorarioCorrigido + $_[0];   # Horário do servidor + horário pré-definido
   my ($seg,$min,$hor,$dia,$mes,$ano,$diasem) = localtime($segtime);
   my $textdiasemana = &TextualizaDiaSemana("Texto",$diasem);
   my $sigladiasemana = &TextualizaDiaSemana("Sigla",$diasem);
   my $textmes = &TextualizaMes($mes);
   $seg = &ZeroEsquerda($seg,2);
   $min = &ZeroEsquerda($min,2);
   $hor = &ZeroEsquerda($hor,2);
   $dia = &ZeroEsquerda($dia,2);
   $mes = &ZeroEsquerda($mes+1,2);
   $ano = $ano + 1900;
   return ($hor,$min,$seg,$dia,$mes,$ano,$textdiasemana,$sigladiasemana,$textmes);
}
#################################################################################










#################################################################################
# TextualizaDiaSemana
# criado : 13/02/2002
#--------------------------------------------------------------------------------
# Retorna o dia da semana em texto ou sigla
#################################################################################
sub TextualizaDiaSemana {
   my $modo = $_[0]; # modo "Sigla" ou "Texto"
   my $diasem = $_[1];
   my $texto  = "";
   if (($modo eq "Sigla") && ($diasem == 0)) { $texto = "DOM"; }
   if (($modo eq "Sigla") && ($diasem == 1)) { $texto = "SEG"; }
   if (($modo eq "Sigla") && ($diasem == 2)) { $texto = "TER"; }
   if (($modo eq "Sigla") && ($diasem == 3)) { $texto = "QUA"; }
   if (($modo eq "Sigla") && ($diasem == 4)) { $texto = "QUI"; }
   if (($modo eq "Sigla") && ($diasem == 5)) { $texto = "SEX"; }
   if (($modo eq "Sigla") && ($diasem == 6)) { $texto = "SAB"; }
   if (($modo eq "Texto") && ($diasem == 0)) { $texto = "Domingo"; }
   if (($modo eq "Texto") && ($diasem == 1)) { $texto = "Segunda"; }
   if (($modo eq "Texto") && ($diasem == 2)) { $texto = "Terça"; }
   if (($modo eq "Texto") && ($diasem == 3)) { $texto = "Quarta"; }
   if (($modo eq "Texto") && ($diasem == 4)) { $texto = "Quinta"; }
   if (($modo eq "Texto") && ($diasem == 5)) { $texto = "Sexta"; }
   if (($modo eq "Texto") && ($diasem == 6)) { $texto = "Sábado"; }
   return $texto;  
}
#################################################################################










#################################################################################
# TextualizaMes
# criado : 13/02/2002
#--------------------------------------------------------------------------------
# Retorna o mês em texto.
#################################################################################
sub TextualizaMes {
   my $mes = $_[0];    # Mês de 0 a 11
   my $texto = "";   
   if ($mes == 0) { $texto = "Janeiro"; }
   if ($mes == 1) { $texto = "Fevereiro"; }
   if ($mes == 2) { $texto = "Março"; }
   if ($mes == 3) { $texto = "Abril"; }
   if ($mes == 4) { $texto = "Maio"; }
   if ($mes == 5) { $texto = "Junho"; }
   if ($mes == 6) { $texto = "Julho"; }
   if ($mes == 7) { $texto = "Agosto"; }
   if ($mes == 8) { $texto = "Setembro"; }
   if ($mes == 9) { $texto = "Outubro"; }
   if ($mes == 10) { $texto = "Novembro"; }
   if ($mes == 11) { $texto = "Dezembro"; }
   return $texto;
}
#################################################################################










#################################################################################
# HoraCertaConversor
# criado : 13/01/2003
#--------------------------------------------------------------------------------
# Baseando na função HoraCerta, retorna a hora de acordo com o número de
# segundos fornecidos, sem somar com os segundos do servidor.
#################################################################################
sub HoraCertaConversor {
   my $segtime = $_[0];
   my ($seg,$min,$hor,$dia,$mes,$ano,$diasem) = localtime($segtime);
   my $textdiasemana = &TextualizaDiaSemana("Texto",$diasem);
   my $sigladiasemana = &TextualizaDiaSemana("Sigla",$diasem);
   my $textmes = &TextualizaMes($mes);
   $seg = &ZeroEsquerda($seg,2);
   $min = &ZeroEsquerda($min,2);
   $hor = &ZeroEsquerda($hor,2);
   $dia = &ZeroEsquerda($dia,2);
   $mes = &ZeroEsquerda($mes+1,2);
   $ano = $ano + 1900;
   return ($hor,$min,$seg,$dia,$mes,$ano,$textdiasemana,$sigladiasemana,$textmes);
}
#################################################################################










#################################################################################
# GerarHoraConversor
# criado : 07/03/2003
#--------------------------------------------------------------------------------
# Baseando na função HoraCerta, retorna a hora de acordo com o número de
# segundos fornecidos, sem somar com os segundos do servidor.
# Esta funcao nao eh estavel,utilizada somente para converter
# dia/mes/ano em numero de segundos
#################################################################################
sub GerarHoraConversor {
   my $ndia = $_[0];
   my $nmes = $_[1];
   my $nano = $_[2];
   my $nhor = 23;
   my $nmin = 59;
   my $nseg = 59;
   my $numatual = time();
   my ($hor,$min,$seg,$dia,$mes,$ano,$textdiasemana,$sigladiasemana,$textmes) = &HoraCertaConversor($numatual);
   if (($nano.$nmes.$ndia.$nhor.$nmin.$nseg)>($ano.$mes.$dia.$hor.$min.$seg)) {
      while (($ano.$mes.$dia) < ($nano.$nmes.$ndia)) {
         $numatual+= 86400;
         ($hor,$min,$seg,$dia,$mes,$ano,$textdiasemana,$sigladiasemana,$textmes) = &HoraCertaConversor($numatual);         
      }
      while ($hor.$min.$seg ne $nhor.$nmin.$nseg) {
         $numatual += (($nhor-$hor) * 3600);
         $numatual += (($nmin-$min) * 60);
         $numatual += (($nseg-$seg) * 1);
         ($hor,$min,$seg,$dia,$mes,$ano,$textdiasemana,$sigladiasemana,$textmes) = &HoraCertaConversor($numatual);         
      }
   }   
   return $numatual;
}
#################################################################################










return 1



