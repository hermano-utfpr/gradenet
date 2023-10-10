#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlAtividades;
use HtmlAtividadesRespostas;
use HtmlAtividadesCorrecoes;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlAtividades = new HtmlAtividades;
my $htmlRespostas = new HtmlAtividadesRespostas;
my $htmlCorrecoes = new HtmlAtividadesCorrecoes;

$umCookie->query($query);
$htmlAtividades->query($query);
$htmlRespostas->query($query);
$htmlCorrecoes->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlAtividades->umUsuario($umCookie->umUsuario);
   $htmlRespostas->umUsuario($umCookie->umUsuario);
   $htmlRespostas->setAtividade();
   $htmlCorrecoes->umUsuario($umCookie->umUsuario);
   $htmlCorrecoes->setAtividade();   
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();   

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   $htmlPrincipal->imprimirMenu();
   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      $htmlAtividades->imprimirTelaAtividades();
   }
   if ($query->param('opcao') eq "visualizar") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaRespostas();
      $htmlCorrecoes->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "incluir") {
      $htmlAtividades->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindo") {
      $htmlAtividades->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterar") {
      $htmlAtividades->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterando") {
      $htmlAtividades->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluir") {
      $htmlAtividades->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindo") {
      $htmlAtividades->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estender") {
      $htmlAtividades->imprimirTelaEstender();
   }
   if ($query->param('opcao') eq "visualizarResposta") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaVisualizar();
      $htmlCorrecoes->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "incluirResposta") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindoResposta") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterarResposta") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterandoResposta") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluirResposta") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindoResposta") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estenderRespostas") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaEstender();
      $htmlCorrecoes->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "atribuirNotas") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAtribuirNotas();
      $htmlCorrecoes->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "atribuindoNotas") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlRespostas->imprimirTelaAtribuindoNotas();
   }
   if ($query->param('opcao') eq "incluirCorrecao") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlCorrecoes->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindoCorrecao") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlCorrecoes->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterarCorrecao") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlCorrecoes->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterandoCorrecao") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlCorrecoes->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluirCorrecao") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlCorrecoes->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindoCorrecao") {
      $htmlAtividades->imprimirTelaVisualizar();
      $htmlCorrecoes->imprimirTelaExcluindo();
   }
   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlAtividades->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

