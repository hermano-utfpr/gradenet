package HtmlTestes;

use strict;
use CGI;
use ClasseTeste;
use DadosTestes;
use ClasseTesteUsuario;
use DadosTestesUsuarios;
use DadosAtividades;
use ClasseUsuario;
use DadosUsuarios;
use FuncoesUteis;









#################################################################################
# HtmlTestes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso aos testes
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
                  size=2>Testes</FONT></B></DIV>
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
      $menuinf = qq |   [<a href="testes.cgi?opcao=incluir">Incluir Teste</a>] - 
                        [<a href="testes.cgi">Mostrar Testes</a>] -
                        [<a href="testes.cgi?opcao=ranking">Ranking</a>]|;
   } else {
      $menuinf = qq |   [<a href="testes.cgi">Mostrar Testes</a>] |;
   }

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaTestes
#--------------------------------------------------------------------------------
# Método que imprime a tela com testes
#################################################################################
sub imprimirTelaTestes {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;

my $totalItens = $dadosTestes->quantidade();

my @colecaoTestes = $dadosTestes->solicitarTestes();


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
                  size=2><b>Testes</b></FONT></DIV>
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
                            Foram encontrados <b>$totalItens</b> testes. Mostrando <b>todos</b>:</font></div>
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
   my $iconeTeste = "";
   if ($totalItens > 0) {
      foreach $umTeste (@colecaoTestes) {
            $titulo = $umTeste->getTitulo();
            if ($umTeste->getHabRanking()) {
               $iconeTeste = "icones/testes_crank.jpg";
            } else {
               $iconeTeste = "icones/testes_srank.jpg";
            }
            my $numQuestoes = $umTeste->getNumQuestoes();
            my $qtdeQuestoes = $umTeste->info->getQtdeQuestoes();

            my $gerenciar = qq |[Gerenciar]|;
            if ($numQuestoes <= $qtdeQuestoes) {
               $gerenciar = qq |[<a href="testes.cgi?opcao=gerenciarTeste\&codigoTeste=${$umTeste}{'codigoTeste'}">Gerenciar</a>]|;
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
                                    ${$umTeste}{'data'}</font></div>
                                </td>
                                <td width="400"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                   <img src="$iconeTeste" width=16 height=16 border=0></img>&nbsp;<img src="icones/testes.jpg" width=16 height=16 border=0></img>
                                   <a href="testes.cgi?opcao=visualizar\&codigoTeste=${$umTeste}{'codigoTeste'}">$titulo</a>
                                   </font>
                                </td>
                                <td>
                                  <div align="left"></div>
                                </td>
                              </tr>
                              <tr>
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="30">
                                  <div align="center"><font face="Arial, Helvetica, sans-serif" size="1" color="#006600"><font color="#000000"></font></font></div>
                                </td>
                                <td width="150">
                                  <div align="center"></div>
                                </td>
                                <td width="400"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">Questões: </font>
                                  <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">$numQuestoes/$qtdeQuestoes</font>
                                </td>                           
                                <td>
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">$gerenciar</font></div>
                                </td>
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
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=1>
                       <font color="000000">
                       <img src="icones/testes_crank.jpg" width=16 height=16 border="0"> - Teste para Ranking!&nbsp;&nbsp;
                       <img src="icones/testes_srank.jpg" width=16 height=16 border="0"> - Teste fora do Ranking!
                       </font>
                       </font>
                    </CENTER></TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      &nbsp;
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
                  size=2><b>Testes</b></FONT></DIV>
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
                            teste: </font></b></td>
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
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Número de questões para gerar o teste:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                              <input type="text" name="numQuestoes" size="10" maxlength="10">
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Código da atividade vinculada:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                              <input type="text" name="codigoAtividade" size="10" maxlength="10" value="0">
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
                            <input type="checkbox" name="habRanking" value="1" checked> <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Habilitar Teste no Ranking!</font>
                            </td>
                          <td width="70" height="2">&nbsp;</td>
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
# Método que inclui um teste e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTeste = new ClasseTeste;
   my $dadosTestes = new DadosTestes;


   $umTeste->setDadosIU(0,$self->query->param('titulo'),
                          $self->query->param('texto'),
                          $self->query->param('habRanking')*1,
                          $self->query->param('numQuestoes'),
                          $self->umUsuario->getCodigoUsuario(),
                          $self->query->param('codigoAtividade'));
                          
   $dadosTestes->gravar($umTeste);

   $self->imprimirMensagem("Teste incluído com sucesso!","testes.cgi",0);

}

#################################################################################









#################################################################################
# imprimirTelaVisualizar
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar o teste
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $permiteAluno = $_[0];

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;

$umTeste = $dadosTestes->selecionarTeste($self->query->param('codigoTeste'));

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

$umaAtividade = $dadosAtividades->selecionarAtividade($umTeste->getCodigoAtividade());

my $tituloAtividade = $umaAtividade->getTitulo();

if ($tituloAtividade eq "") {
   $tituloAtividade = "-"
}

   if (!($self->umUsuario->getPrivilegios() || $permiteAluno == 1)) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $habRanking = "Desabilitado";
   if ($umTeste->getHabRanking()) {
      $habRanking = "Habilitado";
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
                  size=2><b>Testes</b></FONT></DIV>
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
                          ${$umTeste}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umTeste}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umTeste}{'umUsuario'}}{'nome'}</a>
                            em ${$umTeste}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umTeste}{'texto'}</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Número de questões para gerar o teste:
                          <font color="#006600"><b>${$umTeste}{'numQuestoes'}</b></font></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Atividade vinculada:
                          <font color="#0000FF"><b>$tituloAtividade</b></font></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Teste <b>$habRanking</b> no Ranking!
                          </font></td>
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
                       [<a href="testes.cgi?opcao=alterar\&codigoTeste=${$umTeste}{'codigoTeste'}">Alterar</a>] - 
                       [<a href="testes.cgi?opcao=excluir\&codigoTeste=${$umTeste}{'codigoTeste'}">Excluir</a>]  
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
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar um teste
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $dadosTestes = new DadosTestes;
my $umTeste = $dadosTestes->selecionarTeste($self->query->param('codigoTeste'));

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $editaTexto = &getTextoHTML($umTeste->getTexto());
my $habRanking = "";
if ($umTeste->getHabRanking()) {
   $habRanking = "checked";
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
                  size=2><b>Testes</b></FONT></DIV>
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
                            teste: </font></b></td>
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
                              <input type="text" name="titulo" size="60" maxlength="60" value="${$umTeste}{'titulo'}">
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Número de questões para gerar o teste:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                              <input type="text" name="numQuestoes" size="10" maxlength="10" value="${$umTeste}{'numQuestoes'}">
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Código da atividade vinculada:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                              <input type="text" name="codigoAtividade" size="10" maxlength="10" value="${$umTeste}{'codigoAtividade'}">
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
                          <td height="2"><input type="checkbox" name="habRanking" value="1" $habRanking> <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Habilitar Teste no Ranking!</font>
                          </td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                          <font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="006600">${$umTeste}{'data'}
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
                            <input type="hidden" name="codigoTeste" value="${$umTeste}{'codigoTeste'}">
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
# Método que altera um teste e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTeste = new ClasseTeste;
   my $dadosTestes = new DadosTestes;

   $umTeste = $dadosTestes->selecionarTeste($self->query->param('codigoTeste'));

   if ($self->query->param('atualizarData')) {
      $umTeste->setDadosIU($self->query->param('codigoTeste'),
                          $self->query->param('titulo'),
                          $self->query->param('texto'),
                          $self->query->param('habRanking')*1,
                          $self->query->param('numQuestoes'),   
                          $self->umUsuario->getCodigoUsuario(),
                          $self->query->param('codigoAtividade'));
   } else {
      $umTeste->setDados($self->query->param('codigoTeste'),
                          $self->query->param('titulo'),
                          $self->query->param('texto'),
                          $umTeste->getData(),
                          $self->query->param('habRanking')*1,
                          $self->query->param('numQuestoes'),   
                          $self->umUsuario->getCodigoUsuario(),
                          $self->query->param('codigoAtividade'));
   }   
   
      

   $dadosTestes->gravar($umTeste);

   $self->imprimirMensagem("Teste alterado com sucesso!","testes.cgi",0);

}

#################################################################################









#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar o teste para exclusão
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;

$umTeste = $dadosTestes->selecionarTeste($self->query->param('codigoTeste'));

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

$umaAtividade = $dadosAtividades->selecionarAtividade($umTeste->getCodigoAtividade());

my $tituloAtividade = $umaAtividade->getTitulo();

my $valorAtividade = $umaAtividade->getValorNota();

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $habRanking = "Desabilitado";
   if ($umTeste->getHabRanking()) {
      $habRanking = "Habilitado";
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
                  size=2><b>Testes</b></FONT></DIV>
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
                          ${$umTeste}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umTeste}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umTeste}{'umUsuario'}}{'nome'}</a>
                            em ${$umTeste}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umTeste}{'texto'}</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Número de questões para gerar o teste:
                          <font color="#006600"><b>${$umTeste}{'numQuestoes'}</b></font></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                                                <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Atividade vinculada:
                          <font color="#006600"><b>$tituloAtividade</b></font></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Valor:
                          <font color="#006600"><b>$valorAtividade</b></font></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>     
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Teste <b>$habRanking</b> no Ranking!
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
                          <td>
                          <input type="hidden" name="codigoTeste" value="${$umTeste}{'codigoTeste'}">
                          <input type="hidden" name="opcao" value="excluindo">
                          <input type="submit" name="submit" value="Confirmar a Exclusão">
                          </td>
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
                      <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">&nbsp;</div>
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
# Método que exclui um teste e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTeste = new ClasseTeste;
   my $dadosTestes = new DadosTestes;

   $umTeste = $dadosTestes->selecionarTeste($self->query->param('codigoTeste'));

   $dadosTestes->excluir($umTeste->getCodigoTeste());

   $self->imprimirMensagem("Teste excluído com sucesso!","testes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaTestesUsuario
#--------------------------------------------------------------------------------
# Método que imprime a tela com testes do usuário
#################################################################################
sub imprimirTelaTestesUsuario {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;
my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $totalItens = $dadosTestes->quantidade();

my @colecaoTestes = $dadosTestesUsuarios->solicitarTestesDoUsuario($self->umUsuario->getCodigoUsuario());


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
                  size=2><b>Testes</b></FONT></DIV>
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
                            Foram encontrados <b>$totalItens</b> testes. Mostrando <b>todos</b>:</font></div>
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
   my $iconeTeste = "";  
   my $status = "";
   if ($totalItens > 0) {
      foreach $umTesteUsuario (@colecaoTestes) {
            $umTeste = $umTesteUsuario->umTeste;
            $titulo = $umTeste->getTitulo();
            $iconeTeste = "icones/testes.jpg";
            if ($umTesteUsuario->getStatus() eq "") {
               $status = "Teste Fechado";
            }
            if ($umTesteUsuario->getStatus() eq "A") {
               $status = "Teste Aberto";
            }
            if ($umTesteUsuario->getStatus() eq "F") {
               $status = "Fazendo Teste";
            }
            if ($umTesteUsuario->getStatus() eq "E") {
               $status = "Teste Encerrado";
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
                                    ${$umTeste}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <img src="$iconeTeste" width=16 height=16 border=0></img>&nbsp;<img src="icones/testes.jpg" width=16 height=16 border=0></img>
                                <a href="etestes.cgi?opcao=visualizar\&codigoTeste=${$umTeste}{'codigoTeste'}">$titulo</a>
                                $status</font></td>
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










#################################################################################
# imprimirTelaGerenciar
#--------------------------------------------------------------------------------
# Método que imprime a tela para gerenciar um teste
#################################################################################
sub imprimirTelaGerenciar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;
my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;
my $dadosUsuarios = new DadosUsuarios;

my $codigoTeste = $self->query->param('codigoTeste');

my $totalItens = $dadosUsuarios->quantidadeAlunos();

my @colecaoTestes = $dadosTestesUsuarios->solicitarUsuariosDoTeste($codigoTeste);


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
                  size=2><b>Gerenciamento</b></FONT></DIV>
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
                            Foram encontrados <b>$totalItens</b> alunos. Mostrando <b>todos</b>:</font></div>
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
   my $iconeTeste = "";
   my $umUsuario = new ClasseUsuario();
   if ($totalItens > 0) {
      foreach $umTesteUsuario (@colecaoTestes) {
            $umUsuario = $umTesteUsuario->umUsuario;            
            $iconeTeste = "icones/testes.jpg";
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
                                    ${$umTesteUsuario}{'data'}</font></div>
                                </td>
                                <td width="350"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                   <img src="$iconeTeste" border=0></img>&nbsp;<img src="icones/testes.jpg" width=16 height=16 border=0></img>
                                   <a href="testes.cgi?opcao=visualizar\&codigoTeste=${$umTesteUsuario}{'codigoTeste'}">${$umUsuario}{'nome'}</a>
                                   </font>
                                </td>
                                <td width="50"> 
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                  10/10</font></div>
                                </td>
                                <td> 
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                  [<a href="teste.cgi\&opcao=gerenciarTeste\&codigoTeste=${$umTesteUsuario}{'codigoTeste'}">Gerenciar</a>]</font></div>
                                </td>
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

