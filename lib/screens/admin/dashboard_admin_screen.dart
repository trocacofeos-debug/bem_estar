// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';

import 'gerenciar_aulas_screen.dart';
import 'relatorio_ocupacao_screen.dart';
import 'selecionar_aula_agendamento_screen.dart';
import 'painel_experimental_screen.dart';

<<<<<<< HEAD
import '../assinatura/assinatura_screen.dart';

=======
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
class DashboardAdminScreen extends StatelessWidget {
  const DashboardAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
<<<<<<< HEAD

    final nome =
        auth.usuario?.nome.split(' ').first ?? 'Administrador';

    return Scaffold(
      backgroundColor: AppColors.background,
=======
    final nome = auth.usuario?.nome.split(' ').first ?? 'Administrador';

    return Scaffold(
      backgroundColor: AppColors.background,

>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              // HEADER
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
=======

              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.75),
                    ],
<<<<<<< HEAD
=======
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                  ),
                ),
                child: Row(
                  children: [
<<<<<<< HEAD
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
=======

                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
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
<<<<<<< HEAD
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          _confirmarLogout(context, auth),
                      icon: const Icon(
                        Icons.logout,
=======
                          const SizedBox(height: 6),
                          const Text(
                            "Gerencie aulas, ocupação e agendamentos.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () => _confirmarLogout(context, auth),
                      icon: const Icon(
                        Icons.logout_rounded,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Acesso rápido",
<<<<<<< HEAD
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
=======
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 20),

<<<<<<< HEAD
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
=======
              // ================= GRID =================
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 0.85,
                children: [

                  _DashboardCard(
                    titulo: "Gerenciar\nAulas",
                    subtitulo: "Criar e editar turmas",
                    icone: Icons.fitness_center_rounded,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                    cor: AppColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
<<<<<<< HEAD
                          builder: (_) =>
                              const GerenciarAulasScreen(),
=======
                          builder: (_) => const GerenciarAulasScreen(),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                        ),
                      );
                    },
                  ),

                  _DashboardCard(
                    titulo: "Relatório\nOcupação",
<<<<<<< HEAD
                    subtitulo: "Visualizar vagas",
                    icone: Icons.bar_chart,
=======
                    subtitulo: "Acompanhar vagas",
                    icone: Icons.bar_chart_rounded,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                    cor: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
<<<<<<< HEAD
                          builder: (_) =>
                              const RelatorioOcupacaoScreen(),
=======
                          builder: (_) => const RelatorioOcupacaoScreen(),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                        ),
                      );
                    },
                  ),

                  _DashboardCard(
                    titulo: "Agendamentos",
<<<<<<< HEAD
                    subtitulo: "Ver alunos",
                    icone: Icons.event_available,
=======
                    subtitulo: "Lista de alunos",
                    icone: Icons.event_available_rounded,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
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

<<<<<<< HEAD
                  _DashboardCard(
                    titulo: "Experimental",
                    subtitulo: "Aulas teste",
=======
                  // ================= EXPERIMENTAL =================
                  _DashboardCard(
                    titulo: "Aulas\nExperimentais",
                    subtitulo: "Gerar e gerenciar",
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                    icone: Icons.auto_awesome,
                    cor: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
<<<<<<< HEAD
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
=======
                          builder: (_) => const PainelExperimentalScreen(),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                        ),
                      );
                    },
                  ),

                  _DashboardCard(
                    titulo: "Sair",
                    subtitulo: "Encerrar sessão",
<<<<<<< HEAD
                    icone: Icons.logout,
                    cor: Colors.red,
                    onTap: () =>
                        _confirmarLogout(context, auth),
=======
                    icone: Icons.logout_rounded,
                    cor: Colors.red,
                    onTap: () => _confirmarLogout(context, auth),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
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
<<<<<<< HEAD
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
=======
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sair'),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
          ),
        ],
      ),
    );

<<<<<<< HEAD
    if (sair == true) {
=======
    if (confirmar == true) {
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
      await auth.logout();
    }
  }
}

<<<<<<< HEAD
=======
// ================= CARD REUTILIZÁVEL =================
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
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
<<<<<<< HEAD
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
=======
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
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
        ),
      ),
    );
  }
}