package HtmlTestesQuestoes;

use strict;
use CGI;
use ClasseTesteQuestao;
use DadosTestesQuestoes;
use ClasseTesteResposta;
use DadosTestesRespostas;
use DadosTestesUsuarios;
use FuncoesUteis;









#################################################################################
# HtmlTestesQuestoes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso às questões de um teste
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
                  size=2>Questões</FONT></B></DIV>
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

   my $codigoTeste = $self->query->param('codigoTeste');

   if ($self->umUsuario->getPrivilegios() == 1) {
      $menuinf = qq |   [<a href="testes.cgi?opcao=incluirQuestao\&codigoTeste=$codigoTeste">Incluir Questão</a>] - 
                        [<a href="testes.cgi?opcao=visualizar\&codigoTeste=$codigoTeste">Mostrar Questões</a>] - 
                        [<a href="testes.cgi?opcao=estenderQuestoes\&codigoTeste=$codigoTeste">Estender Questões</a>] |;
   } 

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaQuestoes
#--------------------------------------------------------------------------------
# Método que imprime a tela com questões
#################################################################################
sub imprimirTelaQuestoes {

my $self = shift;

if ($self->umUsuario->getPrivilegios() != 1) {
   print "<!--";
   die "Usuário não autorizado!\n";
}

my $menuinf = $self->linkMenuInferior();

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;

my $totalItens = $dadosQuestoes->quantidade($self->query->param('codigoTeste'));

my @colecaoQuestoes = $dadosQuestoes->solicitar($self->query->param('codigoTeste'));


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
                  size=2><b>Questões</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> questões. Mostrando <b>Todas</b>:</font></div>
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
   my $iconeQuestao = "";
   if ($totalItens > 0) {
      foreach $umaQuestao (@colecaoQuestoes) {
          $titulo = substr(getTextoHTML($umaQuestao->getTexto()),0,40)."...";
          $iconeQuestao = "icones/questao.jpg";
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
                                    </font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <img src="$iconeQuestao" width=16 height=16 border=0></img>&nbsp;
                                <a href="testes.cgi?opcao=visualizarQuestao\&codigoTeste=${$umaQuestao}{'codigoTeste'}\&codigoQuestao=${$umaQuestao}{'codigoQuestao'}">$titulo</a>
                                <font size="1" face="Arial, Helvetica, sans-serif"></font></font></td>
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
# imprimirTelaIncluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para incluir uma questão
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $codigoTeste = $self->query->param('codigoTeste');

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
                  size=2><b>Questões</b></FONT></DIV>
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
                            questão: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Questão:</font></b></td>
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
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                          Selecione a resposta correta:</font></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="1" checked>
                          Resposta 1:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp1" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="2">
                          Resposta 2:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp2" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="3">
                          Resposta 3:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp3" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="4">
                          Resposta 4:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp4" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="5">
                          Resposta 5:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp5" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="6">
                          Resposta 6:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp6" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="7">
                          Resposta 7:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp7" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="8">
                          Resposta 8:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp8" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="9">
                          Resposta 9:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp9" cols="60" rows="3"></textarea>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="10">
                          Resposta 10:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp10" cols="60" rows="3"></textarea>
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
                            <input type="hidden" name="opcao" value="incluindoQuestao">
                            <input type="hidden" name="codigoTeste" value="$codigoTeste">
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
# Método que inclui uma questao e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

   my $codigoTeste = $self->query->param('codigoTeste');

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umaQuestao = new ClasseTesteQuestao;
   my $dadosQuestoes = new DadosTestesQuestoes;
   my $umaResposta = new ClasseTesteResposta;
   my $dadosRespostas = new DadosTestesRespostas;


   $umaQuestao->setDadosIU(0,$self->query->param('codigoTeste'),$self->query->param('texto'));

   my $codigoQuestao = $dadosQuestoes->gravar($umaQuestao);
   
   my $i = 1;
   my $correta = 0;
   my $resp = "";
   for ($i = 1; $i <= 10; $i++) {
       $umaResposta->clear();
       if ($self->query->param('correta') == $i) {
          $correta = 1; 
       } else {
          $correta = 0; 
       }
       $resp = $self->query->param('resp'.$i);
       if (($resp ne "") || $correta)  {
          $umaResposta->setDadosIU(0,$codigoQuestao,$resp,$correta);
          $dadosRespostas->gravar($umaResposta);
       }
   }

   $self->imprimirMensagem("Questão incluída com sucesso!","testes.cgi?opcao=visualizar\&codigoTeste=$codigoTeste",0);

}

#################################################################################











#################################################################################
# imprimirTelaVisualizar
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar a questão
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

if ($self->umUsuario->getPrivilegios() != 1) {
   print "<!--";
   die "Usuário não autorizado!\n";
}

my $codigoTeste = $self->query->param('codigoTeste');
my $codigoQuestao = $self->query->param('codigoQuestao');

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;
my $umaResposta = new ClasseTesteResposta;
my $dadosRespostas = new DadosTestesRespostas;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

$umaQuestao = $dadosQuestoes->selecionar($codigoQuestao);

my @colecaoRespostas = $dadosRespostas->solicitar($umaQuestao->getCodigoQuestao());

my $texto = $umaQuestao->getTexto();

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
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 size=2><b>Questões</b></FONT></DIV>
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
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <b>Questão:</b></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000">
                          $texto</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   my $i = 1;
   my $cor = "000000";
   my $icone = "";
   my $corLinha = "FFFFFF";
   my $codigoResposta = 0;
   my $qtdeMarcadas = 0;
   my $marcadas = "";
   foreach $umaResposta (@colecaoRespostas) {
      if ($umaResposta->getCorreta()) {
         $cor = "008000";
         $icone = "icones/corrigido.jpg";
      } else {
         $cor = "FF0000";
         $icone = "";
      }
      if ($corLinha eq "FFFFFF") {
         $corLinha = "EEAA55";
      } else {
         $corLinha = "FFFFFF";
      }
      $codigoResposta = $umaResposta->getCodigoResposta();
      $qtdeMarcadas = $dadosTestesUsuarios->quantidadeMarcadas($codigoQuestao,$codigoResposta);
      $marcadas = "";
      for (my $i = 0; $i < $qtdeMarcadas; $i++) {
          $marcadas .= "<img src=\"icones/usuario.jpg\" width=16 height=16 border=0>\&nbsp\;"
      }
      if ($qtdeMarcadas > 0) {
          $marcadas .= "$qtdeMarcadas";
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
                          <td><div align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="$cor">$marcadas</font></div></td>
                          <td width="70">&nbsp;</td>
                        </tr>                        
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="$cor"><b>Resposta $i:</b>
                          <img src="$icone" width=16 height=16 border=0>
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td bgcolor="$corLinha"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000">${$umaResposta}{'texto'}</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         $i++;
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

#                       [<a href="testes.cgi?opcao=alterarQuestao\&codigoTeste=$codigoTeste\&codigoQuestao=$codigoQuestao">Alterar</a>] -

print qq |
                       [<a href="testes.cgi?opcao=excluirQuestao\&codigoTeste=$codigoTeste\&codigoQuestao=$codigoQuestao">Excluir</a>]
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
# Método que imprime a tela para alterar uma questão
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $codigoTeste = $self->query->param('codigoTeste');
my $codigoQuestao = $self->query->param('codigoQuestao');

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;
my $umaResposta = new ClasseTesteResposta;
my $dadosRespostas = new DadosTestesRespostas;

$umaQuestao = $dadosQuestoes->selecionar($codigoQuestao);

my @colecaoRespostas = $dadosRespostas->solicitar($codigoQuestao);

my $editaTexto = &getTextoHTML($umaQuestao->getTexto());

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
                  size=2><b>Questões</b></FONT></DIV>
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
                            questão: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Questão:</font></b></td>
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
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                          Selecione a resposta correta:</font></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

  my $i = 1;  
  my $correta = "";

  for ($i = 1; $i <= 10; $i++) {

      if ($i <= scalar(@colecaoRespostas)) {
         $umaResposta = $colecaoRespostas[$i-1];
      } else {
         $umaResposta->clear;
      }

      if ($umaResposta->getCorreta()) {
         $correta = "checked";
      } else {
         $correta = "";
      }

      $editaTexto = &getTextoHTML($umaResposta->getTexto());

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                          <input type="radio" name="correta" value="$i" $correta>
                          Resposta $i:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <textarea name="resp$i" cols="60" rows="3">$editaTexto</textarea>
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"> 
                            <input type="hidden" name="opcao" value="alterandoQuestao">
                            <input type="hidden" name="codigoTeste" value="$codigoTeste">
                            <input type="hidden" name="codigoQuestao" value="$codigoQuestao">
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
# Método que altera uma questao e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

   my $codigoTeste = $self->query->param('codigoTeste');
   my $codigoQuestao = $self->query->param('codigoQuestao');

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umaQuestao = new ClasseTesteQuestao;
   my $dadosQuestoes = new DadosTestesQuestoes;
   my $umaResposta = new ClasseTesteResposta;
   my $dadosRespostas = new DadosTestesRespostas;


   $umaQuestao->setDadosIU($codigoQuestao,$codigoTeste,$self->query->param('texto'));

   $dadosQuestoes->gravar($umaQuestao);

   $dadosRespostas->excluirRespostas($codigoQuestao);

   my $i = 1;
   my $correta = 0;
   my $resp = "";
   for ($i = 1; $i <= 10; $i++) {
       $umaResposta->clear();
       if ($self->query->param('correta') == $i) {
          $correta = 1; 
       } else {
          $correta = 0; 
       }
       $resp = $self->query->param('resp'.$i);
       if (($resp ne "") || $correta)  {
          $umaResposta->setDadosIU(0,$codigoQuestao,$resp,$correta);
          $dadosRespostas->gravar($umaResposta);
       }
   }

   $self->imprimirMensagem("Questão alterada com sucesso!","testes.cgi?opcao=visualizar\&codigoTeste=$codigoTeste",0);

}

#################################################################################











#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para excluir a questão
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

if ($self->umUsuario->getPrivilegios() != 1) {
   print "<!--";
   die "Usuário não autorizado!\n";
}

my $codigoTeste = $self->query->param('codigoTeste');
my $codigoQuestao = $self->query->param('codigoQuestao');

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;
my $umaResposta = new ClasseTesteResposta;
my $dadosRespostas = new DadosTestesRespostas;

$umaQuestao = $dadosQuestoes->selecionar($codigoQuestao);

my @colecaoRespostas = $dadosRespostas->solicitar($umaQuestao->getCodigoQuestao());

my $texto = $umaQuestao->getTexto();

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
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 size=2><b>Questões</b></FONT></DIV>
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
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <b>Questão:</b></font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000">
                          $texto</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   my $i = 1;
   my $cor = "000000";
   foreach $umaResposta (@colecaoRespostas) {
      if ($umaResposta->getCorreta()) {
         $cor = "FF0000";
      } else {
         $cor = "000000";
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
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="$cor"><b>Resposta $i:</b>
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="$cor">${$umaResposta}{'texto'}</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         $i++;
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
                            <input type="hidden" name="opcao" value="excluindoQuestao">
                            <input type="hidden" name="codigoTeste" value="$codigoTeste">
                            <input type="hidden" name="codigoQuestao" value="$codigoQuestao">
                            <input type="submit" name="Submit" value="Confirmar Exclusão">
                          </td>
                          <td width="70" height="2">&nbsp;</td>
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

#                       [<a href="testes.cgi?opcao=alterarQuestao\&codigoTeste=$codigoTeste\&codigoQuestao=$codigoQuestao">Alterar</a>] - 

print qq |
                       [<a href="testes.cgi?opcao=excluirQuestao\&codigoTeste=$codigoTeste\&codigoQuestao=$codigoQuestao">Excluir</a>]  
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
# imprimirTelaExcluindo
#--------------------------------------------------------------------------------
# Método que exclui uma questao e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

   my $codigoTeste = $self->query->param('codigoTeste');
   my $codigoQuestao = $self->query->param('codigoQuestao');

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $dadosQuestoes = new DadosTestesQuestoes;
   $dadosQuestoes->excluir($codigoQuestao);

   $self->imprimirMensagem("Questão excluída com sucesso!","testes.cgi?opcao=visualizar\&codigoTeste=$codigoTeste",0);

}

#################################################################################










#################################################################################
# imprimirTelaEstenderQuestoes
#--------------------------------------------------------------------------------
# Método que imprime a tela com questões estendidas
#################################################################################
sub imprimirTelaEstenderQuestoes {

my $self = shift;

if ($self->umUsuario->getPrivilegios() != 1) {
   print "<!--";
   die "Usuário não autorizado!\n";
}

my $menuinf = $self->linkMenuInferior();

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;

my $umaResposta = new ClasseTesteResposta;
my $dadosRespostas = new DadosTestesRespostas;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $codigoTeste = $self->query->param('codigoTeste');

my $totalItens = $dadosQuestoes->quantidade($codigoTeste);

my @colecaoQuestoes = $dadosQuestoes->solicitar($codigoTeste);

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
                  size=2><b>Questões</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> questões. Mostrando <b>Todas</b>:</font></div>
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
   my $iconeQuestao = "";
   if ($totalItens > 0) {
      foreach $umaQuestao (@colecaoQuestoes) {
          $iconeQuestao = "icones/questao.jpg";
          my @colecaoRespostas = $dadosRespostas->solicitar($umaQuestao->getCodigoQuestao());
          my $texto = $umaQuestao->getTexto();
          my $codigoQuestao = $umaQuestao->getCodigoQuestao();
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                  <TR>
                    <TD>
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="70"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="000000"><div align="center">$itemAtual</div></font></td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <img src="$iconeQuestao" width=16 height=16 border=0>&nbsp;<b>Questão:</b>
                          &nbsp;
                           [<a href="testes.cgi?opcao=excluirQuestao\&codigoTeste=$codigoTeste\&codigoQuestao=$codigoQuestao">Excluir</a>]
                           </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000">
                          $texto</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   my $i = 1;
   my $cor = "000000";
   my $icone = "";
   my $corLinha = "FFFFFF";
   my $codigoResposta = 0;
   my $qtdeMarcadas = 0;
   my $marcadas = "";
   foreach $umaResposta (@colecaoRespostas) {
      if ($umaResposta->getCorreta()) {
         $cor = "008000";
         $icone = "icones/corrigido.jpg";
      } else {
         $cor = "FF0000";
         $icone = "";
      }
      if ($corLinha eq "FFFFFF") {
         $corLinha = "EEAA55";
      } else {
         $corLinha = "FFFFFF";
      }
      $codigoResposta = $umaResposta->getCodigoResposta();
      $qtdeMarcadas = $dadosTestesUsuarios->quantidadeMarcadas($codigoQuestao,$codigoResposta);
      $marcadas = "";
      for (my $i = 0; $i < $qtdeMarcadas; $i++) {
          $marcadas .= "<img src=\"icones/usuario.jpg\" width=16 height=16 border=0>\&nbsp\;"
      }
      if ($qtdeMarcadas > 0) {
          $marcadas .= "$qtdeMarcadas";
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
                          <td><div align="right"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="$cor">$marcadas</font></div></td>
                          <td width="70">&nbsp;</td>
                        </tr>                        
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="$cor"><b>Resposta $i:</b>
                          <img src="$icone" width=16 height=16 border=0>
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td bgcolor="$corLinha"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000">${$umaResposta}{'texto'}</font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         $i++;
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                      </table>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=2>
                    </TD>
                  </TR>                  
                  <TR>
                    <TD height="2">&nbsp;</TD>
                  </TR>

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
