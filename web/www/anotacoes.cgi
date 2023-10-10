#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlAnotacoes;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlAnotacoes = new HtmlAnotacoes;

$umCookie->query($query);
$htmlAnotacoes->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlAnotacoes->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);

   print $query->header();   
   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();

   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      $htmlAnotacoes->imprimirTelaAnotacoes();
   }
   if ($query->param('opcao') eq "visualizarAnotacao") {
      $htmlAnotacoes->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "incluirAnotacao") {
      $htmlAnotacoes->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindoAnotacao") {
      $htmlAnotacoes->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterarAnotacao") {
      $htmlAnotacoes->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterandoAnotacao") {
      $htmlAnotacoes->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluirAnotacao") {
      $htmlAnotacoes->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindoAnotacao") {
      $htmlAnotacoes->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estenderAnotacoes") {
      $htmlAnotacoes->imprimirTelaEstender();
   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlAnotacoes->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

