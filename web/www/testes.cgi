#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlTestes;
use HtmlTestesQuestoes;
use HtmlTestesUsuarios;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlTestes = new HtmlTestes;
my $htmlQuestoes = new HtmlTestesQuestoes;
my $htmlTestesUsuarios = new HtmlTestesUsuarios;

$umCookie->query($query);
$htmlTestes->query($query);
$htmlQuestoes->query($query);
$htmlTestesUsuarios->query($query);


if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlTestes->umUsuario($umCookie->umUsuario);
   $htmlQuestoes->umUsuario($umCookie->umUsuario);
   $htmlTestesUsuarios->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();

   $htmlPrincipal->imprimirCabecalho();
   $htmlPrincipal->imprimirBoasVindas();
   if ($query->param('opcao') ne "iniciarTeste" && $query->param('opcao') ne "avaliarTeste") {
      $htmlPrincipal->imprimirMenu();
   }
   if ($query->param('opcao') eq "" || $query->param('opcao') eq "mostrar") {
      if ($umCookie->umUsuario->getPrivilegios()) {
         $htmlTestes->imprimirTelaTestes();
      } else {
         $htmlTestesUsuarios->imprimirTelaGerenciarAluno();
      }
   }
   if ($query->param('opcao') eq "visualizar") {
      $htmlTestes->imprimirTelaVisualizar();
      if ($umCookie->umUsuario->getPrivilegios()) {
         $htmlQuestoes->imprimirTelaQuestoes();
      }
   }
   if ($query->param('opcao') eq "incluir") {
      $htmlTestes->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindo") {
      $htmlTestes->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "alterar") {
      $htmlTestes->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterando") {
      $htmlTestes->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "excluir") {
      $htmlTestes->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindo") {
      $htmlTestes->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "incluirQuestao") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlQuestoes->imprimirTelaIncluir();
   }
   if ($query->param('opcao') eq "incluindoQuestao") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlQuestoes->imprimirTelaIncluindo();
   }
   if ($query->param('opcao') eq "visualizarQuestao") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlQuestoes->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "excluirQuestao") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlQuestoes->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindoQuestao") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlQuestoes->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "estenderQuestoes") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlQuestoes->imprimirTelaEstenderQuestoes();
   }
   if ($query->param('opcao') eq "gerenciarTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaGerenciar();
   }
   if ($query->param('opcao') eq "abrirTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaAbrindoTeste();
      $htmlTestesUsuarios->imprimirTelaGerenciar();
   }
   if ($query->param('opcao') eq "abrirSelecao") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaAbrindoSelecionados();
      $htmlTestesUsuarios->imprimirTelaGerenciar();
   }
   if ($query->param('opcao') eq "fecharTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaFechandoTeste();
      $htmlTestesUsuarios->imprimirTelaGerenciar();
   }
   if ($query->param('opcao') eq "zerarTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaZerandoTeste();
      $htmlTestesUsuarios->imprimirTelaGerenciar();
   }
   if ($query->param('opcao') eq "corrigirNotaTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaCorrigindoNotaTeste();
      $htmlTestesUsuarios->imprimirTelaGerenciar();
   }
   if ($query->param('opcao') eq "reabrirTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaReabrirTeste();
   }
   if ($query->param('opcao') eq "reabrindoTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaReabrindoTeste();
      $htmlTestesUsuarios->imprimirTelaGerenciar();
   }
   if ($query->param('opcao') eq "confFecharTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaConfFecharTeste();
   }
   if ($query->param('opcao') eq "confZerarTeste") {
      $htmlTestes->imprimirTelaVisualizar();
      $htmlTestesUsuarios->imprimirTelaConfZerarTeste();
   }
   if ($query->param('opcao') eq "iniciarTeste") {
      $htmlTestes->imprimirTelaVisualizar(1);
      $htmlTestesUsuarios->imprimirTelaIniciarTeste();
   }
   if ($query->param('opcao') eq "avaliarTeste") {
      $htmlTestes->imprimirTelaVisualizar(1);
      $htmlTestesUsuarios->imprimirTelaAvaliarTeste();
   }
   if ($query->param('opcao') eq "visualizarTeste") {
      $htmlTestes->imprimirTelaVisualizar(1);
      $htmlTestesUsuarios->imprimirTelaVisualizarTeste();
   }
   if ($query->param('opcao') eq "ranking") {
      if ($umCookie->umUsuario->getPrivilegios()) {
         $htmlTestesUsuarios->imprimirTelaRankingTodos();
      } else {
         $htmlTestesUsuarios->imprimirTelaRanking();
      }
   }


   $htmlPrincipal->imprimirRodape();
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlTestes->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

