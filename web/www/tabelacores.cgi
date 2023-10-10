#!/usr/bin/perl

use strict;

print "Content-type: text/html\n\n";

my $i = 0;
my $j = 0;
my $k = 0;

print "<html><head><title>Tabela de Cores HTML</title></head><body>";

my $cor;
my $coluna = 0;
my $numColunas = 16;


print "<TABLE border = 0 width=1200>";

for ($i = 0; $i <= 15; $i++ ) {
   for ($j = 0; $j <= 15; $j++) {
      for ($k = 0; $k <= 15; $k++) {
         $coluna++;
         if ($coluna > $numColunas) {
            $coluna = 1;
         }
         if ($coluna == 1) {
            print "<TR>";
         }
          
         $cor = sprintf("%X",$i).sprintf("%X",$i).sprintf("%X",$j).sprintf("%X",$j).sprintf("%X",$k).sprintf("%X",$k);
         print "<TD BGCOLOR=$cor width=20></TD>";
         print "<TD><font color=000000 size=2 face=Arial>$cor</font></TD>";

         if ($coluna == $numColunas) {
            print "</TR>";
         }
      }
   }
}

print "</TABLE>";

print "</html>";
