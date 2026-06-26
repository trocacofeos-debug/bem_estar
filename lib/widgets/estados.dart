import 'package:flutter/material.dart';
import '../utils/theme.dart';

/// Estado vazio genérico, usado quando uma lista (aulas, agendamentos)
/// não possui itens.
class EstadoVazio extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String? mensagem;

  const EstadoVazio({
    super.key,
    required this.icone,
    required this.titulo,
    this.mensagem,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(icone, size: 28, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              titulo,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (mensagem != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                mensagem!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Estado de erro com botão de tentar novamente.
class EstadoErro extends StatelessWidget {
  final String mensagem;
  final VoidCallback? onTentarNovamente;

  const EstadoErro({
    super.key,
    required this.mensagem,
    this.onTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 40, color: AppColors.esgotada),
            const SizedBox(height: AppSpacing.md),
            Text(
              mensagem,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onTentarNovamente != null) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton.icon(
                onPressed: onTentarNovamente,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Indicador de carregamento centralizado, com tamanho consistente.
class CarregandoCentro extends StatelessWidget {
  const CarregandoCentro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 28,
        height: 28,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );
  }
}