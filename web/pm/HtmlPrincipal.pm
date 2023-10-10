package HtmlPrincipal;

use strict;
use ClasseUsuario;
use DadosUsuarios;
use ClasseAmbiente;
use DadosAmbiente;
use FuncoesCronologicas;
use DadosAvisos;
use DadosAtividades;
use DadosPerguntas;
use DadosMateriais;
use DadosCalendario;
use DadosTestesUsuarios;





#################################################################################
# HtmlPrincipal
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe para imprimir Html padrão do site.
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
   };
   bless ($self, $class);
   return ($self);
}
#################################################################################










#################################################################################
# umUsuario
#--------------------------------------------------------------------------------
# Método para manipular o atributo umUsuario
#################################################################################
sub umUsuario {
   my $self = shift;
   if (@_) {
      $self->{umUsuario} = shift;
   }
   return ($self->{umUsuario});
}
#################################################################################









#################################################################################
# imprimirCabecalho
#--------------------------------------------------------------------------------
# Método que imprime o cabeçalho HTML
#################################################################################
sub imprimirCabecalho {
my $self = shift;

my $cgiForm = $ENV{'SCRIPT_NAME'};

my $formAction = qq|<FORM action="$cgiForm" method="post" ENCTYPE="multipart/form-data">|;

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

<HTML><HEAD><TITLE>${$umAmbiente}{'titulo'}</TITLE>
<META http-equiv='pragma' content='no-cache'>
<META http-equiv='expires' content='0'>
</HEAD>
<BODY text=#000000 vLink=#0000ff aLink=#0033ff link=#0033ff bgColor=#${$umAmbiente}{corDeFundo}>
$formAction
<DIV align=center>
    <TABLE cellSpacing=0 cellPadding=0 width=750 border=0>
      <TBODY>
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
                    <TD width=341 rowspan=3>
                      <DIV align=center><IMG
                  src="$cartaz"
                  width=360 height=40></DIV>
                    </TD>
                    <TD width=405><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" color=#000000
                  size=2><B>${$umAmbiente}{'linha1'}</B></FONT></TD>
                  </TR>
                  <TR>
                    <TD width=405><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" color=#666666
                  size=1>${$umAmbiente}{'linha2'}</FONT></TD>
                  </TR>
                  <TR>
                    <TD width=405><FONT
                  face="Verdana, Arial, Helvetica, sans-serif" color=#666666
                  size=1>${$umAmbiente}{'linha3'}</FONT></TD>
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
# imprimirBoasVindas
#--------------------------------------------------------------------------------
# Método que imprime as boas vindas
#################################################################################
sub imprimirBoasVindas {
my $self = shift;

my ($hor,$min,$seg,$dia,$mes,$ano,$textdiasemana,$sigladiasemana,$textmes) = &HoraCerta();

my $texto = "<b>".$self->umUsuario->getNome()."</b>. ";
if (substr($self->umUsuario->getDataNascimento(),0,5) eq "$dia/$mes") {
   $texto .= "<b><font color=FF0000>Feliz Anivers&aacute;rio!</font></b> - ";
} else {
   if ($self->umUsuario->getSexo() == 0) {
      $texto .= "Seja bem-vinda! - ";
   } else {
      $texto .= "Seja bem-vindo! - ";
   }
}
$texto .= "$textdiasemana, $dia de $textmes de $ano ($hor:$min)";


#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR>
        <TD>
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750
        border=2>
            <TBODY>
            <TR>
              <TD bgColor=#ffffff>
                <DIV align=center><FONT face="Verdana, Arial, Helvetica, sans-serif " color=#006600 size=1>
                 $texto
                </FONT></DIV>
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
# imprimirMenu
#--------------------------------------------------------------------------------
# Método que imprime o menu
#################################################################################
sub imprimirMenu {
my $self = shift;

my $dadosUsuarios = new DadosUsuarios;
my $qtdeUsuariosOnline = $dadosUsuarios->quantidadeUsuariosOnline();

my $umAmbiente = new ClasseAmbiente;
my $dadosAmbiente = new DadosAmbiente;

$umAmbiente = $dadosAmbiente->selecionar();


my $linkAvisos = "";
my $dadosAvisos = new DadosAvisos;
if ($dadosAvisos->quantosNaoLido($self->umUsuario->info->getUltimoAcesso())) {
   $linkAvisos = qq | <td width="20"><img src="icones/avisos.jpg" width="15" height="15"></td>
                      <td width="112" align="left" valign="middle"><a href="avisos.cgi"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#0000FF"><b>Avisos</b></font></font></font></font></font></a></td> |;
 } else {
   $linkAvisos = qq | <td width="20"><img src="icones/avisos.jpg" width="15" height="15"></td>
                      <td width="112" align="left" valign="middle"><a href="avisos.cgi"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#0000FF">Avisos</font></font></font></font></font></a></td> |;
}


my $linkCalendario = "";
my $dadosCalendario = new DadosCalendario;
my $dadosAtividades = new DadosAtividades;
if ($umAmbiente->getHabCalendario()) {
   my $lidoCalendario = "Calend\&aacute\;rio";
   if ($dadosCalendario->quantosNaoLido($self->umUsuario->info->getUltimoAcesso())) {
      $lidoCalendario = "<b>Calend\&aacute\;rio</b>";
   }
   if ($dadosAtividades->quantosHoje()) {
      $lidoCalendario = "<b>Calend\&aacute\;rio</b>";
   }
   if ($dadosAvisos->quantosHoje()) {
      $lidoCalendario = "<b>Calend\&aacute\;rio</b>";
   }
   $linkCalendario = qq | <td width="20"><img src="icones/calendario.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="calendario.cgi">$lidoCalendario</a></font></font></font></font></font></td> |;
} else {
   $linkCalendario = qq | <td width="20"><img src="icones/calendario_pb.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          Calend&aacute;rio</font></font></font></font></font></td> |;
}

my $linkAtividades = "";
my $dadosAtividades = new DadosAtividades;
if ($umAmbiente->getHabAtividades()) {
   my $lidoAtividades = "Atividades";
   if ($dadosAtividades->quantosNaoLido($self->umUsuario->info->getUltimoAcesso())) {
      $lidoAtividades = "<b>Atividades</b>";

   }
   $linkAtividades = qq | <td width="20"><img src="icones/atividades.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="atividades.cgi">$lidoAtividades</a></font></font></font></font></font></td> |;
} else {
   $linkAtividades = qq | <td width="20"><img src="icones/atividades_pb.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          Atividades</font></font></font></font></font></td> |;
}

my $linkAnotacoes = "";
if ($umAmbiente->getHabAnotacoes()) {
   $linkAnotacoes = qq | <td width="20"><img src="icones/anotacoes.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="anotacoes.cgi">Anota&ccedil;&otilde;es<img src="icones/arquivo_privado.jpg" width="10" height="10"></a></font></font></font></font></font></td> |;
} else {
   $linkAnotacoes = qq | <td width="20"><img src="icones/anotacoes_pb.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          Anota&ccedil;&otilde;es</font></font></font></font></font></td> |;
}

my $linkArquivos = "";
if ($umAmbiente->getHabArquivos()) {
   $linkArquivos = qq | <td width="20"><img src="icones/arquivos.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="arquivos.cgi">Arquivos<img src="icones/arquivo_privado.jpg" width="10" height="10"></a></font></font></font></font></font></td> |;
} else {
   $linkArquivos = qq | <td width="20"><img src="icones/arquivos_pb.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          Arquivos</font></font></font></font></font></td> |;
}

my $linkMateriais = "";
my $dadosMateriais = new DadosMateriais;
if ($umAmbiente->getHabMateriais()) {
   my $lidoMateriais = "Materiais";
   if ($dadosMateriais->quantosNaoLido($self->umUsuario->info->getUltimoAcesso())) {
      $lidoMateriais = "<b>Materiais</b>";

   }
   $linkMateriais = qq | <td width="20"><img src="icones/materiais.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="materiais.cgi">$lidoMateriais</a></font></font></font></font></font></td> |;
} else {
   $linkMateriais = qq | <td width="20"><img src="icones/materiais_pb.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          Materiais</font></font></font></font></font></td> |;
}

my $linkDesafios = "";
if ($umAmbiente->getHabDesafios()) {
   $linkDesafios = qq | <td width="20"><img src="icones/notas.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="notas.cgi">Notas</a></font></font></font></font></font></td> |;
} else {
   $linkDesafios = qq | <td width="20"><img src="icones/notas_pb.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          Notas</font></font></font></font></font></td> |;
}

my $linkPerguntas = "";
my $dadosPerguntas = new DadosPerguntas;
if ($umAmbiente->getHabPerguntas()) {
   my $lidoPerguntas = "Perguntas";
   if ($dadosPerguntas->quantosNaoLido($self->umUsuario->info->getUltimoAcesso())) {
      $lidoPerguntas = "<b>Perguntas</b>";

   }
   $linkPerguntas = qq | <td width="20"><img src="icones/perguntas.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="perguntas.cgi">$lidoPerguntas</a></font></font></font></font></font></td> |;
} else {
   $linkPerguntas = qq | <td width="20"><img src="icones/perguntas_pb.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          Perguntas</font></font></font></font></font></td> |;
}

my $linkTestes = "";
my $dadosTestesUsuarios = new DadosTestesUsuarios;
my $lidoTestes = "Testes";
if ($dadosTestesUsuarios->qtdeTestesAbertos($self->umUsuario->getCodigoUsuario()) > 0) {
   $lidoTestes = "<b>Testes</b>";
}
if ($umAmbiente->getHabTestes()) {
   $linkTestes = qq | <td width="20"><img src="icones/testes.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">
                          <a href="testes.cgi">$lidoTestes</a></font></font></font></font></font></td> |;
} else {
   $linkTestes = qq | <td width="20"><img src="icones/testes_pb.jpg" width="15" height="15"></td><td width="112" align="left" valign="middle"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#666666">$lidoTestes</font></font></font></font></font></td> |;
}



#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML

print qq |

      <TR>
        <TD height="17">
          <table bordercolor=#000000 cellspacing=0 cellpadding=0 width=750
        border=2>
            <tbody>
            <tr>
              <td bgcolor=#ffffff height="24">
                <table width="746" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td width="20" height="3">&nbsp;</td>
                    <td height="3">
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                          $linkAvisos
                        </tr>
                      </table>
                    </td>
                    <td height="3"> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                           $linkAtividades
                        </tr>
                      </table>
                    </td>
                    <td height="3"> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          $linkTestes
                        </tr>
                      </table>
                    </td>
                    <td height="3"> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          $linkPerguntas
                        </tr>
                      </table>
                    </td>
                    <td> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                         $linkDesafios
                        </tr>
                      </table>
                    </td>
                    <td height="3"> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="20" height="17"><img src="icones/ambiente.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle" height="17"><a href="ambiente.cgi"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif" color="#0000FF">Sobre</font></font></a></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr> 
                    <td>&nbsp;</td>
                    <td> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                         $linkCalendario
                        </tr>
                      </table>
                    </td>
                    <td> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                         $linkAnotacoes
                        </tr>
                      </table>
                    </td>
                    <td> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                         $linkArquivos
                        </tr>
                      </table>
                    </td>
                    <td height="3"> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                           $linkMateriais
                        </tr>
                      </table>
                    </td>
                     <td> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="20"><img src="icones/usuarios.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><a href="usuarios.cgi"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#0000FF"><a href="usuarios.cgi">Usu&aacute;rios</a>&nbsp;($qtdeUsuariosOnline)</font></font></font></font></font></td>
                        </tr>
                      </table>
                    </td>
                    <td> 
                      <table width="122" border="0" cellspacing="0" cellpadding="0">
                        <tr> 
                          <td width="20"><img src="icones/sair.jpg" width="15" height="15"></td>
                          <td width="112" align="left" valign="middle"><a href="index.cgi?opcao=sair"><font size="2"><font size="2"><font face="Verdana, Arial, Helvetica, sans-serif"><font face="Verdana, Arial, Helvetica, sans-serif"><font color="#0000FF">Sair</font></font></font></font></font></a></td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            </tbody> 
          </table>
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
# imprimirRodape
#--------------------------------------------------------------------------------
# Método que imprime o rodapé
#################################################################################
sub imprimirRodape {
my $self = shift;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML  

print qq |

      <TR> 
        <TD height="26"> 
          <TABLE borderColor=#000000 cellSpacing=0 cellPadding=0 width=750 
        border=2 height="11">
            <TBODY> 
            <TR> 
              <TD bgColor=#ffffff valign="top" height="11"> 
                <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" >
                  <tr> 

                    <td valign="middle" width="500">
                      <div align="center"><font face="Verdana, Arial, Helvetica, sans-serif" color=#444444 size=1><b>&copy;</b>2004-2023 GradeNet 4.0 <a href="http://www.gradenet.com.br" target="_new"><img src="imagens/logogradenet.jpg" border=0></a> </font></div>
                    </td>

                  </tr>
                </table>
              </TD>
            </TR>
            </TBODY> 
          </TABLE>
        </TD>
      </TR>
      </TBODY> 
    </TABLE>
  </DIV></FORM></BODY></HTML>

|;

#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---#---# HTML  

}
#################################################################################










1;
