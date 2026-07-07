// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
<<<<<<< HEAD
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController senhaController =
      TextEditingController();
=======
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final auth = context.read<AuthProvider>();

    final ok = await auth.login(
      email: emailController.text.trim(),
      senha: senhaController.text.trim(),
    );

    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
<<<<<<< HEAD
            auth.erro ?? 'Erro ao realizar login',
          ),
          backgroundColor: Colors.red,
=======
            auth.erro ?? "Erro ao realizar login",
          ),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
        ),
      );
      return;
    }

<<<<<<< HEAD
    // Aguarda o AuthProvider carregar o usuário do Firestore
    await Future.delayed(
      const Duration(milliseconds: 1000),
=======
    await Future.delayed(
      const Duration(milliseconds: 500),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
    );

    if (!mounted) return;

<<<<<<< HEAD
    debugPrint('========================');
    debugPrint('LOGIN REALIZADO');
    debugPrint('USUARIO: ${auth.usuario?.nome}');
    debugPrint('ROLE: ${auth.role}');
    debugPrint('SUPERADMIN: ${auth.isSuperAdmin}');
    debugPrint('ADMIN: ${auth.isAdmin}');
    debugPrint('ALUNO: ${auth.isAluno}');
    debugPrint('========================');

    // SUPER ADMIN
    if (auth.isSuperAdmin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/superadmin',
        (route) => false,
      );
      return;
    }

    // ADMIN
    if (auth.isAdmin) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/admin',
        (route) => false,
      );
      return;
    }

    // ALUNO
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/aluno',
      (route) => false,
    );
=======
    if (auth.isAdmin) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.dashboardAdmin,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.homeAluno,
      );
    }
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
<<<<<<< HEAD
=======

>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
<<<<<<< HEAD
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                  ),

                  const SizedBox(height: 20),
=======

            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // =====================
                  // LOGO
                  // =====================

                  Image.asset(
                    'assets/images/logo.png',
                    height: 110,
                  ),

                  const SizedBox(height: 16),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b

                  Text(
                    AppConstants.appName,
                    style: const TextStyle(
<<<<<<< HEAD
                      fontSize: 28,
=======
                      fontSize: 26,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 32),

<<<<<<< HEAD
=======
                  // =====================
                  // FORM LOGIN
                  // =====================

>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
<<<<<<< HEAD
                        TextField(
                          controller: emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            ),
                            filled: true,
                            fillColor:
                                const Color(0xFFF2F3F7),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
=======

                        // EMAIL
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: const Color(0xFFF2F3F7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

<<<<<<< HEAD
=======
                        // SENHA
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                        TextField(
                          controller: senhaController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Senha',
<<<<<<< HEAD
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            filled: true,
                            fillColor:
                                const Color(0xFFF2F3F7),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
=======
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: const Color(0xFFF2F3F7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

<<<<<<< HEAD
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: auth.carregandoAcao
                                ? null
                                : _login,
                            child: auth.carregandoAcao
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
=======
                        // BOTÃO LOGIN
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: auth.carregandoAcao ? null : _login,
                            child: auth.carregandoAcao
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
<<<<<<< HEAD
                                : const Text(
                                    AppStrings.entrar,
                                  ),
=======
                                : const Text(AppStrings.entrar),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

<<<<<<< HEAD
=======
                  // =====================
                  // ESQUECI SENHA (AGORA PRIMEIRO)
                  // =====================

>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.esqueciSenha,
                      );
                    },
                    child: const Text(
                      AppStrings.esqueceuSenha,
<<<<<<< HEAD
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

=======
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),

                  // =====================
                  // CRIAR CONTA
                  // =====================

>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.cadastro,
                      );
                    },
                    child: const Text(
                      AppStrings.criarConta,
<<<<<<< HEAD
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
=======
                      style: TextStyle(fontWeight: FontWeight.w600),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                    ),
                  ),

                  const SizedBox(height: 8),

<<<<<<< HEAD
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: InkWell(
                      borderRadius:
                          BorderRadius.circular(14),
=======
                  // =====================
                  // AULA EXPERIMENTAL (ULTIMO)
                  // =====================

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/aula-experimental',
                        );
                      },
                      child: Container(
                        width: double.infinity,
<<<<<<< HEAD
                        padding:
                            const EdgeInsets.all(16),
=======
                        padding: const EdgeInsets.all(16),
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                        child: const Row(
                          children: [
                            Icon(
                              Icons.card_giftcard,
                              color: Colors.green,
                              size: 32,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
<<<<<<< HEAD
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
=======
                                crossAxisAlignment: CrossAxisAlignment.start,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                                children: [
                                  Text(
                                    'Aula Experimental Grátis',
                                    style: TextStyle(
<<<<<<< HEAD
                                      fontWeight:
                                          FontWeight.bold,
=======
                                      fontWeight: FontWeight.bold,
>>>>>>> 12bfda8db290d757ea89f820ea84b8dab268410b
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Conheça nossa academia sem compromisso.',
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}