package DadosInicial;

use strict;
use ConexaoMySQL;

use DadosAmbiente;
use DadosSessoes;
use DadosUsuarios;
use DadosAvisos;
use DadosAtividades;
use DadosAtividadesRespostas;
use DadosAtividadesCorrecoes;
use DadosPerguntas;
use DadosPerguntasRespostas;
use DadosMateriais;
use DadosCalendario;
use DadosAnotacoes;
use DadosPastas;
use DadosArquivos;
use DadosTestes;
use DadosTestesQuestoes;
use DadosTestesRespostas;
use DadosTestesUsuarios;






#################################################################################
# DadosInicial
# criado  : 01/2004
# projeto : Gradenet.com.br
# autor   : Hermano Pereira
#--------------------------------------------------------------------------------
# Classe que inicializa a base de dados
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
   bless ($self,$class);
   return $self;
}
#################################################################################









#################################################################################
# iniciarBase
#--------------------------------------------------------------------------------
# Método que verifica se as tabelas existem caso contrário, tenta criá-las.
#################################################################################
sub iniciarBase {
   my $self = shift;
   my $dadosTestesUsuarios = new DadosTestesUsuarios;
   if (!$dadosTestesUsuarios->existeTabela()) {
      my $dadosAmbiente = new DadosAmbiente;
      $dadosAmbiente->criarTabela();
      my $dadosSessoes = new DadosSessoes;
      $dadosSessoes->criarTabela();
      my $dadosUsuarios = new DadosUsuarios;
      $dadosUsuarios->criarTabela();
      my $dadosAvisos = new DadosAvisos;
      $dadosAvisos->criarTabela();
      my $dadosAtividades = new DadosAtividades;
      $dadosAtividades->criarTabela();
      my $dadosAtividadesRespostas = new DadosAtividadesRespostas;
      $dadosAtividadesRespostas->criarTabela();
      my $dadosAtividadesCorrecoes = new DadosAtividadesCorrecoes;
      $dadosAtividadesCorrecoes->criarTabela();

      my $dadosPerguntas = new DadosPerguntas;
      $dadosPerguntas->criarTabela();
      my $dadosPerguntasRespostas = new DadosPerguntasRespostas;
      $dadosPerguntasRespostas->criarTabela();

      my $dadosMateriais = new DadosMateriais;
      $dadosMateriais->criarTabela();

      my $dadosCalendario = new DadosCalendario;
      $dadosCalendario->criarTabela();
      my $dadosAnotacoes = new DadosAnotacoes;
      $dadosAnotacoes->criarTabela();
      my $dadosPastas = new DadosPastas;
      $dadosPastas->criarTabela();
      my $dadosArquivos = new DadosArquivos;
      $dadosArquivos->criarTabela();
      my $dadosTestes = new DadosTestes;
      $dadosTestes->criarTabela();
      my $dadosTestesQuestoes = new DadosTestesQuestoes;
      $dadosTestesQuestoes->criarTabela();
      my $dadosTestesRespostas = new DadosTestesRespostas;
      $dadosTestesRespostas->criarTabela();
      $dadosTestesUsuarios->criarTabela();
  } else {
      my $dadosAmbiente = new DadosAmbiente;
      $dadosAmbiente->atualizar01();
      my $dadosAtividades = new DadosAtividades;
      $dadosAtividades->atualizar02();
      my $dadosPerguntas = new DadosPerguntas;
      $dadosPerguntas->atualizar02();
  }
}
#################################################################################









1;
