import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/agenda_provider.dart';
import '../../providers/auth_provider.dart';

import '../../models/aula_model.dart';
import '../../utils/theme.dart';

class AulasDisponiveisScreen extends StatefulWidget {
  const AulasDisponiveisScreen({super.key});

  @override
  State<AulasDisponiveisScreen> createState() =>
      _AulasDisponiveisScreenState();
}

class _AulasDisponiveisScreenState
    extends State<AulasDisponiveisScreen> {
  bool _iniciado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_iniciado) return;

    final auth = context.read<AuthProvider>();

    if (auth.usuario != null) {
      context.read<AgendaProvider>().iniciar(auth.usuario!.id);
      _iniciado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final agenda = context.watch<AgendaProvider>();
    final auth = context.watch<AuthProvider>();

    final usuario = auth.usuario;

    if (usuario == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Aulas disponíveis"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: agenda.voltarDia,
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  "${agenda.dataSelecionada.day.toString().padLeft(2, '0')}/"
                  "${agenda.dataSelecionada.month.toString().padLeft(2, '0')}/"
                  "${agenda.dataSelecionada.year}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: agenda.avancarDia,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),

          Expanded(
            child: agenda.carregandoAulas
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : agenda.aulasDoDia.isEmpty
                    ? const Center(
                        child: Text(
                          "Nenhuma aula disponível neste dia.",
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          bottom: AppSpacing.md,
                        ),
                        itemCount: agenda.aulasDoDia.length,
                        itemBuilder: (context, index) {
                          final aula = agenda.aulasDoDia[index];

                          final jaAgendada = agenda
                              .aulasAgendadasNoDia
                              .contains(aula.id);

                          return _AulaCard(
                            aula: aula,
                            jaAgendada: jaAgendada,
                            onAgendar: () async {
                              try {
                                await agenda.agendar(
                                  alunoId: usuario.id,
                                  alunoNome: usuario.nome,
                                  aula: aula,
                                );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Agendamento realizado com sucesso.',
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.toString(),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _AulaCard extends StatelessWidget {
  final AulaModel aula;
  final bool jaAgendada;
  final VoidCallback onAgendar;

  const _AulaCard({
    required this.aula,
    required this.jaAgendada,
    required this.onAgendar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            aula.nome,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            "${aula.horarioInicio} - ${aula.horarioFim}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            "Instrutor: ${aula.instrutorNome}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            "Vagas disponíveis: ${aula.vagasDisponiveis}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: AppSpacing.md),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: jaAgendada || !aula.temVaga
                  ? null
                  : onAgendar,
              child: Text(
                jaAgendada
                    ? "Já agendada"
                    : !aula.temVaga
                        ? "Esgotada"
                        : "Agendar",
              ),
            ),
          ),
        ],
      ),
    );
  }
}