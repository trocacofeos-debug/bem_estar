import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/usuario_model.dart';
import '../services/auth_service.dart';

enum AuthStatus {
  carregando,
  autenticado,
  naoAutenticado,
  erro,
}

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({
    AuthService? authService,
  }) : _authService = authService ?? AuthService() {
    _init();
  }

  AuthStatus _status = AuthStatus.carregando;
  UsuarioModel? _usuario;
  String? _erro;
  bool _carregandoAcao = false;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<UsuarioModel?>? _usuarioSub;

  AuthStatus get status => _status;
  UsuarioModel? get usuario => _usuario;
  String? get erro => _erro;
  bool get carregandoAcao => _carregandoAcao;

  bool get isAdmin => _usuario?.isAdmin ?? false;

  bool get isLogado => _status == AuthStatus.autenticado;

  // =====================================================
  // INIT AUTH STATE
  // =====================================================
  void _init() {
    _authSub = _authService.authStateChanges.listen(
      (user) {
        debugPrint('AUTH STATE: ${user?.uid}');

        _usuarioSub?.cancel();
        _usuario = null;

        if (user == null) {
          _status = AuthStatus.naoAutenticado;
          notifyListeners();
          return;
        }

        _status = AuthStatus.carregando;
        notifyListeners();

        _usuarioSub = _authService.streamUsuario(user.uid).listen(
          (usuario) {
            _usuario = usuario;
            _status = AuthStatus.autenticado;
            notifyListeners();
          },
          onError: (e) {
            _status = AuthStatus.erro;
            _erro = 'Erro ao carregar usuário';
            notifyListeners();
          },
        );
      },
      onError: (e) {
        _status = AuthStatus.erro;
        _erro = 'Erro de autenticação';
        notifyListeners();
      },
    );
  }

  // =====================================================
  // LOGIN
  // =====================================================
  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    _setCarregando(true);

    try {
      await _authService.login(email: email, senha: senha);
      _erro = null;
      return true;
    } catch (e) {
      _erro = _mensagemErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  // =====================================================
  // CADASTRO
  // =====================================================
  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    String? telefone,
  }) async {
    _setCarregando(true);

    try {
      await _authService.cadastrar(
        nome: nome,
        email: email,
        senha: senha,
        telefone: telefone,
      );

      _erro = null;
      return true;
    } catch (e) {
      _erro = _mensagemErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  // =====================================================
  // RESET SENHA
  // =====================================================
  Future<bool> enviarResetSenha(String email) async {
    _setCarregando(true);

    try {
      await _authService.enviarResetSenha(email);
      _erro = null;
      return true;
    } catch (e) {
      _erro = _mensagemErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  // =====================================================
  // LOGOUT (CORRIGIDO 100%)
  // =====================================================
  Future<void> logout() async {
    try {
      _setCarregando(true);

      await _authService.logout();

      // 🔥 LIMPA ESTADO LOCAL IMEDIATAMENTE
      _usuario = null;
      _status = AuthStatus.naoAutenticado;
      _erro = null;

      await _usuarioSub?.cancel();
      _usuarioSub = null;

      notifyListeners();
    } finally {
      _setCarregando(false);
    }
  }

  // =====================================================
  // ATUALIZAR PERFIL
  // =====================================================
  Future<bool> atualizarPerfil({
    String? nome,
    String? telefone,
    String? fotoUrl,
  }) async {
    final uid = _usuario?.id;

    if (uid == null) return false;

    _setCarregando(true);

    try {
      await _authService.atualizarPerfil(
        uid: uid,
        nome: nome,
        telefone: telefone,
        fotoUrl: fotoUrl,
      );

      _erro = null;
      return true;
    } catch (e) {
      _erro = _mensagemErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  // =====================================================
  // UTIL
  // =====================================================
  void limparErro() {
    _erro = null;
    notifyListeners();
  }

  void _setCarregando(bool valor) {
    _carregandoAcao = valor;
    notifyListeners();
  }

  String _mensagemErro(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não encontrado.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha incorretos.';
        case 'email-already-in-use':
          return 'Este e-mail já está cadastrado.';
        case 'weak-password':
          return 'A senha deve ter pelo menos 6 caracteres.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'too-many-requests':
          return 'Muitas tentativas. Tente novamente mais tarde.';
        default:
          return 'Erro: ${e.message ?? e.code}';
      }
    }

    return 'Erro inesperado.';
  }

  // =====================================================
  // DISPOSE
  // =====================================================
  @override
  void dispose() {
    _authSub?.cancel();
    _usuarioSub?.cancel();
    super.dispose();
  }
}