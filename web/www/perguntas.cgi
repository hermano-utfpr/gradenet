#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlPerguntas;
use HtmlPerguntasRespostas;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlPerguntas = new HtmlPerguntas;
my $htmlRespostas = new HtmlPerguntasRespostas;

$umCookie->query($query);
$htmlPerguntas->query($query);
$htmlRespostas->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlPerguntas->umUsuario($umCookie->umUsuario);
   $htmlRespostas->umUsuario($umCookie->umUsuario);
   $htmlRespostas->setPergunta();
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();   

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();
   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      $htmlPerguntas->imprimirTelaPerguntas();
   }
   if ($query->param('opcao') eq "visualizar") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaEstender();
   }
   if ($query->param('opcao') eq "incluir") {
      $htmlPerguntas->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindo") {
      $htmlPerguntas->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterar") {
      $htmlPerguntas->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterando") {
      $htmlPerguntas->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluir") {
      $htmlPerguntas->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindo") {
      $htmlPerguntas->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estender") {
      $htmlPerguntas->imprimirTelaEstender();
   }
   if ($query->param('opcao') eq "visualizarResposta") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "incluirResposta") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindoResposta") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterarResposta") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterandoResposta") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluirResposta") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindoResposta") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estenderRespostas") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaEstender();
   }
   if ($query->param('opcao') eq "atribuirNotas") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAtribuirNotas();
   }
   if ($query->param('opcao') eq "atribuindoNotas") {
      $htmlPerguntas->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAtribuindoNotas();
   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlPerguntas->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

