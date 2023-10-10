package HtmlAtividadesRespostas;

use strict;
use CGI;
use ClasseAtividade;
use DadosAtividades;
use ClasseAtividadeResposta;
use DadosAtividadesRespostas;
use FuncoesUteis;








#################################################################################
# HtmlAtividadesRespostas
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso às respostas de atividades
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
   my $codigoResposta = $self->query->param('codigoResposta')*1;
   if ($codigoResposta) {
      my $umaResposta = new ClasseAtividadeResposta;
      my $dadosRespostas = new DadosAtividadesRespostas;
      $umaResposta = $dadosRespostas->selecionarResposta($codigoResposta);
      if ($codigoAtividade != $umaResposta->getCodigoAtividade()) {
         die "Códigos de atividade e resposta são incompatíveis!";
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
                  size=2>Respostas</FONT></B></DIV>
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

   my $dadosRespostas = new DadosAtividadesRespostas;
   my $umaResposta = new ClasseAtividadeResposta;

   my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();
   $umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$codigoAtividade);

   my $expirou = $self->umaAtividade->expirouDataLimite();

   if ($self->umUsuario->getPrivilegios() == 1) {
     if (!$expirou || $self->umaAtividade->getValorNota() == 0) {
          $menuinf = qq |   [<a href="atividades.cgi?opcao=atribuirNotas\&codigoAtividade=$codigoAtividade">Atribuir Notas</a>] -
                            [<a href="atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade">Mostrar Respostas</a>] - 
                        [<a href="atividades.cgi?opcao=estenderRespostas\&codigoAtividade=$codigoAtividade">Estender Respostas</a>] 
                        |;
       } else {
          $menuinf = qq |  [<a href="atividades.cgi?opcao=atribuirNotas\&codigoAtividade=$codigoAtividade">Atribuir Notas</a>] -
                           [<a href="atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade">Mostrar Respostas</a>] - 
                        [<a href="atividades.cgi?opcao=estenderRespostas\&codigoAtividade=$codigoAtividade">Estender Respostas</a>] 
                        |;
       }
   } else {
      if ($umaResposta->getCodigoResposta()>0 || $expirou) {      
         $menuinf .= qq |   [<STRIKE>Incluir Resposta</STRIKE>] - |;
      } else {
         $menuinf .= qq |   [<a href="atividades.cgi?opcao=incluirResposta\&codigoAtividade=$codigoAtividade">Incluir Resposta</a>] - |;

      }
      $menuinf .= qq |   [<a href="atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade">Mostrar Respostas</a>] - |;
      if ($expirou) {
            $menuinf .= qq | [<a href="atividades.cgi?opcao=estenderRespostas\&codigoAtividade=$codigoAtividade">Estender Respostas</a>] |;
      } else {
            $menuinf .= qq | [<STRIKE>Estender Respostas</STRIKE>] |;
      }
   }

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaRespostas
#--------------------------------------------------------------------------------
# Método que imprime a tela com respostas
#################################################################################
sub imprimirTelaRespostas {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

my $totalItens = $dadosRespostas->quantidadeRespostas($self->umaAtividade->getCodigoAtividade());

my @colecaoRespostas = $dadosRespostas->solicitarRespostas($self->umaAtividade->getCodigoAtividade());

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
                  size=2><b>Respostas</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> respostas. Mostrando <b>todas</b>:</font></div>
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
   my $nota = "-";
   if ($totalItens > 0) {
      foreach $umaResposta (@colecaoRespostas) {
         if ($umaResposta->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
            $titulo = qq |<b><a href="atividades.cgi?opcao=visualizarResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a></b>|;
         } else {
 	    #if ($self->umUsuario->getPrivilegios() == 1 || $self->umaAtividade->expirouDataLimite()) {
            if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
               $titulo = qq |<a href="atividades.cgi?opcao=visualizarResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a>|;
            } else {
               $titulo = $umaResposta->getTitulo();
            }
         }

         if ($self->umaAtividade->getValorNota() > 0) {
            if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
               if ($umaResposta->getNota() >= 0) {
                  $nota = $umaResposta->getNota();
               } else {
                  $nota = "Sem Nota!";
               }
            } else {
               $nota = "-";
            }
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
                                    ${$umaResposta}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#0000FF">$titulo
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>)</font></font></td>
                                <td width="30"> 
                                </td>
                              </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaAtividade->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                              <tr> 
                                <td width="25"> 
                                </td>
                                <td width="30"> 
                                </td>
                                <td width="150"> 
                                </td>
                                <td>
                                  <div align="left">
                                  <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                                  Nota : <b>$nota</b></font></div>
                               </td>
                              </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
            }
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
# imprimirTelaVisualizar
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar a resposta da atividade
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

$umaResposta = $dadosRespostas->selecionarResposta($self->query->param('codigoResposta'));

#if (!($self->umUsuario->getPrivilegios() == 1 || $self->umaAtividade->expirouDataLimite() || ($self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()))) {
if (!($self->umUsuario->getPrivilegios() == 1 || ($self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()))) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();


my $nota = "-";
if ($self->umaAtividade->getValorNota() > 0) {
   if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
      if ($umaResposta->getNota() >= 0) {
          $nota = $umaResposta->getNota();
      } else {
          $nota = "Sem Nota!";
      }
    } else {
      $nota = "-";
    }
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
                  size=2><b>Respostas</b></FONT></DIV>
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
                          ${$umaResposta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaResposta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaAtividade->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          Nota: <b>$nota</b></font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

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
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaResposta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if (length($umaResposta->getNomeAnexo()) > 0 && $self->umaAtividade->getHabAnexo()) {
      my $tamAnexo = &TamanhoBytes(length($umaResposta->getAnexo()));
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <img src="icones/arquivo.jpg" width=16 height=16 border="0">&nbsp;
                           <a href="anexo.cgi?opcao=baixar\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'nomeAnexo'}</a> $tamAnexo</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

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

   if ($self->umUsuario->getPrivilegios() == 1 || (!$self->umaAtividade->expirouDataLimite() && $umaResposta->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario())) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

          [<a href="atividades.cgi?opcao=alterarResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">Alterar</a>] - [<a href="atividades.cgi?opcao=excluirResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">Excluir</a>]
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
# Método que imprime a tela para incluir uma resposta
#################################################################################
sub imprimirTelaIncluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();


my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoAtividade'));

if (!(!$self->umaAtividade->expirouDataLimite() && $umaResposta->getCodigoResposta() == 0)) {
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
                  size=2><b>Respostas</b></FONT></DIV>
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
                            resposta: </font></b></td>
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
                             <font size="2" face="Verdana, Arial, Helvetica, sans-serif">$titulo</font></td>
                              <input type="hidden" name="titulo" size="60" maxlength="60" value="$titulo">
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
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($self->umaAtividade->getHabAnexo()) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Anexar:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <img src="icones/arquivo.jpg" width=16 height=16 border="0">
                              <input type="file" name="anexo" size="30">
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">
                            <input type="hidden" name="opcao" value="incluindoResposta">
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
# Método que inclui uma resposta na atividade e apresenta o resultado
#################################################################################
sub imprimirTelaIncluindo {

   my $self = shift;

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoAtividade'));

if (!(!$self->umaAtividade->expirouDataLimite() && $umaResposta->getCodigoResposta() == 0)) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

my $titulo = substr("Re: ".$self->umaAtividade->getTitulo(),0,56);

my $nomeAnexo = $self->query->param('anexo');

$nomeAnexo =~ s/ /_/ig;
$nomeAnexo =~ s/\:/_/ig;
$nomeAnexo =~ s/@/_/ig;

my @grvNome = split(/\\/,$nomeAnexo);

foreach my $parteNome (@grvNome) {
   $nomeAnexo = $parteNome;
}

   $umaResposta->setDadosIU(0,$codigoAtividade,
                              $titulo,
                              $self->query->param('texto'),
                              "",
                              $self->umUsuario->getCodigoUsuario());

   $dadosRespostas->gravar($umaResposta);

   if ($self->umaAtividade->getHabAnexo() && length($nomeAnexo) > 0) {
      $umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoAtividade'));

      my $arqUpload = $self->query->param('anexo');
      my $arqPronto;
      while (<$arqUpload>) {
         $arqPronto .= $_;
      }
      $umaResposta->setAnexo($arqPronto);
      $umaResposta->setNomeAnexo($nomeAnexo);
      $dadosRespostas->gravarAnexo($umaResposta);
   }

   $self->imprimirMensagem("Resposta incluída com sucesso!","atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade",0);

}

#################################################################################









#################################################################################
# imprimirTelaAlterar
#--------------------------------------------------------------------------------
# Método que imprime a tela para alterar uma resposta
#################################################################################
sub imprimirTelaAlterar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();


my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoAtividade'));

if (!(!$self->umaAtividade->expirouDataLimite())) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

my $titulo = substr("Re: ".$self->umaAtividade->getTitulo(),0,56);

my $editaTexto = &getTextoHTML($umaResposta->getTexto());

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
                  size=2><b>Respostas</b></FONT></DIV>
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
                            resposta: </font></b></td>
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
                             <font size="2" face="Verdana, Arial, Helvetica, sans-serif">$titulo</font></td>
                              <input type="hidden" name="titulo" size="60" maxlength="60" value="$titulo">
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
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($self->umaAtividade->getHabAnexo()) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Anexar:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                              <img src="icones/arquivo.jpg" width=16 height=16 border="0">
                              <input type="file" name="anexo" size="30">
                          </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">
                            <input type="hidden" name="opcao" value="alterandoResposta">
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
# imprimirTelaAlterando
#--------------------------------------------------------------------------------
# Método que altera uma resposta na atividade e apresenta o resultado
#################################################################################
sub imprimirTelaAlterando {

   my $self = shift;

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

$umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoAtividade'));

if (!(!$self->umaAtividade->expirouDataLimite())) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

my $titulo = substr("Re: ".$self->umaAtividade->getTitulo(),0,56);

my $nomeAnexo = $self->query->param('anexo');

$nomeAnexo =~ s/ /_/ig;
$nomeAnexo =~ s/\:/_/ig;
$nomeAnexo =~ s/@/_/ig;

my @grvNome = split(/\\/,$nomeAnexo);

foreach my $parteNome (@grvNome) {
   $nomeAnexo = $parteNome;
}

   $umaResposta->setDadosIU($umaResposta->getCodigoResposta(),$codigoAtividade,
                              $titulo,
                              $self->query->param('texto'),
                              "",
                              $self->umUsuario->getCodigoUsuario());

   $dadosRespostas->gravar($umaResposta);

   if ($self->umaAtividade->getHabAnexo() && length($nomeAnexo) > 0) {
      $umaResposta = $dadosRespostas->selecionarRespostaUsuario($self->umUsuario->getCodigoUsuario(),$self->query->param('codigoAtividade'));

      my $arqUpload = $self->query->param('anexo');
      my $arqPronto;
      while (<$arqUpload>) {
         $arqPronto .= $_;
      }
      $umaResposta->setAnexo($arqPronto);
      $umaResposta->setNomeAnexo($nomeAnexo);
      $dadosRespostas->gravarAnexo($umaResposta);
   }

   $self->imprimirMensagem("Resposta alterada com sucesso!","atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade",0);

}

#################################################################################









#################################################################################
# imprimirTelaExcluir
#--------------------------------------------------------------------------------
# Método que imprime a tela para excluir a resposta da atividade
#################################################################################
sub imprimirTelaExcluir {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

$umaResposta = $dadosRespostas->selecionarResposta($self->query->param('codigoResposta'));

if (!($self->umUsuario->getPrivilegios() == 1 || (!$self->umaAtividade->expirouDataLimite() && ($self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario())))) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

my $nota = "-";
if ($self->umaAtividade->getValorNota() > 0) {
   if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
      if ($umaResposta->getNota() >= 0) {
          $nota = $umaResposta->getNota();
      } else {
          $nota = "Sem Nota!";
      }
    } else {
      $nota = "-";
    }
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
                  size=2><b>Respostas</b></FONT></DIV>
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
                          ${$umaResposta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaResposta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaAtividade->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          Nota: <b>$nota</b></font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

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
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaResposta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   
   if (length($umaResposta->getNomeAnexo()) > 0 && $self->umaAtividade->getHabAnexo()) {

      my $tamAnexo = &TamanhoBytes(length($umaResposta->getAnexo()));

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <img src="icones/arquivo.jpg" width=16 height=16 border="0">&nbsp;
                           <a href="anexo.cgi?opcao=baixar\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'nomeAnexo'}</a> $tamAnexo</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

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
                          <input type="hidden" name="opcao" value="excluindoResposta">
                          <input type="hidden" name="codigoAtividade" value="$codigoAtividade">
                          <input type="hidden" name="codigoResposta" value="${$umaResposta}{'codigoResposta'}">
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
# Método que exclui uma resposta na atividade e apresenta o resultado
#################################################################################
sub imprimirTelaExcluindo {

   my $self = shift;

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

$umaResposta = $dadosRespostas->selecionarResposta($self->query->param('codigoResposta'));

if (!($self->umUsuario->getPrivilegios() == 1 || (!$self->umaAtividade->expirouDataLimite() && ($self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) && $umaResposta->getCodigoAtividade() == $self->umaAtividade->getCodigoAtividade()))) {
   die "Usuário não autorizado!\n";
}

my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();

   $dadosRespostas->excluir($umaResposta->getCodigoResposta());

   $self->imprimirMensagem("Resposta excluída com sucesso!","atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade",0);

}

#################################################################################










#################################################################################
# imprimirTelaEstender
#--------------------------------------------------------------------------------
# Método que imprime a tela com respostas estendidas
#################################################################################
sub imprimirTelaEstender {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

#if (!($self->umUsuario->getPrivilegios() == 1 || $self->umaAtividade->expirouDataLimite())) {
if (!($self->umUsuario->getPrivilegios() == 1)) {
   die "Usuário não autorizado!\n";
}

my $totalItens = $dadosRespostas->quantidadeRespostas($self->umaAtividade->getCodigoAtividade());

my @colecaoRespostas = $dadosRespostas->solicitarRespostas($self->umaAtividade->getCodigoAtividade());

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
                  size=2><b>Respostas</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> respostas. Mostrando <b>todas</b>:</font></div>
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
   my $nota = "-";
   if ($totalItens > 0) {
      foreach $umaResposta (@colecaoRespostas) {
         if ($umaResposta->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
            $titulo = qq |<b><a href="atividades.cgi?opcao=visualizarResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a></b>|;
         } else {
            if ($self->umUsuario->getPrivilegios() == 1 || $self->umaAtividade->expirouDataLimite()) {
               $titulo = qq |<a href="atividades.cgi?opcao=visualizarResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a>|;
            } else {
               $titulo = $umaResposta->getTitulo();
            }
         }

         if ($self->umaAtividade->getValorNota() > 0) {
            if ($self->umUsuario->getPrivilegios() == 1 || $self->umUsuario->getCodigoUsuario() == $umaResposta->getCodigoUsuario()) {
               if ($umaResposta->getNota() >= 0) {
                  $nota = $umaResposta->getNota();
               } else {
                  $nota = "Sem Nota!";
               }
            } else {
               $nota = "-";
            }
         }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          ${$umaResposta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaResposta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaAtividade->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          Nota: <b>$nota</b></font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

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
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaResposta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   
         if (length($umaResposta->getNomeAnexo()) > 0 && $self->umaAtividade->getHabAnexo()) {
            my $tamAnexo = &TamanhoBytes(length($umaResposta->getAnexo()));

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <img src="icones/arquivo.jpg" width=16 height=16 border="0">&nbsp;
                           <a href="anexo.cgi?opcao=baixar\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'nomeAnexo'}</a> $tamAnexo</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
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
# imprimirTelaAtribuirNotas
#--------------------------------------------------------------------------------
# Método que imprime a tela com respostas estendidas para o preenchimento das notas
#################################################################################
sub imprimirTelaAtribuirNotas {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

if (!($self->umUsuario->getPrivilegios() == 1 && $self->umaAtividade->expirouDataLimite() && $self->umaAtividade->getValorNota() > 0)) {
   die "Usuário não autorizado!\n";
}

my $totalItens = $dadosRespostas->quantidadeRespostas($self->umaAtividade->getCodigoAtividade());

if ($totalItens == 0) {
   die "Nenhuma resposta foi encontrada!";
}

my @colecaoRespostas = $dadosRespostas->solicitarRespostas($self->umaAtividade->getCodigoAtividade());

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
                  size=2><b>Respostas</b></FONT></DIV>
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
                            Foram encontradas <b>$totalItens</b> respostas. Mostrando <b>todas</b>:</font></div>
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
   my $nota = "";
   if ($totalItens > 0) {
      foreach $umaResposta (@colecaoRespostas) {
         if ($umaResposta->getCodigoUsuario() == $self->umUsuario->getCodigoUsuario()) {
            $titulo = qq |<b><a href="atividades.cgi?opcao=visualizarResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a></b>|;
         } else {
            if ($self->umUsuario->getPrivilegios() == 1 || $self->umaAtividade->expirouDataLimite()) {
               $titulo = qq |<a href="atividades.cgi?opcao=visualizarResposta\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'titulo'}</a>|;
            } else {
               $titulo = $umaResposta->getTitulo();
            }
         }
         if ($umaResposta->getNota() >= 0) { 
            $nota = $umaResposta->getNota();
         } else { 
            $nota = "";
         }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#0033FF">
                          ${$umaResposta}{'titulo'}</font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaResposta}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaResposta}{'umUsuario'}}{'nome'}</a>
                            em ${$umaResposta}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

            if ($self->umaAtividade->getValorNota() > 0) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#000000">
                          Nota: <b>$nota</b></font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

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
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umaResposta}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   
         if (length($umaResposta->getNomeAnexo()) > 0 && $self->umaAtividade->getHabAnexo()) {
            my $tamAnexo = &TamanhoBytes(length($umaResposta->getAnexo()));
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <img src="icones/arquivo.jpg" widht=16 height=16 border="0">&nbsp;
                           <a href="anexo.cgi?opcao=baixar\&codigoAtividade=$codigoAtividade\&codigoResposta=${$umaResposta}{'codigoResposta'}">${$umaResposta}{'nomeAnexo'}</a> $tamAnexo</td>
                          <td width="70">&nbsp;</td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         }

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><div align="right">
                          <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                           Atribuir nota para <b>${${$umaResposta}{'umUsuario'}}{'nome'}</b>:</font>&nbsp;
                          <input type="text" size="5" maxlength="5" name="resp${$umaResposta}{'codigoResposta'}" value="$nota">
                          </div>
                          </td>
                          <td width="70" height="2">
                          </td>
                        </tr>
   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

         $itemAtual--;
      }
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
                          <td height="2"><div align="right">
                          <input type="hidden" name="opcao" value="atribuindoNotas">
                          <input type="hidden" name="codigoAtividade" value="$codigoAtividade">
                          <input type="submit" name="submit" value="Gravar Notas"></div>
                          </td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>

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
# imprimirTelaAtribuindoNotas
#--------------------------------------------------------------------------------
# Método que atribui notas e apresenta o resultado
#################################################################################
sub imprimirTelaAtribuindoNotas {

   my $self = shift;

my $umaResposta = new ClasseAtividadeResposta;
my $dadosRespostas = new DadosAtividadesRespostas;

if (!($self->umUsuario->getPrivilegios() == 1 && $self->umaAtividade->expirouDataLimite() && $self->umaAtividade->getValorNota() > 0)) {
   die "Usuário não autorizado!\n";
}
   
   my $codigoAtividade = $self->umaAtividade->getCodigoAtividade();
   my @colecaoRespostas = $dadosRespostas->solicitarRespostas($codigoAtividade);

   my $nota = "";   
   foreach $umaResposta (@colecaoRespostas) {
      $nota = $self->query->param('resp'.$umaResposta->getCodigoResposta());
      if ($nota eq "") {
         $nota = -1;
      }
      $umaResposta->setNota($nota);
      $dadosRespostas->gravar($umaResposta);
   }

   $self->imprimirMensagem("Notas gravadas com sucesso!","atividades.cgi?opcao=visualizar\&codigoAtividade=$codigoAtividade",0);

}

#################################################################################











1;
