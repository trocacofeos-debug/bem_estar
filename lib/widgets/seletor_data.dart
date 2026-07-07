import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../utils/date_helpers.dart';

/// Seletor horizontal de data, com botões de navegação entre dias e
/// exibição da data formatada de forma amigável ("Hoje", "Amanhã").
class SeletorData extends StatelessWidget {
  final DateTime dataSelecionada;
  final VoidCallback onAnterior;
  final VoidCallback onProximo;
  final VoidCallback? onHoje;

  const SeletorData({
    super.key,
    required this.dataSelecionada,
    required this.onAnterior,
    required this.onProximo,
    this.onHoje,
  });

  @override
  Widget build(BuildContext context) {
    final isHoje = DateHelpers.isHoje(dataSelecionada);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onAnterior,
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppColors.textSecondary,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  DateHelpers.formatarCompleto(dataSelecionada),
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                if (!isHoje && onHoje != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: GestureDetector(
                      onTap: onHoje,
                      child: Text(
                        'Voltar para hoje',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onProximo,
            icon: const Icon(Icons.chevron_right_rounded),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

/// Variante em formato de tira de dias da semana (estilo calendário),
/// permitindo selecionar um dia diretamente.
class TiraDias extends StatelessWidget {
  final DateTime dataSelecionada;
  final ValueChanged<DateTime> onSelecionar;
  final int quantidadeDias;

  const TiraDias({
    super.key,
    required this.dataSelecionada,
    required this.onSelecionar,
    this.quantidadeDias = 7,
  });

  @override
  Widget build(BuildContext context) {
    final dias = DateHelpers.proximosDias(quantidadeDias);

    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dias.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final dia = dias[index];
          final selecionado = DateHelpers.mesmoDia(dia, dataSelecionada);

          return GestureDetector(
            onTap: () => onSelecionar(dia),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 56,
              decoration: BoxDecoration(
                color: selecionado ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(
                  color: selecionado ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateHelpers.nomeDiaSemanaAbreviado(dia.weekday),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selecionado ? AppColors.textOnPrimary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${dia.day}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: selecionado ? AppColors.textOnPrimary : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}