package HtmlAtividadesCorrecoes;

use strict;
use CGI;
use ClasseAtividade;
use DadosAtividades;
use ClasseAtividadeCorrecao;
use DadosAtividadesCorrecoes;
use FuncoesUteis;








#################################################################################
# HtmlAtividadesCorrecoes
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso às correções de atividades
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
      umaAtividade => new ClasseAtividade,
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
# umaAtividade
#--------------------------------------------------------------------------------
# Atividade da seleção atual
#################################################################################
sub umaAtividade {
   my $self = shift;
   if (@_) {
      $self->{umaAtividade} = shift;
   }
   return $self->{umaAtividade};
}
#################################################################################










#################################################################################
# setAtividade
#--------------------------------------------------------------------------------
# Busca informações da base de dados e preenche automaticamente
#################################################################################
sub setAtividade {
   my $self = shift;
   my $codigoAtividade = $self->query->param('codigoAtividade')*1;
   my $dadosAtividades = new DadosAtividades;
   my $umaAtividade = $dadosAtividades->selecionarAtividade($codigoAtividade);
   my $codigoCorrecao = $self->query->param('codigoCorrecao')*1;
   if ($codigoCorrecao) {
      my $umaCorrecao = new ClasseAtividadeCorrecao;
      my $dadosCorrecoes = new DadosAtividadesCorrecoes;
      $umaCorrecao = $dadosCorrecoes->selecionarCorrecao($codigoCorrecao);
      if ($codigoAtividade != $umaCorrecao->getCodigoAtividade()) {
         die "Códigos de atividade e correção são incompatíveis!";
      }
   }
   $self->umaAtividade($umaAtividade);
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
                  size=2>Correção</FONT></B></DIV>
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

   my $dadosCorrecoes = new DadosAtividadesCorrecoes;
   my $umaCorrecao = new ClasseAtividadeCorrecao;

   my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();
   $umaCorrecao = $dadosCorrecoes->selecionarCorrecaoAtividade($codigoAtividade);

   if ($self->umUsuario->getPrivilegios() == 1) {
      if ($umaCorrecao->getCodigoCorrecao() == 0) {
          $menuinf = qq |[<a href="atividades.cgi?opcao=incluirCorrecao\&codigoAtividade=$codigoAtividade">Incluir Correção</a>] |;
      } else {
          $menuinf = qq |[<STRIKE>Incluir Correção</STRIKE>] |;
      }
   } else {
      $menuinf = "";
   }

   return $menuinf;

}

#################################################################################











#################################################################################
# imprimirTelaVisualizar
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar a correção da atividade
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaCorrecao = new ClasseAtividadeCorrecao;
my $dadosCorrecoes = new DadosAtividadesCorrecoes;

$umaCorrecao = $dadosCorrecoes->selecionarCorrecaoAtividade($self->query->param('codigoAtividade'));

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();


if ($self->umUsuario->getPrivilegios() == 1 || ($self->umaAtividade->expirouDataLimite() && $umaCorrecao->getCodigoCorrecao() > 0)) {

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
                  size=2><b>Correção</b></FONT></DIV>
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
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($umaCorrecao->getCodigoCorrecao() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          ${$umaCorrecao}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaCorrecao}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaCorrecao}{'umUsuario'}}{'nome'}</a>
                            em ${$umaCorrecao}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaCorrecao}{'texto'}</td>
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
          [<a href="atividades.cgi?opcao=alterarCorrecao\&codigoAtividade=$codigoAtividade\&codigoCorrecao=${$umaCorrecao}{'codigoCorrecao'}">Alterar</a>] -
          [<a href="atividades.cgi?opcao=excluirCorrecao\&codigoAtividade=$codigoAtividade\&codigoCorrecao=${$umaCorrecao}{'codigoCorrecao'}">Excluir</a>]
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   
      }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                    </TD>
                  </TR>
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

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


}
#################################################################################









#################################################################################
# imprimirTelaIncluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para incluir uma correção
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();


my $umaCorrecao = new ClasseAtividadeCorrecao;
my $dadosCorrecoes = new DadosAtividadesCorrecoes;

$umaCorrecao = $dadosCorrecoes->selecionarCorrecaoAtividade($self->query->param('codigoAtividade'));

if (!($umaCorrecao->getCodigoCorrecao() == 0 && $self->umUsuario->getPrivilegios() == 1)) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

my $titulo = substr("Re: ".$self->umaAtividade->getTitulo(),0,56);

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
                  size=2><b>Correção</b></FONT></DIV>
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
                            correção: </font></b></td>
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
                              <input type="text" name="titulo" size="60" maxlength="60" value="$titulo">
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
                            <input type="hidden" name="opcao" value="incluindoCorrecao">
                            <input type="hidden" name="codigoAtividade" value="$codigoAtividade">
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
# Método que inclui uma correção na atividade e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

my $umaCorrecao = new ClasseAtividadeCorrecao;
my $dadosCorrecoes = new DadosAtividadesCorrecoes;

$umaCorrecao = $dadosCorrecoes->selecionarCorrecaoAtividade($self->query->param('codigoAtividade'));

if (!($umaCorrecao->getCodigoCorrecao() == 0 && $self->umUsuario->getPrivilegios() == 1)) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

   $umaCorrecao->setDadosIU(0,$codigoAtividade,
                              $self->query->param('titulo'),
                              $self->query->param('texto'),
                              $self->umUsuario->getCodigoUsuario());

   $dadosCorrecoes->gravar($umaCorrecao);

   $self->imprimirMensagem("Correção incluída com sucesso!","atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade",0);

}

#################################################################################









#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para excluir a correção da atividade
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaCorrecao = new ClasseAtividadeCorrecao;
my $dadosCorrecoes = new DadosAtividadesCorrecoes;

$umaCorrecao = $dadosCorrecoes->selecionarCorrecao($self->query->param('codigoCorrecao'));

if (!($self->umUsuario->getPrivilegios() == 1 && $umaCorrecao->getCodigoCorrecao() > 0)) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();


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
                  size=2><b>Correcao</b></FONT></DIV>
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
                          ${$umaCorrecao}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaCorrecao}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaCorrecao}{'umUsuario'}}{'nome'}</a>
                            em ${$umaCorrecao}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaCorrecao}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">
                          <input type="hidden" name="opcao" value="excluindoCorrecao">
                          <input type="hidden" name="codigoAtividade" value="$codigoAtividade">
                          <input type="hidden" name="codigoCorrecao" value="${$umaCorrecao}{'codigoCorrecao'}">
                          <input type="submit" name="Excluir" value="Confirmar Exclusão">
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
# Método que exclui uma correção na atividade e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

my $umaCorrecao = new ClasseAtividadeCorrecao;
my $dadosCorrecoes = new DadosAtividadesCorrecoes;

$umaCorrecao = $dadosCorrecoes->selecionarCorrecao($self->query->param('codigoCorrecao'));

if (!($self->umUsuario->getPrivilegios() == 1 && $umaCorrecao->getCodigoCorrecao() > 0)) {
   die "Usuário não autorizado!\n";
}

   my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

   $dadosCorrecoes->excluir($umaCorrecao->getCodigoCorrecao());

   $self->imprimirMensagem("Correção excluída com sucesso!","atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade",0);

}

#################################################################################









#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar uma correção
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();


my $umaCorrecao = new ClasseAtividadeCorrecao;
my $dadosCorrecoes = new DadosAtividadesCorrecoes;

$umaCorrecao = $dadosCorrecoes->selecionarCorrecao($self->query->param('codigoCorrecao'));

if (!($umaCorrecao->getCodigoCorrecao() > 0 && $self->umUsuario->getPrivilegios() == 1)) {
   die "Usuário não autorizado !\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

my $editaTexto = &getTextoHTML($umaCorrecao->getTexto());

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
                  size=2><b>Correção</b></FONT></DIV>
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
                            correção: </font></b></td>
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
                              <input type="text" name="titulo" size="60" maxlength="60" value="${$umaCorrecao}{'titulo'}">
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
                          <td height="2"> 
                            <input type="hidden" name="opcao" value="alterandoCorrecao">
                            <input type="hidden" name="codigoAtividade" value="$codigoAtividade">
                            <input type="hidden" name="codigoCorrecao" value="${$umaCorrecao}{'codigoCorrecao'}">
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
# Método que altera uma correção na atividade e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

my $umaCorrecao = new ClasseAtividadeCorrecao;
my $dadosCorrecoes = new DadosAtividadesCorrecoes;

$umaCorrecao = $dadosCorrecoes->selecionarCorrecao($self->query->param('codigoCorrecao'));

if (!($umaCorrecao->getCodigoCorrecao() > 0 && $self->umUsuario->getPrivilegios() == 1)) {
   die "Usuário não autorizado!\n";
}

   my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

   $umaCorrecao->setDadosIU($umaCorrecao->getCodigoCorrecao(),
                              $codigoAtividade,
                              $self->query->param('titulo'),
                              $self->query->param('texto'),
                              $self->umUsuario->getCodigoUsuario());

   $dadosCorrecoes->gravar($umaCorrecao);

   $self->imprimirMensagem("Correção alterada com sucesso!","atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade",0);

}

#################################################################################










1;
