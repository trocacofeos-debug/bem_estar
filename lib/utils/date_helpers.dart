import 'package:intl/intl.dart';
import 'constants.dart';

/// Funções utilitárias para formatação e manipulação de datas/horários
/// usadas nas telas de agenda e agendamentos.
class DateHelpers {
  DateHelpers._();

  static final DateFormat _formatoDiaMes = DateFormat('dd/MM');
  static final DateFormat _formatoDiaMesAno = DateFormat('dd/MM/yyyy');
  static final DateFormat _formatoCompleto = DateFormat("EEEE, dd 'de' MMMM", 'pt_BR');

  /// Remove a parte de horário de um DateTime, mantendo apenas a data.
  static DateTime normalizar(DateTime data) {
    return DateTime(data.year, data.month, data.day);
  }

  static bool mesmoDia(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isHoje(DateTime data) => mesmoDia(data, DateTime.now());

  static bool isPassado(DateTime data) {
    final hoje = normalizar(DateTime.now());
    return normalizar(data).isBefore(hoje);
  }

  /// Ex: "Segunda-feira" a partir do weekday (1..7).
  static String nomeDiaSemana(int weekday) {
    return AppConstants.diasSemana[weekday] ?? '';
  }

  /// Ex: "Seg" a partir do weekday (1..7).
  static String nomeDiaSemanaAbreviado(int weekday) {
    return AppConstants.diasSemanaAbreviado[weekday] ?? '';
  }

  /// Ex: "12/06"
  static String formatarDiaMes(DateTime data) => _formatoDiaMes.format(data);

  /// Ex: "12/06/2026"
  static String formatarDiaMesAno(DateTime data) => _formatoDiaMesAno.format(data);

  /// Ex: "sexta-feira, 12 de junho". Útil para cabeçalhos de tela.
  static String formatarCompleto(DateTime data) {
    if (isHoje(data)) return 'Hoje, ${_formatoDiaMes.format(data)}';
    final amanha = DateTime.now().add(const Duration(days: 1));
    if (mesmoDia(data, amanha)) return 'Amanhã, ${_formatoDiaMes.format(data)}';
    return _capitalizar(_formatoCompleto.format(data));
  }

  /// Converte "HH:mm" em minutos desde a meia-noite, útil para ordenação.
  static int horarioParaMinutos(String horario) {
    final partes = horario.split(':');
    final h = int.tryParse(partes[0]) ?? 0;
    final m = partes.length > 1 ? int.tryParse(partes[1]) ?? 0 : 0;
    return h * 60 + m;
  }

  /// Combina um intervalo "HH:mm - HH:mm" a partir de início e fim.
  static String formatarIntervalo(String inicio, String fim) {
    return '$inicio - $fim';
  }

  /// Calcula a duração em minutos entre dois horários "HH:mm".
  static int duracaoEmMinutos(String inicio, String fim) {
    final diff = horarioParaMinutos(fim) - horarioParaMinutos(inicio);
    return diff < 0 ? diff + (24 * 60) : diff;
  }

  /// Retorna os próximos [quantidade] dias a partir de [inicio] (ou hoje).
  static List<DateTime> proximosDias(int quantidade, {DateTime? inicio}) {
    final base = normalizar(inicio ?? DateTime.now());
    return List.generate(quantidade, (i) => base.add(Duration(days: i)));
  }

  static String _capitalizar(String texto) {
    if (texto.isEmpty) return texto;
    return texto[0].toUpperCase() + texto.substring(1);
  }
}