import 'dart:async';
import 'package:flutter/foundation.dart';

import '../models/aula_model.dart';
import '../models/agendamento_model.dart';
import '../services/aula_service.dart';
import '../services/agendamento_service.dart';

class AgendaProvider extends ChangeNotifier {
  final AulaService _aulaService;
  final AgendamentoService _agendamentoService;

  AgendaProvider({
    AulaService? aulaService,
    AgendamentoService? agendamentoService,
  })  : _aulaService = aulaService ?? AulaService(),
        _agendamentoService = agendamentoService ?? AgendamentoService();

  // =====================================================
  // ESTADO
  // =====================================================

  DateTime _dataSelecionada = DateTime.now();

  List<AulaModel> _aulasDoDia = [];
  List<AgendamentoModel> _meusAgendamentos = [];

  bool _carregandoAulas = false;
  bool _processandoAgendamento = false;

  String? _erro;
  String? _mensagemSucesso;

  StreamSubscription<List<AulaModel>>? _aulasSub;
  StreamSubscription<List<AgendamentoModel>>? _agendamentosSub;

  String? _alunoIdAtual;

  // =====================================================
  // GETTERS
  // =====================================================

  DateTime get dataSelecionada => _dataSelecionada;
  List<AulaModel> get aulasDoDia => _aulasDoDia;
  List<AgendamentoModel> get meusAgendamentos => _meusAgendamentos;
  bool get carregandoAulas => _carregandoAulas;
  bool get processandoAgendamento => _processandoAgendamento;
  String? get erro => _erro;
  String? get mensagemSucesso => _mensagemSucesso;

  Set<String> get aulasAgendadasNoDia {
    final dataNorm = DateTime(
      _dataSelecionada.year,
      _dataSelecionada.month,
      _dataSelecionada.day,
    );

    return _meusAgendamentos
        .where((a) =>
            DateTime(a.data.year, a.data.month, a.data.day) == dataNorm)
        .map((a) => a.aulaId)
        .toSet();
  }

  // =====================================================
  // INICIAR
  // =====================================================

  Future<void> iniciar(String alunoId) async {
    _alunoIdAtual = alunoId;
    _erro = null;

    await _agendamentoService.limparAgendamentosExpirados(alunoId);

    _carregarAulasDoDia();

    await _agendamentosSub?.cancel();

    _agendamentosSub =
        _agendamentoService.streamMeusAgendamentos(alunoId).listen(
      (lista) {
        _meusAgendamentos = lista;
        notifyListeners();
      },
      onError: (e) {
        _erro = e.toString();
        notifyListeners();
      },
    );
  }

  // =====================================================
  // TROCAR DATA (CORRIGIDO)
  // =====================================================

  void selecionarData(DateTime data) {
    _dataSelecionada = DateTime(data.year, data.month, data.day);

    _agendamentoService.limparAgendamentosExpirados(
      _alunoIdAtual ?? '',
    );

    _carregarAulasDoDia();
  }

  void avancarDia() => selecionarData(_dataSelecionada.add(const Duration(days: 1)));

  void voltarDia() => selecionarData(_dataSelecionada.subtract(const Duration(days: 1)));

  void irParaHoje() => selecionarData(DateTime.now());

  // =====================================================
  // CARREGAR AULAS (SEGURO SEM INDEX PROBLEMÁTICO)
  // =====================================================

  void _carregarAulasDoDia() {
    _carregandoAulas = true;
    notifyListeners();

    _aulasSub?.cancel();

    final diaSemana = _dataSelecionada.weekday;

    _aulasSub = _aulaService.streamAulasPorDiaSemana(diaSemana).listen(
      (lista) {
        _aulasDoDia = lista.where((a) => a.ativa).toList();
        _carregandoAulas = false;
        notifyListeners();
      },
      onError: (e) {
        _erro = 'Erro ao carregar aulas';
        _carregandoAulas = false;
        notifyListeners();
      },
    );
  }

  // =====================================================
  // AGENDAR
  // =====================================================

  Future<bool> agendar({
    required String alunoId,
    required String alunoNome,
    required AulaModel aula,
  }) async {
    try {
      _processandoAgendamento = true;
      _erro = null;
      notifyListeners();

      final id = await _agendamentoService.agendarAula(
        alunoId: alunoId,
        alunoNome: alunoNome,
        aulaId: aula.id,
        data: _dataSelecionada,
      );

      if (id.isEmpty) throw Exception('Erro ao agendar');

      await _agendamentoService.limparAgendamentosExpirados(alunoId);

      _mensagemSucesso = 'Agendado com sucesso';
      return true;
    } catch (e) {
      _erro = e.toString();
      return false;
    } finally {
      _processandoAgendamento = false;
      notifyListeners();
    }
  }

  // =====================================================
  // CANCELAR
  // =====================================================

  Future<bool> cancelar(AgendamentoModel agendamento) async {
    try {
      _processandoAgendamento = true;
      notifyListeners();

      await _agendamentoService.cancelarAgendamento(
        agendamentoId: agendamento.id,
        aulaId: agendamento.aulaId,
      );

      _meusAgendamentos.removeWhere((a) => a.id == agendamento.id);

      _mensagemSucesso = 'Cancelado';
      return true;
    } catch (e) {
      _erro = e.toString();
      return false;
    } finally {
      _processandoAgendamento = false;
      notifyListeners();
    }
  }

  // =====================================================
  // ATUALIZAR
  // =====================================================

  Future<void> atualizar() async {
    if (_alunoIdAtual == null) return;

    await _agendamentoService.limparAgendamentosExpirados(_alunoIdAtual!);

    _carregarAulasDoDia();
  }

  @override
  void dispose() {
    _aulasSub?.cancel();
    _agendamentosSub?.cancel();
    super.dispose();
  }
}