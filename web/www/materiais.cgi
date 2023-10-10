#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlMateriais;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlMateriais = new HtmlMateriais;

$umCookie->query($query);
$htmlMateriais->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlMateriais->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();   

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();
   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      $htmlMateriais->imprimirTelaMateriais();
   }
   if ($query->param('opcao') eq "visualizar") {
      $htmlMateriais->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "incluir") {
      $htmlMateriais->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindo") {
      $htmlMateriais->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterar") {
      $htmlMateriais->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterando") {
      $htmlMateriais->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluir") {
      $htmlMateriais->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindo") {
      $htmlMateriais->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estender") {
      $htmlMateriais->imprimirTelaEstender();
   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlMateriais->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

