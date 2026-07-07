// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../providers/agenda_provider.dart';
import '../../models/agendamento_model.dart';
import '../../utils/theme.dart';

class MeusAgendamentosScreen extends StatefulWidget {
  const MeusAgendamentosScreen({super.key});

  @override
  State<MeusAgendamentosScreen> createState() =>
      _MeusAgendamentosScreenState();
}

class _MeusAgendamentosScreenState
    extends State<MeusAgendamentosScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null || !mounted) return;

      await context.read<AgendaProvider>().iniciar(user.uid);
    });
  }

  String _statusTexto(StatusAgendamento status) {
    switch (status) {
      case StatusAgendamento.confirmado:
        return 'Confirmado';
      case StatusAgendamento.cancelado:
        return 'Cancelado';
      case StatusAgendamento.presente:
        return 'Presente';
      case StatusAgendamento.faltou:
        return 'Faltou';
    }
  }

  Color _statusCor(StatusAgendamento status) {
    switch (status) {
      case StatusAgendamento.confirmado:
        return Colors.green;
      case StatusAgendamento.cancelado:
        return Colors.red;
      case StatusAgendamento.presente:
        return Colors.blue;
      case StatusAgendamento.faltou:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final agenda = context.watch<AgendaProvider>();

    final lista = List<AgendamentoModel>.from(agenda.meusAgendamentos);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Meus Agendamentos"),
      ),
      body: Builder(
        builder: (_) {
          if (agenda.processandoAgendamento && lista.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (agenda.erro != null && lista.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  agenda.erro!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (lista.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum agendamento encontrado",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await agenda.atualizar();
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 24),
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final agendamento = lista[index];

                final status = agendamento.status;
                final corStatus = _statusCor(status);
                final textoStatus = _statusTexto(status);

                final podeCancelar =
                    status == StatusAgendamento.confirmado &&
                    !agendamento.jaOcorreu;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: corStatus.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agendamento.aulaNome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${agendamento.data.day.toString().padLeft(2, '0')}/'
                            '${agendamento.data.month.toString().padLeft(2, '0')}/'
                            '${agendamento.data.year}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${agendamento.horarioInicio} - ${agendamento.horarioFim}',
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: corStatus.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          textoStatus,
                          style: TextStyle(
                            color: corStatus,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      if (podeCancelar)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.cancel),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              final ok = await agenda.cancelar(agendamento);

                              if (!mounted) return;

                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    ok
                                        ? 'Agendamento cancelado com sucesso'
                                        : agenda.erro ?? 'Erro ao cancelar',
                                  ),
                                  backgroundColor:
                                      ok ? Colors.green : Colors.red,
                                ),
                              );
                            },
                            label: const Text('Cancelar Agendamento'),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}