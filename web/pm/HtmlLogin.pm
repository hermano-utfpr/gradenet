package HtmlLogin;

use strict;
use ClasseUsuario;
use DadosUsuarios;












#################################################################################
# HtmlLogin
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html padrão de acesso e login
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
   };
   bless ($self, $class);
   return ($self);
}
#################################################################################









#################################################################################
# imprimirTelaLogin
#--------------------------------------------------------------------------------
# Método que imprime a tela de acesso com login 
#################################################################################
sub imprimirTelaLogin {

my $self = shift;

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

my @colecaoUsuarios = $dadosUsuarios->solicitarLogins();


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD height="43"> 
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
                  size=2>Acesso ao Ambiente Virtual </FONT></B></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="186">&nbsp;</td>
                          <td width="70">&nbsp;</td>
                          <td width="40">&nbsp;</td>
                          <td width="450">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="186">&nbsp;</td>
                          <td width="70"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2>Usuário:</font></td>
                          <td width="40"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2><img src="icones/usuario.jpg" width="15" height="15"></font></td>
                          <td width="450"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2> 


                            <select name=login>
                              <option value="" selected>---SELECIONE---</option>

 
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   foreach $umUsuario (@colecaoUsuarios) {
      print "<option value=\"".$umUsuario->getLogin()."\">".$umUsuario->getLogin()."</option>";
   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </select>
                            </font></td>
                        </tr>
                        <tr> 
                          <td width="186">&nbsp;</td>
                          <td width="70">&nbsp;</td>
                          <td width="40">&nbsp;</td>
                          <td width="450">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="186" height="5">&nbsp;</td>
                          <td width="70" height="5"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2>Senha:</font></td>
                          <td width="40" height="5"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2><img src="icones/senha.jpg" width="15" height="15"></font></td>
                          <td width="450" height="5"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2> 
                            <input type=password maxlength=20 size=10 name=password>
                            <input type=submit value=Confirmar name=Submit>
                            </font></td>
                        </tr>
                        <tr> 
                          <td width="186">&nbsp;</td>
                          <td width="70">&nbsp;</td>
                          <td width="40">&nbsp;</td>
                          <td width="450">&nbsp;</td>
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
# imprimirTelaLogin
#--------------------------------------------------------------------------------
# Método que imprime a tela de acesso com login 
# 14/06/2021
#################################################################################
sub imprimirTelaContato {

my $self = shift;

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

my @colecaoUsuarios = $dadosUsuarios->solicitarLogins();


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD height="43"> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2><TBODY>
        <TR>
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="186">&nbsp;</td>
                          <td width="70">&nbsp;</td>
                          <td width="40">&nbsp;</td>
                          <td width="450">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="186">&nbsp;</td>
                          <td width="70"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#000000 
                  size=2><b>Contato:</b></font></td>
                          <td width="40"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2><img src="icones/email.jpg" width="15" height="15"></font></td>
                          <td width="450"><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#0000ff 
                  size=2> 


 
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   foreach $umUsuario (@colecaoUsuarios) {
       if ($umUsuario->getPrivilegios() == 1) {
            print "".$umUsuario->getEmail()."<br/>";
       }
   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                            </font></td>
                        </tr>
                        <tr> 
                          <td width="186">&nbsp;</td>
                          <td width="70">&nbsp;</td>
                          <td width="40">&nbsp;</td>
                          <td width="450">&nbsp;</td>
                        </tr>
                      </table>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
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
# imprimirMensagem
#--------------------------------------------------------------------------------
# Método que imprime uma Mensagem  
#################################################################################
sub imprimirMensagem {

my $self = shift;

my $mensagem = $_[0];
my $botaoVoltar = $_[1];

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD height="43"> 
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
                  size=2>Acesso ao Ambiente Virtual </FONT></B></DIV>
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
                       $mensagem
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









1;
