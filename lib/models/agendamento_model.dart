import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusAgendamento {
  confirmado,
  cancelado,
  presente,
  faltou,
}

class AgendamentoModel {
  final String id;
  final String alunoId;
  final String alunoNome;
  final String aulaId;
  final String aulaNome;
  final DateTime data;
  final String horarioInicio;
  final String horarioFim;
  final StatusAgendamento status;
  final String tipo; // 👈 NOVO
  final DateTime? criadoEm;

  AgendamentoModel({
    required this.id,
    required this.alunoId,
    required this.alunoNome,
    required this.aulaId,
    required this.aulaNome,
    required this.data,
    required this.horarioInicio,
    required this.horarioFim,
    required this.status,
    required this.tipo,
    this.criadoEm,
  });

  bool get estaAtivo => status == StatusAgendamento.confirmado;

  bool get jaOcorreu {
    final partes = horarioFim.split(':');

    final fim = DateTime(
      data.year,
      data.month,
      data.day,
      int.tryParse(partes[0]) ?? 23,
      int.tryParse(partes.length > 1 ? partes[1] : '59') ?? 59,
    );

    return DateTime.now().isAfter(fim);
  }

  factory AgendamentoModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data() ?? {};

    DateTime dataAula;

    final campoData = map['data'];

    if (campoData is Timestamp) {
      dataAula = campoData.toDate();
    } else {
      dataAula = DateTime.tryParse(campoData?.toString() ?? '') ??
          DateTime.now();
    }

    DateTime? criadoEm;

    final criadoEmField = map['criadoEm'];
    if (criadoEmField is Timestamp) {
      criadoEm = criadoEmField.toDate();
    }

    return AgendamentoModel(
      id: doc.id,
      alunoId: map['alunoId'] ?? '',
      alunoNome: map['alunoNome'] ?? '',
      aulaId: map['aulaId'] ?? '',
      aulaNome: map['aulaNome'] ?? '',
      data: dataAula,
      horarioInicio: map['horarioInicio'] ?? '00:00',
      horarioFim: map['horarioFim'] ?? '00:00',
      status: _fromString(map['status']),
      tipo: map['tipo'] ?? 'aluno', // 👈 default
      criadoEm: criadoEm,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'alunoId': alunoId,
      'alunoNome': alunoNome,
      'aulaId': aulaId,
      'aulaNome': aulaNome,
      'data': Timestamp.fromDate(
        DateTime(data.year, data.month, data.day),
      ),
      'horarioInicio': horarioInicio,
      'horarioFim': horarioFim,
      'status': status.name,
      'tipo': tipo, // 👈 NOVO
      'criadoEm': criadoEm ?? FieldValue.serverTimestamp(),
    };
  }

  static StatusAgendamento _fromString(dynamic value) {
    switch (value?.toString()) {
      case 'cancelado':
        return StatusAgendamento.cancelado;
      case 'presente':
        return StatusAgendamento.presente;
      case 'faltou':
        return StatusAgendamento.faltou;
      default:
        return StatusAgendamento.confirmado;
    }
  }
}