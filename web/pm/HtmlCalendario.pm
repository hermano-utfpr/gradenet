package HtmlCalendario;

use strict;
use CGI;
use ClasseCalendario;
use DadosCalendario;
use FuncoesCronologicas;
use FuncoesUteis;
use ClasseAtividade;
use DadosAtividades;
use ClasseAviso;
use DadosAvisos;
use ClasseUsuario;
use DadosUsuarios;





#################################################################################
# HtmlCalendario
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html para acesso ao calendário
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

my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

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
                  size=2>Calendário $ano</FONT></B></DIV>
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
      $menuinf = qq | [<a href="calendario.cgi">Mostrar Calendário</a>] - 
                      [<a href="calendario.cgi?opcao=mostrarAniversarios">Mostrar Aniversários</a>] |;
   } else {
      $menuinf = qq | [<a href="calendario.cgi">Mostrar Calendário</a>] |;
   }

   return $menuinf;

}

#################################################################################










#################################################################################
# imprimirTelaCalendario
#--------------------------------------------------------------------------------
# Método que imprime a tela com calendario
#################################################################################
sub imprimirTelaCalendario {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umCalendario = new ClasseCalendario;
my $dadosCalendario = new DadosCalendario;
my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

my @colecaoCalendario = $dadosCalendario->solicitarCalendarioAno($ano,$self->umUsuario->info->getUltimoAcesso());

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

my @colecaoAvisos = $dadosAvisos->solicitarAvisos($self->umUsuario->info->getUltimoAcesso());

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades();

my @colecaoAtividades = $dadosAtividades->solicitarAtividades($self->umUsuario->info->getUltimoAcesso());


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
                  size=2><b>Calendário $ano</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>

|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

  
   my $mesC = 0;

   my $diaSemana = (localtime(time))[6];
   my $diaAno    = (localtime(time))[7];
   for (my $contDias = $diaAno-1; $contDias >= 0; $contDias--) {
      $diaSemana--;
      if ($diaSemana == -1) {
         $diaSemana = 6;
      }
   }
   $diaSemana++;   

   my $bissexto = 0;
   if ($ano % 4 == 0) {
      $bissexto = 1;
   }

   for (my $i = 1; $i <= 6; $i++) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |

                  <TR> 
                    <TD height="2"> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="20">&nbsp;</td>
                          <td width="10">&nbsp;</td>
                          <td width="20">&nbsp;</td>
                          <td>&nbsp;</td>
                          <td width="20">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="20">&nbsp;</td>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML      
      for (my $j = 1; $j <= 2; $j++) {
          my $textoMes = &TextualizaMes($mesC);
          $mesC++;
          my $diaC = 0;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                          <td width="10"> 
                            <table width="340" border="0" cellspacing="0" cellpadding="0">
                              <tr bgcolor="#000000"> 
                                <td colspan="14" height="8"> 
                                  <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><font color="#FFFFFF">$textoMes</font></b></font></div>
                                </td>
                              </tr>
                              <tr bgcolor="#00AAFF"> 
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Dom</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Seg</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Ter</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Qua</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Qui</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Sex</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#FFFFFF">Sab</font></b></div>
                                </td>
                              </tr>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         my $terminouMes = 0;
         for (my $k = 1; $k <= 6; $k++) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                               <tr>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
            for (my $l = 1; $l <= 7; $l++) {
               my $imprimeDia = "\&nbsp\;";
               if ($diaSemana == $l && !$terminouMes) {
                  $diaC++;
                  $diaSemana++;
                  if ($diaSemana > 7) { $diaSemana = 1; } 
                  if (($diaC > 31) && ($mesC == 1 || $mesC == 3 || $mesC == 5 || $mesC == 7 || $mesC == 8 || $mesC == 10 || $mesC == 12)) {
                     $diaC = 0;
                     $diaSemana--;
                     if ($diaSemana < 1) { $diaSemana = 7; }   
                     $terminouMes = 1;
                  }
                  if (($diaC > 30) && ($mesC == 4 || $mesC == 6 || $mesC == 9 || $mesC == 11)) {
                     $diaC = 0;
                     $diaSemana--;
                     if ($diaSemana < 1) { $diaSemana = 7; }   
                     $terminouMes = 1;
                  } 
                  if (($diaC > 28 && $mesC == 2 && !$bissexto) || ($diaC > 29 && $mesC == 2 && $bissexto)) {
                     $diaC = 0;
                     $diaSemana--;
                     if ($diaSemana < 1) { $diaSemana = 7; }   
                     $terminouMes = 1;
                  } 
                  if (!$terminouMes) {
                     $imprimeDia = &ZeroEsquerda($diaC,2);
                  }
               }

               my $icone = "";
               my $corFundo = "FFFFFF";
               my $corDestaque = "FFFF55";
               #####################################################################               
               my $dataC = &ZeroEsquerda($diaC,2)."/".&ZeroEsquerda($mesC,2)."/$ano";
               foreach $umCalendario (@colecaoCalendario) {
                  if ($dataC eq $umCalendario->getDataMarcada()) {
                     $icone = "";
                     $corFundo = $corDestaque;
                     if ($umCalendario->getLido()) {
                        $imprimeDia = qq|<a href="calendario.cgi?opcao=visualizar\&dataMarcada=$dataC">$imprimeDia</a>|;
                     } else {
                        #$icone = qq|<img src="icones/atencao_amarelo.jpg" border="0"></img> |;
                        $imprimeDia = qq|<b><a href="calendario.cgi?opcao=visualizar\&dataMarcada=$dataC">$imprimeDia</a></b>|;
                     }
                  }
               }
               foreach $umAviso (@colecaoAvisos) {
                  if ($dataC eq $umAviso->getDataCalendario()) {
                     $corFundo = $corDestaque;
                     if ($umAviso->getLido()) {
                        if ($self->umUsuario->getPrivilegios() == 1) {                         
                           $imprimeDia = qq|<a href="calendario.cgi?opcao=gravar\&dataMarcada=$dataC">$imprimeDia</a>|;
                        } else {
                           $imprimeDia = qq|<a href="calendario.cgi?opcao=visualizar\&dataMarcada=$dataC">$imprimeDia</a>|;
                        }
                     } else {
                        if ($self->umUsuario->getPrivilegios() == 1) {                         
                           $imprimeDia = qq|<b><a href="calendario.cgi?opcao=gravar\&dataMarcada=$dataC">$imprimeDia</a></b>|;
                        } else {
                           $imprimeDia = qq|<b><a href="calendario.cgi?opcao=visualizar\&dataMarcada=$dataC">$imprimeDia</a></b>|;
                        }
                     }
                  }
               }
               foreach $umaAtividade (@colecaoAtividades) {
                  if ($dataC eq substr($umaAtividade->getDataLimite(),0,10)) {
                     #$icone = qq|<img src="icones/atencao_amarelo.jpg" border="0"></img> |;
                     $corFundo = $corDestaque;
                     if ($umaAtividade->getLido()) {
                        if ($self->umUsuario->getPrivilegios() == 1) {                         
                           $imprimeDia = qq|<a href="calendario.cgi?opcao=gravar\&dataMarcada=$dataC">$imprimeDia</a>|;
                        } else {
                           $imprimeDia = qq|<a href="calendario.cgi?opcao=visualizar\&dataMarcada=$dataC">$imprimeDia</a>|;
                        }
                     } else {
                        if ($self->umUsuario->getPrivilegios() == 1) {                         
                           $imprimeDia = qq|<b><a href="calendario.cgi?opcao=gravar\&dataMarcada=$dataC">$imprimeDia</a></b>|;
                        } else {
                           $imprimeDia = qq|<b><a href="calendario.cgi?opcao=visualizar\&dataMarcada=$dataC">$imprimeDia</a></b>|;
                        }
                     }
                  }
               }
               if ($dataC eq "$dia/$mes/$ano") {
                  if ($corFundo eq $corDestaque) {
                     $icone = qq|<img src="icones/paradireita_amarelo.jpg" width=16 height=16 border="0"></img>|;
                  } else {
                     $icone = qq|<img src="icones/paradireita.jpg" width=16 height=16 border="0"></img>|;
                  }
                  $imprimeDia = "<b>".$imprimeDia."</b>";
               }
               if ($self->umUsuario->getPrivilegios() == 1 && !($corFundo eq $corDestaque) && $diaC != 0) {
                  $imprimeDia = qq|<a href="calendario.cgi?opcao=gravar\&dataMarcada=$dataC">$imprimeDia</a>|;
               }
               if (substr($self->umUsuario->getDataNascimento(),0,5) eq substr($dataC,0,5)) {
                  if ($corFundo eq $corDestaque) {
                     $icone = qq|<img src="icones/bolo_amarelo.jpg" width=16 height=16 border="0"></img>|;
                  } else {
                     $icone = qq|<img src="icones/bolo.jpg" width=16 height=16 border="0"></img>|;
                  }             
               }
               #####################################################################
               
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                                <td width="16" height="20" bgcolor="$corFundo" valign="middle">$icone</td>
                                <td width="32" height="20" bgcolor="$corFundo" valign="middle"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                $imprimeDia</font></td>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
            }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                                </tr>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                            </table>
                          </td>
                          <td width="20">&nbsp;</td>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                        </tr>
                      </table>
                    </TD>
                  </TR>

|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                      <img src="icones/paradireita.jpg" width=16 height=16 border="0"></img> - Hoje!&nbsp;&nbsp;
                      <img src="icones/bolo.jpg" width=16 height=16 border="0"></img> - Feliz Aniversário!
                      </font></div>
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
# Método que imprime a tela para visualizar o calendário
#################################################################################
sub imprimirTelaVisualizar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umCalendario = new ClasseCalendario;
my $dadosCalendario = new DadosCalendario;

my $dataMarcada = $self->query->param('dataMarcada');

$umCalendario->setDataMarcada($self->query->param('dataMarcada'));

$umCalendario = $dadosCalendario->selecionarCalendario($umCalendario);

$umCalendario->setDataMarcada($self->query->param('dataMarcada'));

my $ano = (&HoraCerta())[5];

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

my @colecaoAvisos = $dadosAvisos->solicitarAvisosCalendario($umCalendario->getDataMarcadaBD(), $self->umUsuario->info->getUltimoAcesso());

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

my @colecaoAtividades = $dadosAtividades->solicitarAtividadesDataLimite($umCalendario->getDataMarcadaBD(), $self->umUsuario->info->getUltimoAcesso(), $self->umUsuario->getCodigoUsuario());


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
                  size=2><b>Calendário $ano</b></FONT></DIV>
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
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000"><b>Informações de  $dataMarcada:</b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   if ($umCalendario->getData() ne "00/00/0000 00:00:00") {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umCalendario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umCalendario}{'umUsuario'}}{'nome'}</a>
                            em ${$umCalendario}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umCalendario}{'texto'}</td>
                          <td width="70">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
   if (@colecaoAvisos) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000"><b>Avisos para $dataMarcada:</b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td align="left">
                            <table width="600" border="0" cellspacing="0" cellpadding="0">
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      foreach $umAviso (@colecaoAvisos) {
         my $titulo = "";
         my $iconeAviso = "";
         if ($umAviso->getLido()) {
            $titulo = $umAviso->getTitulo();
            $iconeAviso = qq |<img src="icones/avisos_pb.jpg" width=16 height=16 border="0"></img>|;
         } else {
            $titulo = "<b>".$umAviso->getTitulo()."</b>";
            $iconeAviso = qq |<img src="icones/avisos.jpg" width=16 height=16 border="0"></img>|;
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr> 
                                <td width="150"> 
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                    ${$umAviso}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                $iconeAviso&nbsp;<a href="avisos.cgi?opcao=visualizar\&codigoAviso=${$umAviso}{'codigoAviso'}">$titulo</a>                                
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umAviso}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umAviso}{'umUsuario'}}{'nome'}</a>)</font></font>
                                </td>
                              </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                            </table>
                          </td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
   if (@colecaoAtividades) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000"><b>Atividades para $dataMarcada:</b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td align="left">
                            <table width="600" border="0" cellspacing="0" cellpadding="0">
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      my $corDataLimite = "";
      my $respondida = "";
      my $corrigida = "";
      foreach $umaAtividade (@colecaoAtividades) {
         my $titulo = "";
         if ($umaAtividade->getLido()) {
            $titulo = $umaAtividade->getTitulo();
         } else {
            $titulo = "<b>".$umaAtividade->getTitulo()."</b>";
         }
         if ($umaAtividade->expirouDataLimite()) {
            $corDataLimite = "999999";
         } else {
             $corDataLimite = "FF0000";
         }
         $respondida = "";
         if ($self->umUsuario->getPrivilegios() != 1) {
            if ($umaAtividade->info->getRespondida()) {
               $respondida = qq | <img src="icones/positivo.jpg" width=16 height=16 border="0"></img> |;
            } else {
               if ($umaAtividade->expirouDataLimite()) {
                  $respondida = qq | <img src="icones/atencao_pb.jpg" width=16 height=16 border="0"></img> |;
               } else {
                  $respondida = qq | <img src="icones/atencao.jpg" width=16 height=16 border="0"></img> |;
               }
            }
         } else {
               if ($umaAtividade->expirouDataLimite()) {
                  $respondida = qq | <img src="icones/atencao_pb.jpg" width=16 height=16 border="0"></img> |;
               } else {
                  $respondida = qq | <img src="icones/atencao.jpg" width=16 height=16 border="0"></img> |;
               }
         }
         $corrigida = "";
         if ($umaAtividade->info->getCorrigida() && ($umaAtividade->expirouDataLimite() || $self->umUsuario->getPrivilegios() == 1)) {
            $corrigida = qq | <img src="icones/corrigido.jpg" width=8 height=8 border="0"></img>|;
         }
         my $dataDivulgacao = "";
         my $tituloAutorizado = qq | <a href="atividades.cgi?opcao=visualizar\&codigoAtividade=${$umaAtividade}{'codigoAtividade'}">$titulo</a>|;
         if (!$umaAtividade->expirouDataDivulgacao() && !$self->umUsuario->getPrivilegios()) {
            $tituloAutorizado = $titulo;
         }
         my $responderAte = qq |Responder até ${$umaAtividade}{'dataLimite'}. |;
         if (!$umaAtividade->expirouDataDivulgacao()) {
            $corDataLimite = "FF0000";
            $respondida = qq | <img src="icones/bloqueado.jpg" width=16 height=16 border="0"></img>|;
            $responderAte = qq |Bloqueada até ${$umaAtividade}{'dataDivulgacao'}. |;
         }


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr>
                                <td width="150">
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                    ${$umaAtividade}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="0000FF">
                                $tituloAutorizado
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaAtividade}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaAtividade}{'umUsuario'}}{'nome'}</a>)</font></font>
                                $corrigida
                                </td>
                              </tr>
                              <tr>
                                <td width="150">
                                </td>
                                <td>
                                   <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="$corDataLimite">
                                     $respondida&nbsp;$responderAte
                                   </font>
                                   &nbsp;
                                </td>
                              </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                            </table>
                          </td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
   if (substr($self->umUsuario->getDataNascimento(),0,5) eq substr($dataMarcada,0,5)) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><img src="icones/bolo.jpg" width=16 height=16 border="0"></img>&nbsp;<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#FF0000"><b>Feliz Aniversário!</b></td>
                          <td width="70">&nbsp;</td>
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
                      </table>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
  |;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if ($self->umUsuario->getPrivilegios() == 1) {

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |
                       [<a href="calendario.cgi?opcao=gravar\&dataMarcada=${$umCalendario}{'dataMarcada'}">Alterar</a>] - 
                       [<a href="calendario.cgi?opcao=apagar\&dataMarcada=${$umCalendario}{'dataMarcada'}">Apagar</a>]  
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
# imprimirTelaGravar
#--------------------------------------------------------------------------------
# Método que imprime a tela para incluir um calendário
#################################################################################
sub imprimirTelaGravar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $umCalendario = new ClasseCalendario();

my $dataMarcada = $self->query->param('dataMarcada');

$umCalendario->setDataMarcada($self->query->param('dataMarcada'));

my $dadosCalendario = new DadosCalendario;


$umCalendario = $dadosCalendario->selecionarCalendario($umCalendario);

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

$umCalendario->setDataMarcada($self->query->param('dataMarcada'));

my $ano = (&HoraCerta)[5];

my $umAviso = new ClasseAviso;
my $dadosAvisos = new DadosAvisos;

my @colecaoAvisos = $dadosAvisos->solicitarAvisosCalendario($umCalendario->getDataMarcadaBD(), $self->umUsuario->info->getUltimoAcesso());

my $umaAtividade = new ClasseAtividade;
my $dadosAtividades = new DadosAtividades;

my @colecaoAtividades = $dadosAtividades->solicitarAtividadesDataLimite($umCalendario->getDataMarcadaBD(), $self->umUsuario->info->getUltimoAcesso(), $self->umUsuario->getCodigoUsuario());

my $editaTexto = &getTextoHTML($umCalendario->getTexto());

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
                  size=2><b>Calendário $ano</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      &nbsp;
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="248"> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="70"> 
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">
                           Informações de $dataMarcada: </font></b></td>
                          <td width="70">&nbsp;</td>
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
                            <input type="hidden" name="opcao" value="gravando">
                            <input type="hidden" name="dataMarcada" value="${$umCalendario}{'dataMarcada'}">
                            <input type="submit" name="Submit" value="Gravar">
                          </td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   if (@colecaoAvisos) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000"><b>Avisos para $dataMarcada:</b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td align="left">
                            <table width="600" border="0" cellspacing="0" cellpadding="0">
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      foreach $umAviso (@colecaoAvisos) {
         my $titulo = "";
         my $iconeAviso = "";
         if ($umAviso->getLido()) {
            $titulo = $umAviso->getTitulo();
            $iconeAviso = qq |<img src="icones/avisos_pb.jpg" width=16 height=16 border="0"></img>|;
         } else {
            $titulo = "<b>".$umAviso->getTitulo()."</b>";
            $iconeAviso = qq |<img src="icones/avisos.jpg" width=16 height=16 border="0"></img>|;
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr> 
                                <td width="150"> 
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                    ${$umAviso}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                $iconeAviso&nbsp;<a href="avisos.cgi?opcao=visualizar\&codigoAviso=${$umAviso}{'codigoAviso'}">$titulo</a>                                
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umAviso}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umAviso}{'umUsuario'}}{'nome'}</a>)</font></font>
                                </td>
                              </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                            </table>
                          </td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
   if (@colecaoAtividades) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000"><b>Atividades para $dataMarcada:</b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr>
                          <td width="70">&nbsp;</td>
                          <td align="left">
                            <table width="600" border="0" cellspacing="0" cellpadding="0">
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      my $corDataLimite = "";
      my $respondida = "";
      my $corrigida = "";
      foreach $umaAtividade (@colecaoAtividades) {
         my $titulo = "";
         if ($umaAtividade->getLido()) {
            $titulo = $umaAtividade->getTitulo();
         } else {
            $titulo = "<b>".$umaAtividade->getTitulo()."</b>";
         }
         if ($umaAtividade->expirouDataLimite()) {
            $corDataLimite = "999999";
         } else {
             $corDataLimite = "FF0000";
         }
         $respondida = "";
         if ($self->umUsuario->getPrivilegios() != 1) {
            if ($umaAtividade->info->getRespondida()) {
               $respondida = qq | <img src="icones/positivo.jpg" width=16 height=16 border="0"></img> |;
            } else {
               if ($umaAtividade->expirouDataLimite()) {
                  $respondida = qq | <img src="icones/atencao_pb.jpg" width=16 height=16 border="0"></img> |;
               } else {
                  $respondida = qq | <img src="icones/atencao.jpg" width=16 height=16 border="0"></img> |;
               }
            }   
         } else {
               if ($umaAtividade->expirouDataLimite()) {
                  $respondida = qq | <img src="icones/atencao_pb.jpg" width=16 height=16 border="0"></img> |;
               } else {
                  $respondida = qq | <img src="icones/atencao.jpg" width=16 height=16 border="0"></img> |;
               }
         }
         $corrigida = "";
         if ($umaAtividade->info->getCorrigida() && ($umaAtividade->expirouDataLimite() || $self->umUsuario->getPrivilegios() == 1)) {
            $corrigida = qq | <img src="icones/corrigido.jpg" width=8 height=8 border="0"></img>|;
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                              <tr> 
                                <td width="150"> 
                                  <div align="left"><font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">
                                    ${$umaAtividade}{'data'}</font></div>
                                </td>
                                <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2">
                                <a href="atividades.cgi?opcao=visualizar\&codigoAtividade=${$umaAtividade}{'codigoAtividade'}">$titulo</a>                                
                                <font size="1" face="Arial, Helvetica, sans-serif"> (<a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umaAtividade}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umaAtividade}{'umUsuario'}}{'nome'}</a>)</font></font>
                                $corrigida
                                </td>
                              </tr>
                              <tr> 
                                <td width="150"> 
                                </td>
                                <td>
                                   <font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="$corDataLimite">
                                     $respondida&nbsp;Responder até ${$umaAtividade}{'dataLimite'}. 
                                   </font>
                                   &nbsp;                                   
                                </td>
                              </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                            </table>
                          </td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
   if (substr($self->umUsuario->getDataNascimento(),0,5) eq substr($dataMarcada,0,5)) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70" height="8">&nbsp;</td>
                          <td height="8">&nbsp;</td>
                          <td width="70" height="8">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><img src="icones/bolo.jpg" width=16 height=16 border="0"></img>&nbsp;<font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#FF0000"><b>Feliz Aniversário!</b></td>
                          <td width="70">&nbsp;</td>
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
# imprimirTelaGravando
#--------------------------------------------------------------------------------
# Método que inclui um calendário e apresenta o resultado
#################################################################################
sub imprimirTelaGravando {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $umCalendario = new ClasseCalendario;
   my $dadosCalendario = new DadosCalendario;

   $umCalendario->setDadosIU($self->query->param('dataMarcada'),
                        $self->query->param('texto'),
                        $self->umUsuario->getCodigoUsuario());


   $dadosCalendario->gravar($umCalendario);

   $self->imprimirMensagem("Calendário gravado com sucesso!","calendario.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaApagar
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar o calendário para excluir
#################################################################################
sub imprimirTelaApagar {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

my $umCalendario = new ClasseCalendario;
my $dadosCalendario = new DadosCalendario;

my $dataMarcada = $self->query->param('dataMarcada');

$umCalendario->setDataMarcada($self->query->param('dataMarcada'));

$umCalendario = $dadosCalendario->selecionarCalendario($umCalendario);


my $ano = (&HoraCerta())[5];

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
                  size=2><b>Calendário $ano</b></FONT></DIV>
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
                          <td width="70"> 
                            <div align="right"></div>
                          </td>
                          <td><b><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#CC0000">
                           Informações de $dataMarcada: </font></b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2"><font size="2" face="Verdana, Arial, Helvetica, sans-serif" color="#006600">Postado por 
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umCalendario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${${$umCalendario}{'umUsuario'}}{'nome'}</a>
                            em ${$umCalendario}{'data'}.</font></td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">${$umCalendario}{'texto'}</td>
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
                           <font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                           <input type="hidden" name="opcao" value="apagando">
                           <input type="hidden" name="dataMarcada" value="${$umCalendario}{'dataMarcada'}">
                           <input type="submit" name="submit" value="Apagar Informações">
                          </td>
                          <td width="70">&nbsp;</td>
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
# imprimirTelaApagando
#--------------------------------------------------------------------------------
# Método que exclui um calendário e apresenta o resultado
#################################################################################
sub imprimirTelaApagando {

   my $self = shift;

   if ($self->umUsuario->getPrivilegios() != 1) {
      print "<!--";
      die "Usuário não autorizado!\n";
   }

   my $dadosCalendario = new DadosCalendario;
   my $umCalendario = new ClasseCalendario();

   $umCalendario->setDataMarcada($self->query->param('dataMarcada'));

   $dadosCalendario->excluir($umCalendario->getDataMarcadaBD());

   $self->imprimirMensagem("Informações apagadas com sucesso!","calendario.cgi",0);

}

#################################################################################










#################################################################################
# imprimirTelaAniversarios
#--------------------------------------------------------------------------------
# Método que imprime a tela com calendario e aniversários
#################################################################################
sub imprimirTelaAniversarios {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

if ($self->umUsuario->getPrivilegios() != 1) {  
   print "<!--";
   die "Usuário não autorizado!\n";
}

my $umCalendario = new ClasseCalendario;
my $dadosCalendario = new DadosCalendario;
my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

my @colecaoUsuarios = $dadosUsuarios->solicitar();

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
                  size=2><b>Aniversários $ano</b></FONT></DIV>
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <HR SIZE=1>
                    </TD>
                  </TR>

|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

  
   my $mesC = 0;

   my $diaSemana = (localtime(time))[6];
   my $diaAno    = (localtime(time))[7];
   for (my $contDias = $diaAno-1; $contDias >= 0; $contDias--) {
      $diaSemana--;
      if ($diaSemana == -1) {
         $diaSemana = 6;
      }
   }
   $diaSemana++;   

   my $bissexto = 0;
   if ($ano % 4 == 0) {
      $bissexto = 1;
   }

   for (my $i = 1; $i <= 6; $i++) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |

                  <TR> 
                    <TD height="2"> 
                      <table width="746" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="20">&nbsp;</td>
                          <td width="10">&nbsp;</td>
                          <td width="20">&nbsp;</td>
                          <td>&nbsp;</td>
                          <td width="20">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="20">&nbsp;</td>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML      
      for (my $j = 1; $j <= 2; $j++) {
          my $textoMes = &TextualizaMes($mesC);
          $mesC++;
          my $diaC = 0;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                          <td width="10"> 
                            <table width="340" border="0" cellspacing="0" cellpadding="0">
                              <tr bgcolor="#000000"> 
                                <td colspan="14" height="8"> 
                                  <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><font color="#FFFFFF">$textoMes</font></b></font></div>
                                </td>
                              </tr>
                              <tr bgcolor="#00AAFF"> 
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Dom</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Seg</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Ter</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Qua</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Qui</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font color="#FFFFFF" size="2" face="Verdana, Arial, Helvetica, sans-serif">Sex</font></b></div>
                                </td>
                                <td colspan="2"> 
                                  <div align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#FFFFFF">Sab</font></b></div>
                                </td>
                              </tr>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         my $terminouMes = 0;
         for (my $k = 1; $k <= 6; $k++) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                               <tr>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
            for (my $l = 1; $l <= 7; $l++) {
               my $imprimeDia = "\&nbsp\;";
               if ($diaSemana == $l && !$terminouMes) {
                  $diaC++;
                  $diaSemana++;
                  if ($diaSemana > 7) { $diaSemana = 1; } 
                  if (($diaC > 31) && ($mesC == 1 || $mesC == 3 || $mesC == 5 || $mesC == 7 || $mesC == 8 || $mesC == 10 || $mesC == 12)) {
                     $diaC = 0;
                     $diaSemana--;
                     if ($diaSemana < 1) { $diaSemana = 7; }   
                     $terminouMes = 1;
                  }
                  if (($diaC > 30) && ($mesC == 4 || $mesC == 6 || $mesC == 9 || $mesC == 11)) {
                     $diaC = 0;
                     $diaSemana--;
                     if ($diaSemana < 1) { $diaSemana = 7; }   
                     $terminouMes = 1;
                  } 
                  if (($diaC > 28 && $mesC == 2 && !$bissexto) || ($diaC > 29 && $mesC == 2 && $bissexto)) {
                     $diaC = 0;
                     $diaSemana--;
                     if ($diaSemana < 1) { $diaSemana = 7; }   
                     $terminouMes = 1;
                  } 
                  if (!$terminouMes) {
                     $imprimeDia = &ZeroEsquerda($diaC,2);
                  }
               }

               my $icone = "";
               my $corFundo = "FFFFFF";
               my $corDestaque = "FFFF55";
               #####################################################################               
               my $dataC = &ZeroEsquerda($diaC,2)."/".&ZeroEsquerda($mesC,2)."/$ano";
               foreach $umUsuario (@colecaoUsuarios) {
                  if (substr($dataC,0,5) eq substr($umUsuario->getDataNascimento(),0,5)) {
                     $icone = qq|<img src="icones/bolo_amarelo.jpg" width=16 height=16 border="0"></img>|;
                     $corFundo = $corDestaque;
                     $imprimeDia = qq|<b><a href="calendario.cgi?opcao=visualizarAniversarios\&dataMarcada=$dataC">$imprimeDia</a></b>|;
                  }
               }
               #####################################################################
               
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                                <td width="16" height="20" bgcolor="$corFundo" valign="middle">$icone</td>
                                <td width="32" height="20" bgcolor="$corFundo" valign="middle"><font size="2" face="Verdana, Arial, Helvetica, sans-serif">
                                $imprimeDia</font></td>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
            }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                                </tr>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                            </table>
                          </td>
                          <td width="20">&nbsp;</td>
|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
      }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                        </tr>
                      </table>
                    </TD>
                  </TR>

|; ##---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
   }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML 
print qq |
                    </TD>
                  </TR>
                  <TR> 
                    <TD height="2"> 
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" size="1" color="#000000">
                      <img src="icones/paradireita.jpg" width=16 height=16 border="0"></img> - Hoje!&nbsp;&nbsp;
                      <img src="icones/bolo.jpg" width=16 height=16 border="0"></img> - Feliz Aniversário!
                      </font></div>
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
# imprimirTelaVisualizarAniversarios
#--------------------------------------------------------------------------------
# Método que imprime a tela para visualizar aniversários
#################################################################################
sub imprimirTelaVisualizarAniversarios {

my $self = shift;

my $menuinf = $self->linkMenuInferior();

my $ano = (&HoraCerta())[5];

my $dataMarcada = $self->query->param('dataMarcada');

my $umUsuario = new ClasseUsuario;
my $dadosUsuarios = new DadosUsuarios;

my @colecaoUsuarios = $dadosUsuarios->solicitar();

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
                  size=2><b>Aniversários $ano</b></FONT></DIV>
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
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#CC0000"><b>Aniversários de  $dataMarcada:</b></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

   if (@colecaoUsuarios) {
      foreach $umUsuario (@colecaoUsuarios) {
         my $titulo = "";
         my $iconeUsuario = "";
         if ($umUsuario->getSexo() == 0) {
            $iconeUsuario = qq |<img src="icones/usuaria_online.jpg" width=16 height=16 border="0"></img>|;
         } else {
            $iconeUsuario = qq |<img src="icones/usuario_online.jpg" width=16 height=16 border="0"></img>|;
         }        
         if (substr($umUsuario->getDataNascimento(),0,5) eq substr($dataMarcada,0,5)) {
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
                        <tr> 
                          <td width="70">&nbsp;</td>
                          <td><font face="Verdana, Arial, Helvetica, sans-serif" size="2" color="#000000">
                            $iconeUsuario&nbsp;        
                            <a href=# onClick=window.open("usuarios.cgi?opcao=visualizarPerfil\&codigoUsuario=${$umUsuario}{'codigoUsuario'}","","width=790,height=310,top=50,left=50,scrollbars=yes,status=yes,toolbar=no,menubar=no,resizable=yes")>${$umUsuario}{'nome'}</a>
                           </font></td>
                          <td width="70">&nbsp;</td>
                        </tr>
                        <tr> 
                          <td width="70" height="2">&nbsp;</td>
                          <td height="2">&nbsp;</td>
                          <td width="70" height="2">&nbsp;</td>
                        </tr>
  |;
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
         }
      }
   }
#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML
print qq |
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












1;


