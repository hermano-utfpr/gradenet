#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use HtmlLogin;
use HtmlAvisos;
use DadosInicial;
use CGI;
use CGI::Carp qw (fatalsToBrowser);

my $dadosInicial = new DadosInicial;
$dadosInicial->iniciarBase();

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlLogin = new HtmlLogin;
my $htmlAvisos = new HtmlAvisos;

$umCookie->query($query);

if ($umCookie->existeSessao()) {
   if ($query->param('opcao') eq "sair") {
      $umCookie->fecharSessao();
      print $query->header();
      $htmlPrincipal->imprimirCabecalho();
      $htmlLogin->imprimirMensagem("Sua sessão foi encerrada!",0);
      $htmlPrincipal->imprimirRodape();
   } else {
      print $query->redirect("avisos.cgi");
   }
} else {
   if (length($query->param('login')) > 0) {
      $umCookie->criarSessao();
      $htmlPrincipal->umUsuario($umCookie->umUsuario);
      $htmlAvisos->umUsuario($umCookie->umUsuario);
      $htmlPrincipal->imprimirCabecalho();
      $htmlPrincipal->imprimirBoasVindas();
      $htmlPrincipal->imprimirMenu();
      $htmlAvisos->imprimirTelaAvisos();
      $htmlPrincipal->imprimirRodape();
   } else {
      print $query->header();
      $htmlPrincipal->imprimirCabecalho();
      $htmlLogin->imprimirTelaLogin();
      $htmlAvisos->imprimirTelaUltimosAvisos();
      $htmlLogin->imprimirTelaContato();
      $htmlPrincipal->imprimirRodape();
   }
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      $htmlPrincipal->imprimirCabecalho();
      $htmlLogin->imprimirMensagem($error_message,1);
      $htmlPrincipal->imprimirRodape();      
   }
   CGI::Carp::set_message(\&carp_error);
}

