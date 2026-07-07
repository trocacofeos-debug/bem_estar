// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';

import 'gerenciar_aulas_screen.dart';
import 'relatorio_ocupacao_screen.dart';
import 'selecionar_aula_agendamento_screen.dart';
import 'painel_experimental_screen.dart';

import '../assinatura/assinatura_screen.dart';

class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    final nome =
        auth.usuario?.nome.split(' ').first ?? 'Administrador';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.75),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Painel Administrativo",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Olá, $nome 👋",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _confirmarLogout(context, auth),
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
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
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 20),

              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.95,
                children: [
                  _DashboardCard(
                    titulo: "Gerenciar\nAulas",
                    subtitulo: "Criar e editar aulas",
                    icone: Icons.fitness_center,
                    cor: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const GerenciarAulasScreen(),
                        ),
                      );
                    },
                  ),

                  _DashboardCard(
                    titulo: "Relatório\nOcupação",
                    subtitulo: "Visualizar vagas",
                    icone: Icons.bar_chart,
                    cor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const RelatorioOcupacaoScreen(),
                        ),
                      );
                    },
                  ),

                  _DashboardCard(
                    titulo: "Agendamentos",
                    subtitulo: "Ver alunos",
                    icone: Icons.event_available,
                    cor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const SelecionarAulaAgendamentoScreen(),
                        ),
                      );
                    },
                  ),

                  _DashboardCard(
                    titulo: "Experimental",
                    subtitulo: "Aulas teste",
                    icone: Icons.auto_awesome,
                    cor: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const PainelExperimentalScreen(),
                        ),
                      );
                    },
                  ),

                  // ASSINATURA
                  _DashboardCard(
                    titulo: "Assinatura",
                    subtitulo: "Plano e cobrança",
                    icone: Icons.workspace_premium,
                    cor: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AssinaturaScreen(),
                        ),
                      );
                    },
                  ),

                  _DashboardCard(
                    titulo: "Sair",
                    subtitulo: "Encerrar sessão",
                    icone: Icons.logout,
                    cor: Colors.red,
                    onTap: () =>
                        _confirmarLogout(context, auth),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmarLogout(
    BuildContext context,
    AuthProvider auth,
  ) async {
    final sair = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sair"),
        content: const Text(
          "Deseja realmente sair?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("Sair"),
          ),
        ],
      ),
    );

    if (sair == true) {
      await auth.logout();
    }
  }
}

class _DashboardCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: cor.withOpacity(.12),
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
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitulo,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}