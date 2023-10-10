#!/usr/bin/perl

use strict;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use ClasseAmbiente;
use DadosAmbiente;

my $query = new CGI;

my $umAmbiente = new ClasseAmbiente;
my $dadosAmbiente = new DadosAmbiente;

my $cartaz = $dadosAmbiente->selecionarCartaz();
print "Content-type: image/jpeg\n\n";   
print $cartaz;
   
