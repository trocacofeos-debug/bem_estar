import 'package:flutter/material.dart';
import '../models/agendamento_model.dart';
import '../utils/theme.dart';
import '../utils/date_helpers.dart';
import 'botao_primario.dart';

/// Card que representa um agendamento do aluno, usado na tela
/// "Meus agendamentos". Mostra data, horário, aula e status.
class AgendamentoCard extends StatelessWidget {
  final AgendamentoModel agendamento;
  final bool carregando;
  final VoidCallback? onCancelar;

  const AgendamentoCard({
    super.key,
    required this.agendamento,
    this.carregando = false,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final podeCancel = agendamento.estaAtivo && !agendamento.jaOcorreu;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDataBox(context),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agendamento.aulaNome,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            DateHelpers.formatarIntervalo(
                              agendamento.horarioInicio,
                              agendamento.horarioFim,
                            ),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildStatusChip(),
                    ],
                  ),
                ),
              ],
            ),
            if (podeCancel && onCancelar != null) ...[
              const SizedBox(height: AppSpacing.md),
              BotaoSecundario(
                label: 'Cancelar agendamento',
                onPressed: onCancelar,
                carregando: carregando,
                corTexto: AppColors.esgotada,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDataBox(BuildContext context) {
    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          Text(
            DateHelpers.nomeDiaSemanaAbreviado(agendamento.data.weekday),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${agendamento.data.day}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    final (cor, fundo, texto) = _dadosStatus();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  (Color, Color, String) _dadosStatus() {
    if (agendamento.status == StatusAgendamento.cancelado) {
      return (AppColors.textSecondary, AppColors.surfaceMuted, 'Cancelado');
    }
    if (agendamento.status == StatusAgendamento.faltou) {
      return (AppColors.esgotada, AppColors.esgotadaBg, 'Falta');
    }
    if (agendamento.status == StatusAgendamento.presente) {
      return (AppColors.disponivel, AppColors.disponivelBg, 'Presença confirmada');
    }
    if (agendamento.jaOcorreu) {
      return (AppColors.textSecondary, AppColors.surfaceMuted, 'Concluído');
    }
    return (AppColors.primary, AppColors.disponivelBg, 'Confirmado');
  }
}