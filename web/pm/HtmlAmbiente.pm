package HtmlAmbiente;

use strict;
use CGI;
use ClasseAmbiente;
use DadosAmbiente;
use FuncoesUteis;









#################################################################################
# HtmlAmbiente
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso as configuracoes do ambiente
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
                  size=2>Sobre</FONT></B></DIV>
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
      $menuinf = qq |   [<a href="ambiente.cgi">Sobre o Ambiente</a>] - 
                        [<a href="ambiente.cgi?opcao=alterar">Alterar Configuração</a>] - 
                        [<a href="ambiente.cgi?opcao=trocarCartaz">Trocar o Cartaz</a>] |;
   } else {
      $menuinf = qq | &nbsp; |;
   }

   return $menuinf;

}

#################################################################################








  

#################################################################################
# imprimirTelaAmbiente
#--------------------------------------------------------------------------------
# Método que imprime a tela com informações sobre o ambiente
#################################################################################
sub imprimirTelaAmbiente {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umAmbiente = new ClasseAmbiente;
my $dadosAmbiente = new DadosAmbiente;

$umAmbiente = $dadosAmbiente->selecionar();

my $cartaz = "";
if (!$umAmbiente->getCartaz()) {
   $cartaz = "imagens/semcartaz.jpg";
} else {
   $cartaz = "cartaz.cgi";
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
                  size=2><B>Sobre o Ambiente</B></FONT> </DIV>
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
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td height="2"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Sobre 
                                  a Disciplina:</font></b></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2"> 
                            <div align="center"><img src="$cartaz" width="360" height="40"></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF"><b><font color="#006600">
                             ${$umAmbiente}{'nomeDisciplina'}</font></b></font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><font size="2" color="#CC0000">
                              ${$umAmbiente}{'turma'}</font></font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF">Site: 
                              <a href="${$umAmbiente}{'link'}">${$umAmbiente}{'link'} 
                              </a></font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td height="2"> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="100">&nbsp;</td>
                                <td><font size="2" face="Verdana, Arial, Helvetica, sans-serif">${$umAmbiente}{'sobre'}</font></td>
                                <td width="100">&nbsp;</td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td>&nbsp; </td>
                        </tr>
                        <tr> 
                          <td height="2"> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td height="2"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Sobre 
                                  o GradeNet:</font></b></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr> 
                          <td height="2"> 
                            <div align="center"><img src="imagens/semcartaz.jpg" width="360" height="40"></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="3"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF"><b><font color="#006600">Ambiente 
                              Virtual de Apoio ao Ensino - GradeNet</font></b></font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="3"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1"><font size="2" color="#CC0000">Vers&atilde;o 
                              4.0 - 2004-2023</font></font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="3"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF">Site: 
                              <a href="http://www.gradenet.com.br">www.gradenet.com.br</a></font></div>
                          </td>
                        </tr>
                        <tr> 
                          <td height="3">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td height="3"> 
                            <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">Vectors and icons by <a href="https://www.svgrepo.com" target="_blank">SVG Repo</a>.
                          </td>
                        </tr>
                        <tr> 
                          <td height="3">&nbsp;</td>
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
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela com informações sobre o ambiente para serem alterados
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umAmbiente = new ClasseAmbiente;
my $dadosAmbiente = new DadosAmbiente;

$umAmbiente = $dadosAmbiente->selecionar();

my $cartaz = "";
if (!$umAmbiente->getCartaz()) {
   $cartaz = "imagens/semcartaz.jpg";
} else {
   $cartaz = "cartaz.cgi";
}

my $editaSobre = &getTextoHTML($umAmbiente->getSobre());

my $habCalendario = "";
if ($umAmbiente->getHabCalendario()) {
   $habCalendario = "checked";
}

my $habAtividades = "";
if ($umAmbiente->getHabAtividades()) {
   $habAtividades = "checked";
}

my $habAnotacoes = "";
if ($umAmbiente->getHabAnotacoes()) {
   $habAnotacoes = "checked";
}

my $habArquivos = "";
if ($umAmbiente->getHabArquivos()) {
   $habArquivos = "checked";
}

my $habMateriais = "";
if ($umAmbiente->getHabMateriais()) {
   $habMateriais = "checked";
}

my $habDesafios = "";
if ($umAmbiente->getHabDesafios()) {
   $habDesafios = "checked";
}

my $habPerguntas = "";
if ($umAmbiente->getHabPerguntas()) {
   $habPerguntas = "checked";
}

my $habTestes = "";
if ($umAmbiente->getHabTestes()) {
   $habTestes = "checked";
}

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR> 
        <TD> 
          <table bordercolor=#000000 cellspacing=0 cellpadding=0 width=750 
        border=2>
            <tbody> 
            <tr> 
              <td bgcolor=#ffffff> 
                <table cellspacing=0 cellpadding=0 width=746 border=0>
                  <tbody> 
                  <tr> 
                    <td> 
                      <div align=center><font 
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000 
                  size=2><b>Ambiente</b></font> </div>
                    </td>
                  </tr>
                  <tr> 
                    <td height="2"> 
                      <hr size=1>
                    </td>
                  </tr>
                  <tr> 
                    <td> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td> 
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr> 
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td height="2"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Alterar 
                                  c</font><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">onfigura&ccedil;&atilde;o 
                                  do ambiente:</font></b></td>
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
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Disciplina:</font></b></td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Disciplina:</font></b></td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"> 
                                  <input type="text" name="nomeDisciplina" size="50" maxlength="100" value="${$umAmbiente}{'nomeDisciplina'}">
                                  <font color="#990000"><b>**</b></font> </font></td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="180"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Turma/Curso/Local:</font></b></td>
                                <td> 
                                  <input type="text" name="turma" size="50" maxlength="100" value="${$umAmbiente}{'turma'}">
                                  <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><font color="#990000"><b>**</b></font> 
                                  </font> </td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Link 
                                  (acesso ao ambiente): </font></b></td>
                                <td> 
                                  <input type="text" name="link" size="50" maxlength="100" value="${$umAmbiente}{'link'}">
                                  <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><font color="#990000"><b>**</b></font> 
                                  </font> </td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220" valign="top"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Sobre 
                                  a disciplina:</font></b></td>
                                <td> 
                                  <textarea name="sobre" cols="40" rows="5" wrap="PHYSICAL">$editaSobre</textarea>
                                  <font size="1" face="Verdana, Arial, Helvetica, sans-serif"><br><a href=# onClick=window.open("pseudohtml.htm","","width=400,height=350,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Pseudo-HTML</a> / <a href=# onClick=window.open("pseudo.cgi","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>Arquivos</a></font>
                                </td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220">&nbsp;</td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#006600"><font color="#990000"><b>**</b></font></font> 
                                  <font size="1" face="Verdana, Arial, Helvetica, sans-serif">- 
                                  Ser&aacute; utilizado para preencher e-mails 
                                  de notifica&ccedil;&atilde;o.</font></td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Ambiente:</font></b></td>
                                <td>&nbsp;</td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220" valign="top"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Cartaz:</font></b></td>
                                <td height="28"><img src="$cartaz" width="360" height="40"></td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Cor 
                                  de fundo:</font></b></td>
                                <td> 
                                  <input type="text" name="corDeFundo" size="10" maxlength="6" value="${$umAmbiente}{'corDeFundo'}">
                                  <font size="2" face="Verdana, Arial, Helvetica, sans-serif">(<a href="tabelacores.cgi" target="_new">tabela 
                                  de cores</a>) </font></td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">T&iacute;tulo:</font></b></td>
                                <td> 
                                  <input type="text" name="titulo" size="50" value="${$umAmbiente}{'titulo'}">
                                </td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Cabe&ccedil;alho 
                                  (linha 1)</font></b></td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" color=#000000 size=2> 
                                  <input type="text" name="linha1" size="50" value="${$umAmbiente}{'linha1'}">
                                  </font></td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Cabe&ccedil;alho 
                                  (linha 2)</font></b></td>
                                <td> 
                                  <input type="text" name="linha2" size="50" value="${$umAmbiente}{'linha2'}">
                                </td>
                              </tr>
                              <tr> 
                                <td width="25">&nbsp;</td>
                                <td width="220"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Cabe&ccedil;alho 
                                  (linha 3)</font></b></td>
                                <td> 
                                  <input type="text" name="linha3" size="50" value="${$umAmbiente}{'linha3'}">
                                </td>
                              </tr>
                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Habilitar
                                  m&oacute;dulos : </font></b></td>
                                <td height="22">
                                  <table width="440" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="24" height="3">&nbsp; </td>
                                      <td width="25" height="3"><img src="icones/avisos.jpg" width="15" height="15"></td>
                                      <td width="120" height="3"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Avisos</font></td>
                                      <td height="3"><font size="1" face="Verdana, Arial, Helvetica, sans-serif">(sempre
                                        habilitado)</font></td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habCalendario" value="1" $habCalendario>
                                      </td>
                                      <td width="25"><img src="icones/calendario.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Calend&aacute;rio</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habAtividades" value="1" $habAtividades>
                                      </td>
                                      <td width="25"><img src="icones/atividades.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Atividades</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habAnotacoes" value="1" $habAnotacoes>
                                      </td>
                                      <td width="25"><img src="icones/anotacao.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Anota&ccedil;&otilde;es</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habArquivos" value="1" $habArquivos>
                                      </td>
                                      <td width="25"><img src="icones/arquivos.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Arquivos</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habMateriais" value="1" $habMateriais>
                                      </td>
                                      <td width="25"><img src="icones/materiais.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Materiais</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habDesafios" value="1" $habDesafios>
                                      </td>
                                      <td width="25"><img src="icones/notas.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Notas</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habPerguntas" value="1" $habPerguntas>
                                      </td>
                                      <td width="25"><img src="icones/perguntas.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Perguntas</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                        <input type="checkbox" name="habTestes" value="1" $habTestes>
                                      </td>
                                      <td width="25"><img src="icones/testes.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Testes</font></td>
                                      <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                      <td width="24">&nbsp;</td>
                                      <td width="25"><img src="icones/usuarios.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Usu&aacute;rios</font></td>
                                      <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">(sempre
                                        habilitado)</font></td>
                                    </tr>
                                    <tr>
                                      <td width="24">&nbsp;</td>
                                      <td width="25"><img src="icones/ambiente.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Ambiente</font></td>
                                      <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif">(sempre
                                        habilitado)</font></td>
                                    </tr>
                                    <tr>
                                      <td width="24">
                                      </td>
                                      <td width="25"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">&nbsp;</font></td>
                                      <td></td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>
                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Outras opções:</font></b></td>
                                <td height="22">
                                  <table width="440" border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                      <td width="24">
                                      </td>
                                      <td width="25"><img src="icones/arquivo.jpg" width="15" height="15"></td>
                                      <td width="120"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">Quota</font></td>
                                      <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><input type="text" name="kBytesArquivo" value="${$umAmbiente}{'kBytesArquivo'}" size="10"> KiloBytes/Aluno</font></td>
                                    </tr>
                                  </table>
                                </td>
                              </tr>

                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22">&nbsp;</td>
                                <td height="22">&nbsp;</td>
                              </tr>
                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22">&nbsp;</td>
                                <td height="22">
                                  <input type="hidden" name="opcao" value="alterando">
                                  <input type="submit" name="Submit" value="Gravar">
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="2">&nbsp;</td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr> 
                    <td height="2"> 
                      <hr size=1>
                    </td>
                  </tr>
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
# imprimirTelaAlterando
#--------------------------------------------------------------------------------
# Método que imprime a tela com informações sobre o ambiente para serem alterados
#################################################################################
sub imprimirTelaAlterando {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

if ($self->umUsuario->getPrivilegios() != 1) {
   die "Usuário não autorizado!";
}

my $umAmbiente = new ClasseAmbiente;
my $dadosAmbiente = new DadosAmbiente;

$umAmbiente->setDadosIU($self->query->param('nomeDisciplina'),
                        $self->query->param('turma'),
                        $self->query->param('link'),
                        $self->query->param('sobre'),
                        $self->query->param('corDeFundo'),
                        $self->query->param('titulo'),
                        $self->query->param('linha1'),
                        $self->query->param('linha2'),
                        $self->query->param('linha3'),
                        $self->query->param('habCalendario')*1,
                        $self->query->param('habAtividades')*1,
                        $self->query->param('habAnotacoes')*1,
                        $self->query->param('habArquivos')*1,
                        $self->query->param('habMateriais')*1,
                        $self->query->param('habDesafios')*1,
                        $self->query->param('habPerguntas')*1,
                        $self->query->param('habTestes')*1,
                        $self->query->param('kBytesArquivo')*1);

$dadosAmbiente->gravar($umAmbiente);

$self->imprimirMensagem("Configuração do ambiente gravada com sucesso!","ambiente.cgi",0);


}
#################################################################################










#################################################################################
# imprimirTelaTrocarCartaz
#--------------------------------------------------------------------------------
# Método que imprime a tela para trocar o cartaz
#################################################################################
sub imprimirTelaTrocarCartaz {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umAmbiente = new ClasseAmbiente;
my $dadosAmbiente = new DadosAmbiente;

$umAmbiente = $dadosAmbiente->selecionar();

my $cartaz = "";
if (!$umAmbiente->getCartaz()) {
   $cartaz = "imagens/semcartaz.jpg";
} else {
   $cartaz = "cartaz.cgi";
}

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR>
        <TD>
          <table bordercolor=#000000 cellspacing=0 cellpadding=0 width=750
        border=2>
            <tbody>
            <tr>
              <td bgcolor=#ffffff>
                <table cellspacing=0 cellpadding=0 width=746 border=0>
                  <tbody>
                  <tr>
                    <td>
                      <div align=center><font
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000
                  size=2><b>Ambiente</b></font> </div>
                    </td>
                  </tr>
                  <tr>
                    <td height="2">
                      <hr size=1>
                    </td>
                  </tr>
                  <tr>
                    <td>
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          <td>
                            <table width="746" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="5" height="2">&nbsp;</td>
                                <td width="20" height="2">&nbsp;</td>
                                <td height="2"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">Alterar
                                  c</font><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000">onfigura&ccedil;&atilde;o
                                  do ambiente:</font></b></td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td>
                            <table width="730" border="0" cellspacing="0" cellpadding="0">
                              <tr>
                                <td width="25" height="28">&nbsp;</td>
                                <td width="220" valign="top" height="28"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Cartaz
                                  atual:</font></b></td>
                                <td height="28" width="485"><img src="$cartaz" width="360" height="40"></td>
                              </tr>
                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Novo
                                  cartaz:</font></b></td>
                                <td height="22" width="485">
                                  <input type="file" name="cartaz" size="30">
                                </td>
                              </tr>
                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22">&nbsp;</td>
                                <td width="485"><font size="1" color="#CC0000"><img src="icones/foto.jpg" width="15" height="15">
                                  <b><font face="Verdana, Arial, Helvetica, sans-serif">Formato
                                  jpeg/png - 360 x 40 pixels - m&aacute;ximo de
                                  60 KBytes.</font></b></font> </td>
                              </tr>
                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22">&nbsp;</td>
                                <td height="22" width="485">&nbsp; </td>
                              </tr>
                              <tr>
                                <td width="25" height="22">&nbsp;</td>
                                <td width="220" valign="top" height="22">&nbsp;</td>
                                <td height="22" width="485">
                                  <input type="hidden" name="opcao" value="trocandoCartaz">
                                  <input type="submit" name="Submit" value="Gravar">
                                </td>
                              </tr>
                            </table>
                          </td>
                        </tr>
                        <tr>
                          <td height="2">&nbsp;</td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td height="2">
                      <hr size=1>
                    </td>
                  </tr>
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
# imprimirTelaTrocandoCartaz
#--------------------------------------------------------------------------------
# Método que imprime a tela que troca o cartaz e apresenta o resultado
#################################################################################
sub imprimirTelaTrocandoCartaz {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

if ($self->umUsuario->getPrivilegios() != 1) {
   die "Usuário não autorizado!";
}

my $umAmbiente = new ClasseAmbiente;
my $dadosAmbiente = new DadosAmbiente;

my $cartazUpload = $self->query->param('cartaz');

my $cartazPronto;

while (<$cartazUpload>) {
   $cartazPronto .= $_;
}

$umAmbiente->setCartaz($cartazPronto);

$dadosAmbiente->gravarCartaz($umAmbiente);

$self->imprimirMensagem("Cartaz do ambiente gravado com sucesso!","ambiente.cgi",0);


}
#################################################################################








1;
