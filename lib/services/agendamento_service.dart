import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/aula_model.dart';
import '../models/agendamento_model.dart';

class AgendamentoService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const int limiteAgendamentosAtivos = 3;

  CollectionReference<Map<String, dynamic>> get _aulasCol =>
      _db.collection('aulas');

  CollectionReference<Map<String, dynamic>> get _agendamentosCol =>
      _db.collection('agendamentos');

  // =====================================================
  // LIMPEZA AUTOMÁTICA
  // =====================================================
  Future<void> limparAgendamentosExpirados(String alunoId) async {
    final agora = DateTime.now();

    final query = await _agendamentosCol
        .where('alunoId', isEqualTo: alunoId)
        .where('status', isEqualTo: StatusAgendamento.confirmado.name)
        .get();

    final batch = _db.batch();

    for (final doc in query.docs) {
      final agendamento = AgendamentoModel.fromFirestore(doc);

      final partes = agendamento.horarioFim.split(':');
      final hora = int.tryParse(partes[0]) ?? 23;
      final minuto = partes.length > 1 ? int.tryParse(partes[1]) ?? 59 : 59;

      final fimAula = DateTime(
        agendamento.data.year,
        agendamento.data.month,
        agendamento.data.day,
        hora,
        minuto,
      );

      if (agora.isAfter(fimAula)) {
        batch.update(doc.reference, {
          'status': StatusAgendamento.presente.name,
        });
      }
    }

    await batch.commit();
  }

  // =====================================================
  // AGENDAR AULA (NORMAL OU EXPERIMENTAL)
  // =====================================================
  Future<String> agendarAula({
    required String alunoId,
    required String alunoNome,
    required String aulaId,
    required DateTime data,
    String tipo = 'normal',
  }) async {
    final dataNormalizada = DateTime(data.year, data.month, data.day);

    await limparAgendamentosExpirados(alunoId);

    final aulaRef = _aulasCol.doc(aulaId);

    // =====================================================
    // LIMITE SÓ PARA NORMAL
    // =====================================================
    final ativos = await _agendamentosCol
        .where('alunoId', isEqualTo: alunoId)
        .where('status', isEqualTo: StatusAgendamento.confirmado.name)
        .where('tipo', isEqualTo: 'normal')
        .get();

    if (tipo == 'normal' &&
        ativos.docs.length >= limiteAgendamentosAtivos) {
      throw Exception('Limite de 3 agendamentos ativos atingido');
    }

    // evita duplicar aula
    final duplicado = await _agendamentosCol
        .where('alunoId', isEqualTo: alunoId)
        .where('aulaId', isEqualTo: aulaId)
        .where('status', isEqualTo: StatusAgendamento.confirmado.name)
        .get();

    if (duplicado.docs.isNotEmpty) {
      throw Exception('Você já está agendado nesta aula');
    }

    return _db.runTransaction<String>((tx) async {
      final aulaSnap = await tx.get(aulaRef);

      if (!aulaSnap.exists) {
        throw Exception('Aula não encontrada');
      }

      final aula = AulaModel.fromFirestore(aulaSnap);

      // experimental NÃO ocupa vaga
      if (tipo == 'normal' && !aula.temVaga) {
        throw Exception('Sem vagas disponíveis');
      }

      final novoRef = _agendamentosCol.doc();

      final agendamento = AgendamentoModel(
        id: novoRef.id,
        alunoId: alunoId,
        alunoNome: alunoNome,
        aulaId: aulaId,
        aulaNome: aula.nome,
        data: dataNormalizada,
        horarioInicio: aula.horarioInicio,
        horarioFim: aula.horarioFim,
        status: StatusAgendamento.confirmado,
        tipo: tipo,
        criadoEm: DateTime.now(),
      );

      tx.set(novoRef, agendamento.toMap());

      // só reduz vaga se for NORMAL
      if (tipo == 'normal') {
        tx.update(aulaRef, {
          'vagasOcupadas': aula.vagasOcupadas + 1,
        });
      }

      return novoRef.id;
    });
  }

  // =====================================================
  // CANCELAR AGENDAMENTO
  // =====================================================
  Future<void> cancelarAgendamento({
    required String agendamentoId,
    required String aulaId,
  }) async {
    final agSnap = await _agendamentosCol.doc(agendamentoId).get();

    final tipo = agSnap.data()?['tipo'] ?? 'normal';

    await _agendamentosCol.doc(agendamentoId).update({
      'status': StatusAgendamento.cancelado.name,
      'canceladoEm': FieldValue.serverTimestamp(),
    });

    // só devolve vaga se for NORMAL
    if (tipo == 'normal') {
      final aulaSnap = await _aulasCol.doc(aulaId).get();

      if (aulaSnap.exists) {
        final aula = AulaModel.fromFirestore(aulaSnap);

        await _aulasCol.doc(aulaId).update({
          'vagasOcupadas': aula.vagasOcupadas > 0
              ? aula.vagasOcupadas - 1
              : 0,
        });
      }
    }
  }

  // =====================================================
  // MEUS AGENDAMENTOS
  // =====================================================
  Stream<List<AgendamentoModel>> streamMeusAgendamentos(
    String alunoId,
  ) {
    return _agendamentosCol
        .where('alunoId', isEqualTo: alunoId)
        .where('status', isEqualTo: StatusAgendamento.confirmado.name)
        .orderBy('data')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AgendamentoModel.fromFirestore(doc))
              .toList(),
        );
  }

  // =====================================================
  // AGENDAMENTOS DA AULA
  // =====================================================
  Stream<List<AgendamentoModel>> streamAgendamentosDaAula({
    required String aulaId,
    required DateTime data,
  }) {
    final dataNormalizada = Timestamp.fromDate(
      DateTime(data.year, data.month, data.day),
    );

    return _agendamentosCol
        .where('aulaId', isEqualTo: aulaId)
        .where('data', isEqualTo: dataNormalizada)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AgendamentoModel.fromFirestore(doc))
              .toList(),
        );
  }

  // =====================================================
  // HISTÓRICO
  // =====================================================
  Stream<List<AgendamentoModel>> streamHistoricoAgendamentos(
    String alunoId,
  ) {
    return _agendamentosCol
        .where('alunoId', isEqualTo: alunoId)
        .orderBy('data', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AgendamentoModel.fromFirestore(doc))
              .toList(),
        );
  }

  // =====================================================
  // PRESENÇA
  // =====================================================
  Future<void> marcarPresenca({
    required String agendamentoId,
    required bool presente,
  }) async {
    await _agendamentosCol.doc(agendamentoId).update({
      'status': presente
          ? StatusAgendamento.presente.name
          : StatusAgendamento.faltou.name,
    });
  }
}