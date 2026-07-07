import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// Services
import 'services/notification_service.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/agenda_provider.dart';

// Models
import 'models/usuario_model.dart';

// Splash
import 'screens/splash/splash_screen.dart';

// Auth
import 'screens/auth/login_screen.dart';
import 'screens/auth/cadastro_screen.dart';
import 'screens/auth/esqueci_senha_screen.dart';
import 'screens/auth/aula_experimental_screen.dart';

// Admin
import 'screens/admin/dashboard_admin_screen.dart';

// Super Admin
import 'screens/superadmin/super_admin_screen.dart';

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
    'Firebase inicializado com sucesso',
  );


  runApp(
    const MyApp(),
  );
}




class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });



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


        debugShowCheckedModeBanner:false,


        title:
            'Bem Estar App',




        theme: ThemeData(

          useMaterial3:true,

          colorScheme:
              ColorScheme.fromSeed(

            seedColor:
                Colors.green,

          ),

        ),




        routes:{


          '/login':
              (_) =>
              const LoginScreen(),


          '/cadastro':
              (_) =>
              const CadastroScreen(),



          '/esqueci-senha':
              (_) =>
              const EsqueciSenhaScreen(),



          '/aula-experimental':
              (_) =>
              const AulaExperimentalScreen(),




          '/admin':
              (_) =>
              const DashboardAdminScreen(),



          '/superadmin':
              (_) =>
              const SuperAdminScreen(),




          '/aluno':
              (_) =>
              const HomeAlunoScreen(),



          '/aluno/agendamentos':
              (_) =>
              const MeusAgendamentosScreen(),



          '/aluno/aulas':
              (_) =>
              const AulasDisponiveisScreen(),



          '/aluno/perfil':
              (_) =>
              const PerfilScreen(),



        },



        // PRIMEIRA TELA
        home:
            const SplashScreen(),


      ),

    );

  }

}








// =====================================================
// CONTROLE DE LOGIN
// =====================================================

class AuthWrapper extends StatelessWidget {


  const AuthWrapper({
    super.key,
  });




  @override
  Widget build(BuildContext context) {


    final auth =
        context.watch<AuthProvider>();




    // Aguarda Firebase verificar usuário

    if(auth.status ==
        AuthStatus.carregando){


      return const Scaffold(

        body:
            Center(

          child:
              CircularProgressIndicator(),

        ),

      );

    }




    // Erro

    if(auth.status ==
        AuthStatus.erro){


      return Scaffold(

        body:
            Center(

          child:
              Text(

            auth.erro ??
                'Erro ao carregar autenticação',

            textAlign:
                TextAlign.center,

          ),

        ),

      );


    }





    // Sem usuário logado

    if(auth.usuario == null){


      return const LoginScreen();


    }






    final TipoUsuario? role =
        auth.role;




    debugPrint(
      "==============================",
    );

    debugPrint(
      "USUARIO: ${auth.usuario?.nome}",
    );

    debugPrint(
      "ROLE: $role",
    );

    debugPrint(
      "SUPERADMIN: ${auth.isSuperAdmin}",
    );

    debugPrint(
      "ADMIN: ${auth.isAdmin}",
    );

    debugPrint(
      "==============================",
    );







    // SUPER ADMIN

    if(role ==
        TipoUsuario.superadmin){


      return const SuperAdminScreen();


    }






    // ADMIN

    if(role ==
        TipoUsuario.admin){


      return const DashboardAdminScreen();


    }







    // ALUNO

    return const HomeAlunoScreen();


  }

}