import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/usuario_model.dart';


class AuthService {


  final FirebaseAuth _auth =
      FirebaseAuth.instance;


  final FirebaseFirestore _db =
      FirebaseFirestore.instance;





  // =====================================================
  // AUTH STREAM
  // =====================================================

  Stream<User?> get authStateChanges =>
      _auth.authStateChanges();



  User? get currentUser =>
      _auth.currentUser;








  // =====================================================
  // LOGIN
  // =====================================================

  Future<UserCredential> login({

    required String email,

    required String senha,

  }) async {


    return await _auth.signInWithEmailAndPassword(

      email: email,

      password: senha,

    );


  }








  // =====================================================
  // CADASTRO
  // PADRÃO: ALUNO + ATIVO
  // =====================================================

  Future<void> cadastrar({

    required String nome,

    required String email,

    required String senha,

    String? telefone,

  }) async {



    final credential =
        await _auth.createUserWithEmailAndPassword(

      email: email,

      password: senha,

    );



    final uid =
        credential.user!.uid;





    final usuario =
        UsuarioModel(

      id: uid,

      nome: nome,

      email: email,

      telefone: telefone,

      role: TipoUsuario.aluno,

      criadoEm: DateTime.now(),

    );





    final dados =
        usuario.toMap();



    // garante status no cadastro

    dados['status'] =
        "ATIVO";





    await _db

        .collection('usuarios')

        .doc(uid)

        .set(dados);


  }









  // =====================================================
  // PEGAR USUÁRIO
  // =====================================================

  Future<UsuarioModel?> getUsuario(
      String uid) async {


    final doc =
        await _db

            .collection('usuarios')

            .doc(uid)

            .get();




    if(!doc.exists ||
        doc.data() == null){


      return null;


    }





    return UsuarioModel.fromFirestore(doc);


  }









  // =====================================================
  // STREAM USUÁRIO REALTIME
  // =====================================================

  Stream<UsuarioModel?> streamUsuario(
      String uid) {


    return _db

        .collection('usuarios')

        .doc(uid)

        .snapshots()

        .map((doc){



      if(!doc.exists ||
          doc.data() == null){


        return null;


      }





      return UsuarioModel.fromFirestore(doc);


    });


  }









  // =====================================================
  // RESET SENHA
  // =====================================================

  Future<void> enviarResetSenha(
      String email) async {


    await _auth.sendPasswordResetEmail(

      email: email,

    );


  }









  // =====================================================
  // LOGOUT
  // =====================================================

  Future<void> logout() async {


    await _auth.signOut();


  }









  // =====================================================
  // ATUALIZAR PERFIL
  // =====================================================

  Future<void> atualizarPerfil({

    required String uid,

    String? nome,

    String? telefone,

    String? fotoUrl,

  }) async {



    final dados =
        <String,dynamic>{};




    if(nome != null){

      dados['nome'] =
          nome;

    }




    if(telefone != null){

      dados['telefone'] =
          telefone;

    }




    if(fotoUrl != null){

      dados['fotoUrl'] =
          fotoUrl;

    }




    if(dados.isEmpty){

      return;

    }




    await _db

        .collection('usuarios')

        .doc(uid)

        .update(dados);


  }









  // =====================================================
  // ALTERAR ROLE
  // =====================================================

  Future<void> definirRole({

    required String uid,

    required TipoUsuario role,

  }) async {



    await _db

        .collection('usuarios')

        .doc(uid)

        .update({

      'role':
          role.name,

    });


  }









  // =====================================================
  // CRIAR SUPER ADMIN
  // =====================================================

  Future<void> criarSuperAdmin(
      String uid) async {



    await _db

        .collection('usuarios')

        .doc(uid)

        .update({

      'role':
          'superadmin',

      'status':
          'ATIVO',

    });


  }



}