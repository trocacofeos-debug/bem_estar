// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../utils/constants.dart';

class HomeAlunoScreen extends StatelessWidget {
  const HomeAlunoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: const Text("Área do Aluno"),
        actions: [
          IconButton(
            tooltip: "Meus agendamentos",
            icon: const Icon(Icons.event_note),
            onPressed: () {
              Navigator.pushNamed(
                context,
                AppRoutes.meusAgendamentos,
              );
            },
          ),
          IconButton(
            tooltip: "Sair",
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Sair"),
                  content: const Text(
                    "Deseja realmente sair da sua conta?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text("Sair"),
                    ),
                  ],
                ),
              );

              if (confirmar == true) {
                await auth.logout();

                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login,
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(width: 18),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Área do Aluno",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "Gerencie suas aulas e agendamentos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Acesso rápido",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// GRID
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.95,
                children: [

                  _AlunoCard(
                    titulo: "Aulas\nDisponíveis",
                    subtitulo: "Agende suas aulas",
                    icone: Icons.fitness_center_rounded,
                    cor: AppColors.primary,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.aulasDisponiveis,
                      );
                    },
                  ),

                  _AlunoCard(
                    titulo: "Meus\nAgendamentos",
                    subtitulo: "Veja suas reservas",
                    icone: Icons.calendar_today_rounded,
                    cor: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.meusAgendamentos,
                      );
                    },
                  ),

                  /// ✅ PERFIL CORRIGIDO
                  _AlunoCard(
                    titulo: "Perfil",
                    subtitulo: "Seus dados",
                    icone: Icons.person_rounded,
                    cor: Colors.orange,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/aluno/perfil',
                      );
                    },
                  ),

                  _AlunoCard(
                    titulo: "Sair",
                    subtitulo: "Encerrar sessão",
                    icone: Icons.logout_rounded,
                    cor: Colors.red,
                    onTap: () async {
                      await auth.logout();

                      if (context.mounted) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                          AppRoutes.login,
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// CARD
class _AlunoCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;

  const _AlunoCard({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: cor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icone,
                    color: cor,
                    size: 28,
                  ),
                ),

                const Spacer(),

                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  subtitulo,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}