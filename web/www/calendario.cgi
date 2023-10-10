#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlCalendario;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlCalendario = new HtmlCalendario;

$umCookie->query($query);
$htmlCalendario->query($query);


if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlCalendario->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();   

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();
   if ($query->param('opcao') eq "") {
      $htmlCalendario->imprimirTelaCalendario();
   }
   if ($query->param('opcao') eq "visualizar") {
      $htmlCalendario->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "gravar") {
      $htmlCalendario->imprimirTelaGravar();
   }
   if ($query->param('opcao') eq "gravando") {
      $htmlCalendario->imprimirTelaGravando();
   }
   if ($query->param('opcao') eq "apagar") {
      $htmlCalendario->imprimirTelaApagar();
   }
   if ($query->param('opcao') eq "apagando") {
      $htmlCalendario->imprimirTelaApagando();
   }
  if ($query->param('opcao') eq "mostrarAniversarios") {
      $htmlCalendario->imprimirTelaAniversarios();
   }
  if ($query->param('opcao') eq "visualizarAniversarios") {
      $htmlCalendario->imprimirTelaVisualizarAniversarios();
   }
#   if ($query->param('opcao') eq "excluindo") {
#      $htmlAvisos->imprimirTelaExcluindo();
#   }
#   if ($query->param('opcao') eq "estender") {
#      $htmlAvisos->imprimirTelaEstender();
#   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlCalendario->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

