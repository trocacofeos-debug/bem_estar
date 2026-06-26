// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../models/aula_model.dart';
import '../../models/agendamento_model.dart';
import '../../services/agendamento_service.dart';

class AgendamentosAulaScreen extends StatelessWidget {
  final AulaModel aula;
  final DateTime data;

  const AgendamentosAulaScreen({
    super.key,
    required this.aula,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Agendamentos • ${aula.nome}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),

      body: StreamBuilder<List<AgendamentoModel>>(
        stream: AgendamentoService().streamAgendamentosDaAula(
          aulaId: aula.id,
          data: data,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          final agendamentos = snapshot.data ?? [];

          if (agendamentos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 90,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Nenhum agendamento encontrado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Essa aula ainda não possui alunos',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: agendamentos.length,
            itemBuilder: (context, index) {
              final agendamento = agendamentos[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [

                    /// STATUS BAR LATERAL (MUDANÇA VISUAL FORTE)
                    Container(
                      width: 6,
                      height: 90,
                      decoration: BoxDecoration(
                        color: _statusColor(
                          agendamento.status
                              .toString()
                              .split('.')
                              .last,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(18),
                          bottomLeft: Radius.circular(18),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            /// ALUNO + STATUS
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    agendamento.alunoNome,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),

                                _statusChip(
                                  agendamento.status
                                      .toString()
                                      .split('.')
                                      .last,
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// DATA
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${agendamento.data.day.toString().padLeft(2, '0')}/'
                                  '${agendamento.data.month.toString().padLeft(2, '0')}/'
                                  '${agendamento.data.year}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            /// HORÁRIO
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${agendamento.horarioInicio} - ${agendamento.horarioFim}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// 🔥 COR MAIS FORTE (DÁ IMPACTO VISUAL REAL)
  Color _statusColor(String status) {
    switch (status) {
      case 'presente':
        return Colors.green;
      case 'faltou':
        return Colors.red;
      case 'cancelado':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  Widget _statusChip(String status) {
    final color = _statusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}