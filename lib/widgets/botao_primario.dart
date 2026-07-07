import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// Botão primário com largura total, suporte a estado de carregamento
/// e ícone opcional. Usado em formulários e ações principais.
class BotaoPrimario extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool carregando;
  final IconData? icone;
  final Color? cor;

  const BotaoPrimario({
    super.key,
    required this.label,
    required this.onPressed,
    this.carregando = false,
    this.icone,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final desabilitado = onPressed == null || carregando;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: desabilitado ? null : onPressed,
        style: cor != null
            ? ElevatedButton.styleFrom(
                backgroundColor: cor,
                foregroundColor: AppColors.textOnPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              )
            : null,
        child: carregando
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icone != null) ...[
                    Icon(icone, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(label),
                ],
              ),
      ),
    );
  }
}

/// Variante secundária (outline), usada para ações de menor destaque
/// como "Cancelar agendamento".
class BotaoSecundario extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool carregando;
  final Color? corTexto;

  const BotaoSecundario({
    super.key,
    required this.label,
    required this.onPressed,
    this.carregando = false,
    this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    final desabilitado = onPressed == null || carregando;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: desabilitado ? null : onPressed,
        style: corTexto != null
            ? OutlinedButton.styleFrom(
                foregroundColor: corTexto,
                side: BorderSide(color: corTexto!.withValues(alpha: 0.4)),
              )
            : null,
        child: carregando
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    corTexto ?? AppColors.primary,
                  ),
                ),
              )
            : Text(label),
      ),
    );
  }
}