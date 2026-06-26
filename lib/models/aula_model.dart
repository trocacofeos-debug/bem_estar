import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa uma aula/turma recorrente da academia funcional.
///
/// O campo [diaSemana] usa o índice do Dart (1 = segunda ... 7 = domingo),
/// igual ao retornado por [DateTime.weekday], para facilitar comparações.
class AulaModel {
  final String id;
  final String nome;
  final String descricao;
  final int diaSemana; // 1 = segunda ... 7 = domingo
  final String horarioInicio; // formato "HH:mm"
  final String horarioFim; // formato "HH:mm"
  final int vagasTotais;
  final int vagasOcupadas;
  final String instrutorId;
  final String instrutorNome;
  final String? cor; // código hex usado para diferenciar a modalidade na UI
  final bool ativa;

  AulaModel({
    required this.id,
    required this.nome,
    this.descricao = '',
    required this.diaSemana,
    required this.horarioInicio,
    required this.horarioFim,
    required this.vagasTotais,
    this.vagasOcupadas = 0,
    required this.instrutorId,
    required this.instrutorNome,
    this.cor,
    this.ativa = true,
  });

  int get vagasDisponiveis => (vagasTotais - vagasOcupadas).clamp(0, vagasTotais);

  bool get temVaga => vagasDisponiveis > 0;

  /// Percentual de ocupação entre 0.0 e 1.0, útil para barras de progresso.
  double get percentualOcupacao =>
      vagasTotais == 0 ? 0 : (vagasOcupadas / vagasTotais).clamp(0, 1);

  /// Status textual usado em badges (ex: "Disponível", "Quase cheia", "Esgotada").
  StatusOcupacao get statusOcupacao {
    if (vagasDisponiveis == 0) return StatusOcupacao.esgotada;
    if (percentualOcupacao >= 0.8) return StatusOcupacao.quaseCheia;
    return StatusOcupacao.disponivel;
  }

  factory AulaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AulaModel(
      id: doc.id,
      nome: data['nome'] as String? ?? '',
      descricao: data['descricao'] as String? ?? '',
      diaSemana: (data['diaSemana'] as num?)?.toInt() ?? 1,
      horarioInicio: data['horarioInicio'] as String? ?? '00:00',
      horarioFim: data['horarioFim'] as String? ?? '00:00',
      vagasTotais: (data['vagasTotais'] as num?)?.toInt() ?? 0,
      vagasOcupadas: (data['vagasOcupadas'] as num?)?.toInt() ?? 0,
      instrutorId: data['instrutorId'] as String? ?? '',
      instrutorNome: data['instrutorNome'] as String? ?? '',
      cor: data['cor'] as String?,
      ativa: data['ativa'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'diaSemana': diaSemana,
      'horarioInicio': horarioInicio,
      'horarioFim': horarioFim,
      'vagasTotais': vagasTotais,
      'vagasOcupadas': vagasOcupadas,
      'instrutorId': instrutorId,
      'instrutorNome': instrutorNome,
      'cor': cor,
      'ativa': ativa,
    };
  }

  AulaModel copyWith({
    String? nome,
    String? descricao,
    int? diaSemana,
    String? horarioInicio,
    String? horarioFim,
    int? vagasTotais,
    int? vagasOcupadas,
    String? instrutorId,
    String? instrutorNome,
    String? cor,
    bool? ativa,
  }) {
    return AulaModel(
      id: id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      diaSemana: diaSemana ?? this.diaSemana,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      horarioFim: horarioFim ?? this.horarioFim,
      vagasTotais: vagasTotais ?? this.vagasTotais,
      vagasOcupadas: vagasOcupadas ?? this.vagasOcupadas,
      instrutorId: instrutorId ?? this.instrutorId,
      instrutorNome: instrutorNome ?? this.instrutorNome,
      cor: cor ?? this.cor,
      ativa: ativa ?? this.ativa,
    );
  }

  /// Nome do dia da semana em português, a partir do índice [diaSemana].
  String get nomeDiaSemana {
    const dias = {
      1: 'Segunda-feira',
      2: 'Terça-feira',
      3: 'Quarta-feira',
      4: 'Quinta-feira',
      5: 'Sexta-feira',
      6: 'Sábado',
      7: 'Domingo',
    };
    return dias[diaSemana] ?? '';
  }
}

enum StatusOcupacao { disponivel, quaseCheia, esgotada }