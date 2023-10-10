package DadosAtividades;

use strict;
use ConexaoMySQL;
use ClasseAtividade;
use FuncoesCronologicas;







#################################################################################
# DadosAtividades
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de atividades.
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
      umaConexao => ConexaoMySQL->new,
   };
   bless ($self,$class);
   return $self;
}
#################################################################################









#################################################################################
# umaConexao
#--------------------------------------------------------------------------------
# Método para manipulador de conexão.
#################################################################################
sub umaConexao {
   my $self = shift;
   if (@_) {
      $self->{umaConexao} = shift;
   }
   return $self->{umaConexao};
}
#################################################################################









#################################################################################
# existeTabela
#--------------------------------------------------------------------------------
# Método que verifica se a tabela Atividade existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de atividades!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Atividade") {
         $existe = 1;
      }
   } 
   $SQL->finish;
   return $existe;
}
#################################################################################









#################################################################################
# criarTabela
#--------------------------------------------------------------------------------
# Método que verifica se a tabela Atividade existe, se não existir irá tentar 
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Atividade (";
      $tSQL = $tSQL."CodigoAtividade int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."DataLimite datetime not null,";
      $tSQL = $tSQL."HabAnexo bool,";
      $tSQL = $tSQL."ValorNota float(5,2), ";
      $tSQL = $tSQL."CodigoUsuario int not null, ";
      $tSQL = $tSQL."DataDivulgacao datetime not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de atividades na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma atividade na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaAtividade = $_[0];
      if ($umaAtividade->getCodigoAtividade() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Atividade set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Atividade set ";
         $fSQL = "WHERE CodigoAtividade = ".$umaAtividade->getCodigoAtividade()." ";
      }
      $tSQL = $tSQL."Titulo = \'".$umaAtividade->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umaAtividade->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umaAtividade->getDataBD()."\', ";
      $tSQL = $tSQL."DataLimite = \'".$umaAtividade->getDataLimiteBD()."\', ";
      $tSQL = $tSQL."HabAnexo = \'".$umaAtividade->getHabAnexo()."\', ";
      $tSQL = $tSQL."ValorNota = \'".$umaAtividade->getValorNota()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umaAtividade->getCodigoUsuario()."\', ";
      $tSQL = $tSQL."DataDivulgacao = \'".$umaAtividade->getDataDivulgacaoBD()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar atividade!\n";
      if ($linhas == 0) {
         #die "Atividade não foi gravada!\n";
      }
   } else {
      die "Nenhuma atividade foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as atividades da base de dados em ordem de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Atividade order by Data Desc ";
   my @colecaoAtividades = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar atividades!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAtividades[$i] = new ClasseAtividade;
      $colecaoAtividades[$i]->setDadosBD($r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAtividades;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui a atividade da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoAtividade = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Atividade WHERE CodigoAtividade = ".$codigoAtividade." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a atividade!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeResposta WHERE CodigoAtividade = ".$codigoAtividade." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as respostas da atividade!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."AtividadeCorrecao WHERE CodigoAtividade = ".$codigoAtividade." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as correções da atividade!";
}
#################################################################################










#################################################################################
# selecionarAtividade
#--------------------------------------------------------------------------------
# Método que seleciona uma atividade a partir de seu código
#################################################################################
sub selecionarAtividade {
   my $self = shift;
   my $codigoAtividade = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Atividade AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoAtividade = ".$codigoAtividade." ";
   my $umaAtividade = new ClasseAtividade;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a atividade!\n";
   while (my $r = $SQL->fetchrow_hashref) {
       $umaAtividade->setDadosBD($r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
       $umaAtividade->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaAtividade->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umaAtividade;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de atividades na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Atividade ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de atividades!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# solicitarParcial
#--------------------------------------------------------------------------------
# Método que solicita parcialmente as atividades da base de dados.
#################################################################################
sub solicitarParcial {
   my $self = shift;
   my $indicePagina = $_[0];
   my $quantosPagina = $_[1];
   my $ultimoAcesso = $_[2];
   my $posicao = ($indicePagina-1) * $quantosPagina;
   my $tSQL = "SELECT A.*,U.Nome, (A.Data < \'$ultimoAcesso\') AS Lido, ";
   $tSQL .= "COUNT(C.CodigoCorrecao) AS QtdeCorrecoes, ";
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Atividade as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeResposta as R ";
   $tSQL .= "ON A.CodigoAtividade = R.CodigoAtividade ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeCorrecao as C ";
   $tSQL .= "ON A.CodigoAtividade = C.CodigoAtividade ";
   $tSQL .= "GROUP BY A.CodigoAtividade ";
   $tSQL .= "ORDER BY A.Data Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoAtividades = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar atividades!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAtividades[$i] = new ClasseAtividade;
      $colecaoAtividades[$i]->setDadosBD($r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoAtividades[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAtividades[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoAtividades[$i]->setLido($r->{'Lido'});
      $colecaoAtividades[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoAtividades[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAtividades;
}
#################################################################################










#################################################################################
# quantosNaoLido
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de atividades não lidas
#################################################################################
sub quantosNaoLido {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Atividade ";
   $tSQL .= "WHERE (Data >= \'$ultimoAcesso\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de atividades não lidas!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################










#################################################################################
# solicitarParcialAluno
#--------------------------------------------------------------------------------
# Método que solicita parcialmente as atividades da base de dados de acordo
# com informações do aluno
#################################################################################
sub solicitarParcialAluno {
   my $self = shift;
   my $indicePagina = $_[0];
   my $quantosPagina = $_[1];
   my $ultimoAcesso = $_[2];
   my $codigoUsuario = $_[3];
   my $posicao = ($indicePagina-1) * $quantosPagina;
   my $tSQL = "SELECT A.*,U.Nome, (A.Data < \'$ultimoAcesso\') AS Lido, ";
   $tSQL .= "MAX(R.CodigoUsuario = $codigoUsuario) AS Respondida, ";
   $tSQL .= "MAX(CASE WHEN R.CodigoUsuario = $codigoUsuario THEN R.Nota ELSE -1 END) AS NotaAluno, ";
   $tSQL .= "COUNT(C.CodigoCorrecao) AS QtdeCorrecoes, ";
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Atividade as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeResposta as R ";
   $tSQL .= "ON A.CodigoAtividade = R.CodigoAtividade ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeCorrecao as C ";
   $tSQL .= "ON A.CodigoAtividade = C.CodigoAtividade ";
   $tSQL .= "GROUP BY A.CodigoAtividade ";
   $tSQL .= "ORDER BY A.Data Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoAtividades = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar atividades!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAtividades[$i] = new ClasseAtividade;
      $colecaoAtividades[$i]->setDadosBD($r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoAtividades[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAtividades[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoAtividades[$i]->setLido($r->{'Lido'});
      $colecaoAtividades[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoAtividades[$i]->info->setRespondida($r->{'Respondida'});
      $colecaoAtividades[$i]->info->setNota($r->{'NotaAluno'});
      $colecaoAtividades[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAtividades;
}
#################################################################################










#################################################################################
# solicitarAtividades
#--------------------------------------------------------------------------------
# Método que solicita parcialmente as atividades da base de dados.
#################################################################################
sub solicitarAtividades {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT A.*,U.Nome, (A.Data < \'$ultimoAcesso\') AS Lido, ";
   $tSQL .= "COUNT(C.CodigoCorrecao) AS QtdeCorrecoes, ";
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Atividade as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeResposta as R ";
   $tSQL .= "ON A.CodigoAtividade = R.CodigoAtividade ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeCorrecao as C ";
   $tSQL .= "ON A.CodigoAtividade = C.CodigoAtividade ";
   $tSQL .= "GROUP BY A.CodigoAtividade ";
   $tSQL .= "ORDER BY A.Data ";
   my @colecaoAtividades;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar atividades!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAtividades[$i] = new ClasseAtividade;
      $colecaoAtividades[$i]->setDadosBD($r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoAtividades[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAtividades[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoAtividades[$i]->setLido($r->{'Lido'});
      $colecaoAtividades[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoAtividades[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAtividades;
}
#################################################################################










#################################################################################
# solicitarAtividadesDataLimite
#--------------------------------------------------------------------------------
# Método que solicita parcialmente as atividades da base de dados.
#################################################################################
sub solicitarAtividadesDataLimite {
   my $self = shift;
   my $dataLimiteBD = $_[0];
   my $ultimoAcesso = $_[1];
   my $codigoUsuario = $_[2];
   my $tSQL = "SELECT A.*,U.Nome, (A.Data < \'$ultimoAcesso\') AS Lido, ";
   $tSQL .= "MAX(R.CodigoUsuario = $codigoUsuario) AS Respondida, ";
   $tSQL .= "COUNT(C.CodigoCorrecao) AS QtdeCorrecoes, ";
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Atividade as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeResposta as R ";
   $tSQL .= "ON A.CodigoAtividade = R.CodigoAtividade ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."AtividadeCorrecao as C ";
   $tSQL .= "ON A.CodigoAtividade = C.CodigoAtividade ";
   $tSQL .= "WHERE A.DataLimite >= \'$dataLimiteBD 00:00:00\' AND A.DataLimite <= \'$dataLimiteBD 23:59:59\' ";
   $tSQL .= "GROUP BY A.CodigoAtividade ";
   $tSQL .= "ORDER BY A.Data DESC ";
   my @colecaoAtividades;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar atividades!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoAtividades[$i] = new ClasseAtividade;
      $colecaoAtividades[$i]->setDadosBD($r->{'CodigoAtividade'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoAtividades[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoAtividades[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoAtividades[$i]->setLido($r->{'Lido'});
      $colecaoAtividades[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoAtividades[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $colecaoAtividades[$i]->info->setRespondida($r->{'Respondida'});
      $i++;
   }
   $SQL->finish;
   return @colecaoAtividades;
}
#################################################################################










#################################################################################
# quantosHoje
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de atividades que expiram hoje
#################################################################################
sub quantosHoje {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Atividade ";
   $tSQL .= "WHERE (DataLimite >= \'$ano-$mes-$dia 00:00:00\' AND DataLimite <= \'$ano-$mes-$dia 23:59:59\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de atividades não lidas!\n";
   while (my $r = $SQL->fetchrow_hashref) {
      $qtde = $r->{'qtde'};
   }
   $SQL->finish;
   return $qtde;
}
#################################################################################



















#################################################################################
# atualizar02
#--------------------------------------------------------------------------------
# Método que atualiza os dados da tabela atividade:
# - nova coluna (DataDivulgacao datetime)
#################################################################################
sub atualizar02 {

   my $self = shift;
   my $tSQL = "DESC ".$self->umaConexao->getTab()."Atividade ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a tabela atividade!\n";
   my $coluna = "";
   my $existe = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $coluna = $r->{'Field'};
      if ($coluna eq "DataDivulgacao") {
         $existe = 1;
      }
   }
   $SQL->finish;

   if (!$existe) {
      my $tSQL = "ALTER TABLE ".$self->umaConexao->getTab."Atividade ADD COLUMN DataDivulgacao datetime DEFAULT \'0000-00-00 00:00:00\' ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao fazer atualização na tabela Atividade!\n";
      $SQL->finish;
   }

}
#################################################################################












1;
