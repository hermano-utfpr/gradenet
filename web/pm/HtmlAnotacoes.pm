package HtmlAnotacoes;

use strict;
use CGI;
use ClasseAnotacao;
use DadosAnotacoes;
use FuncoesUteis;









#################################################################################
# HtmlAnotacoes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso às anotações
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
                  size=2>Anotações</FONT></B></DIV>
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

      $menuinf = qq |   [<a href="anotacoes.cgi?opcao=incluirAnotacao">Incluir Anotação</a>] - 
                        [<a href="anotacoes.cgi">Mostrar Anotações</a>] - 
                        [<a href="anotacoes.cgi?opcao=estenderAnotacoes">Estender Anotações</a>] |;

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaAnotacoes
#--------------------------------------------------------------------------------
# Método que imprime a tela com anotações
#################################################################################
sub imprimirTelaAnotacoes {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaAnotacao = new ClasseAnotacao;
my $dadosAnotacoes = new DadosAnotacoes;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 20;
my $totalItens = $dadosAnotacoes->quantidade($self->umUsuario->getCodigoUsuario());
my $numPaginas = int($totalItens/$itensPagina);
if ($totalItens % $itensPagina) {
   $numPaginas++;
}
if ($indicePagina == 0 || $indicePagina > $numPaginas) {
   $indicePagina = 1;
}
my $intervaloIni = $totalItens - (($indicePagina-1) * $itensPagina);
my $intervaloFin = $totalItens - (($indicePagina) * $itensPagina) + 1;
if ($intervaloFin <= 0) {
   $intervaloFin = 1;
}
if ($totalItens == 0) {
   $intervaloIni = 0;
   $intervaloFin = 0;
}

my @colecaoAnotacoes = $dadosAnotacoes->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->getCodigoUsuario());


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
                  size=2><b>Anotações</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> anotações. Mostrando de <b>$intervaloIni</b> 
                              a <b>$intervaloFin</b>:</font></div>
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

   my $itemAtual = $intervaloIni;
   my $titulo = "";
   my $iconeAnotacao = "icones/anotacao.jpg";
   if ($totalItens > 0) {
      foreach $umaAnotacao (@colecaoAnotacoes) {
         $titulo = $umaAnotacao->getTitulo();
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
                                    ${$umaAnotacao}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <img src="$iconeAnotacao" width=16 height=16 border=0></img>&nbsp;
                                <a href="anotacoes.cgi?opcao=visualizarAnotacao\&codigoAnotacao=${$umaAnotacao}{'codigoAnotacao'}">$titulo</a>
                                </font></td>
                              </tr>

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         $itemAtual--;
      }
   }

   my $navegacao = "";
   my $anterior = $indicePagina - 1;
   my $proximo =  $indicePagina + 1;

   if ($anterior > 0) {
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="anotacoes.cgi?opcao=mostrar\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="anotacoes.cgi?opcao=mostrar\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="anotacoes.cgi?opcao=mostrar\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
   }


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td>&nbsp; </td>
                        </tr>
                        <tr> 
                          <td> 
                            <div align="center"> 
                            <font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                            $navegacao
                            </font>
                            </div>
                          </td>
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
# Método que imprime a tela para visualizar uma anotação
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaAnotacao = new ClasseAnotacao;
my $dadosAnotacoes = new DadosAnotacoes;

$umaAnotacao = $dadosAnotacoes->selecionarAnotacao($self->query->param('codigoAnotacao'),$self->umUsuario->getCodigoUsuario());


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
                  size=2><b>Anotações</b></FONT></DIV>
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
                          ${$umaAnotacao}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado em ${$umaAnotacao}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaAnotacao}{'texto'}</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                      </table>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">&nbsp;</TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                       [<a href="anotacoes.cgi?opcao=alterarAnotacao\&codigoAnotacao=${$umaAnotacao}{'codigoAnotacao'}">Alterar</a>] - 
                       [<a href="anotacoes.cgi?opcao=excluirAnotacao\&codigoAnotacao=${$umaAnotacao}{'codigoAnotacao'}">Excluir</a>]  
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
# Método que imprime a tela para incluir uma anotação
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();


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
                  size=2><b>Anotações</b></FONT></DIV>
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
                            anotação: </font></b></td>
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
                            <p> 
                              <input type="text" name="titulo" size="60" maxlength="60">
                            </p>
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
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"> 
                            <input type="hidden" name="opcao" value="incluindoAnotacao">
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
# Método que inclui uma anotação e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

   my $umaAnotacao = new ClasseAnotacao;
   my $dadosAnotacoes = new DadosAnotacoes;

   $umaAnotacao->setDadosIU(0,$self->query->param('titulo'),
                              $self->query->param('texto'),
                              $self->umUsuario->getCodigoUsuario());

   $dadosAnotacoes->gravar($umaAnotacao);

   $self->imprimirMensagem("Anotação incluída com sucesso!","anotacoes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar uma anotação
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $dadosAnotacoes = new DadosAnotacoes;
my $umaAnotacao = $dadosAnotacoes->selecionarAnotacao($self->query->param('codigoAnotacao'),$self->umUsuario->getCodigoUsuario);


my $editaTexto = &getTextoHTML($umaAnotacao->getTexto());

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
                  size=2><b>Anotações</b></FONT></DIV>
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
                            anotação: </font></b></td>
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
                            <p> 
                              <input type="text" name="titulo" size="60" maxlength="60" value="${$umaAnotacao}{'titulo'}">
                            </p>
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
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                          <font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="006600">${$umaAnotacao}{'data'}
                          </font>
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                          <input type="checkbox" name="atualizarData" value="1">
                          <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Atualizar a data!
                          </font>
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"> 
                            <input type="hidden" name="opcao" value="alterandoAnotacao">
                            <input type="hidden" name="codigoAnotacao" value="${$umaAnotacao}{'codigoAnotacao'}">
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
# Método que altera uma anotação e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

   my $umaAnotacao = new ClasseAnotacao;
   my $dadosAnotacoes = new DadosAnotacoes;

   $umaAnotacao = $dadosAnotacoes->selecionarAnotacao($self->query->param('codigoAnotacao'),$self->umUsuario->getCodigoUsuario());

   if ($umaAnotacao->getCodigoUsuario() != $self->umUsuario->getCodigoUsuario()) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   if ($self->query->param('atualizarData')) {
      $umaAnotacao->setDadosIU($self->query->param('codigoAnotacao'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $self->umUsuario->getCodigoUsuario());
   } else {
      $umaAnotacao->setDados ($self->query->param('codigoAnotacao'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $umaAnotacao->getData(),
                           $self->umUsuario->getCodigoUsuario());
   }

   $dadosAnotacoes->gravar($umaAnotacao);

   $self->imprimirMensagem("Anotação alterada com sucesso!","anotacoes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar uma anotação para excluir
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaAnotacao = new ClasseAnotacao;
my $dadosAnotacoes = new DadosAnotacoes;

$umaAnotacao = $dadosAnotacoes->selecionarAnotacao($self->query->param('codigoAnotacao'),$self->umUsuario->getCodigoUsuario());


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
                  size=2><b>Anotações</b></FONT></DIV>
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
                          ${$umaAnotacao}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado em ${$umaAnotacao}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaAnotacao}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td>
                          <input type="hidden" name="codigoAnotacao" value="${$umaAnotacao}{'codigoAnotacao'}">
                          <input type="hidden" name="opcao" value="excluindoAnotacao">
                          <input type="submit" name="submit" value="Confirmar a Exclusão">
                          </td>
                          <td width="70">&nbsp;</td>
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
# Método que exclui uma anotacao e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

   my $umaAnotacao = new ClasseAnotacao;
   my $dadosAnotacoes = new DadosAnotacoes;

   $umaAnotacao = $dadosAnotacoes->selecionarAnotacao($self->query->param('codigoAnotacao'),$self->umUsuario->getCodigoUsuario());

   if ($umaAnotacao->getCodigoUsuario() != $self->umUsuario->getCodigoUsuario()) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   $dadosAnotacoes->excluir($self->query->param('codigoAnotacao'));

   $self->imprimirMensagem("Anotação excluída com sucesso!","anotacoes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaEstender
#--------------------------------------------------------------------------------
# Método que imprime a tela com anotações estendidas
#################################################################################
sub imprimirTelaEstender {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaAnotacao = new ClasseAnotacao;
my $dadosAnotacoes = new DadosAnotacoes;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 5;
my $totalItens = $dadosAnotacoes->quantidade($self->umUsuario->getCodigoUsuario());
my $numPaginas = int($totalItens/$itensPagina);
if ($totalItens % $itensPagina) {
   $numPaginas++;
}
if ($indicePagina == 0 || $indicePagina > $numPaginas) {
   $indicePagina = 1;
}
my $intervaloIni = $totalItens - (($indicePagina-1) * $itensPagina);
my $intervaloFin = $totalItens - (($indicePagina) * $itensPagina) + 1;
if ($intervaloFin <= 0) {
   $intervaloFin = 1;
}
if ($totalItens == 0) {
   $intervaloIni = 0;
   $intervaloFin = 0;
}

my @colecaoAnotacoes = $dadosAnotacoes->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->getCodigoUsuario());


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
                  size=2><b>Anotações</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> anotações. Mostrando de <b>$intervaloIni</b> 
                              a <b>$intervaloFin</b>:</font></div>
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

   my $itemAtual = $intervaloIni;
   my $titulo = "";
   if ($totalItens > 0) {
      foreach $umaAnotacao (@colecaoAnotacoes) {
         $titulo = $umaAnotacao->getTitulo();
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr> 
                          <td width="70"><center>
                          <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          $itemAtual</center></font></td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                         <a href="anotacoes.cgi?opcao=visualizarAnotacao\&codigoAnotacao=${$umaAnotacao}{'codigoAnotacao'}">$titulo</a>
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado em ${$umaAnotacao}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaAnotacao}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
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

   my $navegacao = "";
   my $anterior = $indicePagina - 1;
   my $proximo =  $indicePagina + 1;

   if ($anterior > 0) {
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="anotacoes.cgi?opcao=estenderAnotacoes\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="anotacoes.cgi?opcao=estenderAnotacoes\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="anotacoes.cgi?opcao=estenderAnotacoes\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
   }


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td>&nbsp; </td>
                        </tr>
                        <tr> 
                          <td> 
                            <div align="center"> 
                            <font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                            $navegacao
                            </font>
                            </div>
                          </td>
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
