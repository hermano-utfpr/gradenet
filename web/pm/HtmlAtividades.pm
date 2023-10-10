package HtmlAtividades;

use strict;
use CGI;
use ClasseAtividade;
use DadosAtividades;
use FuncoesUteis;
use FuncoesCronologicas;









#################################################################################
# HtmlAtividade
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso às atividades
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
                  size=2>Atividades</FONT></B></DIV>
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
      $menuinf = qq |   [<a href="atividades.cgi?opcao=incluir">Incluir Atividade</a>] - 
                        [<a href="atividades.cgi">Mostrar Atividades</a>] - 
                        [<a href="atividades.cgi?opcao=estender">Estender Atividades</a>] |;
   } else {
      $menuinf = qq |   [<a href="atividades.cgi">Mostrar Atividades</a>] - 
                        [<a href="atividades.cgi?opcao=estender">Estender Atividades</a>] |;
   }

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaAtividades
#--------------------------------------------------------------------------------
# Método que imprime a tela com atividades
#################################################################################
sub imprimirTelaAtividades {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 20;
my $totalItens = $dadosAtividades->quantidade();
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

my @colecaoAtividades;

if ($self->umUsuario->getPrivilegios() == 1) {
   @colecaoAtividades = $dadosAtividades->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso());
} else {
   @colecaoAtividades = $dadosAtividades->solicitarParcialAluno($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso(),$self->umUsuario->getCodigoUsuario()); 
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
                  size=2><b>Atividades</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> atividades. Mostrando de <b>$intervaloIni</b> 
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
      foreach $umaAtividade (@colecaoAtividades) {
         if ($umaAtividade->getLido()) {     
            $titulo = $umaAtividade->getTitulo();
         } else {
            $titulo = "<b>".$umaAtividade->getTitulo()."</b>";
         }
         if ($umaAtividade->getValorNota() > 0) {
            $valorNota = "<font color=000000>Valendo <b>".$umaAtividade->getValorNota()."</b> pontos.</font>";
         } else {
            $valorNota = "";
         }
         if ($umaAtividade->expirouDataLimite()) {
            $corDataLimite = "999999";
         } else {
            $corDataLimite = "FF0000";
         }

         $respondida = "";
         if ($self->umUsuario->getPrivilegios() != 1) {
            if ($umaAtividade->info->getRespondida()) {
               $respondida = qq | <img src="icones/positivo.jpg" width=16 height=16 border="0"></img>|;
            } else {
               if ($umaAtividade->expirouDataLimite()) {
                  $respondida = qq | <img src="icones/atencao_pb.jpg" width=16 height=16 border="0"></img>|;
               } else {
                  $respondida = qq | <img src="icones/atencao.jpg" width=16 height=16 border="0"></img>|;
               }
            }
         } else {
            if ($umaAtividade->expirouDataLimite()) {
               $respondida = qq | <img src="icones/atencao_pb.jpg" width=16 height=16 border="0"></img>|;
            } else {
               $respondida = qq | <img src="icones/atencao.jpg" width=16 height=16 border="0"></img>|;
            }
         }
         $suaNota = "";
         if ($self->umUsuario->getPrivilegios() != 1 & $umaAtividade->getValorNota() > 0) {
            if ($umaAtividade->info->getNota() >= 0) {
               $suaNota = "Nota: <b>".$umaAtividade->info->getNota()."</b>";
            } else {
               if (!$umaAtividade->expirouDataLimite() & $umaAtividade->info->getRespondida()) {
                  $suaNota = "Nota: <b>Sem Nota!</b>";
               }
               if ($umaAtividade->expirouDataLimite() & !$umaAtividade->info->getRespondida()) {
                     $suaNota = "Nota: <b>0.00</b>";
               }
            }
         }
         $corrigida = "";
         if ($umaAtividade->info->getCorrigida() && ($umaAtividade->expirouDataLimite() || $self->umUsuario->getPrivilegios() == 1) ) {
            $corrigida = qq |<img src="icones/corrigido.jpg" width=16 height=16 border="0"></img>|;
         }
         my $dataDivulgacao = "";
         my $tituloAutorizado = qq | <a href="atividades.cgi?opcao=visualizar\&codigoAtividade=${$umaAtividade}{'codigoAtividade'}">$titulo</a>|;
         if (!$umaAtividade->expirouDataDivulgacao() && !$self->umUsuario->getPrivilegios()) {
            $tituloAutorizado = $titulo;
         }
         my $responderAte = qq |Responder até ${$umaAtividade}{'dataLimite'}. $valorNota |;
         if (!$umaAtividade->expirouDataDivulgacao()) {
            $corDataLimite = "FF0000";
            $respondida = qq | <img src="icones/bloqueado.jpg" width=16 height=16 border="0"></img>|;
            $responderAte = qq |Bloqueada até ${$umaAtividade}{'dataDivulgacao'}. |;
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
                                    ${$umaAtividade}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="0000FF">
                                $tituloAutorizado [${${$umaAtividade}{'info'}}{'qtdeRespostas'}]
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaAtividade}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaAtividade}{'umUsuario'}}{'nome'}</a>)</font></font>
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
                                   $respondida&nbsp;
                                   <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#$corDataLimite">
                                      $responderAte
                                   </font>
                                   &nbsp;
                                   <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                                      $suaNota
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
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="atividades.cgi?opcao=mostrar\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="atividades.cgi?opcao=mostrar\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="atividades.cgi?opcao=mostrar\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
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
                                   <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                                    <img src="icones/atencao.jpg" width=16 height=16 border="0"></img>&nbsp;- Responder!
                                    &nbsp
                                    <img src="icones/atencao_pb.jpg" width=16 height=16 border="0"></img>&nbsp;- Expirou!
                                    &nbsp
                                    <img src="icones/bloqueado.jpg" width=16 height=16 border="0"></img>&nbsp;- Bloqueada!
                                    &nbsp
                                    <img src="icones/positivo.jpg" width=16 height=16 border="0"></img>&nbsp;- Respondida!
                                    &nbsp
                                    <img src="icones/corrigido.jpg" width=16 height=16 border="0"></img>&nbsp;- Corrigida!
                                   </font>
                                   </div>
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
# Método que imprime a tela para visualizar a atividade
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

$umaAtividade = $dadosAtividades->selecionarAtividade($self->query->param('codigoAtividade'));

if (!$umaAtividade->expirouDataDivulgacao() && !$self->umUsuario->getPrivilegios()) {
   die "Usuário não autorizado!\n";
}

my $anexo = "";
if ($umaAtividade->getHabAnexo()) {
   $anexo = "Permitido anexar arquivo.";
} else {
   $anexo = "<b>Não</b> é permitido anexar arquivo.";
}
my $valorNota = "";
if ($umaAtividade->getValorNota() > 0) {
    $valorNota = "<font color=000000>Valendo <b>".$umaAtividade->getValorNota()."</b> pontos.</font>";
} else {
    $valorNota = "";
}
my $corDataLimite="FF0000";
if ($umaAtividade->expirouDataLimite()) {
    $corDataLimite = "999999";
}

my $bloqueadaAte = "";
if (!$umaAtividade->expirouDataDivulgacao()) {
   $bloqueadaAte = qq |<br><font color="FF0000">Bloqueada até <b>${$umaAtividade}{'dataDivulgacao'}</b>.</font> |;
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
                  size=2><b>Atividades</b></FONT></DIV>
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
                          ${$umaAtividade}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaAtividade}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaAtividade}{'umUsuario'}}{'nome'}</a>
                            em ${$umaAtividade}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#$corDataLimite">
                          Responder até <b>${$umaAtividade}{'dataLimite'}</b>. $valorNota $bloqueadaAte
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="1" face="Arial, Helvetica, sans-serif" color="#000000">
                          $anexo
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaAtividade}{'texto'}</td>
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

   if ($self->umUsuario->getPrivilegios() == 1) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                       [<a href="atividades.cgi?opcao=alterar\&codigoAtividade=${$umaAtividade}{'codigoAtividade'}">Alterar</a>] 
- 
                       [<a href="atividades.cgi?opcao=excluir\&codigoAtividade=${$umaAtividade}{'codigoAtividade'}">Excluir</a>]  
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
# Método que imprime a tela para incluir uma atividade
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

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
                  size=2><b>Atividades</b></FONT></DIV>
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
                            atividade: </font></b></td>
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
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Data de Divulgação:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <input type="text" name="dataDivulgacao" size="16" maxlength="16" value="$dataAgora">
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
                              <input type="text" name="dataLimite" size="16" maxlength="16" value="$dataAgora">
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
                              <input type="text" name="valorNota" size="16" maxlength="5">
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
                              <input type="checkbox" name="habAnexo" value="1">
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
# Método que inclui uma atividade e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umaAtividade = new ClasseAtividade;
   my $dadosAtividades = new DadosAtividades;

   $umaAtividade->setDadosIU(0,$self->query->param('titulo'),
                          $self->query->param('texto'),
                          $self->query->param('dataLimite'),
                          $self->query->param('habAnexo')*1,
                          $self->query->param('valorNota'),
                          $self->umUsuario->getCodigoUsuario(),
                          $self->query->param('dataDivulgacao'));

   $dadosAtividades->gravar($umaAtividade);

   $self->imprimirMensagem("Atividade incluída com sucesso!","atividades.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar uma atividade
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $dadosAtividades = new DadosAtividades;
my $umaAtividade = $dadosAtividades->selecionarAtividade($self->query->param('codigoAtividade'));

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $habAnexo = "";
   if ($umaAtividade->getHabAnexo()) {
      $habAnexo = "checked";
   }

   my $editaTexto = &getTextoHTML($umaAtividade->getTexto());

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
                  size=2><b>Atividades</b></FONT></DIV>
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
                            atividade: </font></b></td>
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
                              <input type="text" name="titulo" size="60" maxlength="60" value="${$umaAtividade}{'titulo'}">
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
                              <input type="text" name="dataDivulgacao" size="16" maxlength="16" value="${$umaAtividade}{'dataDivulgacao'}">
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
                              <input type="text" name="dataLimite" size="16" maxlength="16" value="${$umaAtividade}{'dataLimite'}">
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
                              <input type="text" name="valorNota" size="16" maxlength="5" value="${$umaAtividade}{'valorNota'}">
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
                          <font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="006600">${$umaAtividade}{'data'}
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
                            <input type="hidden" name="codigoAtividade" value="${$umaAtividade}{'codigoAtividade'}">
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
# Método que altera uma atividade e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umaAtividade = new ClasseAtividade;
   my $dadosAtividades = new DadosAtividades;

   $umaAtividade = $dadosAtividades->selecionarAtividade($self->query->param('codigoAtividade'));

   if ($self->query->param('atualizarData')) {
      $umaAtividade->setDadosIU($self->query->param('codigoAtividade'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $self->query->param('dataLimite'),
                           $self->query->param('habAnexo')*1,
                           $self->query->param('valorNota'),
                           $self->umUsuario->getCodigoUsuario(),
                           $self->query->param('dataDivulgacao'));
   } else {
      $umaAtividade->setDados ($self->query->param('codigoAtividade'),
                           $self->query->param('titulo'),
                           $self->query->param('texto'),
                           $umaAtividade->getData(),
                           $self->query->param('dataLimite'),
                           $self->query->param('habAnexo')*1,
                           $self->query->param('valorNota'),
                           $self->umUsuario->getCodigoUsuario(),
                           $self->query->param('dataDivulgacao'));
   }

   $dadosAtividades->gravar($umaAtividade);

   $self->imprimirMensagem("Atividade alterada com sucesso!","atividades.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar uma atividade para excluir
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

$umaAtividade = $dadosAtividades->selecionarAtividade($self->query->param('codigoAtividade'));

my $anexo = "";
if ($umaAtividade->getHabAnexo()) {
   $anexo = "Permitido anexar arquivo.";
} else {
   $anexo = "<b>Não</b> é permitido anexar arquivo.";
}
my $valorNota = "";
if ($umaAtividade->getValorNota() > 0) {
   $valorNota = "<font color=000000>Valendo <b>".$umaAtividade->getValorNota()."</b> pontos.</font>";
} else {
   $valorNota = "";
}
my $corDataLimite="FF0000";
if ($umaAtividade->expirouDataLimite()) {
    $corDataLimite = "999999";
}

my $bloqueadaAte = "";
if (!$umaAtividade->expirouDataDivulgacao()) {
   $bloqueadaAte = qq |<br><font color="FF0000">Bloqueada até <b>${$umaAtividade}{'dataDivulgacao'}</b>.</font> |;
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
                  size=2><b>Atividades</b></FONT></DIV>
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
                          ${$umaAtividade}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaAtividade}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaAtividade}{'umUsuario'}}{'nome'}</a>
                            em ${$umaAtividade}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#$corDataLimite">
                          Responder até <b>${$umaAtividade}{'dataLimite'}</b>. $valorNota $bloqueadaAte
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="1" face="Arial, Helvetica, sans-serif" color="#000000">
                          $anexo
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaAtividade}{'texto'}</td>
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
                          <input type="hidden" name="codigoAtividade" value="${$umaAtividade}{'codigoAtividade'}">
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
# Método que exclui uma atividade e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $dadosAtividades = new DadosAtividades;

   $dadosAtividades->excluir($self->query->param('codigoAtividade'));

   $self->imprimirMensagem("Atividade excluída com sucesso!","atividades.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaEstender
#--------------------------------------------------------------------------------
# Método que imprime a tela com atividades estendidas
#################################################################################
sub imprimirTelaEstender {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

my $indicePagina = $self->query->param('indicePagina')*1;
my $itensPagina = 5;
my $totalItens = $dadosAtividades->quantidade();
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

my @colecaoAtividades = $dadosAtividades->solicitarParcial($indicePagina, $itensPagina, $self->umUsuario->info->getUltimoAcesso());


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
                  size=2><b>Atividades</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> atividades. Mostrando de <b>$intervaloIni</b>
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
      foreach $umaAtividade (@colecaoAtividades) {
         if ($umaAtividade->getLido()) {
            $titulo = $umaAtividade->getTitulo();
         } else {
            $titulo = "<b>".$umaAtividade->getTitulo()."</b>";
         }
         my $anexo = "";
         if ($umaAtividade->getHabAnexo()) {
            $anexo = "Permitido anexar arquivo.";
         } else {
            $anexo = "<b>Não</b> é permitido anexar arquivo.";
         }
         my $valorNota = "";
         if ($umaAtividade->getValorNota() > 0) {
            $valorNota = "<font color=000000>Valendo <b>".$umaAtividade->getValorNota()."</b> pontos.</font>";
         } else {
            $valorNota = "";
         }
         if ($umaAtividade->expirouDataLimite()) {
            $corDataLimite = "999999";
         } else {
            $corDataLimite = "FF0000";
         }

         my $bloqueadaAte = "";
         if (!$umaAtividade->expirouDataDivulgacao()) {
            $bloqueadaAte = qq |<br><font color="FF0000">Bloqueada até <b>${$umaAtividade}{'dataDivulgacao'}</b>.</font> |;
         }

         if (!(!$umaAtividade->expirouDataDivulgacao() && !$self->umUsuario->getPrivilegios())) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td width="70"><center>
                          <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          $itemAtual</center></font></td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <a href="atividades.cgi?opcao=visualizar\&codigoAtividade=${$umaAtividade}{'codigoAtividade'}">$titulo</a></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaAtividade}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaAtividade}{'umUsuario'}}{'nome'}</a>
                            em ${$umaAtividade}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#$corDataLimite">
                          Responder até <b>${$umaAtividade}{'dataLimite'}</b>. $valorNota $bloqueadaAte
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="1" face="Arial, Helvetica, sans-serif" color="#000000">
                          $anexo
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaAtividade}{'texto'}</td>
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
      $navegacao .= qq |<img src="icones/setaantes.jpg"> [<a href="atividades.cgi?opcao=estender\&indicePagina=$anterior">anterior</a>]|;
   }
   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq | [<b>$pag</b>] |;
      } else {
         $navegacao .= qq | [<a href="atividades.cgi?opcao=estender\&indicePagina=$pag">$pag</a>] |;
      }
   }
   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq | [<a href="atividades.cgi?opcao=estender\&indicePagina=$proximo">próximo</a>] <img src="icones/setadepois.jpg"> |;
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
