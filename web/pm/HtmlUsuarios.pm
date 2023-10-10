package HtmlUsuarios;

use strict;
use CGI;
use ClasseUsuario;
use DadosUsuarios;
use ClasseSessao;
use DadosSessoes;
use ClasseAmbiente;
use DadosAmbiente;
use FuncoesUteis;









#################################################################################
# HtmlUsuarios
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso ao cadastro de usuários
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
                  size=2>Usuários </FONT></B></DIV>
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
      $menuinf = qq |   [<a href="usuarios.cgi?opcao=incluir">Incluir Usu&aacute;rio</a>] - 
                        [<a href="usuarios.cgi">Mostrar Usuários</a>] - 
                        [<a href="usuarios.cgi?opcao=album">Álbum</a>] -
                        [<a href="usuarios.cgi?opcao=ultimosAcessos">&Uacute;ltimos Acessos</a>]|;
   } else {
      $menuinf = qq |   [<a href="usuarios.cgi">Mostrar Usuários</a>] - 
                        [<a href="usuarios.cgi?opcao=album">Álbum</a>]|;
   }

   return $menuinf;

}

#################################################################################









#################################################################################
# imprimirTelaUsuarios
#--------------------------------------------------------------------------------
# Método que imprime a tela com a listagem de todos usuários
#################################################################################
sub imprimirTelaUsuarios {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

my $qtdeUsuarios = $dadosUsuarios->quantidade();
my $qtdeUsuariosOnline = $dadosUsuarios->quantidadeUsuariosOnline();
my @colecaoUsuarios = $dadosUsuarios->solicitarUsuariosInformacoes();


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
                  size=2><B>Usu&aacute;rios</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD>
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">Foram
                        encontrados <b>$qtdeUsuarios</b> usu&aacute;rios e <b>$qtdeUsuariosOnline</b> est&atilde;o
                        on-line. Mostrando todos:</font></div>
                    </TD>
                  </TR>
                  <TR>
                    <TD height="2">
                      &nbsp;
                    </TD>
                  </TR>
                  <TR>
                    <TD>
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td height="2"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Alunos:</font></b></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="7">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"></font></td>
                                <td width="20"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"></font></td>
                                <td width="300"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Nome:</font></b></td>
                                <td width="120"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Login:</font></b></td>
                                <td width="200"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">E-mail</font></b></td>
                                <td>
                                  <div align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Acessos:</font></b></div>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   foreach $umUsuario (@colecaoUsuarios) {
      my $iconeUsuario = "icones/usuario_offline.jpg";
      my $b1 = "";
      my $b2 = "";
      my $acessos = "-";

      if ($umUsuario->getPrivilegios() == 0) {
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

         if ($self->umUsuario->getPrivilegios() == 1) {
            $acessos = $umUsuario->info->getAcessos();
         }
         if ($self->umUsuario->getCodigoUsuario() == $umUsuario->getCodigoUsuario()) {
            $acessos = $umUsuario->info->getAcessos();
            $b1 = "<B>";
            $b2 = "</B>";
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
                                      <td width="5">&nbsp;</td>
                                      <td width="20"></td>
                                      <td width="300"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeUsuario" width="15" height="15">&nbsp;
                                      <a href="usuarios.cgi?opcao=visualizar\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">$b1<font color="#0033FF">
                                       ${$umUsuario}{'nome'}</font>$b2</a></font></td>
                                      <td width="120">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                       ${$umUsuario}{'login'}</font></div>
                                      </td>
                                      <td width="200">
                                        <div align="left"><font size="1" face="Arial, Helvetica, sans-serif"><a href="mailto:${$umUsuario}{'email'}">${$umUsuario}{'email'}</a></font></div>
                                      </td>
                                      <td>
                                        <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">
                                        $acessos</font></div>
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

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                        <tr>
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="2">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Professores:</font></b></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="2">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"></font></td>
                                <td width="20"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"></font></td>
                                <td width="300"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Nome:</font></b></td>
                                <td width="120"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Login:</font></b></td>
                                <td width="200"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">E-mail</font></b></td>
                                <td>
                                  <div align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Acessos:</font></b></div>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


   foreach $umUsuario (@colecaoUsuarios) {
      my $iconeUsuario = "icones/usuario_offline.jpg";
      my $b1 = "";
      my $b2 = "";
      my $acessos = "-";

      if ($umUsuario->getPrivilegios() == 1) {
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

         if ($self->umUsuario->getPrivilegios() == 1) {
            $acessos = $umUsuario->info->getAcessos();
         }
         if ($self->umUsuario->getCodigoUsuario() == $umUsuario->getCodigoUsuario()) {
            $acessos = $umUsuario->info->getAcessos();
            $b1 = "<B>";
            $b2 = "</B>";
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
                                      <td width="5">&nbsp;</td>
                                      <td width="20"></td>
                                      <td width="300"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                      <img src="$iconeUsuario" width="15" height="15">&nbsp;
                                      <a href="usuarios.cgi?opcao=visualizar\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">$b1<font color="#0033FF">
                                       ${$umUsuario}{'nome'}</font>$b2</a></font></td>
                                      <td width="120">
                                        <div align="left"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                       ${$umUsuario}{'login'}</font></div>
                                      </td>
                                      <td width="200">
                                        <div align="left"><font size="1" face="Arial, Helvetica, sans-serif"><a href="mailto:${$umUsuario}{'email'}">${$umUsuario}{'email'}</a></font></div>
                                      </td>
                                      <td>
                                        <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">
                                        $acessos</font></div>
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

   my $mailTodos = "mailto:";
   my $mailTodosAlunos = "mailto:";
   my $mailTodosProfessores = "mailto:";

   foreach $umUsuario (@colecaoUsuarios) {
      if (length($umUsuario->getEmail()) > 0 && $umUsuario->getAtivo()) {
         $mailTodos = $mailTodos.$umUsuario->getEmail().", ";
         if ($umUsuario->getPrivilegios() == 0) {
            $mailTodosAlunos = $mailTodosAlunos.$umUsuario->getEmail().", ";
         } else {
            $mailTodosProfessores = $mailTodosProfessores.$umUsuario->getEmail().", ";
         }
      }
   }

   $mailTodos = substr($mailTodos,0,length($mailTodos)-2);
   $mailTodosAlunos = substr($mailTodosAlunos,0,length($mailTodosAlunos)-2);
   $mailTodosProfessores = substr($mailTodosProfessores,0,length($mailTodosProfessores)-2);


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="2">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td height="2"> <font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>E-mail
                                  para : </b></font><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><a
href="$mailTodos">Todos</a>
                                  ou <a href="$mailTodosAlunos">Todos Alunos</a> ou <a
href="$mailTodosProfessores">Todos
                                  Professores</a>.</font></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="2">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td height="2"> <font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>Texto:</b></font><font face="Verdana, Arial, Helvetica, sans-serif" size="2"> <a
href="usuarios.cgi?opcao=listarAlunos" target="_new">Lista de Alunos</a></font></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td height="9">
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td width="35" height="2"><img src="icones/usuaria_online.jpg" width="15" height="15"><img src="icones/usuario_online.jpg" width="15" height="15"></td>
                                <td width="150" height="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">=
                                  usu&aacute;rio(a) on-line</font></td>
                                <td width="35" height="2"><img src="icones/usuaria_offline.jpg" width="15" height="15"><img src="icones/usuario_offline.jpg" width="15" height="15"></td>
                                <td width="150" height="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">=
                                  usu&aacute;rio(a) off-line</font></td>
                                <td width="35" height="2"><img src="icones/usuaria_inativa.jpg" width="15" height="15"><img src="icones/usuario_inativo.jpg" width="15" height="15"></td>
                                <td height="2"><font face="Verdana, Arial, Helvetica, sans-serif" size="1">=
                                  usu&aacute;rio(a) inativo(a)</font></td>
                              </tr>
                            </table>
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
# imprimirTelaIncluirUsuario
#--------------------------------------------------------------------------------
# Método que imprime a tela para inclusão de um usuário
#################################################################################
sub imprimirTelaIncluirUsuario {

my $self = shift;
my $menuinf = $self->linkMenuInferior();

if ($self->umUsuario->getPrivilegios() != 1) {  
   print "<!--";
   die "Usuário não autorizado!";
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
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR> 
                          <TD> 
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY> 
                              <TR> 
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">Incluir 
                                  novo usu&aacute;rio:</font></B></TD>
                              </TR>
                              </TBODY> 
                            </TABLE>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=7>&nbsp; </TD>
                        </TR>
                        <TR> 
                          <TD> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nome:<font color="#FF0000">*</font></b></font></td>
                                <td> 
                                  <input type="text" name="nome" maxlength="60" size="50">
                                </td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Sexo:<font color="#FF0000">*</font></b></font></td>
                                <td> 
                                  <input type="radio" name="sexo" value="0" checked>
                                  <img src="icones/usuaria_online.jpg" width="15" height="15"> 
                                  <font face="Verdana, Arial, Helvetica, sans-serif" size="2">Feminino 
                                  <input type="radio" name="sexo" value="1">
                                  <img src="icones/usuario_online.jpg" width="15" height="15">Masculino 
                                  </font></td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Login:<font color="#FF0000">*</font></b></font></td>
                                <td> 
                                  <input type="text" name="login" size="20" maxlength="20">
                                </td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Senha:<font color="#FF0000">*</font></b></font></td>
                                <td> 
                                  <input type="password" name="password" size="20" maxlength="20">
                                </td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Senha 
                                  (confere):<font color="#FF0000">*</font></b></font></td>
                                <td> 
                                  <input type="password" name="confPassword" size="20" maxlength="20">
                                </td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Privil&eacute;gios:<font color="#FF0000">*</font></b></font></td>
                                <td> 
                                  <input type="radio" name="privilegios" value="0" checked>
                                  <font face="Verdana, Arial, Helvetica, sans-serif" size="2">Aluno 
                                  <input type="radio" name="privilegios" value="1">
                                  Professor</font> </td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>E-mail:</b></font></td>
                                <td> 
                                  <input type="text" name="email" size="50" maxlength="200">
                                </td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="180">&nbsp;</td>
                                <td> 
                                  <img src="icones/email.jpg" width="15" height="15">
                                  <input type="checkbox" name="notificar" value="1">
                                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Notificar 
                                  usu&aacute;rio por e-mail.</font> 
                                </td>
                              </tr>
                              <tr> 
                                <td width="5">&nbsp;</td>
                                <td width="20">&nbsp;</td>
                                <td width="150">&nbsp;</td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td width="5" height="18">&nbsp;</td>
                                <td width="20" height="18">&nbsp;</td>
                                <td width="150" height="18">&nbsp;</td>
                                <td height="18"> 
                                  <input type="hidden" name="opcao" value="incluindo">
                                  <input type="submit" name="Submit" value="Gravar">
                                </td>
                              </tr>
                            </table>
                          </TD>
                        </TR>
                        </TBODY> 
                      </TABLE>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" size=2>$menuinf</FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
  <TR>
        <TD height="2">&nbsp;</TD>
      </TR>
  <TR>
 
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################









#################################################################################
# imprimirTelaIncluindoUsuario
#--------------------------------------------------------------------------------
# Método que inclui um usuário e imprime o resultado
#################################################################################
sub imprimirTelaIncluindoUsuario {

my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {  
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umUsuario = new ClasseUsuario;
   my $dadosUsuarios = new DadosUsuarios;         

   $umUsuario->setDadosIU(0,
                          $self->query->param('nome'),
                          $self->query->param('login'),
                          $self->query->param('password'),
                          $self->query->param('confPassword'),
                          $self->query->param('privilegios'),
                          $self->query->param('email'),
                          $self->query->param('sexo'),
                          "00/00/0000",
                          "",
                          1);

   $dadosUsuarios->gravar($umUsuario);

   my $umAmbiente = new ClasseAmbiente; 
   my $dadosAmbiente = new DadosAmbiente;

   $umAmbiente = $dadosAmbiente->selecionar();

   my $texto = $umUsuario->getNome().", você acaba de ser cadastrado(a) no Ambiente Virtual:\n\n".$umAmbiente->getNomeDisciplina."\n".$umAmbiente->getTurma()."\n\nPara acessar:\n\nSite: ".$umAmbiente->getLink()."\nLogin: ".$umUsuario->getLogin()."\nSenha: ".$umUsuario->getPassword()."\n";

   if ($self->query->param('notificar') == 1) {
      EnviaMail($self->umUsuario->getEmail(),
                $umUsuario->getEmail(),
                $umAmbiente->getNomeDisciplina(),
                $texto
                );
   }

   $self->imprimirMensagem("Usuário incluído com sucesso!","usuarios.cgi",0);

}
#################################################################################









#################################################################################
# imprimirTelaVisualizar
#--------------------------------------------------------------------------------
# Método que imprime a tela para inclusão de um usuário
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;
my $menuinf = $self->linkMenuInferior();

my $dadosUsuarios = new DadosUsuarios;
my $umUsuario = $dadosUsuarios->selecionarUsuarioInformacoes($self->query->param('codigoUsuario'));

my $mostrarFoto = "";
if (!$umUsuario->getFoto()) {
   $mostrarFoto = "imagens/semfoto.jpg";
} else {
   $mostrarFoto = "foto.cgi?opcao=mostrar\&codigoUsuario=".$umUsuario->getCodigoUsuario;
}

my $idade = $umUsuario->getIdade();

my $dataNascimento = "";
my $acessos = "";
if ($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
   $dataNascimento = $umUsuario->getDataNascimento();
   $acessos = $umUsuario->info->getAcessos();
} else {
   $dataNascimento = "-";
   $acessos = "-";
}

      my $iconeUsuario = "";
      my $tipoUsuario = "";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluna";
         } else {
            $tipoUsuario = "Professora";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluno";
         } else {
            $tipoUsuario = "Professor";
         }
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
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR> 
                          <TD> 
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY> 
                              <TR> 
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">Visualizando 
                                  usu&aacute;rio: </font></B></TD>
                              </TR>
                              </TBODY> 
                            </TABLE>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=7>&nbsp; </TD>
                        </TR>
                        <TR> 
                          <TD> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="25" valign="top" align="right">&nbsp;</td>
                                <td width="100" valign="top" > 
                                  <table width="90" border="3" cellspacing="0" cellpadding="0" bordercolor="#000000" bgcolor="#000000">
                                    <tr> 
                                      <td width="90" height="120"> 
                                        <div align="center"><img src="$mostrarFoto" width="90" height="120"></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                                <td valign="top"> 
                                  <table width="570" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="120"><img src="$iconeUsuario" width="15" height="15"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><font color="#0000FF"> 
                                        $tipoUsuario</font></b></font> </td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nome:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><b>
                                       ${$umUsuario}{'nome'}</b></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Login:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                       ${$umUsuario}{'login'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>E-mail:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" 
color="#006600"><a href="mailto:${$umUsuario}{'email'}">${$umUsuario}{'email'}</a></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Idade:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $idade anos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Data 
                                        nasc.:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $dataNascimento</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Acessos:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $acessos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>&Uacute;ltimo 
                                        acesso: </b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      ${${$umUsuario}{'info'}}{'ultimoAcesso'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Perfil:</b></font></td>
                                      <td height="2"> 
                                        <p><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                        ${$umUsuario}{'perfil'}</font></p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                              </tr>
                            </table>
                          </TD>
                        </TR>
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {

      my $menuUsuario = "";
      if ($self->umUsuario->getCodigoUsuario() != $umUsuario->getCodigoUsuario()) {
         if ($umUsuario->getAtivo()) {
            $menuUsuario = qq | [<a href="usuarios.cgi?opcao=desativar\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">Desativar</a>] - |;
         } else {
            $menuUsuario = qq | [<a href="usuarios.cgi?opcao=ativar\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">Ativar</a>] - |;
         }
         $menuUsuario = qq |$menuUsuario [<a href="usuarios.cgi?opcao=excluir\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">Excluir</a>] - |;
      }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <TR> 
                          <TD height=2>&nbsp;</TD>
                        </TR>
                        <TR> 
                          <TD height=2> 
                            <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                            [<a href="usuarios.cgi?opcao=alterar\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">Alterar</a>] - 
                            [<a href="usuarios.cgi?opcao=trocarSenha\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">Trocar Senha</a>] - 
                            [<a href="usuarios.cgi?opcao=trocarFoto\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">Trocar Foto</a>] -
                            $menuUsuario 
                            [<a href="usuarios.cgi?opcao=ultimosAcessos\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">&Uacute;ltimos Acessos</a>]</font></div>
                          </TD>
                        </TR>
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                        </TBODY> 
                      </TABLE>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" size=2>$menuinf</FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
      <TR>
        <TD height="2">&nbsp;</TD>
      </TR>
 
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################









#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar dados de um usuário
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;
my $menuinf = $self->linkMenuInferior();

my $dadosUsuarios = new DadosUsuarios;
my $umUsuario = $dadosUsuarios->selecionarUsuarioInformacoes($self->query->param('codigoUsuario'));

if (!($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {
   print "<!--";
   die "Usuário não autorizado!";
}


my $mostrarFoto = "";
if (!$umUsuario->getFoto()) {
   $mostrarFoto = "imagens/semfoto.jpg";
} else {
   $mostrarFoto = "foto.cgi?opcao=mostrar\&codigoUsuario=".$umUsuario->getCodigoUsuario;
}

my $campoNome = "";
my $campoLogin = "";
if ($self->umUsuario->getPrivilegios() == 1) {
   $campoNome = qq|<input type="text" name="nome" size="50" maxlength="60" value="${$umUsuario}{'nome'}"> |;
   $campoLogin = qq|<input type="text" name="login" size="20" maxlength="20" value="${$umUsuario}{'login'}"> |;
} else {
   $campoNome = $umUsuario->getNome();
   $campoLogin = $umUsuario->getLogin();
}

my $sexoFeminino = "";
my $sexoMasculino = "";
if ($umUsuario->getSexo() == 0) {
   $sexoFeminino = "checked";
} else {
   $sexoMasculino = "checked";
}


      my $iconeUsuario = "";
      my $tipoUsuario = "";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluna";
         } else {
            $tipoUsuario = "Professora";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluno";
         } else {
            $tipoUsuario = "Professor";
         }
      }

      my $editaPerfil = getTextoHTML($umUsuario->getPerfil());   


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=746 
        border=2><TBODY>
        <TR>
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR> 
                          <TD> 
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY> 
                              <TR> 
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">Alterando</font><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2"> 
                                  usu&aacute;rio: </font></B></TD>
                              </TR>
                              </TBODY> 
                            </TABLE>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=7>&nbsp; </TD>
                        </TR>
                        <TR> 
                          <TD> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="25" valign="top" align="right">&nbsp;</td>
                                <td width="100" valign="top"> 
                                  <table width="90" border="3" cellspacing="0" cellpadding="0" bordercolor="#000000" bgcolor="#000000">
                                    <tr> 
                                      <td width="90" height="120"> 
                                        <div align="center"><img src="$mostrarFoto" width="90" height="120"></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                                <td valign="top"> 
                                  <table width="570" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="120"><img src="$iconeUsuario" width="15" height="15"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><font color="#0000FF"> 
                                        $tipoUsuario</font></b></font> </td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nome:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"> 
                                      $campoNome
                                        </font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Login:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"> 
                                      $campoLogin
                                        </font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>E-mail:</b></font></td>
                                      <td> 
                                        <input type="text" name="email" maxlength="200" size="40" value="${$umUsuario}{'email'}">
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Data 
                                        nasc.:</b></font></td>
                                      <td> 
                                        <input type="text" name="dataNascimento" size="10" maxlength="10" value="${$umUsuario}{'dataNascimento'}">
                                        <font size="2" face="Verdana, Arial, Helvetica, sans-serif">formato 
                                        (dd/mm/aaaa) </font> </td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Sexo:</b></font></td>
                                      <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif"> 
                                        <input type="radio" name="sexo" value="0" $sexoFeminino>
                                        <img src="icones/usuaria_online.jpg" width="15" height="15"> 
                                        Feminino 
                                        <input type="radio" name="sexo" value="1" $sexoMasculino>
                                        <img src="icones/usuario_online.jpg" width="15" height="15"> 
                                        Masculino </font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="6" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Perfil:</b></font></td>
                                      <td height="6"> 
                                        <p> 
                                          <textarea name="perfil" wrap="PHYSICAL" rows="5" cols="40">$editaPerfil</textarea>
                                          <font size="1" face="Arial, Helvetica, sans-serif"><br><a href=# onClick=window.open("pseudohtml.htm","","width=400,height=350,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Pseudo-HTML</a> / <a href=# onClick=window.open("pseudo.cgi","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Arquivos</a></font>
                                        </p>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2"> 
                                        <input type="hidden" name="codigoUsuario" value="${$umUsuario}{'codigoUsuario'}">
                                        <input type="hidden" name="opcao" value="alterando">
                                        <input type="submit" name="Submit" value="Gravar">
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <!-- <td width="5">&nbsp;</td> -->
                              </tr>
                            </table>
                          </TD>
                        </TR>
                        </TBODY> 
                      </TABLE>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" size=2>
                      $menuinf</A></FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
      <TR>
        <TD height="2">&nbsp;</TD>
      </TR>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

}

#################################################################################









#################################################################################
# imprimirTelaAlterando
#--------------------------------------------------------------------------------
# Método que altera um usuário e imprime o resultado
#################################################################################
sub imprimirTelaAlterando {

my $self = shift;

   my $umUsuario = new ClasseUsuario;
   my $dadosUsuarios = new DadosUsuarios;      

   $umUsuario = $dadosUsuarios->selecionarUsuarioCodigo($self->query->param('codigoUsuario'));

   if (!($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {
      print "<!--";
      die "Usuário não autorizado!";
   }


   if ($self->umUsuario->getPrivilegios() == 1) {
      $umUsuario->setNome($self->query->param('nome'));
      $umUsuario->setLogin($self->query->param('login'));
   }
   $umUsuario->setEmail($self->query->param('email'));
   $umUsuario->setDataNascimento($self->query->param('dataNascimento'));
   $umUsuario->setSexo($self->query->param('sexo'));
   $umUsuario->setPerfil($self->query->param('perfil'));

   $dadosUsuarios->gravar($umUsuario);

   $self->imprimirMensagem("Usuário alterado com sucesso!","usuarios.cgi?opcao=visualizar\&codigoUsuario=".$umUsuario->getCodigoUsuario,0);

}
#################################################################################









#################################################################################
# imprimirTelaTrocarFoto
#--------------------------------------------------------------------------------
# Método que imprime a tela para trocar foto de um usuário
#################################################################################
sub imprimirTelaTrocarFoto {

my $self = shift;
my $menuinf = $self->linkMenuInferior();

my $dadosUsuarios = new DadosUsuarios;
my $umUsuario = $dadosUsuarios->selecionarUsuarioInformacoes($self->query->param('codigoUsuario'));

if (!($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {
   print "<!--";
   die "Usuário não autorizado!";
}


my $mostrarFoto = "";
if (!$umUsuario->getFoto()) {
   $mostrarFoto = "imagens/semfoto.jpg";
} else {
   $mostrarFoto = "foto.cgi?opcao=mostrar\&codigoUsuario=".$umUsuario->getCodigoUsuario;
}

my $idade = $umUsuario->getIdade();

my $dataNascimento = "";
my $acessos = "";
if ($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
   $dataNascimento = $umUsuario->getDataNascimento();
   $acessos = $umUsuario->info->getAcessos();
} else {
   $dataNascimento = "-";
   $acessos = "-";
}

      my $iconeUsuario = "";
      my $tipoUsuario = "";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluna";
         } else {
            $tipoUsuario = "Professora";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluno";
         } else {
            $tipoUsuario = "Professor";
         }
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
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR> 
                          <TD> 
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY> 
                              <TR> 
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">Trocar foto do 
                                  usu&aacute;rio: </font></B></TD>
                              </TR>
                              </TBODY>
                            </TABLE>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=7>&nbsp; </TD>
                        </TR>
                        <TR> 
                          <TD> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="25" valign="top" align="right">&nbsp;</td>
                                <td width="100" valign="top" > 
                                  <table width="90" border="3" cellspacing="0" cellpadding="0" bordercolor="#000000" bgcolor="#000000">
                                    <tr> 
                                      <td width="90" height="120"> 
                                        <div align="center"><img src="$mostrarFoto" width="90" height="120"></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                                <td valign="top"> 
                                  <table width="570" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="120"><img src="$iconeUsuario" width="15" height="15"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><font color="#0000FF"> 
                                        $tipoUsuario</font></b></font> </td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nome:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><b>
                                       ${$umUsuario}{'nome'}</b></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Login:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                       ${$umUsuario}{'login'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>E-mail:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><a href="mailto:${$umUsuario}{'email'}">${$umUsuario}{'email'}</a></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Idade:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $idade anos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Data 
                                        nasc.:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $dataNascimento</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Acessos:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $acessos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>&Uacute;ltimo 
                                        acesso: </b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      ${${$umUsuario}{'info'}}{'ultimoAcesso'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Perfil:</b></font></td>
                                      <td height="2"> 
                                        <p><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                        ${$umUsuario}{'perfil'}</font></p>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Foto: 
                                        </b></font></td>
                                      <td height="2"> 
                                        <input type="file" name="foto" size="30">
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><img src="icones/foto.jpg" width="15" height="15"></b></font> 
                                        <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000"><b>Formato 
                                        jpeg/png - 90x120 pixels - m&aacute;ximo 60 
                                        KBytes.</b></font></td>
                                    </tr>
                                    <tr>
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2"> 
                                        <input type="hidden" name="codigoUsuario" value="${$umUsuario}{'codigoUsuario'}">
                                        <input type="hidden" name="opcao" value="trocandoFoto">
                                        <input type="submit" name="Submit" value="Gravar Foto">
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                              </tr>
                            </table>
                          </TD>
                        </TR>
                        </TBODY> 
                      </TABLE>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" size=2>
                      $menuinf</FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
      <TR>
        <TD height="2">&nbsp;</TD>
      </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

}

#################################################################################









#################################################################################
# imprimirTelaTrocandoFoto
#--------------------------------------------------------------------------------
# Método que troca a foto de um usuário e apresenta o resultado
#################################################################################
sub imprimirTelaTrocandoFoto {

my $self = shift;

   my $umUsuario = new ClasseUsuario;
   my $dadosUsuarios = new DadosUsuarios;      


   $umUsuario = $dadosUsuarios->selecionarUsuarioCodigo($self->query->param('codigoUsuario'));



   if (!($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {
      print "<!--";
      die "Usuário não autorizado!";
   }


   my $fotoUpload = $self->query->param('foto');
   
   my $fotoPronta;
   
   while (<$fotoUpload>) {
      $fotoPronta .= $_;
   }   

   
   $umUsuario->setFoto($fotoPronta);

   $dadosUsuarios->gravarFoto($umUsuario);

   $self->imprimirMensagem("Foto enviada com sucesso!","usuarios.cgi?opcao=visualizar\&codigoUsuario=".$umUsuario->getCodigoUsuario,0);

}
#################################################################################









#################################################################################
# imprimirTelaTrocarSenha
#--------------------------------------------------------------------------------
# Método que imprime a tela para trocar a senha de um usuário
#################################################################################
sub imprimirTelaTrocarSenha {

my $self = shift;
my $menuinf = $self->linkMenuInferior();

my $dadosUsuarios = new DadosUsuarios;
my $umUsuario = $dadosUsuarios->selecionarUsuarioInformacoes($self->query->param('codigoUsuario'));

if (!($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {
   print "<!--";
   die "Usuário não autorizado!";
}


my $mostrarFoto = "";
if (!$umUsuario->getFoto()) {
   $mostrarFoto = "imagens/semfoto.jpg";
} else {
   $mostrarFoto = "foto.cgi?opcao=mostrar\&codigoUsuario=".$umUsuario->getCodigoUsuario;
}

my $idade = $umUsuario->getIdade();

my $dataNascimento = "";
if ($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
   $dataNascimento = $umUsuario->getDataNascimento();
} else {
   $dataNascimento = "-";
}

my $loginQuemTroca = $self->umUsuario->getLogin();


      my $iconeUsuario = "";
      my $tipoUsuario = "";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluna";
         } else {
            $tipoUsuario = "Professora";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluno";
         } else {
            $tipoUsuario = "Professor";
         }
      }



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=746
        border=2><TBODY>
        <TR>
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY> 
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR> 
                          <TD> 
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY> 
                              <TR> 
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">Trocar senha do 
                                  usu&aacute;rio: </font></B></TD>
                              </TR>
                              </TBODY>
                            </TABLE>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=7>&nbsp; </TD>
                        </TR>
                        <TR> 
                          <TD> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="25" valign="top" align="right">&nbsp;</td>
                                <td width="100" valign="top" > 
                                  <table width="90" border="3" cellspacing="0" cellpadding="0" bordercolor="#000000" bgcolor="#000000">
                                    <tr> 
                                      <td width="90" height="120"> 
                                        <div align="center"><img src="$mostrarFoto" width="90" height="120"></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                                <td valign="top"> 
                                  <table width="570" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="120"><img src="$iconeUsuario" width="15" height="15"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><font color="#0000FF"> 
                                        $tipoUsuario</font></b></font> </td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nome:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><b>
                                       ${$umUsuario}{'nome'}</b></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Login:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                       ${$umUsuario}{'login'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>E-mail:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><a href="mailto:${$umUsuario}{'email'}">${$umUsuario}{'email'}</a></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Idade:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $idade anos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Data 
                                        nasc.:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $dataNascimento</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Acessos:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      ${${$umUsuario}{'info'}}{'acessos'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>&Uacute;ltimo 
                                        acesso: </b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      ${${$umUsuario}{'info'}}{'ultimoAcesso'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Perfil:</b></font></td>
                                      <td height="2"> 
                                        <p><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                        ${$umUsuario}{'perfil'}</font></p>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>

                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Senha 
                                        atual: </b></font></td>
                                      <td height="2">                                                   
                                        <input type="password" name="passwordAtual" size="20" maxlength="20">
                                        <img src="icones/senha.jpg" width="15" height="15">
                                        <font size="1" face="Verdana, Arial, Helvetica, sans-serif">(Senha 
                                        de <b>$loginQuemTroca</b>)</font> 
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nova 
                                        senha: </b></font></td>
                                      <td height="2">
                                        <input type="password" name="password" size="20" maxlength="20">
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Confere:</b></font></td>
                                      <td height="2">
                                        <input type="password" name="confPassword" size="20" maxlength="20">
                                      </td>
                                    </tr>
                                    <tr>
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">
                                         <img src="icones/email.jpg" width="15" height="15">
                                         <input type="checkbox" name="notificar" value="1">
                                         <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Notificar 
                                         usu&aacute;rio por e-mail.</font> 
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2"> 
                                        <input type="hidden" name="codigoUsuario" value="${$umUsuario}{'codigoUsuario'}">
                                        <input type="hidden" name="opcao" value="trocandoSenha">
                                        <input type="submit" name="Submit" value="Gravar Senha">
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                              </tr>
                            </table>
                          </TD>
                        </TR>
                        </TBODY>
                      </TABLE>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       $menuinf</FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
      <TR>
        <TD height="2">&nbsp;</TD>
      </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

}

#################################################################################









#################################################################################
# imprimirTelaTrocandoSenha
#--------------------------------------------------------------------------------
# Método que troca a senha de um usuário e apresenta o resultado
#################################################################################
sub imprimirTelaTrocandoSenha {

my $self = shift;

   my $umUsuario = new ClasseUsuario;
   my $dadosUsuarios = new DadosUsuarios;      

   $umUsuario = $dadosUsuarios->selecionarUsuarioCodigo($self->query->param('codigoUsuario'));

   if (!($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {
      print "<!--";
      die "Usuário não autorizado!";
   }

   $dadosUsuarios->verificarSenha($self->umUsuario->getLogin(),$self->query->param('passwordAtual'));

   $umUsuario->conferePassword($self->query->param('password'),$self->query->param('confPassword'));

   $dadosUsuarios->gravarSenha($umUsuario);

   my $umAmbiente = new ClasseAmbiente; 
   my $dadosAmbiente = new DadosAmbiente;

   $umAmbiente = $dadosAmbiente->selecionar();

   my $texto = $umUsuario->getNome().", sua senha foi alterada no Ambiente Virtual:\n\n".$umAmbiente->getNomeDisciplina."\n".$umAmbiente->getTurma()."\n\nPara acessar:\n\nSite: ".$umAmbiente->getLink()."\nLogin: ".$umUsuario->getLogin()."\nSenha: ".$umUsuario->getPassword()."\n";

   if ($self->query->param('notificar') == 1) {
      EnviaMail($self->umUsuario->getEmail(),
                $umUsuario->getEmail(),
                $umAmbiente->getNomeDisciplina(),
                $texto
                );
   }


   $self->imprimirMensagem("Senha gravada com sucesso!","usuarios.cgi?opcao=visualizar\&codigoUsuario=".$umUsuario->getCodigoUsuario,0);

}
#################################################################################









#################################################################################
# imprimirTelaAtivarDesativar
#--------------------------------------------------------------------------------
# Método que troca a foto de um usuário e apresenta o resultado
#################################################################################
sub imprimirTelaAtivarDesativar {

   my $self = shift; 

   my $umUsuario = new ClasseUsuario;
   my $dadosUsuarios = new DadosUsuarios;      

   $umUsuario = $dadosUsuarios->selecionarUsuarioCodigo($self->query->param('codigoUsuario'));

   if (!($self->umUsuario->getPrivilegios() == 1 && $umUsuario->getCodigoUsuario() != $self->umUsuario->getCodigoUsuario())) {
      print "<!--";
      die "Usuário não autorizado!";
   }
   
   if ($self->query->param('opcao') eq "ativar") {
      $umUsuario->setAtivo(1);
      $dadosUsuarios->gravar($umUsuario);
      $self->imprimirMensagem("Usuário foi ativado!","usuarios.cgi?opcao=visualizar\&codigoUsuario=".$umUsuario->getCodigoUsuario,0);
   } else {
      $umUsuario->setAtivo(0);
      $dadosUsuarios->gravar($umUsuario);
      $self->imprimirMensagem("Usuário foi desativado!","usuarios.cgi?opcao=visualizar\&codigoUsuario=".$umUsuario->getCodigoUsuario,0);
   }

}
#################################################################################









#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para 
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;
my $menuinf = $self->linkMenuInferior();

my $dadosUsuarios = new DadosUsuarios;
my $umUsuario = $dadosUsuarios->selecionarUsuarioInformacoes($self->query->param('codigoUsuario'));

if (!($self->umUsuario->getPrivilegios() == 1 && $umUsuario->getCodigoUsuario() != $self->umUsuario->getCodigoUsuario())) {
   print "<!--";
   die "Usuário não autorizado!";
}

my $mostrarFoto = "";
if (!$umUsuario->getFoto()) {
   $mostrarFoto = "imagens/semfoto.jpg";
} else {
   $mostrarFoto = "foto.cgi?opcao=mostrar\&codigoUsuario=".$umUsuario->getCodigoUsuario;
}

my $idade = $umUsuario->getIdade();

my $dataNascimento = "";
if ($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
   $dataNascimento = $umUsuario->getDataNascimento();
} else {
   $dataNascimento = "-";
}

      my $iconeUsuario = "";
      my $tipoUsuario = "";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluna";
         } else {
            $tipoUsuario = "Professora";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluno";
         } else {
            $tipoUsuario = "Professor";
         }
      }



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=746
        border=2><TBODY>
        <TR>
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY>
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR> 
                          <TD> 
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY> 
                              <TR> 
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">Excluir 
                                  usu&aacute;rio? </font></B></TD>
                              </TR>
                              </TBODY> 
                            </TABLE>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=7>&nbsp; </TD>
                        </TR>
                        <TR> 
                          <TD> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="25" valign="top" align="right">&nbsp;</td>
                                <td width="100" valign="top" > 
                                  <table width="90" border="3" cellspacing="0" cellpadding="0" bordercolor="#000000" bgcolor="#000000">
                                    <tr> 
                                      <td width="90" height="120"> 
                                        <div align="center"><img src="$mostrarFoto" width="90" height="120"></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                                <td valign="top"> 
                                  <table width="570" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="120"><img src="$iconeUsuario" width="15" height="15"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><font color="#0000FF"> 
                                        $tipoUsuario</font></b></font> </td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nome:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><b>
                                       ${$umUsuario}{'nome'}</b></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Login:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                       ${$umUsuario}{'login'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>E-mail:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><a href="mailto:${$umUsuario}{'email'}">${$umUsuario}{'email'}</a></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Idade:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $idade anos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Data 
                                        nasc.:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $dataNascimento</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Acessos:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      ${${$umUsuario}{'info'}}{'acessos'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>&Uacute;ltimo 
                                        acesso: </b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      ${${$umUsuario}{'info'}}{'ultimoAcesso'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Perfil:</b></font></td>
                                      <td height="2">
                                        <p><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                        ${$umUsuario}{'perfil'}</font></p>
                                      </td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2"> 
                                        <input type="hidden" name="codigoUsuario" value="${$umUsuario}{'codigoUsuario'}">
                                        <input type="hidden" name="opcao" value="excluindo">
                                        <input type="submit" name="Submit" value="Excluir usuário e todas suas informações">
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                              </tr>
                            </table>
                          </TD>
                        </TR>
                        </TBODY> 
                      </TABLE>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       $menuinf</FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
      <TR>
        <TD height="2">&nbsp;</TD>
      </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

}

#################################################################################









#################################################################################
# imprimirTelaExcluindo
#--------------------------------------------------------------------------------
# Método que exclui um usuário e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift; 

   my $umUsuario = new ClasseUsuario;
   my $dadosUsuarios = new DadosUsuarios;      

   $umUsuario = $dadosUsuarios->selecionarUsuarioCodigo($self->query->param('codigoUsuario'));

   if (!($self->umUsuario->getPrivilegios() == 1 && $umUsuario->getCodigoUsuario() != $self->umUsuario->getCodigoUsuario())) {
      print "<!--";
      die "Usuário não autorizado!";
   }
   
   $dadosUsuarios->excluir($umUsuario->getCodigoUsuario());

   $self->imprimirMensagem("Usuário foi excluído com sucesso!","usuarios.cgi",0);

}
#################################################################################









#################################################################################
# imprimirTelaAlbum
#--------------------------------------------------------------------------------
# Método que imprime um álbum com a foto de todos usuários
#################################################################################
sub imprimirTelaAlbum {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

my @colecaoUsuarios = $dadosUsuarios->solicitarUsuariosInformacoes();


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
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR>
                          <TD height="2">
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY>
                              <TR>
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">&Aacute;lbum:</font></B></TD>
                              </TR>
                              </TBODY>
                            </TABLE>
                          </TD>
                        </TR>
                        <TR>
                          <TD height=2>&nbsp; </TD>
                        </TR>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   my $colunas = 0;
   my $abreLinha = "";
   my $fechaLinha = "";

   foreach $umUsuario (@colecaoUsuarios) {

      $colunas++;
      if ($colunas > 4) {
         $colunas = 1;
      }

      if ($colunas == 1) {
         $abreLinha = qq| <TR> <TD> <table width="746" border="0" cellspacing="0" cellpadding="0"> <tr> |;
      } else {
         $abreLinha = "";
      }
      if ($colunas == 4) {
         $fechaLinha = " </tr> </table> </TD> </TR> ";
      } else {
         $fechaLinha = "";
      }

      my $mostrarFoto = "";
      if (!$umUsuario->getFoto()) {
         $mostrarFoto = "imagens/semfoto.jpg";
      } else {
         $mostrarFoto = "foto.cgi?opcao=mostrar\&codigoUsuario=".$umUsuario->getCodigoUsuario;
      }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                                $abreLinha
                                <td width="186">
                                  <table width="186" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td align="center">
                                        <table width="90" border="3" cellspacing="0" cellpadding="0" bordercolor="000000" bgcolor="000000">
                                          <tr>
                                            <td width="90" height="120">
                                              <div align="center"><a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")><img src="$mostrarFoto" width="90" height="120" border="0"></img></a></div>
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td height="2">
                                        <div align="center"><font face="Arial, Helvetica, sans-serif" size="1">
                                          ${$umUsuario}{'nome'} </font></div>
                                      </td>
                                    </tr>
                                    <tr>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                  </table>
                                </td>
                                $fechaLinha
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }

   my $acabouFotos = qq |<td width="186">&nbsp;</td>|;
   if ($colunas != 4) {
      foreach ($colunas = $colunas; $colunas <= 4; $colunas++) {
         print $acabouFotos;
      }
      $fechaLinha = " </tr> </table> </TD> </TR> ";
      print $fechaLinha;
   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |


                        </TBODY>
                      </TABLE>
                    </TD>
                  </TR>
                  <TR>
                    <TD height=2>
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR>
                    <TD height=2>
                      <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif" size=2>
                       $menuinf</FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE></TD></TR>
      <TR>
        <TD height="2">&nbsp;</TD>
      </TR>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

}

#################################################################################









#################################################################################
# imprimirTelaUltimosAcessos
#--------------------------------------------------------------------------------
# Método que imprime os últimosAcessos do site
#################################################################################
sub imprimirTelaUltimosAcessos {

my $self = shift;
my $menuinf = $self->linkMenuInferior();

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;
my $umaSessao = new ClasseSessao;
my $dadosSessoes = new DadosSessoes;


if ($self->query->param('codigoUsuario') > 0) {
   $umUsuario = $dadosUsuarios->selecionarUsuarioCodigo($self->query->param('codigoUsuario'));
}

if (!($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umUsuario->getCodigoUsuario())) {
   print "<!--";
   die "Usuário não autorizado!";
}

my $indicePagina = $self->query->param('indicePagina')*1;
my $acessosPagina = 0;
if ($umUsuario->getCodigoUsuario() > 0) {
   $acessosPagina = 100;
} else {
   $acessosPagina = 100;
}

my $totalAcessos = $dadosSessoes->quantidade($umUsuario->getCodigoUsuario());

if ($totalAcessos == 0) {
   die "Este usuário ainda não acessou o ambiente!";
}

my $numPaginas = int($totalAcessos/$acessosPagina);
if ($totalAcessos % $acessosPagina) {
   $numPaginas++;
}
if ($indicePagina == 0 || $indicePagina > $numPaginas) {
   $indicePagina = 1;
}
my $intervaloIni = $totalAcessos - (($indicePagina-1)*$acessosPagina);
my $intervaloFin = $totalAcessos - (($indicePagina)*$acessosPagina) + 1;
if ($intervaloFin <= 0) {
   $intervaloFin = 1;
}

my @colecaoSessoes = $dadosSessoes->solicitarParcial($indicePagina,$acessosPagina,$umUsuario->getCodigoUsuario());


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

        <TD>
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=746
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
                  size=2><B>Usu&aacute;rios</B></FONT> </DIV>
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
                          <td>
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td height="2"><center><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                        Foram encontrados <b>$totalAcessos</b> acessos.
                        Mostrando de <b>$intervaloIni</b> a <b>$intervaloFin</b>:</font></center>
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="7">&nbsp; </td>
                        </tr>


  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   my $acessoAtual = $intervaloIni;
   my $nomeUsuario = "";

   foreach $umaSessao (@colecaoSessoes) {
      if ($umaSessao->getDataFinal() eq "00/00/0000 00:00:00") {
         $nomeUsuario = "<b>".$umaSessao->umUsuario->getNome()."</b>";
      } else {
         $nomeUsuario = $umaSessao->umUsuario->getNome();
      }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td>
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="25">&nbsp;</td>
                                <td width="50">
                                  <div align="center"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><font color="#000000" size="1">$acessoAtual</font></font></div>
                                </td>
                                <td width="179"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#336600"><b>
                                  ${$umaSessao}{dataInicial}</b></font></td>
                                <td width="492"><font size="1" face="Verdana, Arial, Helvetica, sans-serif"><font color="#0000FF">
                                  $nomeUsuario</font></font></td>
                              </tr>
                              <tr>
                                <td width="25">&nbsp;</td>
                                <td width="50">&nbsp;</td>
                                <td width="179"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#336600"><font color="#999999">
                                  ${$umaSessao}{'dataFinal'} </font></font></td>
                                <td width="492"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">
                                  ${$umaSessao}{'ip'}</font></td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="50">&nbsp;</td>
                                <td colspan="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#999999">
                                  ${$umaSessao}{'browser'}</font></td>
                              </tr>
                            </table>
                          </td>
                        </tr>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      $acessoAtual--;
   }

 
   my $navegacao = "";
   my $anterior = $indicePagina - 1;
   my $proximo  = $indicePagina + 1;

   if ($anterior > 0) {
      $navegacao .= qq| <img src="icones/setaantes.jpg">[<a href="usuarios.cgi?opcao=ultimosAcessos\&indicePagina=$anterior\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">anterior</a>] |;
   }

   for (my $pag = 1; $pag <= $numPaginas; $pag++) {
      if ($pag == $indicePagina) {
         $navegacao .= qq|[<b>$pag</b>] |;
      } else {
         $navegacao .= qq|[<a href="usuarios.cgi?opcao=ultimosAcessos\&indicePagina=$pag\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">$pag</a>] |;
      }
   }

   if ($proximo <= $numPaginas && $numPaginas > 1) {
      $navegacao .= qq| [<a 
href="usuarios.cgi?opcao=ultimosAcessos\&indicePagina=$proximo\&codigoUsuario=${$umUsuario}{'codigoUsuario'}">pr&oacute;ximo</a>] <img src="icones/setadepois.jpg"> |;
   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr>
                          <td height="7">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td height="7"> 
                            <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
  
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
# imprimirTelaVisualizarPerfil
#--------------------------------------------------------------------------------
# Método que imprime o perfil do usuário em janela separada
#################################################################################
sub imprimirTelaVisualizarPerfil {

my $self = shift;
my $menuinf = "";

my $dadosUsuarios = new DadosUsuarios;
my $umUsuario = $dadosUsuarios->selecionarUsuarioInformacoes($self->query->param('codigoUsuario'));

my $dadosAmbiente = new DadosAmbiente;
my $umAmbiente = $dadosAmbiente->selecionar();

my $mostrarFoto = "";
if (!$umUsuario->getFoto()) {
   $mostrarFoto = "imagens/semfoto.jpg";
} else {
   $mostrarFoto = "foto.cgi?opcao=mostrar\&codigoUsuario=".$umUsuario->getCodigoUsuario;
}

my $idade = $umUsuario->getIdade();

my $dataNascimento = "";
my $acessos = "";
if ($self->umUsuario->getPrivilegios() == 1 || $umUsuario->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
   $dataNascimento = $umUsuario->getDataNascimento();
   $acessos = $umUsuario->info->getAcessos();
} else {
   $dataNascimento = "-";
   $acessos = "-";
}

      my $iconeUsuario = "";
      my $tipoUsuario = "";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluna";
         } else {
            $tipoUsuario = "Professora";
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
         if ($umUsuario->getPrivilegios() == 0) {
            $tipoUsuario = "Aluno";
         } else {
            $tipoUsuario = "Professor";
         }
      }



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
         
       <HTML> <HEAD> <TITLE>${$umUsuario}{'nome'}</TITLE> </HEAD>
       <BODY BGCOLOR="#${$umAmbiente}{'corDeFundo'}">

          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2><TBODY>
        <TR>
              <TD bgColor=#ffffff> 
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY>
                  <TR> 
                    <TD> 
                      <DIV align=center><FONT 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><B>Usuários</B></FONT> </DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD> 
                      <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                        <TBODY> 
                        <TR> 
                          <TD> 
                            <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                              <TBODY> 
                              <TR> 
                                <TD width=5 height=2>&nbsp;</TD>
                                <TD width=20 height=2>&nbsp;</TD>
                                <TD height=2><B><font face="Verdana, Arial, Helvetica, sans-serif" color="#cc0000" size="2">Visualizando 
                                  usu&aacute;rio: </font></B></TD>
                              </TR>
                              </TBODY> 
                            </TABLE>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=7>&nbsp; </TD>
                        </TR>
                        <TR> 
                          <TD> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="25" valign="top" align="right">&nbsp;</td>
                                <td width="100" valign="top" > 
                                  <table width="90" border="3" cellspacing="0" cellpadding="0" bordercolor="#000000" bgcolor="#000000">
                                    <tr> 
                                      <td width="90" height="120"> 
                                        <div align="center"><img src="$mostrarFoto" width="90" height="120"></div>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                                <td valign="top"> 
                                  <table width="570" border="0" cellspacing="0" cellpadding="0">
                                    <tr> 
                                      <td width="120"><img src="$iconeUsuario" width="15" height="15"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b><font color="#0000FF"> 
                                        $tipoUsuario</font></b></font> </td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Nome:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><b>
                                       ${$umUsuario}{'nome'}</b></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Login:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                       ${$umUsuario}{'login'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>E-mail:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><a href="mailto:${$umUsuario}{'email'}">${$umUsuario}{'email'}</a></font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Idade:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $idade anos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Data 
                                        nasc.:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $dataNascimento</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Acessos:</b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      $acessos</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>&Uacute;ltimo 
                                        acesso: </b></font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600">
                                      ${${$umUsuario}{'info'}}{'ultimoAcesso'}</font></td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top">&nbsp;</td>
                                      <td height="2">&nbsp;</td>
                                    </tr>
                                    <tr> 
                                      <td width="120" height="2" valign="top"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Perfil:</b></font></td>
                                      <td height="2">
                                        <p><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                        ${$umUsuario}{'perfil'}</font></p>
                                      </td>
                                    </tr>
                                  </table>
                                </td>
                                <td width="25">&nbsp;</td>
                              </tr>
                            </table>
                          </TD>
                        </TR>
                        <TR> 
                          <TD height=2>&nbsp;</TD>
                        </TR>
                        </TBODY> 
                      </TABLE>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height=2> 
                      <DIV align=center><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" size=2>&nbsp;</FONT></DIV>
                    </TD>
                  </TR>
                  </TBODY>
                </TABLE>
              </TD></TR></TBODY></TABLE>
          </BODY> </HTML>
 
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################










#################################################################################
# imprimirListaAlunos
#--------------------------------------------------------------------------------
# Método que imprime a tela com a listagem de todos usuários em formato texto
#################################################################################
sub imprimirListaAlunos {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

my @colecaoUsuarios = $dadosUsuarios->solicitarUsuariosInformacoes();

   foreach $umUsuario (@colecaoUsuarios) {
      if (!$umUsuario->getPrivilegios()) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |${$umUsuario}{'nome'}|;

print "<br>";

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

      }
   }

}
#################################################################################










1;
