package HtmlNotas;

use strict;
use CGI;
use FuncoesUteis;
use ClasseUsuario;
use DadosUsuarios;
use DadosAtividades;
use ClasseAtividade;
use DadosTestes;
use ClasseTeste;
use ClasseNotas;
use DadosNotas;
use ClasseTesteUsuario;
use DadosTestesUsuarios;







#################################################################################
# HtmlNotas
# criado  : 08/2016 e 02/2018
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para mostrar as Notas
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
                  size=2>Notas</FONT></B></DIV>
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

   return $menuinf;

}

#################################################################################





  

#################################################################################
# imprimirTelaNotas
#--------------------------------------------------------------------------------
# Método que imprime a tela com as notas do aluno
#################################################################################
sub imprimirTelaNotas {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umNotas = new ClasseNotas;
my $dadosNotas = new DadosNotas;

# Personalizado:
my $maximo_teste = 6;
my $qtde_testes = 8;

###### Para os alunos:

if ($self->umUsuario->getPrivilegios() != 1) {

   $self->imprimirTelaNotasAluno($self->umUsuario->getCodigoUsuario());

### Aqui para o professor

   } else {

   my $dadosUsuarios = new DadosUsuarios;
   my @colecaoUsuarios = $dadosUsuarios->solicitarLogins();
   
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
                  size=2><B>Notas:</B></FONT> </DIV>
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
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000"><b>Acessar notas dos alunos:</b></font></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2">&nbsp;</td>
                        </tr>


  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   my $lincor = "\#FFFFFF";
   
      foreach my $umUsuario (@colecaoUsuarios) {

      if ($umUsuario->getPrivilegios() != 1) {

         my $nome = $umUsuario->getNome();

         my $codigo = $umUsuario->getCodigoUsuario();

         if ($lincor eq "\#D0D0D0") {
             $lincor = "\#FFFFFF";
         } else {
             $lincor = "\#D0D0D0";
         }


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr bgcolor="$lincor"> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000">$nome</font></td>
                                <td width="50" height="5"><div align=right><font face="Verdana, Arial, Helvetica, sans-serif" color="000000" size=2>[<a href="notas.cgi?opcao=visualizar\&codigoAluno=$codigo">visualizar</a>]</font></div></td>
                                <td width="100" height="2">&nbsp;</td>
                                <td width="5" height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>


  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

      }

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td height="2">&nbsp;</td>
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

}
#################################################################################





#################################################################################
# imprimirTelaNotasAluno
#--------------------------------------------------------------------------------
# Método que imprime a tela com as notas de apenas um aluno
# 2018/02/26
#################################################################################
sub imprimirTelaNotasAluno {

   my $self = shift;
   my $codigoAluno = $_[0];

   my $notaTotal = 0;
   my $umaAtividade = new ClasseAtividade;
   my $dadosAtividades = new DadosAtividades;
 
 
   if (!($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $codigoAluno)) {
       
      die "Usuário não autorizado!\n";       
      
   }

   my @colecaoAtividades;
   @colecaoAtividades = $dadosAtividades->solicitarParcialAluno(1, 100, $self->umUsuario->info->getUltimoAcesso(),$codigoAluno);
   
   my $qtdeAtividades = $dadosAtividades->quantidade();
   
   my $umTeste = new ClasseTeste;
   my $dadosTestes = new DadosTestes;
   my $umTesteUsuario = new ClasseTesteUsuario;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;
   
   my $dadosUsuarios = new DadosUsuarios;
   my $umAluno = new ClasseUsuario;
   $umAluno = $dadosUsuarios->selecionarUsuarioCodigo($codigoAluno);
  
   my $nomeAluno = $umAluno->getNome();
   
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
                  size=2><B>Notas:</B></FONT> </DIV>
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
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Aluno: <b>$nomeAluno</b></font></td>
                              </tr>
                            </table>
                          </td>
                        </tr>                      
                        <tr> 
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Notas Parciais:</font></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
    |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

    if ($qtdeAtividades >0) {
        foreach $umaAtividade (@colecaoAtividades) {
            my $valorNota = $umaAtividade->getValorNota();
            my $notaAtividade = $umaAtividade->info->getNota();
            my $tituloAtividade = $umaAtividade->getTitulo();
            if ($notaAtividade < 0) {
                $notaAtividade = '-';
            }
            $umTeste = $dadosTestes->selecionarTesteAtividade($umaAtividade->getCodigoAtividade());
            my $tituloTeste = "-";
            my $notaTeste = "-";
            my $notaTesteFinal = "-";
            if ($umTeste->getCodigoTeste() > 0) {
                $umTesteUsuario = $dadosTestesUsuarios->selecionarNotaTeste($umTeste->getCodigoTeste(),$codigoAluno);
                $tituloTeste = $umTeste->getTitulo();
                $notaTeste = $umTesteUsuario->getNotaCorrigida();
                if ($umTesteUsuario->getCodigoUsuario == 0) {
                    $notaTesteFinal = "-";
                } else {
                    $notaTesteFinal = sprintf("%5.2f",$valorNota * ($notaTeste / 10));
                }
            }
        
            my $imprimeNotaAtividade = $notaAtividade;
            my $imprimeNotaTesteFinal = $notaTesteFinal;
            my $imprimeNotaObtida = "-";
            if ($notaAtividade > $notaTesteFinal) {
                $imprimeNotaAtividade = "$notaAtividade";
                if ($notaTesteFinal ne "-") {
                    $imprimeNotaTesteFinal = "<strike>$notaTesteFinal</strike>";
                }
                $imprimeNotaObtida = $notaAtividade; 
                $notaTotal += $notaAtividade;
            } else  {
                if ($notaAtividade ne "-") {
                    $imprimeNotaAtividade = "<strike>$notaAtividade</strike>";
                }
                $imprimeNotaTesteFinal = "$notaTesteFinal";
                $imprimeNotaObtida = $notaTesteFinal; 
                $notaTotal += $notaTesteFinal;
            }

            if ($valorNota > 0) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |

    
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF">$tituloAtividade</font></td>
                                <td width="10" height="5"><div align=center><font face="Verdana, Arial, Helvetica, sans-serif" color=#0000FF size=2>$imprimeNotaAtividade</font></div></td>
                                <td width="100" height="2">&nbsp;</td>
                                <td width="5" height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>      
                        
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

               if ($umTeste->getCodigoTeste() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |

                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF">$tituloTeste (nota no teste: $notaTeste)</font></td>
                                <td width="10" height="5"><div align=center><font face="Verdana, Arial, Helvetica, sans-serif" color=#0000FF size=2>$imprimeNotaTesteFinal</font></div></td>
                                <td width="100" height="2">&nbsp;</td>
                                <td width="5" height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

                }
                        
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Nota obtida (máximo: $valorNota):</font></td>
                                <td width="10" height="5"><div align=center><font face="Verdana, Arial, Helvetica, sans-serif" color=#000000 size=2>$imprimeNotaObtida</font></div></td>
                                <td width="100" height="2">&nbsp;</td>
                                <td width="5" height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>  
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            }
        }
    }
    my $notaTotalFormat = "";
    if ($notaTotal >= 10) {
        $notaTotalFormat = "10.00";
    } else {
        $notaTotalFormat = sprintf("%5.2f",$notaTotal);
    }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |

                         <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="5">&nbsp;</td>
                                <td width="10" height="5">&nbsp;</td>
                                <td width="100" height="2">&nbsp;</td>
                                <td width="5" height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>                        
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="30" height="2">&nbsp;</td>
                                <td height="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000"><b>Nota Total (máximo: 10.00):</b></font></td>
                                <td width="10" height="5"><div align=center><font face="Verdana, Arial, Helvetica, sans-serif" color=#000000 size=2><b>$notaTotalFormat</b></font></div></td>
                                <td width="100" height="2">&nbsp;</td>
                                <td width="5" height="2">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2">&nbsp;</td>
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
