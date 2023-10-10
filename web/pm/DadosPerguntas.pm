package DadosPerguntas;

use strict;
use ConexaoMySQL;
use ClassePergunta;
use FuncoesCronologicas;







#################################################################################
# DadosPerguntas
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe de acesso à base da dados de perguntas.
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
# Método que verifica se a tabela Pergunta existe.
#################################################################################
sub existeTabela {
   my $self = shift;
   my $tSQL = "SHOW TABLES";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   my $existe = 0;   
   $SQL->execute or die "Problemas ao consultar tabelas de perguntas!\n";
   my $i = 0;
   while (my $nomeTabelas = $SQL->fetchrow_arrayref) { 
      if ($nomeTabelas->[0] eq $self->umaConexao->getTab."Pergunta") {
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
# Método que verifica se a tabela Pergunta existe, se não existir irá tentar 
# criá-la.
#################################################################################
sub criarTabela {
   my $self = shift;
   if (!$self->existeTabela()) {
      my $tSQL = "CREATE TABLE ".$self->umaConexao->getTab."Pergunta (";
      $tSQL = $tSQL."CodigoPergunta int PRIMARY KEY AUTO_INCREMENT,";
      $tSQL = $tSQL."Titulo varchar(60) not null,";
      $tSQL = $tSQL."Texto text,";
      $tSQL = $tSQL."Data datetime not null,";
      $tSQL = $tSQL."DataLimite datetime not null,";
      $tSQL = $tSQL."HabAnexo bool,";
      $tSQL = $tSQL."ValorNota float(5,2), ";
      $tSQL = $tSQL."CodigoUsuario int not null, ";
      $tSQL = $tSQL."DataDivulgacao datetime not null) ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao criar tabelas de perguntas na base de dados!\n";
      $SQL->finish;
   }
}
#################################################################################









#################################################################################
# gravar
#--------------------------------------------------------------------------------
# Método que grava uma pergunta na base de dados.
#################################################################################
sub gravar {
   my $self = shift;
   if (@_) {
      my $tSQL = "";
      my $fSQL = "";
      my $umaPergunta = $_[0];
      if ($umaPergunta->getCodigoPergunta() == 0) {
         $tSQL = "INSERT INTO ".$self->umaConexao->getTab()."Pergunta set ";
      } else {
         $tSQL = "UPDATE ".$self->umaConexao->getTab()."Pergunta set ";
         $fSQL = "WHERE CodigoPergunta = ".$umaPergunta->getCodigoPergunta()." ";
      }
      $tSQL = $tSQL."Titulo = \'".$umaPergunta->getTitulo()."\', ";
      $tSQL = $tSQL."Texto = \'".$umaPergunta->getTexto()."\', ";
      $tSQL = $tSQL."Data = \'".$umaPergunta->getDataBD()."\', ";
      $tSQL = $tSQL."DataLimite = \'".$umaPergunta->getDataLimiteBD()."\', ";
      $tSQL = $tSQL."HabAnexo = \'".$umaPergunta->getHabAnexo()."\', ";
      $tSQL = $tSQL."ValorNota = \'".$umaPergunta->getValorNota()."\', ";
      $tSQL = $tSQL."CodigoUsuario = \'".$umaPergunta->getCodigoUsuario()."\', ";
      $tSQL = $tSQL."DataDivulgacao = \'".$umaPergunta->getDataDivulgacaoBD()."\' ";
      $tSQL = $tSQL.$fSQL;
      my $linhas = $self->umaConexao->executar->do($tSQL) or die "Problemas ao gravar pergunta!\n";
      if ($linhas == 0) {
         #die "Pergunta não foi gravada!\n";
      }
   } else {
      die "Nenhuma pergunta foi enviada para ser gravada!\n";
   }
}
#################################################################################









#################################################################################
# solicitar
#--------------------------------------------------------------------------------
# Método que solicita as perguntas da base de dados em ordem de data.
#################################################################################
sub solicitar {
   my $self = shift;
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Pergunta order by Data Desc ";
   my @colecaoPerguntas = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar perguntas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoPerguntas[$i] = new ClassePergunta;
      $colecaoPerguntas[$i]->setDadosBD($r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $i++;
   }
   $SQL->finish;
   return @colecaoPerguntas;
}
#################################################################################









#################################################################################
# excluir
#--------------------------------------------------------------------------------
# Método que exclui a pergunta da base de dados.
#################################################################################
sub excluir {
   my $self = shift;
   my $codigoPergunta = $_[0];
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."Pergunta WHERE CodigoPergunta = ".$codigoPergunta." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir a pergunta!";
   my $tSQL = "DELETE FROM ".$self->umaConexao->getTab()."PerguntaResposta WHERE CodigoPergunta = ".$codigoPergunta." ";
   $self->umaConexao->executar->do($tSQL) or die "Não foi possível excluir as respostas da pergunta!";
}
#################################################################################










#################################################################################
# selecionarPergunta
#--------------------------------------------------------------------------------
# Método que seleciona uma pergunta a partir de seu código
#################################################################################
sub selecionarPergunta {
   my $self = shift;
   my $codigoPergunta = $_[0];
   my $tSQL = "SELECT * FROM ".$self->umaConexao->getTab()."Pergunta AS A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario AS U ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "WHERE A.CodigoPergunta = ".$codigoPergunta." ";
   my $umaPergunta = new ClassePergunta;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a pergunta!\n";
   while (my $r = $SQL->fetchrow_hashref) {
       $umaPergunta->setDadosBD($r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
       $umaPergunta->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
       $umaPergunta->umUsuario->setNome($r->{'Nome'});
   }
   $SQL->finish;
   return $umaPergunta;
}
#################################################################################










#################################################################################
# quantidade
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de perguntas na base de dados
#################################################################################
sub quantidade {
   my $self = shift;
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Pergunta ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de perguntas!\n";
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
# Método que solicita parcialmente as perguntas da base de dados.
#################################################################################
sub solicitarParcial {
   my $self = shift;
   my $indicePagina = $_[0];
   my $quantosPagina = $_[1];
   my $ultimoAcesso = $_[2];
   my $posicao = ($indicePagina-1) * $quantosPagina;
   my $tSQL = "SELECT A.*,U.Nome, (A.Data < \'$ultimoAcesso\') AS Lido, ";
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Pergunta as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."PerguntaResposta as R ";
   $tSQL .= "ON A.CodigoPergunta = R.CodigoPergunta ";
   $tSQL .= "GROUP BY A.CodigoPergunta ";
   $tSQL .= "ORDER BY A.Data Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoPerguntas = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar perguntas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoPerguntas[$i] = new ClassePergunta;
      $colecaoPerguntas[$i]->setDadosBD($r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoPerguntas[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoPerguntas[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoPerguntas[$i]->setLido($r->{'Lido'});
      $colecaoPerguntas[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoPerguntas[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoPerguntas;
}
#################################################################################










#################################################################################
# quantosNaoLido
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de perguntas não lidas
#################################################################################
sub quantosNaoLido {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Pergunta ";
   $tSQL .= "WHERE (Data >= \'$ultimoAcesso\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de perguntas não lidas!\n";
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
# Método que solicita parcialmente as perguntas da base de dados de acordo
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
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Pergunta as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."PerguntaResposta as R ";
   $tSQL .= "ON A.CodigoPergunta = R.CodigoPergunta ";
   $tSQL .= "GROUP BY A.CodigoPergunta ";
   $tSQL .= "ORDER BY A.Data Desc LIMIT $posicao, $quantosPagina ";
   my @colecaoPerguntas = [];
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar perguntas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoPerguntas[$i] = new ClassePergunta;
      $colecaoPerguntas[$i]->setDadosBD($r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoPerguntas[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoPerguntas[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoPerguntas[$i]->setLido($r->{'Lido'});
      $colecaoPerguntas[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoPerguntas[$i]->info->setRespondida($r->{'Respondida'});
      $colecaoPerguntas[$i]->info->setNota($r->{'NotaAluno'});
      $colecaoPerguntas[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoPerguntas;
}
#################################################################################










#################################################################################
# solicitarPerguntas
#--------------------------------------------------------------------------------
# Método que solicita parcialmente as perguntas da base de dados.
#################################################################################
sub solicitarPerguntas {
   my $self = shift;
   my $ultimoAcesso = $_[0];
   my $tSQL = "SELECT A.*,U.Nome, (A.Data < \'$ultimoAcesso\') AS Lido, ";
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Pergunta as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."PerguntaResposta as R ";
   $tSQL .= "ON A.CodigoPergunta = R.CodigoPergunta ";
   $tSQL .= "GROUP BY A.CodigoPergunta ";
   $tSQL .= "ORDER BY A.Data ";
   my @colecaoPerguntas;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar perguntas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoPerguntas[$i] = new ClassePergunta;
      $colecaoPerguntas[$i]->setDadosBD($r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoPerguntas[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoPerguntas[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoPerguntas[$i]->setLido($r->{'Lido'});
      $colecaoPerguntas[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoPerguntas[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $i++;
   }
   $SQL->finish;
   return @colecaoPerguntas;
}
#################################################################################










#################################################################################
# solicitarPerguntasDataLimite
#--------------------------------------------------------------------------------
# Método que solicita parcialmente as perguntas da base de dados.
#################################################################################
sub solicitarPerguntasDataLimite {
   my $self = shift;
   my $dataLimiteBD = $_[0];
   my $ultimoAcesso = $_[1];
   my $codigoUsuario = $_[2];
   my $tSQL = "SELECT A.*,U.Nome, (A.Data < \'$ultimoAcesso\') AS Lido, ";
   $tSQL .= "MAX(R.CodigoUsuario = $codigoUsuario) AS Respondida, ";
   $tSQL .= "COUNT(R.CodigoResposta) AS QtdeRespostas ";
   $tSQL .= "FROM ".$self->umaConexao->getTab()."Pergunta as A ";
   $tSQL .= "INNER JOIN ".$self->umaConexao->getTab()."Usuario as U ";
   $tSQL .= "ON A.CodigoUsuario = U.CodigoUsuario ";
   $tSQL .= "LEFT OUTER JOIN ".$self->umaConexao->getTab()."PerguntaResposta as R ";
   $tSQL .= "ON A.CodigoPergunta = R.CodigoPergunta ";
   $tSQL .= "WHERE A.DataLimite >= \'$dataLimiteBD 00:00:00\' AND A.DataLimite <= \'$dataLimiteBD 23:59:59\' ";
   $tSQL .= "GROUP BY A.CodigoPergunta ";
   $tSQL .= "ORDER BY A.Data DESC ";
   my @colecaoPerguntas;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar perguntas!\n";
   my $i = 0;
   while (my $r = $SQL->fetchrow_hashref) {
      $colecaoPerguntas[$i] = new ClassePergunta;
      $colecaoPerguntas[$i]->setDadosBD($r->{'CodigoPergunta'},$r->{'Titulo'},$r->{'Texto'},$r->{'Data'},$r->{'DataLimite'},$r->{'HabAnexo'},$r->{'ValorNota'},$r->{'CodigoUsuario'},$r->{'DataDivulgacao'});
      $colecaoPerguntas[$i]->umUsuario->setCodigoUsuario($r->{'CodigoUsuario'});
      $colecaoPerguntas[$i]->umUsuario->setNome($r->{'Nome'});
      $colecaoPerguntas[$i]->setLido($r->{'Lido'});
      $colecaoPerguntas[$i]->info->setQtdeRespostas($r->{'QtdeRespostas'});
      $colecaoPerguntas[$i]->info->setCorrigida($r->{'QtdeCorrecoes'});
      $colecaoPerguntas[$i]->info->setRespondida($r->{'Respondida'});
      $i++;
   }
   $SQL->finish;
   return @colecaoPerguntas;
}
#################################################################################










#################################################################################
# quantosHoje
#--------------------------------------------------------------------------------
# Método que solicita a quantidade de perguntas que expiram hoje
#################################################################################
sub quantosHoje {
   my $self = shift;
   my ($hor,$min,$seg,$dia,$mes,$ano) = &HoraCerta();
   my $tSQL = "SELECT count(*) as qtde FROM ".$self->umaConexao->getTab()."Pergunta ";
   $tSQL .= "WHERE (DataLimite >= \'$ano-$mes-$dia 00:00:00\' AND DataLimite <= \'$ano-$mes-$dia 23:59:59\') ";
   my $qtde = 0;
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Problemas ao selecionar a quantidade de perguntas não lidas!\n";
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
# Método que atualiza os dados da tabela pergunta:
# - nova coluna (DataDivulgacao datetime)
#################################################################################
sub atualizar02 {

   my $self = shift;
   my $tSQL = "DESC ".$self->umaConexao->getTab()."Pergunta ";
   my $SQL = $self->umaConexao->executar->prepare($tSQL);
   $SQL->execute or die "Não foi possível selecionar a tabela pergunta!\n";
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
      my $tSQL = "ALTER TABLE ".$self->umaConexao->getTab."Pergunta ADD COLUMN DataDivulgacao datetime DEFAULT \'0000-00-00 00:00:00\' ";
      my $SQL = $self->umaConexao->executar->prepare($tSQL);
      $SQL->execute or die "Problemas ao fazer atualização na tabela Pergunta!\n";
      $SQL->finish;
   }

}
#################################################################################












1;
