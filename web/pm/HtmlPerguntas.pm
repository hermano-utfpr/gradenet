package HtmlPerguntas;

use strict;
use CGI;
use ClassePergunta;
use DadosPerguntas;
use FuncoesUteis;
use FuncoesCronologicas;









#################################################################################
# HtmlPergunta
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso às perguntas
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
                  size=2>Perguntas</FONT></B></DIV>
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

   $menuinf = qq |   [<a href="perguntas.cgi?opcao=incluir">Incluir Pergunta</a>] - 
                        [<a href="perguntas.cgi">Mostrar Perguntas</a>] - 
                        [<a href="perguntas.cgi?opcao=estender">Estender Perguntas</a>] |;
 
   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaPerguntas
#--------------------------------------------------------------------------------
# Método que imprime a tela com perguntas
#################################################################################
sub imprimirTelaPerguntas {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPergunta = new ClassePergunta;
my $dadosPerguntas = new DadosPerguntas;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 20;
my $totalItens = $dadosPerguntas->quantidade();
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

my @colecaoPerguntas;

if ($self->umUsuario->getPrivilegios() == 1) {
   @colecaoPerguntas = $dadosPerguntas->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso());
} else {
   @colecaoPerguntas = $dadosPerguntas->solicitarParcialAluno($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso(),$self->umUsuario->getCodigoUsuario()); 
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
                  size=2><b>Perguntas</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> perguntas. Mostrando de <b>$intervaloIni</b> 
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
   my $valorNota = "";
   my $corDataLimite = "";
   my $respondida = "";
   my $suaNota = "-";
   my $corrigida = "";
   if ($totalItens > 0) {
      foreach $umaPergunta (@colecaoPerguntas) {
         if ($umaPergunta->getLido()) {     
            $titulo = $umaPergunta->getTitulo();
         } else {
            $titulo = "<b>".$umaPergunta->getTitulo()."</b>";
         }
         if ($umaPergunta->getValorNota() > 0) {
            $valorNota = "Valendo ".$umaPergunta->getValorNota()." pontos.";
         } else {
            $valorNota = "";
         }
         if ($umaPergunta->expirouDataLimite()) {
            $corDataLimite = "999999";
         } else {
            $corDataLimite = "FF0000";
         }

         $respondida = "";

         $suaNota = "";
         if ($self->umUsuario->getPrivilegios() != 1 & $umaPergunta->getValorNota() > 0) {
            if ($umaPergunta->info->getNota() >= 0) {
               $suaNota = "Nota: <b>".$umaPergunta->info->getNota()."</b>";
            } else {
               if (!$umaPergunta->expirouDataLimite() & $umaPergunta->info->getRespondida()) {
                  $suaNota = "Nota: <b>Sem Nota!</b>";
               }
               if ($umaPergunta->expirouDataLimite() & !$umaPergunta->info->getRespondida()) {
                     $suaNota = "Nota: <b>0.00</b>";
               }
            }
         }
         $corrigida = "";
         if ($umaPergunta->info->getCorrigida() && ($umaPergunta->expirouDataLimite() || $self->umUsuario->getPrivilegios() == 1) ) {
            $corrigida = qq |<img src="icones/corrigido.jpg" width=16 height=16 border="0"></img>|;
         }
         my $dataDivulgacao = "";
         my $tituloAutorizado = qq | <a href="perguntas.cgi?opcao=visualizar\&codigoPergunta=${$umaPergunta}{'codigoPergunta'}">$titulo</a>|;
         if (!$umaPergunta->expirouDataDivulgacao() && !$self->umUsuario->getPrivilegios()) {
            $tituloAutorizado = $titulo;
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
                                    ${$umaPergunta}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="0000FF">
                                <img src="/icones/pergunta.jpg" width=16 height=16 border=0></img>$tituloAutorizado 
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaPergunta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaPergunta}{'umUsuario'}}{'nome'}</a>)</font></font>
                                $corrigida</td>
                              </tr>

                              <tr>
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="30">
                                </td>
                                <td width="150">
                                  <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#FF0000"></font></div>
                                </td>
                                <td>
                                   &nbsp;&nbsp;&nbsp;
                                   <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#FF0000">
                                    <b>${${$umaPergunta}{'info'}}{'qtdeRespostas'}</b> respostas
                                   </font>
                                   &nbsp;
                                   <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">

                                   </font>

                                </td>
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
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="perguntas.cgi?opcao=mostrar\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="perguntas.cgi?opcao=mostrar\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="perguntas.cgi?opcao=mostrar\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
   }


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                            </table>
                          </td>
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
# Método que imprime a tela para visualizar a pergunta
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPergunta = new ClassePergunta;
my $dadosPerguntas = new DadosPerguntas;

$umaPergunta = $dadosPerguntas->selecionarPergunta($self->query->param('codigoPergunta'));

if (!$umaPergunta->expirouDataDivulgacao()) {
   die "Usuário não autorizado!\n";
}

my $anexo = "";
if ($umaPergunta->getHabAnexo()) {
   $anexo = "Permitido anexar arquivo.";
} else {
   $anexo = "<b>Não</b> é permitido anexar arquivo.";
}
my $valorNota = "";
if ($umaPergunta->getValorNota() > 0) {
    $valorNota = "Valendo <b>".$umaPergunta->getValorNota()."</b> pontos.";
} else {
    $valorNota = "";
}
my $corDataLimite="FF0000";
if ($umaPergunta->expirouDataLimite()) {
    $corDataLimite = "999999";
}

my $bloqueadaAte = "";
if (!$umaPergunta->expirouDataDivulgacao()) {
   $bloqueadaAte = qq |<br><font color="FF0000">Bloqueada até <b>${$umaPergunta}{'dataDivulgacao'}</b>.</font> |;
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
                  size=2><b>Perguntas</b></FONT></DIV>
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
                          ${$umaPergunta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaPergunta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaPergunta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaPergunta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
        
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaPergunta}{'texto'}</td>
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
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML




#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                       [<a href="perguntas.cgi?opcao=excluir\&codigoPergunta=${$umaPergunta}{'codigoPergunta'}">Excluir</a>]  
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   
   
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
# Método que imprime a tela para incluir uma pergunta
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

   my $dataAgora = "$dia/$mes/$ano $hor:$min";

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
                  size=2><b>Perguntas</b></FONT></DIV>
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
                            pergunta: </font></b></td>
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
                          <td height="8">&nbsp;</td>
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
# Método que inclui uma pergunta e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

   my $umaPergunta = new ClassePergunta;
   my $dadosPerguntas = new DadosPerguntas;

   $umaPergunta->setDadosIU(0,$self->query->param('titulo'),
                          $self->query->param('texto'),
                          "00/00/0000 00:00",
                          0,
                          0.00,
                          $self->umUsuario->getCodigoUsuario(),
                          "00/00/0000 00:00");

   $dadosPerguntas->gravar($umaPergunta);

   $self->imprimirMensagem("Pergunta incluída com sucesso!","perguntas.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar uma pergunta
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $dadosPerguntas = new DadosPerguntas;
my $umaPergunta = $dadosPerguntas->selecionarPergunta($self->query->param('codigoPergunta'));


      print "<!--";
      die "Usuário não autorizado!\n";


   my $habAnexo = "";
   if ($umaPergunta->getHabAnexo()) {
      $habAnexo = "checked";
   }

   my $editaTexto = &getTextoHTML($umaPergunta->getTexto());

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
                  size=2><b>Perguntas</b></FONT></DIV>
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
                            pergunta: </font></b></td>
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
                              <input type="text" name="titulo" size="60" maxlength="60" value="${$umaPergunta}{'titulo'}">
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Data de Divulgação:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <input type="text" name="dataDivulgacao" size="16" maxlength="16" value="${$umaPergunta}{'dataDivulgacao'}">
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">formato (dd/mm/aaaa hh:mm)</font>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Data Limite:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <input type="text" name="dataLimite" size="16" maxlength="16" value="${$umaPergunta}{'dataLimite'}">
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">formato (dd/mm/aaaa hh:mm)</font>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Valor (nota):</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <input type="text" name="valorNota" size="16" maxlength="5" value="${$umaPergunta}{'valorNota'}">
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">formato (99.99)</font>
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
                              <input type="checkbox" name="habAnexo" value="1" $habAnexo>
                              <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Habilitar respostas com anexo!</font>
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
                          <font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="006600">${$umaPergunta}{'data'}
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
                            <input type="hidden" name="codigoPergunta" value="${$umaPergunta}{'codigoPergunta'}">
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
# Método que altera uma pergunta e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

   my $umaPergunta = new ClassePergunta;
   my $dadosPerguntas = new DadosPerguntas;

   $umaPergunta = $dadosPerguntas->selecionarPergunta($self->query->param('codigoPergunta'));


      print "<!--";
      die "Usuário não autorizado!\n";
   
   if ($self->query->param('atualizarData')) {
      $umaPergunta->setDadosIU($self->query->param('codigoPergunta'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $self->query->param('dataLimite'),
                           $self->query->param('habAnexo')*1,
                           $self->query->param('valorNota'),
                           $self->umUsuario->getCodigoUsuario(),
                           $self->query->param('dataDivulgacao'));
   } else {
      $umaPergunta->setDados ($self->query->param('codigoPergunta'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $umaPergunta->getData(),
                           $self->query->param('dataLimite'),
                           $self->query->param('habAnexo')*1,
                           $self->query->param('valorNota'),
                           $self->umUsuario->getCodigoUsuario(),
                           $self->query->param('dataDivulgacao'));
   }

   $dadosPerguntas->gravar($umaPergunta);

   $self->imprimirMensagem("Pergunta alterada com sucesso!","perguntas.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar uma pergunta para excluir
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPergunta = new ClassePergunta;
my $dadosPerguntas = new DadosPerguntas;

$umaPergunta = $dadosPerguntas->selecionarPergunta($self->query->param('codigoPergunta'));

   if (!($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaPergunta->getCodigoUsuario())) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $anexo = "";
if ($umaPergunta->getHabAnexo()) {
   $anexo = "Permitido anexar arquivo.";
} else {
   $anexo = "<b>Não</b> é permitido anexar arquivo.";
}
my $valorNota = "";
if ($umaPergunta->getValorNota() > 0) {
   $valorNota = "Valendo <b>".$umaPergunta->getValorNota()."</b> pontos.";
} else {
   $valorNota = "";
}
my $corDataLimite="FF0000";
if ($umaPergunta->expirouDataLimite()) {
    $corDataLimite = "999999";
}

my $bloqueadaAte = "";
if (!$umaPergunta->expirouDataDivulgacao()) {
   $bloqueadaAte = qq |<br><font color="FF0000">Bloqueada até <b>${$umaPergunta}{'dataDivulgacao'}</b>.</font> |;
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
                  size=2><b>Perguntas</b></FONT></DIV>
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
                          ${$umaPergunta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaPergunta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaPergunta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaPergunta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
  
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaPergunta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td>
                          <input type="hidden" name="codigoPergunta" value="${$umaPergunta}{'codigoPergunta'}">
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
# Método que exclui uma pergunta e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

   my $umaPergunta = new ClassePergunta;
   my $dadosPerguntas = new DadosPerguntas;

   $umaPergunta = $dadosPerguntas->selecionarPergunta($self->query->param('codigoPergunta'));

   if (!($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaPergunta->getCodigoUsuario())) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   $dadosPerguntas->excluir($self->query->param('codigoPergunta'));

   $self->imprimirMensagem("Pergunta excluída com sucesso!","perguntas.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaEstender
#--------------------------------------------------------------------------------
# Método que imprime a tela com perguntas estendidas
#################################################################################
sub imprimirTelaEstender {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPergunta = new ClassePergunta;
my $dadosPerguntas = new DadosPerguntas;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 5;
my $totalItens = $dadosPerguntas->quantidade();
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

my @colecaoPerguntas = $dadosPerguntas->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso());


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
                  size=2><b>Perguntas</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> perguntas. Mostrando de <b>$intervaloIni</b>
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
   my $corDataLimite = "";
   if ($totalItens > 0) {
      foreach $umaPergunta (@colecaoPerguntas) {
         if ($umaPergunta->getLido()) {
            $titulo = $umaPergunta->getTitulo();
         } else {
            $titulo = "<b>".$umaPergunta->getTitulo()."</b>";
         }
         my $anexo = "";
         if ($umaPergunta->getHabAnexo()) {
            $anexo = "Permitido anexar arquivo.";
         } else {
            $anexo = "<b>Não</b> é permitido anexar arquivo.";
         }
         my $valorNota = "";
         if ($umaPergunta->getValorNota() > 0) {
            $valorNota = "Valendo <b>".$umaPergunta->getValorNota()."</b> pontos.";
         } else {
            $valorNota = "";
         }
         if ($umaPergunta->expirouDataLimite()) {
            $corDataLimite = "999999";
         } else {
            $corDataLimite = "FF0000";
         }

         my $bloqueadaAte = "";
         if (!$umaPergunta->expirouDataDivulgacao()) {
            $bloqueadaAte = qq |<br><font color="FF0000">Bloqueada até <b>${$umaPergunta}{'dataDivulgacao'}</b>.</font> |;
         }

         if (!(!$umaPergunta->expirouDataDivulgacao() && !$self->umUsuario->getPrivilegios())) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td width="70"><center>
                          <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          $itemAtual</center></font></td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <a href="perguntas.cgi?opcao=visualizar\&codigoPergunta=${$umaPergunta}{'codigoPergunta'}">$titulo</a></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaPergunta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaPergunta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaPergunta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
 
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaPergunta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         }
         $itemAtual--;
      }
   }

   my $navegacao = "";
   my $anterior = $indicePagina - 1;
   my $proximo =  $indicePagina + 1;

   if ($anterior > 0) {
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="perguntas.cgi?opcao=estender\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="perguntas.cgi?opcao=estender\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="perguntas.cgi?opcao=estender\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
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
