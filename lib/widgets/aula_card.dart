import 'package:flutter/material.dart';
import '../models/aula_model.dart';
import '../utils/theme.dart';
import '../utils/date_helpers.dart';
import 'badge_vagas.dart';
import 'botao_primario.dart';

/// Card que exibe uma aula com horário, instrutor, status de vagas e
/// botão de ação (agendar ou cancelar, dependendo de [jaAgendado]).
class AulaCard extends StatelessWidget {
  final AulaModel aula;
  final bool jaAgendado;
  final bool carregando;
  final VoidCallback? onAgendar;
  final VoidCallback? onCancelar;

  const AulaCard({
    super.key,
    required this.aula,
    this.jaAgendado = false,
    this.carregando = false,
    this.onAgendar,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    final corFaixa = aula.cor != null
        ? _corDeHex(aula.cor!)
        : AppColors.primary;

    return Card(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Faixa lateral colorida indicando a modalidade
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: corFaixa,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  bottomLeft: Radius.circular(AppRadius.lg),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                aula.nome,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_rounded,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateHelpers.formatarIntervalo(
                                      aula.horarioInicio,
                                      aula.horarioFim,
                                    ),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline_rounded,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    aula.instrutorNome,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        BadgeVagas(aula: aula),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildAcao(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcao(BuildContext context) {
    if (jaAgendado) {
      return Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 18, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Você está agendado',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          if (onCancelar != null)
            TextButton(
              onPressed: carregando ? null : onCancelar,
              style: TextButton.styleFrom(foregroundColor: AppColors.esgotada),
              child: const Text('Cancelar'),
            ),
        ],
      );
    }

    return BotaoPrimario(
      label: aula.temVaga ? 'Agendar' : 'Esgotada',
      onPressed: aula.temVaga ? onAgendar : null,
      carregando: carregando,
    );
  }

  Color _corDeHex(String hex) {
    final codigo = hex.replaceAll('#', '');
    final valor = int.tryParse('FF$codigo', radix: 16);
    return valor != null ? Color(valor) : AppColors.primary;
  }
}