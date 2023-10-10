package HtmlPerguntasRespostas;

use strict;
use CGI;
use ClassePergunta;
use DadosPerguntas;
use ClassePerguntaResposta;
use DadosPerguntasRespostas;
use FuncoesUteis;








#################################################################################
# HtmlPerguntasRespostas
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso às respostas de perguntas
#################################################################################










#################################################################################
# new
#--------------------------------------------------------------------------------
# Construtor
#################################################################################
sub new {
   my $proto = shift;
   my $class = ref($proto) || $proto;
   my $self = {
      umUsuario => new ClasseUsuario,
      umaPergunta => new ClassePergunta,
      query => new CGI,
   };
   bless ($self, $class);
   return ($self);
}
#################################################################################










#################################################################################
# umUsuario
#--------------------------------------------------------------------------------
# Usuário da sessão atual
#################################################################################
sub umUsuario {
   my $self = shift;
   if (@_) {
      $self->{umUsuario} = shift;
   }
   return $self->{umUsuario};
}
#################################################################################










#################################################################################
# umaPergunta
#--------------------------------------------------------------------------------
# Pergunta da seleção atual
#################################################################################
sub umaPergunta {
   my $self = shift;
   if (@_) {
      $self->{umaPergunta} = shift;
   }
   return $self->{umaPergunta};
}
#################################################################################










#################################################################################
# setPergunta
#--------------------------------------------------------------------------------
# Busca informações da base de dados e preenche automaticamente
#################################################################################
sub setPergunta {
   my $self = shift;
   my $codigoPergunta = $self->query->param('codigoPergunta')*1;
   my $dadosPerguntas = new DadosPerguntas;
   my $umaPergunta = $dadosPerguntas->selecionarPergunta($codigoPergunta);
   my $codigoResposta = $self->query->param('codigoResposta')*1;
   if ($codigoResposta) {
      my $umaResposta = new ClassePerguntaResposta;
      my $dadosRespostas = new DadosPerguntasRespostas;
      $umaResposta = $dadosRespostas->selecionarResposta($codigoResposta);
      if ($codigoPergunta != $umaResposta->getCodigoPergunta()) {
         die "Códigos de pergunta e resposta são incompatíveis!";
      }
   }
   $self->umaPergunta($umaPergunta);
}
#################################################################################










#################################################################################
# query
#--------------------------------------------------------------------------------
# query da sessão atual
#################################################################################
sub query {
   my $self = shift;
   if (@_) {
      $self->{query} = shift;
   }
   return $self->{query};
}
#################################################################################









#################################################################################
# imprimirMensagem
#--------------------------------------------------------------------------------
# Método que imprime uma Mensagem  
#################################################################################
sub imprimirMensagem {

my $self = shift;

my $mensagem = $_[0];
my $link = $_[1];
my $botaoVoltar = $_[2];
my $msgLink = "";

if (length($link)>0) {
   $msgLink = qq|<a href="$link">$mensagem</a>|;
} else {
   $msgLink = $mensagem;
}


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2><TBODY>
        <TR>
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <DIV align=center><B><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2>Respostas</FONT></B></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      &nbsp;
                    </TD>
                  </TR>
                  <TR> 
                    <TD><CENTER> 
                       <font face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff size=2>
                       $msgLink
                       </font>
                    </CENTER></TD>
                  </TR>
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($botaoVoltar) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                  <TR> 
                    <TD> 
                      &nbsp;
                    </TD>
                  </TR>
                  <TR> 
                    <TD><CENTER> 
                    <INPUT TYPE="button" VALUE="Voltar" onclick="window.history.go(-1)"></INPUT>
                    </CENTER></TD>
                  </TR>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

}

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                  <TR> 
                    <TD> 
                      &nbsp;
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2">&nbsp;</TD>
                  </TR>
                  </TBODY> 
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
  <TR>
    <TD>&nbsp;</TD></TR>
  <TR>
 
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################









#################################################################################
# linkMenuInferior
#--------------------------------------------------------------------------------
# Método que retorna os links do menu inferior
#################################################################################
sub linkMenuInferior {

   my $self = shift;
   my $menuinf = "";

   my $dadosRespostas = new DadosPerguntasRespostas;
   my $umaResposta = new ClassePerguntaResposta;

   my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();
   $umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$codigoPergunta);

   $menuinf .= qq |   [<a href="perguntas.cgi?opcao=incluirResposta\&codigoPergunta=$codigoPergunta">Incluir Resposta</a>] - |;

   $menuinf .= qq |   [<a href="perguntas.cgi?opcao=visualizar\&codigoPergunta=$codigoPergunta">Mostrar Respostas</a>] |;

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaRespostas
#--------------------------------------------------------------------------------
# Método que imprime a tela com respostas
#################################################################################
sub imprimirTelaRespostas {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

my $totalItens = $dadosRespostas->quantidadeRespostas($self->umaPergunta->getCodigoPergunta());

my @colecaoRespostas = $dadosRespostas->solicitarRespostas($self->umaPergunta->getCodigoPergunta());

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR> 
        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2>
            <TBODY> 
            <TR> 
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><b>Respostas</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td height="2"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                            Foram encontradas <b>$totalItens</b> respostas. Mostrando <b>todas</b>:</font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td> 
                            <table width="746" border="0" cellspacing="2" cellpadding="0">

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   my $itemAtual = $totalItens;
   my $titulo = "";
   my $nota = "-";
   if ($totalItens > 0) {
      foreach $umaResposta (@colecaoRespostas) {
         if ($umaResposta->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
            $titulo = qq |<b><a href="perguntas.cgi?opcao=visualizarResposta\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a></b>|;
         } else {
               $titulo = qq |<a href="perguntas.cgi?opcao=visualizarResposta\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a>|;
         }
  
         if ($self->umaPergunta->getValorNota() > 0) {
            if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
               if ($umaResposta->getNota() >= 0) {
                  $nota = $umaResposta->getNota();
               } else {
                  $nota = "Sem Nota!";
               }
            } else {
               $nota = "-";
            }
         }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                              <tr> 
                                <td width="25"> 
                                  <div align="right"></div>
                                </td>
                                <td width="30"> 
                                  <div align="center"><font face="Arial, Helvetica, sans-serif" size="1" color="#006600"><font color="#000000">$itemAtual</font></font></div>
                                </td>
                                <td width="150"> 
                                  <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                    ${$umaResposta}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF">$titulo
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>)</font></font></td>
                                <td width="30"> 
                                </td>
                              </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaPergunta->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                              <tr> 
                                <td width="25"> 
                                </td>
                                <td width="30"> 
                                </td>
                                <td width="150"> 
                                </td>
                                <td>
                                  <div align="left">
                                  <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                  Nota : <b>$nota</b></font></div>
                               </td>
                              </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
            }
         $itemAtual--;
      }
   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td>&nbsp; </td>
                        </tr>
                      </table>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      $menuinf</font></div>
                    </TD>
                  </TR>
                  </TBODY> 
                </TABLE>
              </TD>
            </TR>
            </TBODY> 
          </TABLE>
        </TD>
      </TR>
      <TR> 
        <TD>&nbsp;</TD>
      </TR>
  
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################









#################################################################################
# imprimirTelaVisualizar
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar a resposta da pergunta
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

$umaResposta = $dadosRespostas->selecionarResposta($self->query->param('codigoResposta'));

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();


my $nota = "-";
if ($self->umaPergunta->getValorNota() > 0) {
   if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
      if ($umaResposta->getNota() >= 0) {
          $nota = $umaResposta->getNota();
      } else {
          $nota = "Sem Nota!";
      }
    } else {
      $nota = "-";
    }
}



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR> 
        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2>
            <TBODY> 
            <TR> 
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><b>Respostas</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2">&nbsp;</TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          ${$umaResposta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaResposta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaPergunta->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          Nota: <b>$nota</b></font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaResposta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if (length($umaResposta->getNomeAnexo()) > 0 && $self->umaPergunta->getHabAnexo()) {
      my $tamAnexo = &TamanhoBytes(length($umaResposta->getAnexo()));
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <img src="icones/arquivo.jpg" width=16 height=16 border="0">&nbsp;
                           <a href="anexo.cgi?opcao=baixar\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'nomeAnexo'}</a> $tamAnexo</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                      </table>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">&nbsp;</TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($self->umUsuario->getPrivilegios() == 1 || ($umaResposta->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

          [<a href="perguntas.cgi?opcao=excluirResposta\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">Excluir</a>]
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      $menuinf
                      </font></div>
                    </TD>
                  </TR>
                  </TBODY> 
                </TABLE>
              </TD>
            </TR>
            </TBODY> 
          </TABLE>
        </TD>
      </TR>
      <TR> 
        <TD>&nbsp;</TD>
      </TR>
  
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################









#################################################################################
# imprimirTelaIncluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para incluir uma resposta
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();


my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoPergunta'));

#if ($umaResposta->getCodigoResposta() != 0) {
#   die "Usuário já incluiu uma resposta!\n";
#}

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

my $titulo = substr("Re: ".$self->umaPergunta->getTitulo(),0,56);

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR>
        <TD height="336">
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750
        border=2>
            <TBODY>
            <TR>
              <TD bgColor=#ffffff height="288">
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY>
                  <TR>
                    <TD>
                      <DIV align=center><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000
                  size=2><b>Respostas</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="248">
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="70">
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">Incluir
                            resposta: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">T&iacute;tulo:</font></b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9">
                             <font size="2" face="Verdana, Arial, Helvetica, sans-serif">$titulo</font></td>
                              <input type="hidden" name="titulo" size="60" maxlength="60" value="$titulo">
                          </td>
                          <td width="70" height="9">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Texto:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                            <textarea name="texto" cols="60" rows="10"></textarea>
                            <font size="1" face="Arial, Helvetica, sans-serif"><br><a href=# onClick=window.open("pseudohtml.htm","","width=400,height=350,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Pseudo-HTML</a> / <a href=# onClick=window.open("pseudo.cgi","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Arquivos</a></font>
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($self->umaPergunta->getHabAnexo()) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Anexar:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <img src="icones/arquivo.jpg" width=16 height=16 border="0">
                              <input type="file" name="anexo" size="30">
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">
                            <input type="hidden" name="opcao" value="incluindoResposta">
                            <input type="hidden" name="codigoPergunta" value="$codigoPergunta">
                            <input type="submit" name="Submit" value="Gravar">
                          </td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                      </table>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      $menuinf </font></div>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD>
            </TR>
            </TBODY>
          </TABLE>
        </TD>
      </TR>
      <TR>
        <TD>&nbsp;</TD>
      </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################










#################################################################################
# imprimirTelaIncluindo
#--------------------------------------------------------------------------------
# Método que inclui uma resposta na pergunta e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoPergunta'));

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

my $titulo = substr("Re: ".$self->umaPergunta->getTitulo(),0,56);

my $nomeAnexo = $self->query->param('anexo');

$nomeAnexo =~ s/ /_/ig;
$nomeAnexo =~ s/\:/_/ig;
$nomeAnexo =~ s/@/_/ig;

my @grvNome = split(/\\/,$nomeAnexo);

foreach my $parteNome (@grvNome) {
   $nomeAnexo = $parteNome;
}

   $umaResposta->setDadosIU(0,$codigoPergunta,
                              $titulo,
                              $self->query->param('texto'),
                              "",
                              $self->umUsuario->getCodigoUsuario());

   $dadosRespostas->gravar($umaResposta);

   if ($self->umaPergunta->getHabAnexo() && length($nomeAnexo) > 0) {
      $umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoPergunta'));

      my $arqUpload = $self->query->param('anexo');
      my $arqPronto;
      while (<$arqUpload>) {
         $arqPronto .= $_;
      }
      $umaResposta->setAnexo($arqPronto);
      $umaResposta->setNomeAnexo($nomeAnexo);
      $dadosRespostas->gravarAnexo($umaResposta);
   }

   $self->imprimirMensagem("Resposta incluída com sucesso!","perguntas.cgi?opcao=visualizar\&codigoPergunta=$codigoPergunta",0);

}

#################################################################################









#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar uma resposta
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();


my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoPergunta'));

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

my $titulo = substr("Re: ".$self->umaPergunta->getTitulo(),0,56);

my $editaTexto = &getTextoHTML($umaResposta->getTexto());

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR>
        <TD height="336">
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750
        border=2>
            <TBODY>
            <TR>
              <TD bgColor=#ffffff height="288">
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY>
                  <TR>
                    <TD>
                      <DIV align=center><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000
                  size=2><b>Respostas</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="248">
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="70">
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">Alterar
                            resposta: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">T&iacute;tulo:</font></b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9">
                             <font size="2" face="Verdana, Arial, Helvetica, sans-serif">$titulo</font></td>
                              <input type="hidden" name="titulo" size="60" maxlength="60" value="$titulo">
                          </td>
                          <td width="70" height="9">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Texto:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                            <textarea name="texto" cols="60" rows="10">$editaTexto</textarea>
                            <font size="1" face="Arial, Helvetica, sans-serif"><br><a href=# onClick=window.open("pseudohtml.htm","","width=400,height=350,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Pseudo-HTML</a> / <a href=# onClick=window.open("pseudo.cgi","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Arquivos</a></font>
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($self->umaPergunta->getHabAnexo()) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Anexar:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <img src="icones/arquivo.jpg" width=16 height=16 border="0">
                              <input type="file" name="anexo" size="30">
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">
                            <input type="hidden" name="opcao" value="alterandoResposta">
                            <input type="hidden" name="codigoPergunta" value="$codigoPergunta">
                            <input type="submit" name="Submit" value="Gravar">
                          </td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                      </table>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      $menuinf </font></div>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD>
            </TR>
            </TBODY>
          </TABLE>
        </TD>
      </TR>
      <TR>
        <TD>&nbsp;</TD>
      </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################










#################################################################################
# imprimirTelaAlterando
#--------------------------------------------------------------------------------
# Método que altera uma resposta na pergunta e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoPergunta'));


my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

my $titulo = substr("Re: ".$self->umaPergunta->getTitulo(),0,56);

my $nomeAnexo = $self->query->param('anexo');

$nomeAnexo =~ s/ /_/ig;
$nomeAnexo =~ s/\:/_/ig;
$nomeAnexo =~ s/@/_/ig;

my @grvNome = split(/\\/,$nomeAnexo);

foreach my $parteNome (@grvNome) {
   $nomeAnexo = $parteNome;
}

   $umaResposta->setDadosIU($umaResposta->getCodigoResposta(),$codigoPergunta,
                              $titulo,
                              $self->query->param('texto'),
                              "",
                              $self->umUsuario->getCodigoUsuario());

   $dadosRespostas->gravar($umaResposta);

   if ($self->umaPergunta->getHabAnexo() && length($nomeAnexo) > 0) {
      $umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoPergunta'));

      my $arqUpload = $self->query->param('anexo');
      my $arqPronto;
      while (<$arqUpload>) {
         $arqPronto .= $_;
      }
      $umaResposta->setAnexo($arqPronto);
      $umaResposta->setNomeAnexo($nomeAnexo);
      $dadosRespostas->gravarAnexo($umaResposta);
   }

   $self->imprimirMensagem("Resposta alterada com sucesso!","perguntas.cgi?opcao=visualizar\&codigoPergunta=$codigoPergunta",0);

}

#################################################################################









#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para excluir a resposta da pergunta
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

$umaResposta = $dadosRespostas->selecionarResposta($self->query->param('codigoResposta'));

if (!($self->umUsuario->getPrivilegios() == 1 || (($self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario())))) {
   die "Usuário não autorizado!\n";
}

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

my $nota = "-";
if ($self->umaPergunta->getValorNota() > 0) {
   if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
      if ($umaResposta->getNota() >= 0) {
          $nota = $umaResposta->getNota();
      } else {
          $nota = "Sem Nota!";
      }
    } else {
      $nota = "-";
    }
}


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR> 
        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2>
            <TBODY> 
            <TR> 
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><b>Respostas</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2">&nbsp;</TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          ${$umaResposta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaResposta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaPergunta->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          Nota: <b>$nota</b></font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |

                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaResposta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   
   if (length($umaResposta->getNomeAnexo()) > 0 && $self->umaPergunta->getHabAnexo()) {

      my $tamAnexo = &TamanhoBytes(length($umaResposta->getAnexo()));

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <img src="icones/arquivo.jpg" width=16 height=16 border="0">&nbsp;
                           <a href="anexo.cgi?opcao=baixar\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'nomeAnexo'}</a> $tamAnexo</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">
                          <input type="hidden" name="opcao" value="excluindoResposta">
                          <input type="hidden" name="codigoPergunta" value="$codigoPergunta">
                          <input type="hidden" name="codigoResposta" value="${$umaResposta}{'codigoResposta'}">
                          <input type="submit" name="Excluir" value="Confirmar Exclusão">
                          </td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                      </table>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      $menuinf
                      </font></div>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD>
            </TR>
            </TBODY>
          </TABLE>
        </TD>
      </TR>
      <TR>
        <TD>&nbsp;</TD>
      </TR>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################










#################################################################################
# imprimirTelaExcluindo
#--------------------------------------------------------------------------------
# Método que exclui uma resposta na pergunta e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;

$umaResposta = $dadosRespostas->selecionarResposta($self->query->param('codigoResposta'));

if (!($self->umUsuario->getPrivilegios() == 1 || (($self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) && $umaResposta->getCodigoPergunta() == $self->umaPergunta->getCodigoPergunta()))) {
   die "Usuário não autorizado!\n";
}

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

   $dadosRespostas->excluir($umaResposta->getCodigoResposta());

   $self->imprimirMensagem("Resposta excluída com sucesso!","perguntas.cgi?opcao=visualizar\&codigoPergunta=$codigoPergunta",0);

}

#################################################################################










#################################################################################
# imprimirTelaEstender
#--------------------------------------------------------------------------------
# Método que imprime a tela com respostas estendidas
#################################################################################
sub imprimirTelaEstender {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClassePerguntaResposta;
my $dadosRespostas = new DadosPerguntasRespostas;


my $totalItens = $dadosRespostas->quantidadeRespostas($self->umaPergunta->getCodigoPergunta());

my @colecaoRespostas = $dadosRespostas->solicitarRespostas($self->umaPergunta->getCodigoPergunta());

my $codigoPergunta = $self->umaPergunta->getCodigoPergunta();

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR> 
        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2>
            <TBODY> 
            <TR> 
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><b>Respostas</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td height="2"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                            Foram encontradas <b>$totalItens</b> respostas. Mostrando <b>todas</b>:</font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td> 
                            <table width="746" border="0" cellspacing="2" cellpadding="0">

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   my $itemAtual = $totalItens;
   my $titulo = "";
   my $nota = "-";
   if ($totalItens > 0) {
      foreach $umaResposta (@colecaoRespostas) {
         if ($umaResposta->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
            $titulo = qq |<b><a href="perguntas.cgi?opcao=visualizarResposta\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a></b>|;
         } else {
            $titulo = qq |<a href="perguntas.cgi?opcao=visualizarResposta\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a>|;
         }

         if ($self->umaPergunta->getValorNota() > 0) {
            if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
               if ($umaResposta->getNota() >= 0) {
                  $nota = $umaResposta->getNota();
               } else {
                  $nota = "Sem Nota!";
               }
            } else {
               $nota = "-";
            }
         }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |


                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaResposta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaPergunta->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          Nota: <b>$nota</b></font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaResposta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

           if ($self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario() || $self->umUsuario->getPrivilegios() == 1) {


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

     print qq | 
                       <tr> 
                          <td width="70">&nbsp;</td>
                          <td align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">[<a href="perguntas.cgi?opcao=excluirResposta\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">Excluir</a>]</td>
                          <td width="70">&nbsp;</td>
                        </tr>


   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

          }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   
         if (length($umaResposta->getNomeAnexo()) > 0 && $self->umaPergunta->getHabAnexo()) {
            my $tamAnexo = &TamanhoBytes(length($umaResposta->getAnexo()));

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <img src="icones/arquivo.jpg" width=16 height=16 border="0">&nbsp;
                           <a href="anexo.cgi?opcao=baixar\&codigoPergunta=$codigoPergunta\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'nomeAnexo'}</a> $tamAnexo</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         $itemAtual--;
      }
   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td>&nbsp; </td>
                        </tr>
                      </table>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      $menuinf</font></div>
                    </TD>
                  </TR>
                  </TBODY> 
                </TABLE>
              </TD>
            </TR>
            </TBODY> 
          </TABLE>
        </TD>
      </TR>
      <TR> 
        <TD>&nbsp;</TD>
      </TR>
  
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################













1;
