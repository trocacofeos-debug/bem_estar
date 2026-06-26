import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Serviços
import 'services/notification_service.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/agenda_provider.dart';

// Splash
import 'screens/splash/splash_screen.dart';

// Auth
import 'screens/auth/login_screen.dart';
import 'screens/auth/cadastro_screen.dart';
import 'screens/auth/esqueci_senha_screen.dart';
import 'screens/auth/aula_experimental_screen.dart';

// Admin
import 'screens/admin/dashboard_admin_screen.dart';

// Aluno
import 'screens/aluno/home_aluno_screen.dart';
import 'screens/aluno/meus_agendamentos_screen.dart';
import 'screens/aluno/aulas_disponiveis_screen.dart';
import 'screens/aluno/perfil_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

  debugPrint(
    'Firebase + Notificações inicializados com sucesso.',
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider<AgendaProvider>(
          create: (_) => AgendaProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bem Estar App',

        routes: {
          '/login': (context) => const LoginScreen(),
          '/cadastro': (context) => const CadastroScreen(),
          '/esqueci-senha': (context) =>
              const EsqueciSenhaScreen(),
          '/aula-experimental': (context) =>
              const AulaExperimentalScreen(),
          '/admin': (context) =>
              const DashboardAdminScreen(),
          '/aluno': (context) =>
              const HomeAlunoScreen(),
          '/aluno/agendamentos': (context) =>
              const MeusAgendamentosScreen(),
          '/aluno/aulas': (context) =>
              const AulasDisponiveisScreen(),
          '/aluno/perfil': (context) =>
              const PerfilScreen(),
          '/auth': (context) =>
              const AuthWrapper(),
        },

        home: const SplashScreen(),
      ),
    );
  }
}

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

    if (auth.status == AuthStatus.erro) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'Erro ao carregar autenticação.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    if (auth.usuario == null) {
      return const LoginScreen();
    }

    if (auth.isAdmin) {
      return const DashboardAdminScreen();
    }

    return const HomeAlunoScreen();
  }
}