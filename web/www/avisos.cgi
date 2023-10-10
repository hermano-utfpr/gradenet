#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlAvisos;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlAvisos = new HtmlAvisos;

$umCookie->query($query);
$htmlAvisos->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlAvisos->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();   

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();
   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      $htmlAvisos->imprimirTelaAvisos();
   }
   if ($query->param('opcao') eq "visualizar") {
      $htmlAvisos->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "incluir") {
      $htmlAvisos->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindo") {
      $htmlAvisos->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterar") {
      $htmlAvisos->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterando") {
      $htmlAvisos->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluir") {
      $htmlAvisos->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindo") {
      $htmlAvisos->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estender") {
      $htmlAvisos->imprimirTelaEstender();
   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlAvisos->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

