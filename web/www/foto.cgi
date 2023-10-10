#!/usr/bin/perl

use strict;
use ClasseCookie;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use ClasseUsuario;
use DadosUsuarios;

my $query = new CGI;
my $umCookie = new ClasseCookie;

$umCookie->query($query);

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

if ($umCookie->existeSessao()) {

   if ($query->param('opcao') eq "mostrar") {
      my $foto = $dadosUsuarios->selecionarFotoUsuario($query->param('codigoUsuario'));   
      print "Content-type: image/jpeg\n\n";   
#      print "Content-type: application/octet-stream\n\n";   
      print $foto;
   }

   
} else {
   print $query->redirect("index.cgi");
}


