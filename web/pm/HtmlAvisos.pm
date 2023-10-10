package HtmlAvisos;

use strict;
use CGI;
use ClasseAviso;
use DadosAvisos;
use FuncoesUteis;









#################################################################################
# HtmlAviso
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso aos avisos
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
                  size=2>Avisos</FONT></B></DIV>
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

   if ($self->umUsuario->getPrivilegios() == 1) {
      $menuinf = qq |   [<a href="avisos.cgi?opcao=incluir">Incluir Aviso</a>] - 
                        [<a href="avisos.cgi">Mostrar Avisos</a>] - 
                        [<a href="avisos.cgi?opcao=estender">Estender Avisos</a>] |;
   } else {
      $menuinf = qq |   [<a href="avisos.cgi">Mostrar Avisos</a>] - 
                        [<a href="avisos.cgi?opcao=estender">Estender Avisos</a>] |;
   }

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaAvisos
#--------------------------------------------------------------------------------
# Método que imprime a tela com avisos
#################################################################################
sub imprimirTelaAvisos {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 20;
my $totalItens = $dadosAvisos->quantidade();
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

my @colecaoAvisos = $dadosAvisos->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso());


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
                  size=2><b>Avisos</b></FONT></DIV>
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
                            Foram encontrados <b>$totalItens</b> avisos. Mostrando de <b>$intervaloIni</b> 
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
   my $iconeAviso = "";
   if ($totalItens > 0) {
      foreach $umAviso (@colecaoAvisos) {
         if ($umAviso->getLido()) {     
            $titulo = $umAviso->getTitulo();
            $iconeAviso = "icones/avisos_pb.jpg";
         } else {
            $titulo = "<b>".$umAviso->getTitulo()."</b>";
            $iconeAviso = "icones/avisos.jpg";
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
                                    ${$umAviso}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <img src="$iconeAviso" width=16 height=16 border=0></img>&nbsp;
                                <a href="avisos.cgi?opcao=visualizar\&codigoAviso=${$umAviso}{'codigoAviso'}">$titulo</a>
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umAviso}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umAviso}{'umUsuario'}}{'nome'}</a>)</font></font></td>
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
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="avisos.cgi?opcao=mostrar\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="avisos.cgi?opcao=mostrar\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="avisos.cgi?opcao=mostrar\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
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
# Método que imprime a tela para visualizar o aviso
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

$umAviso = $dadosAvisos->selecionarAviso($self->query->param('codigoAviso'));


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
                  size=2><b>Avisos</b></FONT></DIV>
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
                          ${$umAviso}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umAviso}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umAviso}{'umUsuario'}}{'nome'}</a>
                            em ${$umAviso}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umAviso}{'texto'}</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      if ($umAviso->getDataCalendario() ne "00/00/0000") {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Vinculado ao calendário:
                          <font color="#006600">${$umAviso}{'dataCalendario'}</font></font></td>
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

   if ($self->umUsuario->getPrivilegios() == 1) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                       [<a href="avisos.cgi?opcao=alterar\&codigoAviso=${$umAviso}{'codigoAviso'}">Alterar</a>] - 
                       [<a href="avisos.cgi?opcao=excluir\&codigoAviso=${$umAviso}{'codigoAviso'}">Excluir</a>]  
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
# Método que imprime a tela para incluir um aviso
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

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
                  size=2><b>Avisos</b></FONT></DIV>
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
                            aviso: </font></b></td>
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
                          <td height="2"><b>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Vincular ao calendário:</font>
                            </b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9"> 
                            <p> 
                              <input type="radio" name="linkCalendario" value="1">
                              <input type="text" name="dataCalendario" size="10" maxlength="10">
                              &nbsp;
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">formato (dd/mm/aaaa)</font>
                            </p>
                          </td>
                          <td width="70" height="9">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <input type="radio" name="linkCalendario" value="0" checked>
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Não vincular!</font>
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
                            <input type="hidden" name="opcao" value="incluindo">
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
# Método que inclui um aviso e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umAviso = new ClasseAviso;
   my $dadosAvisos = new DadosAvisos;

   my $dataCalendario = "00/00/0000";
   if ($self->query->param('linkCalendario')) {
      $dataCalendario = $self->query->param('dataCalendario');
   }

   $umAviso->setDadosIU(0,$self->query->param('titulo'),
                          $self->query->param('texto'),
                          $dataCalendario,
                          $self->umUsuario->getCodigoUsuario());

   $dadosAvisos->gravar($umAviso);

   $self->imprimirMensagem("Aviso incluído com sucesso!","avisos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar um aviso
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $dadosAvisos = new DadosAvisos;
my $umAviso = $dadosAvisos->selecionarAviso($self->query->param('codigoAviso'));

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $linkCalendarioSim = "checked";
my $linkCalendarioNao = "";
   if ($umAviso->getDataCalendario() eq "00/00/0000") { 
      $linkCalendarioSim = "";
      $linkCalendarioNao = "checked";
   }

my $editaTexto = &getTextoHTML($umAviso->getTexto());


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
                  size=2><b>Avisos</b></FONT></DIV>
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
                            aviso: </font></b></td>
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
                              <input type="text" name="titulo" size="60" maxlength="60" value="${$umAviso}{'titulo'}">
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
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Vincular ao calendário:</font>
                            </b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9"> 
                            <p> 
                              <input type="radio" name="linkCalendario" value="1" $linkCalendarioSim>
                              <input type="text" name="dataCalendario" size="10" maxlength="10" value="${$umAviso}{'dataCalendario'}">
                              &nbsp;
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">formato (dd/mm/aaaa)</font>
                            </p>
                          </td>
                          <td width="70" height="9">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <input type="radio" name="linkCalendario" value="0" $linkCalendarioNao>
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Não vincular!</font>
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                          <font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="006600">${$umAviso}{'data'}
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
                            <input type="hidden" name="opcao" value="alterando">
                            <input type="hidden" name="codigoAviso" value="${$umAviso}{'codigoAviso'}">
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
# Método que altera um aviso e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umAviso = new ClasseAviso;
   my $dadosAvisos = new DadosAvisos;

   $umAviso = $dadosAvisos->selecionarAviso($self->query->param('codigoAviso'));

   my $dataCalendario = "00/00/0000";
   if ($self->query->param('linkCalendario')) {
      $dataCalendario = $self->query->param('dataCalendario');
   } 


   if ($self->query->param('atualizarData')) {
      $umAviso->setDadosIU($self->query->param('codigoAviso'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $dataCalendario,
                           $self->umUsuario->getCodigoUsuario());
   } else {
      $umAviso->setDados ($self->query->param('codigoAviso'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $umAviso->getData(),
                           $dataCalendario,
                           $self->umUsuario->getCodigoUsuario());
   }

   $dadosAvisos->gravar($umAviso);

   $self->imprimirMensagem("Aviso alterado com sucesso!","avisos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar o aviso para excluir
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

$umAviso = $dadosAvisos->selecionarAviso($self->query->param('codigoAviso'));


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
                  size=2><b>Avisos</b></FONT></DIV>
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
                          ${$umAviso}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umAviso}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umAviso}{'umUsuario'}}{'nome'}</a>
                            em ${$umAviso}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umAviso}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      if ($umAviso->getDataCalendario() ne "00/00/0000") {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Vinculado ao calendário:
                          <font color="#006600">${$umAviso}{'dataCalendario'}</font></font></td>
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
                          <td width="70">&nbsp;</td>
                          <td>
                          <input type="hidden" name="codigoAviso" value="${$umAviso}{'codigoAviso'}">
                          <input type="hidden" name="opcao" value="excluindo">
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
# Método que exclui um aviso e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $dadosAvisos = new DadosAvisos;

   $dadosAvisos->excluir($self->query->param('codigoAviso'));

   $self->imprimirMensagem("Aviso excluído com sucesso!","avisos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaEstender
#--------------------------------------------------------------------------------
# Método que imprime a tela com avisos estendidos
#################################################################################
sub imprimirTelaEstender {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 5;
my $totalItens = $dadosAvisos->quantidade();
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

my @colecaoAvisos = $dadosAvisos->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso());


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
                  size=2><b>Avisos</b></FONT></DIV>
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
                            Foram encontrados <b>$totalItens</b> avisos. Mostrando de <b>$intervaloIni</b> 
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
      foreach $umAviso (@colecaoAvisos) {
         if ($umAviso->getLido()) {     
            $titulo = $umAviso->getTitulo();
         } else {
            $titulo = "<b>".$umAviso->getTitulo()."</b>";
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr> 
                          <td width="70"><center>
                          <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          $itemAtual</center></font></td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <a href="avisos.cgi?opcao=visualizar\&codigoAviso=${$umAviso}{'codigoAviso'}">$titulo</a></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umAviso}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umAviso}{'umUsuario'}}{'nome'}</a>
                            em ${$umAviso}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umAviso}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
            if ($umAviso->getDataCalendario() ne "00/00/0000") {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Vinculado ao calendário:
                          <font color="#006600">${$umAviso}{'dataCalendario'}</font></font></td>
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

   my $navegacao = "";
   my $anterior = $indicePagina - 1;
   my $proximo =  $indicePagina + 1;

   if ($anterior > 0) {
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="avisos.cgi?opcao=estender\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="avisos.cgi?opcao=estender\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="avisos.cgi?opcao=estender\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
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
# imprimirTelaUltimosAvisos
#--------------------------------------------------------------------------------
# Método que imprime a tela com os últimos avisos
#################################################################################
sub imprimirTelaUltimosAvisos {

my $self = shift;

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

my $indicePagina = 1;
my $itensPagina = 5;
my $totalItens = $dadosAvisos->quantidade();
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

my @colecaoAvisos = $dadosAvisos->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso());


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
                  size=2><b>Últimos Avisos</b></FONT></DIV>
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
                          <td>&nbsp; </td>
                        </tr>
                        <tr>
                          <td> 
                            <table width="746" border="0" cellspacing="2" cellpadding="0">

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   my $itemAtual = $intervaloIni;
   my $titulo = "";
   if ($totalItens > 0) {
      foreach $umAviso (@colecaoAvisos) {
            $titulo = $umAviso->getTitulo();
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                              <tr> 
                                <td width="25"> 
                                  <div align="right"></div>
                                </td>
                                <td width="30"> 
                                  <div align="center"><font face="Arial, Helvetica, sans-serif" size="1" color="#006600"><b><font color="#000000"></font></b></font></div>
                                </td>
                                <td width="150"> 
                                  <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                    ${$umAviso}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="0000FF">
                                  <img src="icones/avisos.jpg" width=16 height=16 border=0></img>&nbsp;
                                  $titulo
                                <font size="1" face="Arial, Helvetica, sans-serif" color="000000"> (${${$umAviso}{'umUsuario'}}{'nome'})</font></font></td>
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
                    <TD> 
                      &nbsp;
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
