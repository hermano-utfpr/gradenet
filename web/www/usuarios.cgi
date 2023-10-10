#!/usr/bin/perl

use strict;
use ClasseCookie;
use HtmlPrincipal;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use HtmlUsuarios;

my $query = new CGI;
my $umCookie = new ClasseCookie;
my $htmlPrincipal = new HtmlPrincipal;
my $htmlUsuarios = new HtmlUsuarios;
my $impCabRod = 1;
$umCookie->query($query);
$htmlUsuarios->query($query);

if ($umCookie->existeSessao()) {
   $umCookie->marcarPresenca();
   $htmlUsuarios->umUsuario($umCookie->umUsuario);
   $htmlPrincipal->umUsuario($umCookie->umUsuario);
   print $query->header();
   if (($query->param('opcao') eq "visualizarPerfil") ||
       ($query->param('opcao') eq "listarAlunos")
      ){
      $impCabRod = 0;
   }
   if ($impCabRod) {
      $htmlPrincipal->imprimirCabecalho();
      $htmlPrincipal->imprimirBoasVindas();
      $htmlPrincipal->imprimirMenu();
   }
   if ($query->param('opcao') eq "") {
      $htmlUsuarios->imprimirTelaUsuarios();
   }
   if ($query->param('opcao') eq "incluir") {
      $htmlUsuarios->imprimirTelaIncluirUsuario();
   }
   if ($query->param('opcao') eq "incluindo") {
      $htmlUsuarios->imprimirTelaIncluindoUsuario();
   }
   if ($query->param('opcao') eq "visualizar") {
      $htmlUsuarios->imprimirTelaVisualizar();
   }
   if ($query->param('opcao') eq "visualizarPerfil") {
      $htmlUsuarios->imprimirTelaVisualizarPerfil();
   }
   if ($query->param('opcao') eq "alterar") {
      $htmlUsuarios->imprimirTelaAlterar();
   }
   if ($query->param('opcao') eq "alterando") {
      $htmlUsuarios->imprimirTelaAlterando();
   }
   if ($query->param('opcao') eq "trocarFoto") {
      $htmlUsuarios->imprimirTelaTrocarFoto();
   }
   if ($query->param('opcao') eq "trocandoFoto") {
      $htmlUsuarios->imprimirTelaTrocandoFoto();
   }
   if ($query->param('opcao') eq "trocarSenha") {
      $htmlUsuarios->imprimirTelaTrocarSenha();
   }
   if ($query->param('opcao') eq "trocandoSenha") {
      $htmlUsuarios->imprimirTelaTrocandoSenha();
   }
   if (($query->param('opcao') eq "ativar") || ($query->param('opcao') eq "desativar"))  {
      $htmlUsuarios->imprimirTelaAtivarDesativar();
   }
   if ($query->param('opcao') eq "excluir") {
      $htmlUsuarios->imprimirTelaExcluir();
   }
   if ($query->param('opcao') eq "excluindo") {
      $htmlUsuarios->imprimirTelaExcluindo();
   }
   if ($query->param('opcao') eq "album") {
      $htmlUsuarios->imprimirTelaAlbum();
   }
   if ($query->param('opcao') eq "ultimosAcessos") {
      $htmlUsuarios->imprimirTelaUltimosAcessos();
   }
   if ($query->param('opcao') eq "listarAlunos") {
      $htmlUsuarios->imprimirListaAlunos();
   }
   if ($impCabRod) {
      $htmlPrincipal->imprimirRodape();
   }
} else {
   print $query->redirect("index.cgi");
}

BEGIN {
   sub carp_error {
      my $error_message = shift;
      print "-->";
      $htmlUsuarios->imprimirMensagem($error_message,"",1);
      $htmlPrincipal->imprimirRodape();
   }
   CGI::Carp::set_message(\&carp_error);
}

