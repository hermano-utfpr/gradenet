package FuncoesUteis;
require 5.000;
require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(TiraEspacos ZeroEsquerda TamanhoBytes EnviaMail setTextoHTML getTextoHTML RetiraTags);

use strict;










#################################################################################
# FuncoesUteis
# criado  : 13/02/2002
# projeto : Sala Virtual
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Funcoes uteis para todo o site.
#################################################################################










#################################################################################
# TiraEspacos
# criado : 13/02/2002
#--------------------------------------------------------------------------------
# Função que retorna o valor de um texto sem espaços em branco antes e depois.
#################################################################################
sub TiraEspacos {
   my $texto = $_[0];
   my $textonovo = "";
   my $inicio = 0;
   my $i = 0;
   for ($i = 0; $i <= length($texto)-1; $i++) {
      if ((substr($texto,$i,1) ne " ") || ($inicio == 1)) {
          $textonovo = $textonovo.substr($texto,$i,1);
          $inicio = 1;
      }
   }
   $texto = $textonovo;
   $textonovo = "";
   $inicio = 0;
   for ($i = length($texto)-1; $i >= 0; $i--) {
      if ((substr($texto,$i,1) ne " ") || ($inicio == 1)) {
         $textonovo = substr($texto,$i,1).$textonovo;
         $inicio = 1;
      }
   }
   return $textonovo;
}
#################################################################################










#################################################################################
# ZeroEsquerda
# criado : 13/02/2002
#--------------------------------------------------------------------------------
# Retorna um valor string com zeros à esquerda
#################################################################################
sub ZeroEsquerda {
   my $valor = $_[0]; 
   my $tamanho = $_[1]; 
   while (length($valor) < $tamanho) {
      $valor = "0$valor";
   }
   return $valor;
}
#################################################################################
















#################################################################################
# TamanhoBytes
# criado : 25/02/2004
#--------------------------------------------------------------------------------
# Função que retorna um valor e a quantidade de Bytes/KB/MB/GB
#################################################################################
sub TamanhoBytes {
   my $valor = $_[0];
   my $texto = "$valor Bytes";
   if ($valor >= 1024) {
      $valor = int($valor*100/1024)/100;
      $texto = "$valor KB";
      if ($valor >= 1024) {
         $valor = int($valor*100/1024)/100;
         $texto = "$valor MB";
         if ($valor >= 1024) {
            $valor = int($valor*100/1024)/100;
            $texto = "$valor GB";
         }
      }
   }
   return $texto;
}
#################################################################################










#################################################################################
# EnviaMail
# criado : 03/03/2004
#--------------------------------------------------------------------------------
# Função que envia um e-mail
#################################################################################
sub EnviaMail {
   my $origem = $_[0];
   my $destino = $_[1];
   my $assunto = $_[2];
   my $texto = $_[3];
   my $mailprog = "/usr/sbin/sendmail -t";

   open (MAIL,"|$mailprog");
   print MAIL "To: $destino\n";
   print MAIL "From: $origem\n";
   print MAIL "Subject: $assunto\n\n";
   print MAIL $texto;
   close (MAIL);

}
#################################################################################










#################################################################################
# setTextoHTML
# criado : 03/03/2004
#--------------------------------------------------------------------------------
# Função que retorna um texto, retirando tags HTML e utilizando os códigos HTML
# default do projeto gradenet
#################################################################################
sub setTextoHTML {
   my $texto = $_[0];
  
   $texto =~ s/\"/\&quot\;/ig;
   $texto =~ s/\'/&#39\;/ig;
   $texto =~ s/\</\&lt\;/ig;
   $texto =~ s/\>/\&gt\;/ig;
   $texto =~ s/\n/\<br\>/ig;

   $texto =~ s/\[pre\]/\<big\>\<pre\>/ig;
   $texto =~ s/\[\/pre\]/\<\/pre\>\<\/big\>/ig;

   $texto =~ s/\[b\]/\<b\>/ig;
   $texto =~ s/\[\/b\]/\<\/b\>/ig;
   $texto =~ s/\[big\]/\<big\>/ig;
   $texto =~ s/\[\/big\]/\<\/big\>/ig;
   $texto =~ s/\[i\]/\<i\>/ig;
   $texto =~ s/\[\/i\]/\<\/i\>/ig;
   $texto =~ s/\[small\]/\<small\>/ig;
   $texto =~ s/\[\/small\]/\<\/small\>/ig;
   $texto =~ s/\[strike\]/\<strike\>/ig;
   $texto =~ s/\[\/strike\]/\<\/strike\>/ig;
   $texto =~ s/\[sub\]/\<sub\>/ig;
   $texto =~ s/\[\/sub\]/\<\/sub\>/ig;
   $texto =~ s/\[sup\]/\<sup\>/ig;
   $texto =~ s/\[\/sup\]/\<\/sup\>/ig;
   $texto =~ s/\[tt\]/\<tt\>/ig;
   $texto =~ s/\[\/tt\]/\<\/tt\>/ig;
   $texto =~ s/\[center\]/\<center\>/ig;
   $texto =~ s/\[\/center\]/\<\/center\>/ig;

   $texto =~ s/\[link\]/\<a href=\"/ig;
   $texto =~ s/\[link-texto\]/\\" target=\"_new\">/ig;
   $texto =~ s/\[\/link\]/\<\/a\>/ig;

   $texto =~ s/\[img\]/\<img src=\"/ig;
   $texto =~ s/\[\/img\]/\" border=\"0\"\>\<\/img\>/ig;

   $texto =~ s/  /\&nbsp\;\&nbsp\;/ig;
   
   return $texto;
}
#################################################################################










#################################################################################
# getTextoHTML
# criado : 03/03/2004
#--------------------------------------------------------------------------------
# Função que retorna um texto, retirando tags HTML e utilizando os códigos HTML
# default do projeto gradenet
#################################################################################
sub getTextoHTML {
   my $texto = $_[0];

   $texto =~ s/\&nbsp\;/ /ig;
   $texto =~ s/\<br\>/\n/ig;

   $texto =~ s/\<big\>\<pre\>/\[pre\]/ig;
   $texto =~ s/\<\/pre\>\<\/big\>/\[\/pre\]/ig;

   $texto =~ s/\<b\>/\[b\]/ig;
   $texto =~ s/\<\/b\>/\[\/b\]/ig;
   $texto =~ s/\<big\>/\[big\]/ig;
   $texto =~ s/\<\/big\>/\[\/big\]/ig;
   $texto =~ s/\<i\>/\[i\]/ig;
   $texto =~ s/\<\/i\>/\[\/i\]/ig;
   $texto =~ s/\<small\>/\[small\]/ig;
   $texto =~ s/\<\/small\>/\[\/small\]/ig;
   $texto =~ s/\<strike\>/\[strike\]/ig;
   $texto =~ s/\<\/strike\>/\[\/strike\]/ig;
   $texto =~ s/\<sub\>/\[sub\]/ig;
   $texto =~ s/\<\/sub\>/\[\/sub\]/ig;
   $texto =~ s/\<sup\>/\[sup\]/ig;
   $texto =~ s/\<\/sup\>/\[\/sup\]/ig;
   $texto =~ s/\<tt\>/\[tt\]/ig;
   $texto =~ s/\<\/tt\>/\[\/tt\]/ig;
   $texto =~ s/\<center\>/\[center\]/ig;
   $texto =~ s/\<\/center\>/\[\/center\]/ig;
   
   $texto =~ s/\<a href=\"/\[link\]/ig;
   $texto =~ s/\" target=\"_new\">/\[link-texto\]/ig;
   $texto =~ s/\<\/a\>/\[\/link\]/ig;

   $texto =~ s/\<img src=\"/\[img\]/ig;
   $texto =~ s/\" border=\"0\"\>\<\/img\>/\[\/img\]/ig;

   return $texto;
}
#################################################################################










#################################################################################
# RetiraTags
# criado : 03/03/2004
#--------------------------------------------------------------------------------
# Função que retorna um texto, retirando tags HTML 
#################################################################################
sub RetiraTags {
   my $texto = $_[0];
  
   $texto =~ s/\"//ig;
   $texto =~ s/\'//ig;
   $texto =~ s/\<//ig;
   $texto =~ s/\>//ig;
   
   return $texto;
}
#################################################################################










return 1

