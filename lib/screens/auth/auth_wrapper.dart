import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../models/usuario_model.dart';

import '../admin/dashboard_admin_screen.dart';
import '../superadmin/super_admin_screen.dart';
import '../aluno/home_aluno_screen.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.status == AuthStatus.carregando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (auth.usuario == null) {
      return const LoginScreen();
    }

    if (auth.role == TipoUsuario.superadmin) {
      return const SuperAdminScreen();
    }

    if (auth.role == TipoUsuario.admin) {
      return const DashboardAdminScreen();
    }

    return const HomeAlunoScreen();
  }
}