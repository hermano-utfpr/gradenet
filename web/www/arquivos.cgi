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

   if ($query->param('opcao') ne "baixarArquivo") {
      print $query->header();   
      $htmlPrincipal->imprimirCabecalho();
      $htmlPrincipal->imprimirBoasVindas();
      $htmlPrincipal->imprimirMenu();
   } else { 
      $htmlArquivos->imprimirTelaBaixandoArquivo();
   }
   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      $htmlArquivos->imprimirTelaArquivos();
   }
   if ($query->param('opcao') eq "enviarArquivo") {
      $htmlArquivos->imprimirTelaEnviarArquivo();
   }
   if ($query->param('opcao') eq "enviandoArquivo") {
      $htmlArquivos->imprimirTelaEnviandoArquivo();
   }
   if ($query->param('opcao') eq "editarArquivo") {
      $htmlArquivos->imprimirTelaEditarArquivo();
   }
   if ($query->param('opcao') eq "editandoArquivo") {
      $htmlArquivos->imprimirTelaEditandoArquivo();
   }
   if ($query->param('opcao') eq "deletarArquivo") {
      $htmlArquivos->imprimirTelaDeletarArquivo();
   }
   if ($query->param('opcao') eq "deletandoArquivo") {
      $htmlArquivos->imprimirTelaDeletandoArquivo();
   }
   if ($query->param('opcao') eq "criarPasta") {
      $htmlArquivos->imprimirTelaCriarPasta();
   }
   if ($query->param('opcao') eq "criandoPasta") {
      $htmlArquivos->imprimirTelaCriandoPasta();
   }
   if ($query->param('opcao') eq "editarPasta") {
      $htmlArquivos->imprimirTelaEditarPasta();
   }
   if ($query->param('opcao') eq "editandoPasta") {
      $htmlArquivos->imprimirTelaEditandoPasta();
   }
   if ($query->param('opcao') eq "deletarPasta") {
      $htmlArquivos->imprimirTelaDeletarPasta();
   }
   if ($query->param('opcao') eq "deletandoPasta") {
      $htmlArquivos->imprimirTelaDeletandoPasta();
   }
   if ($query->param('opcao') ne "baixarArquivo") {
      $htmlPrincipal->imprimirRodape();
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

