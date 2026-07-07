/// Constantes globais do app.
class AppConstants {
  AppConstants._();

  // Identidade
  static const String appName = 'Academia Funcional';

  // Regras de negócio
  static const int limiteAgendamentosAtivos = 3;

  /// Percentual de ocupação a partir do qual a aula é considerada
  /// "quase cheia" (entre este valor e 100% de ocupação).
  static const double percentualQuaseCheia = 0.8;

  // Nomes dos dias da semana, indexados igual a DateTime.weekday (1..7)
  static const Map<int, String> diasSemana = {
    1: 'Segunda-feira',
    2: 'Terça-feira',
    3: 'Quarta-feira',
    4: 'Quinta-feira',
    5: 'Sexta-feira',
    6: 'Sábado',
    7: 'Domingo',
  };

  // Versões curtas para uso em chips/calendário
  static const Map<int, String> diasSemanaAbreviado = {
    1: 'Seg',
    2: 'Ter',
    3: 'Qua',
    4: 'Qui',
    5: 'Sex',
    6: 'Sáb',
    7: 'Dom',
  };
}

/// Nomes das rotas usadas com Navigator.
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String esqueciSenha = '/esqueci-senha';

  // Aluno
  static const String homeAluno = '/aluno';
  static const String aulasDisponiveis = '/aluno/aulas';
  static const String meusAgendamentos = '/aluno/agendamentos';
  static const String perfil = '/perfil';

  // Admin
  static const String dashboardAdmin = '/admin';
  static const String gerenciarAulas = '/admin/aulas';
  static const String formularioAula = '/admin/aulas/form';
  static const String relatorioOcupacao = '/admin/relatorio';
}

/// Mensagens de texto reutilizadas em toda a UI.
class AppStrings {
  AppStrings._();

  // Genéricas
  static const String erroGenerico = 'Algo deu errado. Tente novamente.';
  static const String semConexao = 'Sem conexão com a internet.';
  static const String carregando = 'Carregando...';

  // Disponibilidade
  static const String statusDisponivel = 'Disponível';
  static const String statusQuaseCheia = 'Quase cheia';
  static const String statusEsgotada = 'Esgotada';

  // Agendamento
  static const String confirmarAgendamento = 'Agendar';
  static const String cancelarAgendamento = 'Cancelar agendamento';
  static const String agendamentoConfirmado = 'Agendamento confirmado!';
  static const String agendamentoCancelado = 'Agendamento cancelado.';
  static const String semAulasNoDia = 'Nenhuma aula programada para este dia.';
  static const String semAgendamentos = 'Você ainda não tem agendamentos.';

  // Auth
  static const String entrar = 'Entrar';
  static const String criarConta = 'Criar conta';
  static const String esqueceuSenha = 'Esqueceu sua senha?';
  static const String sair = 'Sair';
}