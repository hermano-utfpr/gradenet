package HtmlArquivos;

use strict;
use CGI;
use ClasseArquivo;
use ClassePasta;
use ClasseAmbiente;
use DadosArquivos;
use DadosPastas;
use DadosAmbiente;
use FuncoesUteis;









#################################################################################
# HtmlArquivos
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso aos arquivos 
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
                  size=2>Arquivos</FONT></B></DIV>
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

      $menuinf = qq |   [<a href="arquivos.cgi?opcao=enviarArquivo">Enviar Arquivo</a>] -
                        [<a href="arquivos.cgi?opcao=criarPasta">Criar Pasta</a>] -
                        [<a href="arquivos.cgi">Mostrar Arquivos</a>] |;

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaArquivos
#--------------------------------------------------------------------------------
# Método que imprime a tela com arquivos
#################################################################################
sub imprimirTelaArquivos {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umArquivo = new ClasseArquivo;
my $dadosArquivos = new DadosArquivos;
my $umaPasta = new ClassePasta;
my $dadosPastas = new DadosPastas;

my $codigoPasta = 0;
if ($self->query->param('codigoPasta')) {
   $codigoPasta = $self->query->param('codigoPasta');
}

my $qtdeArquivos = $dadosArquivos->quantidade($codigoPasta, $self->umUsuario->getCodigoUsuario());
my @colecaoArquivos;
#= $dadosArquivos->solicitarArquivos($codigoPasta, $self->umUsuario->getCodigoUsuario());

my $qtdePastas = $dadosPastas->quantidade($self->umUsuario->getCodigoUsuario());
my @colecaoPastas = $dadosPastas->solicitarPastas($self->umUsuario->getCodigoUsuario());

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR>
        <TD>
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 border=2>
            <TBODY>
            <TR>
              <TD bgColor=#ffffff>
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY>
                  <TR>
                    <TD>
                      <DIV align=center><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000
                  size=2><b>Arquivos</b></FONT></DIV>
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
                            Foram encontrados <b>$qtdeArquivos</b> arquivos. Mostrando <b>todos</b>:</font></div>
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

      my $lincor = "\#FFFFDD";
      my $nomePasta = "";
      my $iconePasta = "";
      my $nomeArquivo = "";
      my $iconeArquivo = "";
      my $tamArquivo = 0;
      foreach $umaPasta (@colecaoPastas) {
         $iconePasta = "icones/pasta.jpg";
         $nomePasta = $umaPasta->getNomePasta();
         if ($codigoPasta == $umaPasta->getCodigoPasta()) {
            $iconePasta = "icones/pasta_aberta.jpg";
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr bgcolor="$lincor">
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="480"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <img src="$iconePasta" width=16 height=16 border=0></img>&nbsp;
                                <a href="arquivos.cgi?opcao=mostrar\&codigoPasta=${$umaPasta}{'codigoPasta'}">$nomePasta</a>
                                &nbsp;<font size=1 color="#999999"> (${$umaPasta}{'data'})</font>
                                </font></td>
                                <td width="100">
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  ${$umaPasta}{qtdeArquivos} arquivos
                                  </font>
                                </td>
                                <td width="50">
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                   &nbsp;[<a href="arquivos.cgi?opcao=editarPasta\&codigoPasta=${$umaPasta}{'codigoPasta'}">Editar</a>]
                                  </font>
                                </td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                   &nbsp;[<a href="arquivos.cgi?opcao=deletarPasta\&codigoPasta=${$umaPasta}{'codigoPasta'}">Deletar</a>]
                                  </font>
                                </td>
                              </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         if ($lincor eq "\#FFFFDD") {
             $lincor = "\#FFFFFF"
         } else {
             $lincor = "\#FFFFDD"
         }

         if ($codigoPasta == $umaPasta->getCodigoPasta()) {
            @colecaoArquivos = $dadosArquivos->solicitarArquivos($codigoPasta,$self->umUsuario->getCodigoUsuario());
            foreach $umArquivo (@colecaoArquivos) {
               if ($umArquivo->getPermissao()) {
                  $iconeArquivo = "icones/arquivo_publico.jpg";
               } else {
                  $iconeArquivo = "icones/arquivo_privado.jpg";
               }
               $nomeArquivo = $umArquivo->getNomeArquivo();
               $tamArquivo = &TamanhoBytes(length($umArquivo->getArquivo()));

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr bgcolor="$lincor">
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="480"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                &nbsp;&nbsp;&nbsp;&nbsp;<img src="$iconeArquivo" width=16 height=16 border=0></img>&nbsp;<img src="icones/arquivo.jpg" width=16 height=16 border=0></img>
                                <a href="arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}">$nomeArquivo</a>
                                &nbsp;<font size=1 color="#999999"> (${$umArquivo}{'data'})</font>
                                </font></td>
                                <td width="100">
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  $tamArquivo
                                  </font>
                                </td>
                                <td width="50">
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                   &nbsp;[<a href="arquivos.cgi?opcao=editarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}">Editar</a>]
                                  </font>
                                </td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                   &nbsp;[<a href="arquivos.cgi?opcao=deletarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}">Deletar</a>]
                                  </font>
                                </td>
                              </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
                if ($lincor eq "\#FFFFDD") {
                  $lincor = "\#FFFFFF"
                } else {
                  $lincor = "\#FFFFDD"
                }
            }
         }
      }

      @colecaoArquivos = $dadosArquivos->solicitarArquivos(0, $self->umUsuario->getCodigoUsuario());
      foreach $umArquivo (@colecaoArquivos) {
         if ($umArquivo->getPermissao()) {
            $iconeArquivo = "icones/arquivo_publico.jpg";
         } else {
            $iconeArquivo = "icones/arquivo_privado.jpg";
         }
         $nomeArquivo = $umArquivo->getNomeArquivo();
         $tamArquivo = &TamanhoBytes(length($umArquivo->getArquivo()));
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                              <tr bgcolor="$lincor">
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="480"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <img src="$iconeArquivo" width=16 height=16 border=0></img>&nbsp;<img src="icones/arquivo.jpg" width=16 height=16 border=0></img>
                                <a href="arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}">$nomeArquivo</a>
                                &nbsp;<font size=1 color=999999> (${$umArquivo}{'data'})</font>
                                </font></td>
                                <td width="100">
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  $tamArquivo
                                  </font>
                                </td>
                                <td width="50">
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                   &nbsp;[<a href="arquivos.cgi?opcao=editarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}">Editar</a>]
                                  </font>
                                </td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                   &nbsp;[<a href="arquivos.cgi?opcao=deletarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}">Deletar</a>]
                                  </font>
                                </td>
                              </tr>

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }

      my $dadosAmbiente = new DadosAmbiente;
      my $umAmbiente = $dadosAmbiente->selecionar();
      my $espLimite = $umAmbiente->getKBytesArquivo()*1024;
      my $espUsado = $dadosArquivos->qtdeEspacoUsado($self->umUsuario->getCodigoUsuario());
      my $espLivre = ($espLimite - $espUsado);
      $espLivre = &TamanhoBytes($espLivre);
      $espLimite = &TamanhoBytes($espLimite);
      $espUsado = &TamanhoBytes($espUsado);
      if ($self->umUsuario->getPrivilegios() == 1) {
         $espLimite = "ilimitado";
         $espLivre = "ilimitado";
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
                          <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                          <img src="icones/pasta.jpg" width=16 height=16 border="0"></img> - Pasta.&nbsp;&nbsp;
                          <img src="icones/pasta_aberta.jpg" width=16 height=16 border="0"></img> - Pasta aberta.&nbsp;&nbsp;
                          <img src="icones/arquivo_privado.jpg" width=16 height=16 border="0"></img> - <i>Link</i> privado.&nbsp;&nbsp;
                          <img src="icones/arquivo_publico.jpg" width=16 height=16 border="0"></img> - <i>Link</i> público.&nbsp;&nbsp;
                          </font></div>
                          </td>
                        </tr>
                        <tr>
                          <td>&nbsp; </td>
                        </tr>
                                                <tr>
                          <td>
                          <div align="center">
                          <font face="Verdana, Arial, Helvetica, sans-serif" size="1">Espaço utilizado: <b>$espUsado</b>  / Espaço livre: <b>$espLivre</b> / Espaço limite: <b>$espLimite</b>.
                          </font></div>
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
                      <div align="center">
                      <font face="Verdana, Arial, Helvetica, sans-serif" size="2">
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
# imprimirTelaEnviarArquivo
#--------------------------------------------------------------------------------
# Método que imprime a tela para enviar um arquivo
#################################################################################
sub imprimirTelaEnviarArquivo {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPasta = new ClassePasta;
my $dadosPastas = new DadosPastas;

my @colecaoPastas = $dadosPastas->solicitarPastas($self->umUsuario->getCodigoUsuario());

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
                  size=2><b>Arquivos</b></FONT></DIV>
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
                          <td width="70"> 
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000"> 
                           Enviar arquivo: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Arquivo:</font></b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9"> 
                            <p> 
                              <input type="file" name="arquivo" size="30">
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Permissões de <i>link</i>:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8"> 
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                            <input type="radio" name="permissao" value="0" checked><img src="icones/arquivo_privado.jpg" width=16 height=16 border="0"></img>&nbsp;- privado&nbsp;&nbsp;
                            <input type="radio" name="permissao" value="1"><img src="icones/arquivo_publico.jpg" width=16 height=16 border="0"></img>&nbsp;- público
                            </font>                             
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
                          <td height="2"><b>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Guardar na pasta:</font></b>
                            <select name="codigoPasta" size=1>
                            <option value="0" selected>---raiz---</option>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   foreach $umaPasta (@colecaoPastas) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                            <option value="${$umaPasta}{'codigoPasta'}">${$umaPasta}{'nomePasta'}</option>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                             </select>  
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
                            <input type="hidden" name="opcao" value="enviandoArquivo">
                            <input type="submit" name="Submit" value="Enviar">
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
# imprimirTelaEnviandoArquivo
#--------------------------------------------------------------------------------
# Método que envia um arquivo e apresenta o resultado
#################################################################################
sub imprimirTelaEnviandoArquivo {

   my $self = shift;

   my $umArquivo = new ClasseArquivo;
   my $dadosArquivos = new DadosArquivos;

   my $arquivoUpload;
   my $nomeArquivo = $self->query->param('arquivo');

   while (<$nomeArquivo>) {
      $arquivoUpload .= $_;
   }

   $umArquivo->setDadosIU(0,$nomeArquivo,
                          $arquivoUpload,
                          $self->query->param('permissao'),
                          $self->query->param('codigoPasta'),
                          $self->umUsuario->getCodigoUsuario());

   my $dadosAmbiente = new DadosAmbiente;
   my $umAmbiente = $dadosAmbiente->selecionar();

   my $espUsado = $dadosArquivos->qtdeEspacoUsado($self->umUsuario->getCodigoUsuario());
   my $espLivre = ($umAmbiente->getKBytesArquivo()*1024)-$espUsado;

   if ((length($arquivoUpload) > $espLivre) && !$self->umUsuario->getPrivilegios()) {
      $self->imprimirMensagem("Espaço insuficiente para gravar o arquivo!","",1);
   } else {
      $dadosArquivos->gravar($umArquivo);
      $self->imprimirMensagem("Arquivo incluído com sucesso!","arquivos.cgi",0);
   }

}

#################################################################################










#################################################################################
# imprimirTelaEditarArquivo
#--------------------------------------------------------------------------------
# Método que imprime a tela para enviar um arquivo
#################################################################################
sub imprimirTelaEditarArquivo {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPasta = new ClassePasta;
my $dadosPastas = new DadosPastas;
my $umArquivo = new ClasseArquivo;
my $dadosArquivos = new DadosArquivos;

$umArquivo = $dadosArquivos->selecionarArquivo($self->query->param('codigoArquivo'),$self->umUsuario->getCodigoUsuario());
my @colecaoPastas = $dadosPastas->solicitarPastas($self->umUsuario->getCodigoUsuario());

my $permissaoPrivada = "checked";
my $permissaoPublica = "";
if ($umArquivo->getPermissao()) {
   $permissaoPrivada = "";
   $permissaoPublica = "checked";
}
my $selecionaRaiz = "";
if ($umArquivo->getCodigoPasta() == 0) {
   $selecionaRaiz = "selected";
}

my $tamArquivo = &TamanhoBytes(length($umArquivo->getArquivo()));

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
                  size=2><b>Arquivos</b></FONT></DIV>
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
                          <td width="70">
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">
                           Editar arquivo: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Nome:</font></b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9">
                            <p>
                              <input type="text" name="nomeArquivo" size="30" maxlength="200" value="${$umArquivo}{'nomeArquivo'}">
                            &nbsp;<font size=1 color="#999999"> (${$umArquivo}{'data'})</font>
                            &nbsp;<font size=1 color="#000011"> $tamArquivo</font>
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
                          <td height="8"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Permissões de <i>link</i>:</font></b></td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                            <input type="radio" name="permissao" value="0" $permissaoPrivada><img src="icones/arquivo_privado.jpg" width=16 height=16 border="0"></img>&nbsp;- privado&nbsp;&nbsp;
                            <input type="radio" name="permissao" value="1" $permissaoPublica><img src="icones/arquivo_publico.jpg" width=16 height=16 border="0"></img>&nbsp;- público
                            </font>
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
                          <td height="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Link:</b>&nbsp;<br>
                          \[link\]arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}\[link-texto\]${$umArquivo}{'nomeArquivo'} ($tamArquivo)\[/link\]
                          </font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif"><b>Imagem:</b>&nbsp;<br>
                          \[img\]arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}\#${$umArquivo}{'nomeArquivo'}\[/img\]
                          </font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp; </td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b>
                            <font size="2" face="Verdana, Arial, Helvetica, sans-serif">Guardar na pasta:</font></b>
                            <select name="codigoPasta" size=1>
                            <option value="0" $selecionaRaiz>---raiz---</option>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   my $selecionada = "";
   foreach $umaPasta (@colecaoPastas) {
      if ($umaPasta->getCodigoPasta() == $umArquivo->getCodigoPasta()) {
         $selecionada = "selected";
      } else {
         $selecionada = "";
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                            <option value="${$umaPasta}{'codigoPasta'}" $selecionada>${$umaPasta}{'nomePasta'}</option>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                             </select>
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
                            <input type="hidden" name="opcao" value="editandoArquivo">
                            <input type="hidden" name="codigoArquivo" value="${$umArquivo}{'codigoArquivo'}">
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
# imprimirTelaEditandoArquivo
#--------------------------------------------------------------------------------
# Método que altera um aviso e apresenta o resultado
#################################################################################
sub imprimirTelaEditandoArquivo {

   my $self = shift;

   my $umArquivo = new ClasseArquivo;
   my $dadosArquivos= new DadosArquivos;

   $umArquivo = $dadosArquivos->selecionarArquivo($self->query->param('codigoArquivo'),$self->umUsuario->getCodigoUsuario());

   if (!$umArquivo->getCodigoArquivo()) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }
   
   $umArquivo->setNomeArquivo($self->query->param('nomeArquivo'));
   $umArquivo->setPermissao($self->query->param('permissao'));
   $umArquivo->setCodigoPasta($self->query->param('codigoPasta'));
 

   $dadosArquivos->gravar($umArquivo);

   $self->imprimirMensagem("Arquivo gravado com sucesso!","arquivos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaDeletarArquivo
#--------------------------------------------------------------------------------
# Método que imprime a tela para deletar um arquivo
#################################################################################
sub imprimirTelaDeletarArquivo {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPasta = new ClassePasta;
my $dadosPastas = new DadosPastas;
my $umArquivo = new ClasseArquivo;
my $dadosArquivos = new DadosArquivos;

$umArquivo = $dadosArquivos->selecionarArquivo($self->query->param('codigoArquivo'),$self->umUsuario->getCodigoUsuario());
my @colecaoPastas = $dadosPastas->solicitarPastas($self->umUsuario->getCodigoUsuario());

my $tamArquivo = &TamanhoBytes(length($umArquivo->getArquivo()));

my $permissaoPrivada = "checked";
my $permissaoPublica = ""; 
if ($umArquivo->getPermissao()) {
   $permissaoPrivada = "";
   $permissaoPublica = "checked"; 
}
my $selecionaRaiz = "";
if ($umArquivo->getCodigoPasta() == 0) {
   $selecionaRaiz = "selected";
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
                  size=2><b>Arquivos</b></FONT></DIV>
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
                          <td width="70"> 
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000"> 
                           Deletar o arquivo: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="0000FF"><img src="icones/arquivo.jpg" width=16 height=16 border=0></img>
                          <a href="arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}">${$umArquivo}{'nomeArquivo'}</a>
                          &nbsp;<font size=1 color="#999999"> (${$umArquivo}{'data'})</font>
                          &nbsp;<font size=2 color="#000011"> $tamArquivo</font>
                          </font></td>
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
                            <input type="hidden" name="opcao" value="deletandoArquivo">
                            <input type="hidden" name="codigoArquivo" value="${$umArquivo}{'codigoArquivo'}">
                            <input type="submit" name="Submit" value="Confirmar">
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
# imprimirTelaDeletandoArquivo
#--------------------------------------------------------------------------------
# Método que exclui um arquivo e apresenta o resultado
#################################################################################
sub imprimirTelaDeletandoArquivo {

   my $self = shift;

   my $umArquivo = new ClasseArquivo;
   my $dadosArquivos= new DadosArquivos;

   $umArquivo = $dadosArquivos->selecionarArquivo($self->query->param('codigoArquivo'),$self->umUsuario->getCodigoUsuario());

   if (!$umArquivo->getCodigoArquivo()) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }
   
   $dadosArquivos->excluir($self->query->param('codigoArquivo'));

   $self->imprimirMensagem("Arquivo deletado com sucesso!","arquivos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaBaixandoArquivo
#--------------------------------------------------------------------------------
# Método que permite fazer o download de um arquivo
#################################################################################
sub imprimirTelaBaixandoArquivo {

   my $self = shift;

   my $umArquivo = new ClasseArquivo;
   my $dadosArquivos= new DadosArquivos;

   $umArquivo = $dadosArquivos->selecionarArquivo($self->query->param('codigoArquivo'),$self->umUsuario->getCodigoUsuario());
   
   if (!$umArquivo->getCodigoArquivo()) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $tamArquivo = length($umArquivo->getArquivo());

   print "Content-Disposition: inline; filename=\"${$umArquivo}{'nomeArquivo'}\"\n";
   print "Content-Length: $tamArquivo\n";
   print "Content-Type: application/octet-stream\n\n";
   print $umArquivo->getArquivo();

}

#################################################################################










#################################################################################
# imprimirTelaCriarPasta
#--------------------------------------------------------------------------------
# Método que imprime a tela para criar uma pasta
#################################################################################
sub imprimirTelaCriarPasta {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

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
                  size=2><b>Arquivos</b></FONT></DIV>
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
                          <td width="70"> 
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000"> 
                           Criar pasta: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Nome da pasta:</font></b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9"> 
                            <p> 
                              <input type="text" name="nomePasta" size="30" maxlength="100">
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
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"> 
                            <input type="hidden" name="opcao" value="criandoPasta">
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
# imprimirTelaCriandoPasta
#--------------------------------------------------------------------------------
# Método que criar uma pasta e apresenta o resultado
#################################################################################
sub imprimirTelaCriandoPasta {

   my $self = shift;

   my $umaPasta = new ClassePasta;
   my $dadosPastas = new DadosPastas;

   $umaPasta->setDadosIU(0,$self->query->param("nomePasta"),$self->umUsuario->getCodigoUsuario());

   $dadosPastas->gravar($umaPasta);

   $self->imprimirMensagem("Pasta criada com sucesso!","arquivos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaEditarPasta
#--------------------------------------------------------------------------------
# Método que imprime a tela para editar uma pasta
#################################################################################
sub imprimirTelaEditarPasta {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPasta = new ClassePasta;
my $dadosPastas = new DadosPastas;

$umaPasta = $dadosPastas->selecionarPasta($self->query->param('codigoPasta'));



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
                  size=2><b>Arquivos</b></FONT></DIV>
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
                          <td width="70"> 
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000"> 
                           Alterar pasta: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif">Nome da pasta:</font></b></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="9">&nbsp;</td>
                          <td height="9"> 
                            <p> 
                              <input type="text" name="nomePasta" size="30" maxlength="100" value="${$umaPasta}{'nomePasta'}">
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
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"> 
                            <input type="hidden" name="opcao" value="editandoPasta">
                            <input type="hidden" name="codigoPasta" value="${$umaPasta}{'codigoPasta'}">
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
# imprimirTelaEditandoPasta
#--------------------------------------------------------------------------------
# Método que edita uma pasta e apresenta o resultado
#################################################################################
sub imprimirTelaEditandoPasta {

   my $self = shift;

   my $umaPasta = new ClassePasta;
   my $dadosPastas = new DadosPastas;

   $umaPasta = $dadosPastas->selecionarPasta($self->query->param('codigoPasta'),$self->umUsuario->getCodigoUsuario());
 
   if (!$umaPasta->getCodigoPasta()) {
      print "<!--";
      die "Usuário não autorizado!\n";   
   }

   $umaPasta->setDadosIU($self->query->param('codigoPasta'),$self->query->param("nomePasta"),$self->umUsuario->getCodigoUsuario());

   $dadosPastas->gravar($umaPasta);

   $self->imprimirMensagem("Pasta gravada com sucesso!","arquivos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaDeletarPasta
#--------------------------------------------------------------------------------
# Método que imprime a tela para deletar uma pasta
#################################################################################
sub imprimirTelaDeletarPasta {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umaPasta = new ClassePasta;
my $dadosPastas = new DadosPastas;

$umaPasta = $dadosPastas->selecionarPasta($self->query->param('codigoPasta'),$self->umUsuario->getCodigoUsuario());


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
                  size=2><b>Arquivos</b></FONT></DIV>
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
                          <td width="70"> 
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000"> 
                           Deletar a pasta: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="0000FF">
                          ${$umaPasta}{'nomePasta'}</a>
                          </font></td>
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
                            <input type="hidden" name="opcao" value="deletandoPasta">
                            <input type="hidden" name="codigoPasta" value="${$umaPasta}{'codigoPasta'}">
                            <input type="submit" name="Submit" value="Confirmar">
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
# imprimirTelaDeletandoPasta
#--------------------------------------------------------------------------------
# Método que exclui uma pasta e apresenta o resultado
#################################################################################
sub imprimirTelaDeletandoPasta {

   my $self = shift;

   my $umaPasta = new ClassePasta;
   my $dadosPastas = new DadosPastas;

   $umaPasta = $dadosPastas->selecionarPasta($self->query->param('codigoPasta'),$self->umUsuario->getCodigoUsuario());

   if (!$umaPasta->getCodigoPasta()) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }
   
   $dadosPastas->excluir($self->query->param('codigoPasta'));

   $self->imprimirMensagem("Pasta deletada com sucesso!","arquivos.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaArquivosPseudo
#--------------------------------------------------------------------------------
# Método que imprime a tela com arquivos para criar links em pseudo-HTML
#################################################################################
sub imprimirTelaArquivosPseudo {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umArquivo = new ClasseArquivo;
my $dadosArquivos = new DadosArquivos;
my $umaPasta = new ClassePasta;
my $dadosPastas = new DadosPastas;

my $codigoPasta = 0;
if ($self->query->param('codigoPasta')) {
   $codigoPasta = $self->query->param('codigoPasta');
}

my $qtdeArquivos = $dadosArquivos->quantidade($codigoPasta, $self->umUsuario->getCodigoUsuario());
my @colecaoArquivos;
#= $dadosArquivos->solicitarArquivos($codigoPasta, $self->umUsuario->getCodigoUsuario());

my $qtdePastas = $dadosPastas->quantidade($self->umUsuario->getCodigoUsuario());
my @colecaoPastas = $dadosPastas->solicitarPastas($self->umUsuario->getCodigoUsuario());

my $dadosAmbiente = new DadosAmbiente;
my $umAmbiente = $dadosAmbiente->selecionar();


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

       <HTML> <HEAD> <TITLE>Pseudo-HTML (Arquivos)</TITLE> </HEAD>
       <BODY BGCOLOR="#${$umAmbiente}{'corDeFundo'}">

          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750
        border=0><TBODY>

      <TR>
        <TD>
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 border=2>
            <TBODY>
            <TR>
              <TD bgColor=#ffffff>
                <TABLE cellSpacing=0 cellPadding=0 width=746 border=0>
                  <TBODY>
                  <TR>
                    <TD>
                      <DIV align=center><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" color=#ff0000
                  size=2><b>Arquivos</b></FONT></DIV>
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
                            Foram encontrados <b>$qtdeArquivos</b> arquivos. Mostrando <b>todos</b>:</font></div>
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

      my $lincor = "\#FFFFDD";
      my $nomePasta = "";
      my $iconePasta = "";
      my $nomeArquivo = "";
      my $iconeArquivo = "";
      my $tamArquivo = 0;
      foreach $umaPasta (@colecaoPastas) {
         $iconePasta = "icones/pasta.jpg";
         $nomePasta = $umaPasta->getNomePasta();
         if ($codigoPasta == $umaPasta->getCodigoPasta()) {
            $iconePasta = "icones/pasta_aberta.jpg";
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr bgcolor="$lincor">
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="480"><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <img src="$iconePasta" width=16 height=16 border=0></img>&nbsp;
                                <a href="pseudo.cgi?opcao=mostrar\&codigoPasta=${$umaPasta}{'codigoPasta'}">$nomePasta</a>
                                &nbsp;<font size=1 color=999999> (${$umaPasta}{'data'})</font>
                                </font></td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  ${$umaPasta}{qtdeArquivos} arquivos
                                  </font>
                                </td>
                              </tr>

   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
        if ($lincor eq "\#FFFFDD") {
            $lincor = "\#FFFFFF"
        } else {
            $lincor = "\#FFFFDD"
        }
         if ($codigoPasta == $umaPasta->getCodigoPasta()) {
            @colecaoArquivos = $dadosArquivos->solicitarArquivos($codigoPasta,$self->umUsuario->getCodigoUsuario());
            foreach $umArquivo (@colecaoArquivos) {
               if ($umArquivo->getPermissao()) {
                  $iconeArquivo = "icones/arquivo_publico.jpg";
               } else {
                  $iconeArquivo = "icones/arquivo_privado.jpg";
               }
               $nomeArquivo = $umArquivo->getNomeArquivo();
               $tamArquivo = &TamanhoBytes(length($umArquivo->getArquivo()));
               my $linkTexto = qq |\[link\]arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}\[link-texto\]${$umArquivo}{'nomeArquivo'} ($tamArquivo)\[/link\]| ;
               my $linkImagem = qq |\[img\]arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}\#${$umArquivo}{'nomeArquivo'}\[/img]| ;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr bgcolor="$lincor">
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="580"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="0000FF">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="$iconeArquivo" width=16 height=16 border=0></img>&nbsp;<img src="icones/arquivo.jpg" width=16 height=16 border=0></img>
                                $nomeArquivo
                                &nbsp;<font size=1 color=999999> (${$umArquivo}{'data'})</font>
                                </font></td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  $tamArquivo
                                  </font>
                                </td>
                              </tr>
                              <tr bgcolor="$lincor">
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="580"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" size="50" value="$linkTexto"> (link)

                                </font></td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  </font>
                                </td>
                              </tr>
                              <tr bgcolor="$lincor">
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="580"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" size="50" value="$linkImagem"> (imagem)

                                </font></td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  </font>
                                </td>
                              </tr>



   |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
                if ($lincor eq "\#FFFFDD") {
                  $lincor = "\#FFFFFF"
                } else {
                  $lincor = "\#FFFFDD"
                }
            }
         }
      }

      @colecaoArquivos = $dadosArquivos->solicitarArquivos(0, $self->umUsuario->getCodigoUsuario());
      foreach $umArquivo (@colecaoArquivos) {
         if ($umArquivo->getPermissao()) {
            $iconeArquivo = "icones/arquivo_publico.jpg";
         } else {
            $iconeArquivo = "icones/arquivo_privado.jpg";
         }
         $nomeArquivo = $umArquivo->getNomeArquivo();
         $tamArquivo = &TamanhoBytes(length($umArquivo->getArquivo()));
         my $linkTexto = qq |\[link\]arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}\[link-texto\]${$umArquivo}{'nomeArquivo'} ($tamArquivo)\[/link\]| ;
         my $linkImagem = qq |\[img\]arquivos.cgi?opcao=baixarArquivo\&codigoArquivo=${$umArquivo}{'codigoArquivo'}\#${$umArquivo}{'nomeArquivo'}\[/img]| ;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                              <tr>
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="580"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="0000FF">
                                <img src="$iconeArquivo" width=16 height=16 border=0></img>&nbsp;<img src="icones/arquivo.jpg" width=16 height=16 border=0></img>
                                $nomeArquivo
                                &nbsp;<font size=1 color=999999> (${$umArquivo}{'data'})</font>
                                </font></td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  $tamArquivo
                                  </font>
                                </td>
                              </tr>
                              <tr>
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="580"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000"> <input type="text" size="50" value="$linkTexto"> (link)

                                </font></td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  </font>
                                </td>
                              </tr>
                              <tr>
                                <td width="25">
                                  <div align="right"></div>
                                </td>
                                <td width="580"><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="000000"> <input type="text" size="50" value="$linkImagem"> (imagem)

                                </font></td>
                                <td>
                                  <font face="Arial, Helvetica, sans-serif" size="1" color="#000000">
                                  </font>
                                </td>
                              </tr>

   |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }

      my $dadosAmbiente = new DadosAmbiente;
      my $umAmbiente = $dadosAmbiente->selecionar();
      my $espLimite = $umAmbiente->getKBytesArquivo()*1024;
      my $espUsado = $dadosArquivos->qtdeEspacoUsado($self->umUsuario->getCodigoUsuario());
      my $espLivre = ($espLimite - $espUsado);
      $espLivre = &TamanhoBytes($espLivre);
      $espLimite = &TamanhoBytes($espLimite);
      $espUsado = &TamanhoBytes($espUsado);
      if ($self->umUsuario->getPrivilegios() == 1) {
         $espLimite = "ilimitado";
         $espLivre = "ilimitado";
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
                          <font face="Verdana, Arial, Helvetica, sans-serif" size="1">
                          <img src="icones/pasta.jpg" width=16 height=16 border="0"></img> - Pasta.&nbsp;&nbsp;
                          <img src="icones/pasta_aberta.jpg" width=16 height=16 border="0"></img> - Pasta aberta.&nbsp;&nbsp;
                          <img src="icones/arquivo_privado.jpg" width=16 height=16 border="0"></img> - <i>Link</i> privado.&nbsp;&nbsp;
                          <img src="icones/arquivo_publico.jpg" width=16 height=16 border="0"></img> - <i>Link</i> público.&nbsp;&nbsp;
                          </font></div>
                          </td>
                        </tr>
                        <tr>
                          <td>&nbsp; </td>
                        </tr>
                                                <tr>
                          <td>
                          <div align="center">
                          <font face="Verdana, Arial, Helvetica, sans-serif" size="1">Espaço utilizado: <b>$espUsado</b>  / Espaço livre: <b>$espLivre</b> / Espaço limite: <b>$espLimite</b>.
                          </font></div>
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
                      <div align="center">
                      <font face="Verdana, Arial, Helvetica, sans-serif" size="2">
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
      </TR> </TBODY></TABLE>
          </BODY> </HTML>

  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML


}
#################################################################################









1;









