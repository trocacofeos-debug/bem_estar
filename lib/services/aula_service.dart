import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/aula_model.dart';

class AulaService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      db.collection('aulas');

  // =====================================================
  // STREAM AULAS POR DIA (SEM ÍNDICE FIRESTORE)
  // =====================================================
  Stream<List<AulaModel>> streamAulasPorDiaSemana(int diaSemana) {
    return _col
        .where('ativa', isEqualTo: true)
        .where('diaSemana', isEqualTo: diaSemana)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map((doc) => AulaModel.fromFirestore(doc))
          .toList();

      // ordena no Flutter (evita composite index)
      list.sort((a, b) =>
          a.horarioInicio.compareTo(b.horarioInicio));

      return list;
    });
  }

  // =====================================================
  // STREAM TODAS AULAS
  // =====================================================
  Stream<List<AulaModel>> streamTodasAulas() {
    return _col.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => AulaModel.fromFirestore(doc))
          .toList();

      list.sort((a, b) {
        final c = a.diaSemana.compareTo(b.diaSemana);
        if (c != 0) return c;
        return a.horarioInicio.compareTo(b.horarioInicio);
      });

      return list;
    });
  }

  // =====================================================
  // CRIAR AULA
  // =====================================================
  Future<void> criarAula(AulaModel aula) async {
    await _col.add({
      'nome': aula.nome,
      'descricao': aula.descricao,
      'diaSemana': aula.diaSemana,
      'horarioInicio': aula.horarioInicio,
      'horarioFim': aula.horarioFim,
      'vagasTotais': aula.vagasTotais,
      'vagasOcupadas': 0,
      'instrutorId': aula.instrutorId,
      'instrutorNome': aula.instrutorNome,
      'cor': aula.cor,
      'ativa': true,
    });
  }

  // =====================================================
  // ATUALIZAR AULA
  // =====================================================
  Future<void> atualizarAula(AulaModel aula) async {
    await _col.doc(aula.id).update({
      'nome': aula.nome,
      'descricao': aula.descricao,
      'diaSemana': aula.diaSemana,
      'horarioInicio': aula.horarioInicio,
      'horarioFim': aula.horarioFim,
      'vagasTotais': aula.vagasTotais,
      'vagasOcupadas': aula.vagasOcupadas,
      'instrutorId': aula.instrutorId,
      'instrutorNome': aula.instrutorNome,
      'cor': aula.cor,
      'ativa': aula.ativa,
    });
  }

  // =====================================================
  // ATIVAR / DESATIVAR
  // =====================================================
  Future<void> ativarDesativarAula(String id, bool ativo) async {
    await _col.doc(id).update({'ativa': ativo});
  }

  // =====================================================
  // EXCLUIR
  // =====================================================
  Future<void> excluirAula(String id) async {
    await _col.doc(id).delete();
  }

  // =====================================================
  // GERAR AULAS DO DIA (10 HORÁRIOS FIXOS)
  // =====================================================
  Future<void> gerarAulasDoDiaAtual() async {
    final hoje = DateTime.now().weekday;

    final horarios = [
      ["07:00", "08:00"],
      ["08:00", "09:00"],
      ["09:00", "10:00"],
      ["10:00", "11:00"],
      ["16:00", "17:00"],
      ["17:00", "18:00"],
      ["18:00", "19:00"],
      ["19:00", "20:00"],
      ["20:00", "21:00"],
      ["21:00", "22:00"],
    ];

    for (final h in horarios) {
      final inicio = h[0];
      final fim = h[1];

      final existe = await _col
          .where('diaSemana', isEqualTo: hoje)
          .where('horarioInicio', isEqualTo: inicio)
          .limit(1)
          .get();

      if (existe.docs.isNotEmpty) continue;

      await _col.add({
        'nome': 'Treino',
        'descricao': '',
        'diaSemana': hoje,
        'horarioInicio': inicio,
        'horarioFim': fim,
        'vagasTotais': 10,
        'vagasOcupadas': 0,
        'instrutorId': '',
        'instrutorNome': 'Sistema',
        'cor': '0F6E56',
        'ativa': true,
      });
    }
  }

  // =====================================================
  // RESET DE AULAS DO DIA
  // =====================================================
  Future<void> resetarAulasDoDia(int diaSemana) async {
    final snapshot = await _col
        .where('diaSemana', isEqualTo: diaSemana)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.update({
        'vagasOcupadas': 0,
      });
    }
  }
}