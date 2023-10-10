#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlAmbiente;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlAmbiente = new HtmlAmbiente;

$umCookie->query($query);
$htmlAmbiente->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlAmbiente->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();   

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();
   if ($query->param('opcao') eq "") {
      $htmlAmbiente->imprimirTelaAmbiente();
   }
   if ($query->param('opcao') eq "alterar") {
      $htmlAmbiente->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterando") {
      $htmlAmbiente->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "trocarCartaz") {
      $htmlAmbiente->imprimirTelaTrocarCartaz();
   }
   if ($query->param('opcao') eq "trocandoCartaz") {
      $htmlAmbiente->imprimirTelaTrocandoCartaz();
   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlAmbiente->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

