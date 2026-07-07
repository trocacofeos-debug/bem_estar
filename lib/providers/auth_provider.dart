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



  AuthStatus _status =
      AuthStatus.carregando;


  UsuarioModel? _usuario;


  String? _erro;


  bool _carregandoAcao = false;



  StreamSubscription<User?>? _authSub;


  StreamSubscription<UsuarioModel?>? _usuarioSub;





  // =========================
  // GETTERS
  // =========================


  AuthStatus get status =>
      _status;



  UsuarioModel? get usuario =>
      _usuario;



  String? get erro =>
      _erro;



  bool get carregandoAcao =>
      _carregandoAcao;



  TipoUsuario? get role =>
      _usuario?.role;



  bool get isAluno =>
      _usuario?.isAluno ?? false;



  bool get isAdmin =>
      _usuario?.isAdmin ?? false;



  bool get isSuperAdmin =>
      _usuario?.isSuperAdmin ?? false;



  bool get isLogado =>
      _status == AuthStatus.autenticado;






  // =====================================================
  // INICIALIZAÇÃO AUTH
  // =====================================================


  void _init() {


    _authSub =
        _authService.authStateChanges.listen(
      (user) async {


        debugPrint(
          "AUTH STATE: ${user?.uid}",
        );



        await _usuarioSub?.cancel();


        _usuarioSub = null;


        _usuario = null;


        _status =
            AuthStatus.carregando;


        notifyListeners();





        // SEM LOGIN

        if(user == null){


          _status =
              AuthStatus.naoAutenticado;


          notifyListeners();


          return;

        }





        // BUSCA USUARIO FIRESTORE


        _usuarioSub =
            _authService
                .streamUsuario(user.uid)
                .listen(

          (usuario) async {


            if(usuario == null){


              await _bloquearUsuario(
                "Usuário não encontrado.",
              );


              return;

            }





            // =================================
            // BLOQUEIO STATUS
            // =================================


            if(usuario.status
                    .toUpperCase() !=
                "ATIVO"){



              debugPrint(
                "USUÁRIO INATIVO BLOQUEADO",
              );



              await _bloquearUsuario(
                "Sua conta está desativada.",
              );



              return;

            }







            _usuario = usuario;


            _status =
                AuthStatus.autenticado;


            _erro = null;



            debugPrint(
              "======================",
            );


            debugPrint(
              "USUARIO: ${usuario.nome}",
            );


            debugPrint(
              "ROLE: ${usuario.role}",
            );


            debugPrint(
              "STATUS: ${usuario.status}",
            );


            debugPrint(
              "======================",
            );



            notifyListeners();


          },



          onError: (e){


            _status =
                AuthStatus.erro;


            _erro =
                "Erro ao carregar usuário: $e";



            notifyListeners();


          },

        );

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



      final credential =
          await _authService.login(

            email: email,

            senha: senha,

          );



      final usuario =
          await _authService.getUsuario(
            credential.user!.uid,
          );





      if(usuario == null){


        _erro =
            "Usuário não encontrado.";


        await _authService.logout();


        return false;

      }





      // ===============================
      // VERIFICA STATUS
      // ===============================


      if(usuario.status
              .toUpperCase() !=
          "ATIVO"){



        _erro =
            "Usuário bloqueado ou inativo.";



        await _authService.logout();



        return false;

      }





      _usuario =
          usuario;



      _erro = null;



      return true;



    }catch(e){



      _erro =
          _mensagemErro(e);



      return false;



    }finally{


      _setCarregando(false);


    }

  }









  // =====================================================
  // BLOQUEAR USUARIO
  // =====================================================


  Future<void> _bloquearUsuario(
      String mensagem) async {


    _erro =
        mensagem;



    await _authService.logout();



    _usuario = null;



    _status =
        AuthStatus.naoAutenticado;



    notifyListeners();


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



    }catch(e){



      _erro =
          _mensagemErro(e);



      return false;



    }finally{


      _setCarregando(false);


    }

  }








  // =====================================================
  // LOGOUT
  // =====================================================


  Future<void> logout() async {


    _setCarregando(true);



    try {


      await _authService.logout();



      await _usuarioSub?.cancel();



      _usuarioSub = null;



      _usuario = null;



      _status =
          AuthStatus.naoAutenticado;



      _erro = null;



      notifyListeners();



    }finally{


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



    final uid =
        _usuario?.id;



    if(uid == null){

      return false;

    }



    try {



      await _authService.atualizarPerfil(

        uid: uid,

        nome: nome,

        telefone: telefone,

        fotoUrl: fotoUrl,

      );



      return true;



    }catch(e){



      _erro =
          _mensagemErro(e);



      return false;


    }


  }








  void _setCarregando(bool valor){


    _carregandoAcao =
        valor;


    notifyListeners();


  }







  void limparErro(){


    _erro = null;


    notifyListeners();


  }








  String _mensagemErro(Object e){



    if(e is FirebaseAuthException){


      switch(e.code){


        case "user-not-found":

          return "Usuário não encontrado.";



        case "wrong-password":

        case "invalid-credential":

          return "E-mail ou senha incorretos.";



        case "email-already-in-use":

          return "Este e-mail já está cadastrado.";



        case "weak-password":

          return "Senha fraca.";



        case "invalid-email":

          return "E-mail inválido.";



        case "too-many-requests":

          return "Muitas tentativas. Tente mais tarde.";



        default:

          return e.message ??
              "Erro de autenticação.";

      }


    }



    return "Erro inesperado.";

  }







  @override
  void dispose(){


    _authSub?.cancel();


    _usuarioSub?.cancel();


    super.dispose();


  }


}