import 'package:flutter/material.dart';
import '../models/aula_model.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

/// Badge compacto que exibe o status de ocupação de uma aula,
/// com cor e texto correspondentes (Disponível / Quase cheia / Esgotada).
class BadgeVagas extends StatelessWidget {
  final AulaModel aula;
  final bool mostrarContagem;

  const BadgeVagas({
    super.key,
    required this.aula,
    this.mostrarContagem = true,
  });

  @override
  Widget build(BuildContext context) {
    final (corTexto, corFundo, texto) = _dadosPorStatus(aula.statusOcupacao);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: corTexto,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            mostrarContagem
                ? '$texto · ${aula.vagasDisponiveis}/${aula.vagasTotais}'
                : texto,
            style: TextStyle(
              color: corTexto,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, String) _dadosPorStatus(StatusOcupacao status) {
    switch (status) {
      case StatusOcupacao.disponivel:
        return (AppColors.disponivel, AppColors.disponivelBg, AppStrings.statusDisponivel);
      case StatusOcupacao.quaseCheia:
        return (AppColors.quaseCheia, AppColors.quaseCheiaBg, AppStrings.statusQuaseCheia);
      case StatusOcupacao.esgotada:
        return (AppColors.esgotada, AppColors.esgotadaBg, AppStrings.statusEsgotada);
    }
  }
}