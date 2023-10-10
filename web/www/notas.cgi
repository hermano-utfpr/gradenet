#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlNotas;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlNotas = new HtmlNotas;

$umCookie->query($query);
$htmlNotas->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlNotas->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();   

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();
   if ($query->param('opcao') eq "") {
      $htmlNotas->imprimirTelaNotas();
   } elsif ($query->param('opcao') eq "visualizar") {
      $htmlNotas->imprimirTelaNotasAluno($query->param('codigoAluno'));
   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlNotas->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

