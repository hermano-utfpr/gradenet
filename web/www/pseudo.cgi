#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlArquivos;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlArquivos = new HtmlArquivos;

$umCookie->query($query);
$htmlArquivos->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlArquivos->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);

   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      print $query->header();   
      $htmlArquivos->imprimirTelaArquivosPseudo();
   }

} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlArquivos->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

