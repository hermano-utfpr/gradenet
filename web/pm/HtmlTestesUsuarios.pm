package HtmlTestesUsuarios;

use strict;
use CGI;
use ClasseTeste;
use DadosTestes;
use ClasseTesteQuestao;
use DadosTestesQuestoes;
use ClasseTesteUsuario;
use DadosTestesUsuarios;
use ClasseUsuario;
use DadosUsuarios;
use FuncoesUteis;









#################################################################################
# HtmlTestesUsuarios
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para gerenciamento de testes dos alunos
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
                  size=2>Gerenciar Teste</FONT></B></DIV>
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
      $menuinf = qq |   [<a href="testes.cgi?opcao=gerenciarTeste\&codigoTeste=$codigoTeste">Gerenciar Teste</a>]|;
   } else {
      $menuinf = qq |[<a href="testes.cgi">Mostrar Testes</a>] - [<a href="testes.cgi?opcao=ranking">Ranking</a>]|;
   }

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaGerenciar
#--------------------------------------------------------------------------------
# Método que imprime a tela para gerenciamento de testes
#################################################################################
sub imprimirTelaGerenciar {

my $self = shift;

if ($self->umUsuario->getPrivilegios() != 1) {
   print "<!--";
   die "Usuário não autorizado!\n";
}

my $menuinf = $self->linkMenuInferior();

my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $codigoTeste = $self->query->param('codigoTeste');

my $dadosUsuarios = new DadosUsuarios;

my $qtdeAlunos = $dadosUsuarios->quantidadeAlunosAtivos();
my $qtdeAlunosOnline = $dadosUsuarios->quantidadeAlunosOnline();

my @colecaoTestesUsuarios = $dadosTestesUsuarios->solicitarGerenciar($codigoTeste);


my $medSoma = 0;
my $medQtde = 0;

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
                  size=2><b>Gerenciar Teste</b></FONT></DIV>
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
                            Foram encontrados <b>$qtdeAlunos</b> alunos e <b>$qtdeAlunosOnline</b> estão on-line. Mostrando <b>Todos</b>:</font></div>
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


   if (1 > 0) {
      my $lincor = "\#FFFFFF";
      my $corLinha = "FFFFFF";
      foreach $umTesteUsuario (@colecaoTestesUsuarios) {
         my $iconeUsuario = "icones/usuario_offline.jpg";
         my $umUsuario = $umTesteUsuario->umUsuario();

         if ($umUsuario->getSexo() == 0) {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuaria_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuaria_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuaria_inativa.jpg";
            }
         } else {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuario_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuario_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuario_inativo.jpg";
            }
         }

         my $codigoUsuario = $umUsuario->getCodigoUsuario();

         my $notaEnc = "-";
         my $statusAtual = "Teste Fechado";
         my $linkStatus = qq |[<a href="testes.cgi?opcao=abrirTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Abrir</a>]|;
         my $corStatus = "AA99AA";
         my $checkAbrir = qq | <input type="checkbox" name="codigoUsuario" value="${$umUsuario}{'codigoUsuario'}"> |;
         if ($umTesteUsuario->getStatus() eq "E") { #Encerrado
            $notaEnc = $umTesteUsuario->getNotaCorrigida();
            $statusAtual = qq |[<a href="testes.cgi?opcao=visualizarTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Visualizar</a>] ${$umTesteUsuario}{'data'}|;
            $linkStatus = qq |[<a href="testes.cgi?opcao=reabrirTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Reabrir</a>] - [<a href="testes.cgi?opcao=confFecharTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Fechar</a>]|;
            $corStatus = "000000";
            $checkAbrir = "";
            $medSoma += $notaEnc;
            $medQtde++;
         }
         if ($umTesteUsuario->getStatus() eq "F") { #Fazendo
            $statusAtual = "Fazendo Teste";
            $linkStatus = qq |[<a href="testes.cgi?opcao=reabrirTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Reabrir</a>] - [<a href="testes.cgi?opcao=confZerarTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Zerar</a>] - [<a href="testes.cgi?opcao=confFecharTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Fechar</a>]|;
            $corStatus = "FF6600";
            $checkAbrir = "";
         }
         if ($umTesteUsuario->getStatus() eq "A") { #Aberto
            $statusAtual = "Teste Aberto";
            $linkStatus = qq |[<a href="testes.cgi?opcao=zerarTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Zerar</a>] - [<a href="testes.cgi?opcao=fecharTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Fechar</a>]|;
            $corStatus = "FF0000";
            $checkAbrir = "";
         }
         if ($corLinha eq "FFFFFF") {
            $corLinha = "EEFFFF";
         } else {
            $corLinha = "FFFFFF";
         }
         if ($lincor eq "\#FFFFDD") {
             $lincor = "\#FFFFFF";
         } else {
             $lincor = "\#FFFFDD";
         }


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="3" bgcolor="$lincor">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="25">$checkAbrir</td>
                                      <td width="280"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeUsuario" width="16" height="16">&nbsp;
                                      <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${$umUsuario}{'nome'}</a>
                                      </font></td>
                                      <td width="40">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                       $notaEnc</font></div>
                                      </td>
                                      <td width="200">
                                        <div align="left"><font size="1" face=", Arial, Helvetica, sans-serif" color="$corStatus">$statusAtual</font></div>
                                     </td>
                                      <td>
                                        <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="000000">$linkStatus</font></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }
   }

   my $mediaTeste = "0.00";
   if ($medSoma > 0) {
      $mediaTeste = sprintf("%5.2f",$medSoma/$medQtde);
   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td>&nbsp; </td>
                        </tr>
                  <TR>
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       <font color="000000">Média de notas: <font color="0000FF">$mediaTeste</font>
                       </font>
                       </font>
                    </CENTER></TD>
                  </TR>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
                        <tr>
                          <td><div align="center">
                          <input type="hidden" name="codigoTeste" value="$codigoTeste">
                          <input type="hidden" name="opcao" value="abrirSelecao">
                          <input type="submit" name="submit" value="Abrir Selecionados">
                          </div></td>
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
# imprimirTelaAbrindoTeste
#--------------------------------------------------------------------------------
# Método que abre um teste
#################################################################################
sub imprimirTelaAbrindoTeste {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   $dadosTestesUsuarios->abrirTeste($self->query->param('codigoTeste'),$self->query->param('codigoUsuario'));

#   $self->imprimirMensagem("Teste alterado com sucesso!","testes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaAbrindoSelecionados
#--------------------------------------------------------------------------------
# Método que abre mais de um teste
#################################################################################
sub imprimirTelaAbrindoSelecionados {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   my $codigoTeste = $self->query->param('codigoTeste');

   my @codigosUsuarios = $self->query->param('codigoUsuario');


   foreach my $cod (@codigosUsuarios) {
      $dadosTestesUsuarios->abrirTeste($codigoTeste,$cod);
   }

#   $self->imprimirMensagem("Teste alterado com sucesso!","testes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaZerandoTeste
#--------------------------------------------------------------------------------
# Método que zera um teste
#################################################################################
sub imprimirTelaZerandoTeste {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   $dadosTestesUsuarios->zerarTeste($self->query->param('codigoTeste'),$self->query->param('codigoUsuario'));

#   $self->imprimirMensagem("Teste alterado com sucesso!","testes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaFechandoTeste
#--------------------------------------------------------------------------------
# Método que fecha um teste
#################################################################################
sub imprimirTelaFechandoTeste {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   $dadosTestesUsuarios->fecharTeste($self->query->param('codigoTeste'),$self->query->param('codigoUsuario'));

#   $self->imprimirMensagem("Teste alterado com sucesso!","testes.cgi",0);

}

#################################################################################









#################################################################################
# imprimirTelaReabrirTeste
#--------------------------------------------------------------------------------
# Método que imprime HTML solicitando a reabertura de um teste
#################################################################################
sub imprimirTelaReabrirTeste {

my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   my $codigoTeste = $self->query->param('codigoTeste');
   my $codigoUsuario = $self->query->param('codigoUsuario');

   $umTesteUsuario = $dadosTestesUsuarios->selecionarTeste($codigoTeste, $codigoUsuario);

   my $umUsuario = $umTesteUsuario->umUsuario();

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
                  size=2>Gerenciar Teste</FONT></B></DIV>
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
                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="25"></td>
                                      <td width="280"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <font color="#CC0000"><b>Reabrir o Teste:</b></font></font></td>
                                      <td width="40">
                                      </td>
                                      <td width="200">
                                     </td>
                                      <td>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         my $iconeUsuario = "icones/usuario_offline.jpg";
         if ($umUsuario->getSexo() == 0) {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuaria_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuaria_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuaria_inativa.jpg";
            }
         } else {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuario_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuario_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuario_inativo.jpg";
            }
         }

         my $notaEnc = "-";
         my $statusAtual = "Teste Fechado";
         my $corStatus = "AA99AA";
         if ($umTesteUsuario->getStatus() eq "E") { #Encerrado
            $notaEnc = $umTesteUsuario->getNotaCorrigida();
            $statusAtual = qq |[<a href="testes.cgi?opcao=visualizarTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Visualizar</a>] ${$umTesteUsuario}{'data'}|;
            $corStatus = "000000";
         }
         if ($umTesteUsuario->getStatus() eq "F") { #Fazendo
            $statusAtual = "Fazendo Teste";
            $corStatus = "FF6600";
         }
         if ($umTesteUsuario->getStatus() eq "A") { #Aberto
            $statusAtual = "Teste Aberto";
            $corStatus = "FF0000";
         }



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="25"></td>
                                      <td width="280"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeUsuario" width="16" height="16">&nbsp;
                                      <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${$umUsuario}{'nome'}</a>
</font></td>
                                      <td width="40">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                       $notaEnc</font></div>
                                      </td>
                                      <td width="200">
                                        <div align="left"><font size="1" face="Arial, Helvetica, sans-serif" color="$corStatus">$statusAtual</font></div>
                                     </td>
                                      <td>
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000"></font></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |


                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
                  <TR>
                    <TD><CENTER>
                    <INPUT TYPE="hidden" NAME="codigoTeste" VALUE="$codigoTeste">
                    <INPUT TYPE="hidden" NAME="codigoUsuario" VALUE="$codigoUsuario">
                    <INPUT TYPE="hidden" NAME="opcao" VALUE="reabrindoTeste">
                    <INPUT TYPE="submit" VALUE="Reabrir o Teste"></INPUT>&nbsp;
                    <INPUT TYPE="button" VALUE="Voltar" onclick="window.history.go(-1)"></INPUT>
                    </CENTER></TD>
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
# imprimirTelaReabrindoTeste
#--------------------------------------------------------------------------------
# Método que reabre um teste
#################################################################################
sub imprimirTelaReabrindoTeste {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   $dadosTestesUsuarios->reabrirTeste($self->query->param('codigoTeste'),$self->query->param('codigoUsuario'));

}

#################################################################################









#################################################################################
# imprimirTelaConfFecharTeste
#--------------------------------------------------------------------------------
# Método que imprime HTML solicitando o fechamento de um teste
#################################################################################
sub imprimirTelaConfFecharTeste {

my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   my $codigoTeste = $self->query->param('codigoTeste');
   my $codigoUsuario = $self->query->param('codigoUsuario');

   $umTesteUsuario = $dadosTestesUsuarios->selecionarTeste($codigoTeste, $codigoUsuario);

   my $umUsuario = $umTesteUsuario->umUsuario();

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
                  size=2>Gerenciar Teste</FONT></B></DIV>
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
                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="25"></td>
                                      <td width="280"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <font color="#CC0000"><b>Fechar o Teste:</b></font></font></td>
                                      <td width="40">
                                      </td>
                                      <td width="200">
                                     </td>
                                      <td>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         my $iconeUsuario = "icones/usuario_offline.jpg";
         if ($umUsuario->getSexo() == 0) {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuaria_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuaria_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuaria_inativa.jpg";
            }
         } else {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuario_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuario_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuario_inativo.jpg";
            }
         }

         my $notaEnc = "-";
         my $statusAtual = "Teste Fechado";
         my $corStatus = "AA99AA";
         if ($umTesteUsuario->getStatus() eq "E") { #Encerrado
            $notaEnc = $umTesteUsuario->getNotaCorrigida();
            $statusAtual = qq |[<a href="testes.cgi?opcao=visualizarTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Visualizar</a>] ${$umTesteUsuario}{'data'}|;
            $corStatus = "000000";
         }
         if ($umTesteUsuario->getStatus() eq "F") { #Fazendo
            $statusAtual = "Fazendo Teste";
            $corStatus = "FF6600";
         }
         if ($umTesteUsuario->getStatus() eq "A") { #Aberto
            $statusAtual = "Teste Aberto";
            $corStatus = "FF0000";
         }



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="25"></td>
                                      <td width="280"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeUsuario" width="16" height="16">&nbsp;
                                      <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${$umUsuario}{'nome'}</a>
</font></td>
                                      <td width="40">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                       $notaEnc</font></div>
                                      </td>
                                      <td width="200">
                                        <div align="left"><font size="1" face="Arial, Helvetica, sans-serif" color="$corStatus">$statusAtual</font></div>
                                     </td>
                                      <td>
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000"></font></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |


                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
                  <TR>
                    <TD><CENTER>
                    <INPUT TYPE="hidden" NAME="codigoTeste" VALUE="$codigoTeste">
                    <INPUT TYPE="hidden" NAME="codigoUsuario" VALUE="$codigoUsuario">
                    <INPUT TYPE="hidden" NAME="opcao" VALUE="fecharTeste">
                    <INPUT TYPE="submit" VALUE="Fechar o Teste"></INPUT>&nbsp;
                    <INPUT TYPE="button" VALUE="Voltar" onclick="window.history.go(-1)"></INPUT>
                    </CENTER></TD>
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
# imprimirTelaConfZerarTeste
#--------------------------------------------------------------------------------
# Método que imprime HTML solicitando o zeramento de um teste
#################################################################################
sub imprimirTelaConfZerarTeste {

my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   my $codigoTeste = $self->query->param('codigoTeste');
   my $codigoUsuario = $self->query->param('codigoUsuario');

   $umTesteUsuario = $dadosTestesUsuarios->selecionarTeste($codigoTeste, $codigoUsuario);

   my $umUsuario = $umTesteUsuario->umUsuario();

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
                  size=2>Gerenciar Teste</FONT></B></DIV>
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
                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="25"></td>
                                      <td width="280"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <font color="#CC0000"><b>Zerar o Teste:</b></font></font></td>
                                      <td width="40">
                                      </td>
                                      <td width="200">
                                     </td>
                                      <td>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         my $iconeUsuario = "icones/usuario_offline.jpg";
         if ($umUsuario->getSexo() == 0) {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuaria_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuaria_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuaria_inativa.jpg";
            }
         } else {
            if ($umUsuario->getAtivo()) {
               if ($umUsuario->info->getOnline()) {
                  $iconeUsuario = "icones/usuario_online.jpg";
               } else {
                  $iconeUsuario = "icones/usuario_offline.jpg";
               }
            } else {
               $iconeUsuario = "icones/usuario_inativo.jpg";
            }
         }

         my $notaEnc = "-";
         my $statusAtual = "Teste Fechado";
         my $corStatus = "AA99AA";
         if ($umTesteUsuario->getStatus() eq "E") { #Encerrado
            $notaEnc = $umTesteUsuario->getNotaCorrigida();
            $statusAtual = qq |[<a href="testes.cgi?opcao=visualizarTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Visualizar</a>] ${$umTesteUsuario}{'data'}|;
            $corStatus = "000000";
         }
         if ($umTesteUsuario->getStatus() eq "F") { #Fazendo
            $statusAtual = "Fazendo Teste";
            $corStatus = "FF6600";
         }
         if ($umTesteUsuario->getStatus() eq "A") { #Aberto
            $statusAtual = "Teste Aberto";
            $corStatus = "FF0000";
         }



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="25"></td>
                                      <td width="280"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeUsuario" width="16" height="16">&nbsp;
                                      <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${$umUsuario}{'nome'}</a>
</font></td>
                                      <td width="40">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                       $notaEnc</font></div>
                                      </td>
                                      <td width="200">
                                        <div align="left"><font size="1" face="Arial, Helvetica, sans-serif" color="$corStatus">$statusAtual</font></div>
                                     </td>
                                      <td>
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000"></font></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |


                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
                  <TR>
                    <TD><CENTER>
                    <INPUT TYPE="hidden" NAME="codigoTeste" VALUE="$codigoTeste">
                    <INPUT TYPE="hidden" NAME="codigoUsuario" VALUE="$codigoUsuario">
                    <INPUT TYPE="hidden" NAME="opcao" VALUE="zerarTeste">
                    <INPUT TYPE="submit" VALUE="Zerar o Teste"></INPUT>&nbsp;
                    <INPUT TYPE="button" VALUE="Voltar" onclick="window.history.go(-1)"></INPUT>
                    </CENTER></TD>
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
# imprimirTelaGerenciarAluno
#--------------------------------------------------------------------------------
# Método que imprime a tela para gerenciamento de testes de um aluno
#################################################################################
sub imprimirTelaGerenciarAluno {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $codigoUsuario = $self->umUsuario->getCodigoUsuario();

my $dadosUsuarios = new DadosUsuarios;
my $dadosTestes = new DadosTestes;

my $qtdeTestes = $dadosTestes->quantidade();

my $itemAtual = $qtdeTestes;

my @colecaoTestesUsuarios = $dadosTestesUsuarios->solicitarGerenciarAluno($codigoUsuario);

my $medSoma = 0;
my $medQtde = 0;

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
                            Foram encontrados <b>$qtdeTestes</b> testes. Mostrando <b>Todos</b>:</font></div>
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


   if ($qtdeTestes > 0) {
      my $corLinha = "FFFFFF";
      foreach $umTesteUsuario (@colecaoTestesUsuarios) {
         my $iconeTeste = "";
         my $umUsuario = $umTesteUsuario->umUsuario();
         my $umTeste = $umTesteUsuario->umTeste();
         my $codigoTeste = $umTeste->getCodigoTeste();
         if ($umTeste->getHabRanking()) {
            $iconeTeste = "icones/testes_crank.jpg";
         } else {
            $iconeTeste = "icones/testes_srank.jpg";
         }

         my $codigoUsuario = $umUsuario->getCodigoUsuario();

         my $notaEnc = "-";
         my $statusAtual = "Teste Fechado";
         my $linkStatus = qq |&nbsp;|;
         my $corStatus = "AA99AA";
         if ($umTesteUsuario->getStatus() eq "E") { #Encerrado
            $notaEnc = $umTesteUsuario->getNotaCorrigida();
            $statusAtual = qq |[<a href="testes.cgi?opcao=visualizarTeste\&codigoTeste=$codigoTeste\&codigoUsuario=$codigoUsuario">Visualizar</a>] ${$umTesteUsuario}{'data'}|;
            $linkStatus = qq |&nbsp;|;
            $corStatus = "000000";
            if ($umTeste->getHabRanking()) {
               $medSoma += $notaEnc;
               $medQtde++;
            }
         }
         if ($umTesteUsuario->getStatus() eq "F") { #Fazendo
            $statusAtual = "Fazendo Teste";
            $linkStatus = qq |&nbsp;|;
            $corStatus = "FF6600";
         }
         if ($umTesteUsuario->getStatus() eq "A") { #Aberto
            $statusAtual = "Teste Aberto";
            $linkStatus = qq |[<a href=# onClick=window.open("testes.cgi?opcao=iniciarTeste\&codigoTeste=${$umTeste}{'codigoTeste'}","","width=500,height=400,top=10,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Iniciar</a>]|;
#            $linkStatus = qq |[<a href="testes.cgi?opcao=iniciarTeste\&codigoTeste=${$umTeste}{'codigoTeste'}">Iniciar</a>]|;
            $corStatus = "FF0000";
         }
         if ($corLinha eq "FFFFFF") {
            $corLinha = "EEFFFF";
         } else {
            $corLinha = "FFFFFF";
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
                                <td width="400"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="0000FF"><img src="$iconeTeste" width="16" height="16" border=0>&nbsp;<img src="icones/testes.jpg" width=16 height=16 border=0></img>&nbsp;${$umTeste}{'titulo'}</font>
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
                                <td width="400"><div align="left"><font size="2"face="Verdana, Arial, Helvetica, sans-serif" color="000000">\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$notaEnc </font> <font size="1" face="Arial, Helvetica, sans-serif" color="$corStatus">$statusAtual</font> <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="000000">$linkStatus</font></div>
                                </td>                           
                                <td>
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000"></font></div>
                                </td>
                              </tr>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      $itemAtual --;
      }
   }


   my $mediaAluno = "0.00";
   if ($medSoma > 0) {
      $mediaAluno = sprintf("%5.2f",$medSoma/$medQtde);
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
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       <font color="000000">Média de notas no Ranking: <font color="0000FF">$mediaAluno</font>
                       </font>
                       </font>
                    </CENTER></TD>
                  </TR>
                  <TR>
                    <TD>
                      &nbsp;
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
# imprimirTelaIniciarTeste
#--------------------------------------------------------------------------------
# Método que inicia o teste de um aluno
#################################################################################
sub imprimirTelaIniciarTeste {

my $self = shift;


# if ($self->umUsuario->getPrivilegios() != 1) {
#   print "<!--";
#   die "Usuário não autorizado!\n";
# }

my $menuinf = $self->linkMenuInferior();

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;

my $umaResposta = new ClasseTesteResposta;
my $dadosRespostas = new DadosTestesRespostas;

my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;


my $codigoTeste = $self->query->param('codigoTeste');

my $codigoUsuario = $self->umUsuario->getCodigoUsuario();

my $umTesteUsuario = $dadosTestesUsuarios->selecionarTeste($codigoTeste,$codigoUsuario);

if ($umTesteUsuario->getStatus() ne "A") {
   print "<!--";
   die "Teste não está aberto!\n";
}

$dadosTestesUsuarios->iniciarTeste($codigoTeste,$codigoUsuario);

my $umTeste = $dadosTestes->selecionarTeste($codigoTeste);

my $totalItens = $umTeste->getNumQuestoes();

my @colecaoQuestoes = $dadosQuestoes->sortearQuestoes($codigoTeste,$totalItens);


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
          my @colecaoRespostas = $dadosRespostas->sortearRespostas($umaQuestao->getCodigoQuestao());
          my $texto = $umaQuestao->getTexto();
          my $codigoQuestao = $umaQuestao->getCodigoQuestao();
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                  <TR>
                    <TD>
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="70"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="FF0000"><div align="center" valign="top">$itemAtual</div></font></td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <img src="$iconeQuestao" width=16 height=16 border=0>&nbsp;<b>Questão:</b>
                           </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000">
                          $texto</font>
                          <input type="hidden" name="questoes" value="${$umaQuestao}{'codigoQuestao'}">
                          </td>
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
   my $corLinha = "FFFFFF";
   foreach $umaResposta (@colecaoRespostas) {
      if ($corLinha eq "FFFFFF") {
         $corLinha = "EEAA55";
      } else {
         $corLinha = "FFFFFF";
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |

                        <tr>
                          <td width="70" valign="top"><div align="right"><input type="radio" name="${$umaQuestao}{'codigoQuestao'}" value="${$umaResposta}{'codigoResposta'}"></div></td>
                          <td bgcolor="$corLinha"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000">${$umaResposta}{'texto'}
                          <input type="hidden" name="respOrd${$umaQuestao}{'codigoQuestao'}"  value="${$umaResposta}{'codigoResposta'}">
                          </font></td>
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
                    <TD height="2"><HR size="1"></TD>
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
                          <td>
                          <center>
                          <input type="hidden" name="codigoTeste" value="$codigoTeste">
                          <input type="hidden" name="opcao" value="avaliarTeste">
                          <input type="submit" value="Avaliar Teste">
                          </center>
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
                      &nbsp;</font></div>
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
# imprimirTelaAvaliarTeste
#--------------------------------------------------------------------------------
# Método que avalia o teste de um aluno
#################################################################################
sub imprimirTelaAvaliarTeste {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;

my $umaResposta = new ClasseTesteResposta;
my $dadosRespostas = new DadosTestesRespostas;

my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;


my $codigoTeste = $self->query->param('codigoTeste');

my $codigoUsuario = $self->umUsuario->getCodigoUsuario();

my $umTesteUsuario = $dadosTestesUsuarios->selecionarTeste($codigoTeste,$codigoUsuario);

if ($umTesteUsuario->getStatus() ne "F") {
   print "<!--";
   die "Teste não pode ser avaliado!\n";
}

my $umTeste = $dadosTestes->selecionarTeste($codigoTeste);

my $totalItens = $umTeste->getNumQuestoes();

my $historico = "";

my @questoesTeste = $self->query->param('questoes');

my @selecionadas;
my $i = 0;

foreach my $q (@questoesTeste) {
   my $r = $self->query->param($q);
   if ($r eq "") {
      print "<!--";
      die "Alguma questão não foi respondida, favor verifique!!!\n";
   }
   $historico .= "$q";
   $selecionadas[$i] = $r;
   $historico .= "|$r";
   my @respOrd = $self->query->param('respOrd'.$q);
   foreach $r (@respOrd) {
      $historico .= "|$r";
   }
   $historico .= "\n";
   $i++;
}

my $corretas = $dadosRespostas->qtdeCorretas(@selecionadas);

my $numQuestoes = $umTeste->getNumQuestoes();

my $nota = sprintf("%5.2f",($corretas*10)/$numQuestoes);

$umTesteUsuario->setDadosIU($codigoTeste,$codigoUsuario,$historico,$nota,$nota,"E");

$dadosTestesUsuarios->encerrarTeste($umTesteUsuario);


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
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=4>
                       <font color="000000">Nota final: <font color="0000FF">$nota</font></font>
                       </font>
                    </CENTER></TD>
                  </TR>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
                  <TR>
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       <font color="006600">Você acertou <b>$corretas</b> de <b>$numQuestoes</b> questões!</font>
                       </font>
                    </CENTER></TD>
                  </TR>

                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
                  <TR>
                    <TD><CENTER>
                    <INPUT TYPE="button" VALUE="Voltar" onclick="window.history.go(-1)"></INPUT>&nbsp;
                    <INPUT TYPE="button" VALUE="Fechar" onclick="window.close()"></INPUT>
                    </CENTER></TD>
                  </TR>
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
# imprimirTelaVisualizarTeste
#--------------------------------------------------------------------------------
# Método que visualiza o teste de um aluno
#################################################################################
sub imprimirTelaVisualizarTeste {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaQuestao = new ClasseTesteQuestao;
my $dadosQuestoes = new DadosTestesQuestoes;

my $umaResposta = new ClasseTesteResposta;
my $dadosRespostas = new DadosTestesRespostas;

my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $umTeste = new ClasseTeste;
my $dadosTestes = new DadosTestes;

my $codigoTeste = $self->query->param('codigoTeste');

my $codigoUsuario = $self->query->param('codigoUsuario');

my $umTesteUsuario = $dadosTestesUsuarios->selecionarTeste($codigoTeste,$codigoUsuario);

if (!($codigoUsuario == $self->umUsuario->getCodigoUsuario() || $self->umUsuario->getPrivilegios())) {
   print "<!--";
   die "Usuário não autorizado!\n";
}

# Temporario
#if ($self->umUsuario->getPrivilegios() != 1) {
#   print "<!--";
#   die "Favor aguardar, resultados somente no dia 27/03/2017!\n";
#}

my $limitado = 0;
if ($self->umUsuario->getPrivilegios() != 1) {
   $limitado = 1;
}

my $umTeste = $dadosTestes->selecionarTeste($codigoTeste);

my $totalItens = $umTeste->getNumQuestoes();

my @historico = split(/\n/ig,$umTesteUsuario->getHistorico());

my $corretas = 0;
my $numQuestoes = 0;
my $nota = $umTesteUsuario->getNota();
my $notaCorrigida = $umTesteUsuario->getNotaCorrigida();

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
                      
                         |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="2">
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                            Para conferir as suas respostas procure pelo professor no horário de atendimento!</font></div>
                          </td>
                        </tr>
                         |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


if (!($limitado)) { ############################ <<<- bloqueio para o aluno

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="2">
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                            Foram encontradas <b>$totalItens</b> questões. Mostrando <b>Todas</b>:</font></div>
                          </td>
                        </tr>
                         |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


} ############################ <<<- bloqueio para o aluno

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

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
      foreach my $linha (@historico) {
          my @colunas = split (/\|/ig,$linha);
          my $codQuestao = $colunas[0];
          $iconeQuestao = "icones/questao.jpg";
          $umaQuestao = $dadosQuestoes->selecionar($codQuestao);
          my $texto = $umaQuestao->getTexto();
          my $codigoQuestao = $umaQuestao->getCodigoQuestao();
          my @colecaoRespostas = $dadosRespostas->solicitar($codQuestao);
          $numQuestoes++;
          
          
if (!($limitado)) { ############################ <<<- bloqueio para o aluno
          
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                  <TR>
                    <TD>
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td width="70"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="FF0000"><div align="center" valign="top">$itemAtual</div></font></td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          <img src="$iconeQuestao" width=16 height=16 border=0>&nbsp;<b>Questão:</b>
                           </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="000000">
                          $texto</font>
                          </td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

} ############################ <<<- bloqueio para o aluno

   my $i = 1;
   my $corLinha = "FFFFFF";
   my $respMarcada = $colunas[1];
   for ($i = 2; $i <= scalar(@colunas)-1; $i++) {
      foreach my $umaResp (@colecaoRespostas) {
         if ($umaResp->getCodigoResposta() == $colunas[$i]) {
            $umaResposta = $umaResp;
         }
      }

      if ($corLinha eq "FFFFFF") {
         $corLinha = "EEAA55";
      } else {
         $corLinha = "FFFFFF";
      }

      my $iconeResp = qq |(\&nbsp;\&nbsp;)|;
      my $iconeMarc = "";
      if ($umaResposta->getCorreta()) {
         $iconeMarc = qq |<img src="icones/paradireita.jpg" width=16 height=16 border="0">|;
      }
      if ($umaResposta->getCodigoResposta() == $respMarcada) {
         $iconeResp = qq |(\&bull;)|;
      }
      if ($umaResposta->getCorreta() && $umaResposta->getCodigoResposta() == $respMarcada && $umaResposta->getCodigoResposta() == $respMarcada) {
         $iconeMarc = qq |<img src="icones/corrigido.jpg" width=16 height=16 border="0">|;
         $corretas++;
      }
      
if (!($limitado)) { ############################ <<<- bloqueio para o aluno

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |

                        <tr>
                          <td width="70" valign="top"><div align="right">$iconeMarc $iconeResp</div></td>
                          <td bgcolor="$corLinha"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000">${$umaResposta}{'texto'}
                          </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

} ############################ <<<- bloqueio para o aluno

      }
      
 if (!($limitado)) { ############################ <<<- bloqueio para o aluno

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                      </table>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">&nbsp;</TD>
                  </TR>
                  <TR>
                    <TD height="2"><HR size="1"></TD>
                  </TR>
                  <TR>
                    <TD height="2">&nbsp;</TD>
                  </TR>

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
} ############################ <<<- bloqueio para o aluno


         $itemAtual--;
      }
   }


   my $nomeUsuario = $umTesteUsuario->umUsuario->getNome();
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </table>
                          </td>
                        </tr>
                      </table>
                    </TD>
                  <TR>
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       <font color="006600"><b>$nomeUsuario</b></font>
                       </font>
                    </CENTER></TD>
                  </TR>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
                  <TR>
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=4>
                       <font color="000000">Nota final: <font color="0000FF">$nota</font></font>
                       </font>
                    </CENTER></TD>
                  </TR>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   if ($nota != $notaCorrigida) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                  <TR>
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=4>
                       <font color="000000">Nota corrigida: <font color="0000FF">$notaCorrigida</font></font>
                       </font>
                    </CENTER></TD>
                  </TR>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }

   if ($self->umUsuario->getPrivilegios()) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                  <TR>
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=3>
                       <font color="000000">Corrigir nota:
                       <input type="hidden" name="codigoTeste" value="$codigoTeste">
                       <input type="hidden" name="codigoUsuario" value="$codigoUsuario">
                       <input type="hidden" name="opcao" value="corrigirNotaTeste">
                       <input type="text" name="notaCorrigida" value="$notaCorrigida" size=10>&nbsp;
                       <input type="submit" value="Gravar">
                       </font>
                       </font>
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
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       <font color="006600">Você acertou <b>$corretas</b> de <b>$numQuestoes</b> questões!</font>
                       </font>
                    </CENTER></TD>
                  </TR>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

 if (!($limitado)) { ############################ <<<- bloqueio para o aluno
   
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                  <TR>
                    <TD><CENTER>
                       <font face="Verdana, Arial, Helvetica, sans-serif" size=1>
                       <font color="000000">
                       <img src="icones/corrigido.jpg" width=16 height=16 border="0"> - Marcou a resposta certa!&nbsp;&nbsp;
                       <img src="icones/paradireita.jpg" width=16 height=16 border="0"> - Errou e mostra qual era a certa!
                       <!-- <img src="icones/setadireita.jpg" border="0"> - Resposta que foi selecionada! -->
                       </font>
                       </font>
                    </CENTER></TD>
                  </TR>
                  <TR>
                    <TD>
                      &nbsp;
                    </TD>
                  </TR>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

} ############################ <<<- bloqueio para o aluno

                  
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |


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
# imprimirTelaCorrigindoNotaTeste
#--------------------------------------------------------------------------------
# Método que corrige a nota de um teste
#################################################################################
sub imprimirTelaCorrigindoNotaTeste {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }


   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;

   $dadosTestesUsuarios->corrigirNotaTeste($self->query->param('codigoTeste'),$self->query->param('codigoUsuario'),$self->query->param('notaCorrigida'));

#   $self->imprimirMensagem("Teste alterado com sucesso!","testes.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaRanking
#--------------------------------------------------------------------------------
# Método que imprime a tela para apresentar o Ranking
#################################################################################
sub imprimirTelaRanking {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $dadosUsuarios = new DadosUsuarios;

my $qtdeAlunos = $dadosUsuarios->quantidadeAlunosAtivos();
my $qtdeAlunosOnline = $dadosUsuarios->quantidadeAlunosOnline();

my @colecaoUsuarios = $dadosTestesUsuarios->solicitarRanking();

my $qtdeAlunos = scalar(@colecaoUsuarios);

my $colocados = 4;

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
                  size=2><b>Ranking</b></FONT></DIV>
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
                            Foram encontrados <b>$qtdeAlunos</b> alunos. Mostrando os <b>$colocados</b> primeiros colocados (m&eacute;dia &gt;= 6.00):</font></div>
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


   my $posicao = 0;
   my $contador = 0;
   my $nota = 11;
   my $notaAnt = 11;
   my $numTestes = 0;
   if ($qtdeAlunos > 0) {
      my $corLinha = "FFFFFF";
      foreach my $umUsuario (@colecaoUsuarios) {
         my $iconeUsuario = "icones/usuario_offline.jpg";

         my $codigoUsuario = $umUsuario->getCodigoUsuario();

         if ($corLinha eq "FFFFFF") {
            $corLinha = "EEFFFF";
         } else {
            $corLinha = "FFFFFF";
         }

         $notaAnt = $nota;
         $nota = $umUsuario->info->getMediaRank();
         $numTestes = $umUsuario->info->getTestesRank();
         if ($nota == $notaAnt) {
#            $contador++;
         } else {
            $contador++;
            $posicao = $contador;
         }

         my $iconeMedalha = "icones/med_pb.jpg";

         if ($posicao == 1) {
            $iconeMedalha = "icones/ouro.jpg";
         }
         if ($posicao == 2) {
            $iconeMedalha = "icones/prata.jpg";
         }
         if ($posicao == 3) {
            $iconeMedalha = "icones/bronze.jpg";
         }

         if ($posicao <= $colocados || $self->umUsuario->getPrivilegios() == 1) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="100">
                                      <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FF0000">$posicao</font></div>
                                      </td>
                                      <td width="300"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeMedalha" width=16 height=16 border="0">&nbsp;
                                      <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${$umUsuario}{'nome'}</a>
                                      </font></td>
                                      <td width="10">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                       </font></div>
                                      </td>
                                      <td width="200">
                                        <div align="right"><font size="1" face=", Arial, Helvetica, sans-serif" color="000000">$nota</font></div>
                                     </td>
                                      <td>
                                        <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="000000">&nbsp;&nbsp;($numTestes)</font></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         }
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
                       <img src="icones/ouro.jpg" width=16 height=16 border="0"> - Ouro!&nbsp;&nbsp;
                       <img src="icones/prata.jpg" width=16 height=16 border="0"> - Prata!&nbsp;&nbsp;
                       <img src="icones/bronze.jpg" width=16 height=16 border="0"> - Bronze!&nbsp;&nbsp;
                       <img src="icones/med_pb.jpg" width=16 height=16 border="0"> - Participação!&nbsp;&nbsp;
                       </font>
                       </font>
                    </CENTER></TD>
                  </TR>
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
                    <TD height="2">
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      &nbsp;</font></div>
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
# imprimirTelaRanking
#--------------------------------------------------------------------------------
# Método que imprime a tela para apresentar o Ranking
#################################################################################
sub imprimirTelaRankingTodos {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umTesteUsuario = new ClasseTesteUsuario;
my $dadosTestesUsuarios = new DadosTestesUsuarios;

my $dadosUsuarios = new DadosUsuarios;

my $qtdeAlunos = $dadosUsuarios->quantidadeAlunosAtivos();
my $qtdeAlunosOnline = $dadosUsuarios->quantidadeAlunosOnline();

my @colecaoUsuarios = $dadosTestesUsuarios->solicitarRankingTodos();

my $qtdeAlunos = scalar(@colecaoUsuarios);

my $colocados = 3;

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
                  size=2><b>Ranking</b></FONT></DIV>
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
                            Foram encontrados <b>$qtdeAlunos</b> alunos. Mostrando todos:</font></div>
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


   my $posicao = 0;
   my $contador = 0;
   my $nota = 11;
   my $notaAnt = 11;
   my $numTestes = 0;
   if ($qtdeAlunos > 0) {
      my $corLinha = "FFFFFF";
      foreach my $umUsuario (@colecaoUsuarios) {
         my $iconeUsuario = "icones/usuario_offline.jpg";

         my $codigoUsuario = $umUsuario->getCodigoUsuario();

         if ($corLinha eq "FFFFFF") {
            $corLinha = "EEFFFF";
         } else {
            $corLinha = "FFFFFF";
         }

         $notaAnt = $nota;
         $nota = $umUsuario->info->getMediaRank();
         $numTestes = $umUsuario->info->getTestesRank();
         if ($nota == $notaAnt) {
#            $contador++;
         } else {
            $contador++;
            $posicao = $contador;
         }

         my $iconeMedalha = "icones/med_pb.jpg";

         if ($posicao == 1) {
            $iconeMedalha = "icones/ouro.jpg";
         }
         if ($posicao == 2) {
            $iconeMedalha = "icones/prata.jpg";
         }
         if ($posicao == 3) {
            $iconeMedalha = "icones/bronze.jpg";
         }

         if ($self->umUsuario->getPrivilegios() == 1) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="3">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="9">
                                  <table width="746" border="0" cellspacing="0" cellpadding="0">
                                    <tr height=20>
                                      <td width="2">&nbsp;</td>
                                      <td width="100">
                                      <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#FF0000">$posicao</font></div>
                                      </td>
                                      <td width="300"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeMedalha" width=16 height=16 border="0">&nbsp;
                                      <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${$umUsuario}{'nome'}</a>
                                      </font></td>
                                      <td width="10">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                       </font></div>
                                      </td>
                                      <td width="200">
                                        <div align="right"><font size="1" face=", Arial, Helvetica, sans-serif" color="000000">$nota</font></div>
                                     </td>
                                      <td>
                                        <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="000000">&nbsp;&nbsp;($numTestes)</font></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         }
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
                       <img src="icones/ouro.jpg" width=16 height=16 border="0"> - Ouro!&nbsp;&nbsp;
                       <img src="icones/prata.jpg" width=16 height=16 border="0"> - Prata!&nbsp;&nbsp;
                       <img src="icones/bronze.jpg" width=16 height=16 border="0"> - Bronze!&nbsp;&nbsp;
                       <img src="icones/med_pb.jpg" width=16 height=16 border="0"> - Participação!&nbsp;&nbsp;
                       </font>
                       </font>
                    </CENTER></TD>
                  </TR>
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
                    <TD height="2">
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                      &nbsp;</font></div>
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
