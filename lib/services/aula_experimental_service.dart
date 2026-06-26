import 'package:cloud_firestore/cloud_firestore.dart';

class AulaExperimentalService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _aulas =>
      _db.collection('aulas');

  CollectionReference<Map<String, dynamic>> get _agendamentos =>
      _db.collection('aulas_experimentais');

  // =====================================================
  // GERAR AULAS EXPERIMENTAIS
  // =====================================================
  Future<void> gerarAulasAutomaticas({
    required List<String> horariosInicio,
    required List<String> horariosFim,
    required DateTime data,
  }) async {
    final batch = _db.batch();
    final dataBase = DateTime(data.year, data.month, data.day);

    for (int i = 0; i < horariosInicio.length; i++) {
      final ref = _aulas.doc();

      batch.set(ref, {
        'nome': 'Aula Experimental',
        'data': Timestamp.fromDate(dataBase),
        'horarioInicio': horariosInicio[i],
        'horarioFim': horariosFim[i],
        'vagasTotais': 5,
        'vagasOcupadas': 0,
        'ativa': true,
        'tipo': 'experimental',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    await batch.commit();
  }

  // =====================================================
  // RESETAR AULAS EXPERIMENTAIS
  // =====================================================
  Future<void> resetarAulas() async {
    final snap = await _aulas
        .where('tipo', isEqualTo: 'experimental')
        .get();

    final batch = _db.batch();

    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  // =====================================================
  // LISTAR AULAS GERADAS
  // =====================================================
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAulasGeradas() {
    return _aulas
        .where('tipo', isEqualTo: 'experimental')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // =====================================================
  // AGENDAMENTOS EXPERIMENTAIS
  // =====================================================
  Stream<QuerySnapshot<Map<String, dynamic>>>
      streamAgendamentosExperimentais() {
    return _agendamentos
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}