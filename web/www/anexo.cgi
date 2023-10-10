#!/usr/bin/perl

use strict;
use ClasseCookie;
use CGI qw (-unique_headers);
use CGI::Carp qw (fatalsToBrowser);
use ClasseUsuario;
use DadosUsuarios;
use ClasseAtividade;
use DadosAtividades;
use ClasseAtividadeResposta;
use DadosAtividadesRespostas;

my $query = new CGI;
my $umCookie = new ClasseCookie;

$umCookie->query($query);

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;
my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;
my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;


if ($umCookie->existeSessao()) {

   $umaAtividade = $dadosAtividades->selecionarAtividade($query->param('codigoAtividade'));
   
   $umaResposta = $dadosRespostas->selecionarRespostaUsuario($umCookie->umUsuario->getCodigoUsuario(),$umaAtividade->getCodigoAtividade());

   if (!(($umaAtividade->getCodigoAtividade() == $umaResposta->getCodigoAtividade()) || ($umCookie->umUsuario->getPrivilegios() == 1) || ($umCookie->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) || $umaAtividade->expirouDataLimite())) {
      print $query->redirect("index.cgi");
   } else {

      if ($query->param('opcao') eq "mostrar") {     
         my $foto = $dadosRespostas->selecionarAnexo($query->param('codigoResposta'));   
         print "Content-type: image/jpeg\n\n";   
         print $foto;
      }

      if ($query->param('opcao') eq "baixar") {     
         $umaResposta = $dadosRespostas->selecionarResposta($query->param('codigoResposta'));
         my $arquivo = $dadosRespostas->selecionarAnexo($query->param('codigoResposta'));
         my $nomeArquivo = $umaResposta->getNomeAnexo();
         my $tamanho = length($arquivo);
         print "Content-disposition: inline; filename=\"$nomeArquivo\"\n";
         print "Content-Length: $tamanho\n";
         print "Content-Type: application/octet-stream\n\n";
         print $arquivo;
      }
 
   }
   
} else {
   print $query->redirect("index.cgi");
}


