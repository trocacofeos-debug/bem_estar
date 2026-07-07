import 'package:cloud_firestore/cloud_firestore.dart';


enum TipoUsuario {
  aluno,
  admin,
  superadmin,
}



class UsuarioModel {


  final String id;

  final String nome;

  final String email;

  final String? telefone;

  final TipoUsuario role;

  final String status;

  final String? fotoUrl;

  final DateTime? criadoEm;





  UsuarioModel({

    required this.id,

    required this.nome,

    required this.email,

    this.telefone,

    this.role = TipoUsuario.aluno,

    this.status = "ATIVO",

    this.fotoUrl,

    this.criadoEm,

  });






  // =====================================================
  // PERMISSÕES
  // =====================================================


  bool get isAluno =>
      role == TipoUsuario.aluno;



  bool get isAdmin =>
      role == TipoUsuario.admin;



  bool get isSuperAdmin =>
      role == TipoUsuario.superadmin;





  bool get isAtivo =>
      status.toUpperCase().trim() == "ATIVO";





  bool get isInativo =>
      status.toUpperCase().trim() == "INATIVO";









  // =====================================================
  // FIRESTORE -> MODEL
  // =====================================================


  factory UsuarioModel.fromFirestore(
      DocumentSnapshot doc) {


    final data =
        doc.data();



    final map =
        data is Map<String,dynamic>
            ? data
            : <String,dynamic>{};





    return UsuarioModel(


      id:
          doc.id,



      nome:
          map["nome"]?.toString() ?? "",



      email:
          map["email"]?.toString() ?? "",



      telefone:
          map["telefone"]?.toString(),



      role:
          _roleFromString(
              map["role"]),




      status:
          _statusFromString(
              map["status"]),




      fotoUrl:
          map["fotoUrl"]?.toString(),




      criadoEm:

          map["criadoEm"] is Timestamp

              ? (map["criadoEm"] as Timestamp)
                  .toDate()

              : null,


    );


  }









  // =====================================================
  // MAP -> MODEL
  // =====================================================


  factory UsuarioModel.fromMap(
      String id,
      Map<String,dynamic> data) {


    return UsuarioModel(


      id:
          id,



      nome:
          data["nome"]?.toString() ?? "",



      email:
          data["email"]?.toString() ?? "",



      telefone:
          data["telefone"]?.toString(),



      role:
          _roleFromString(
              data["role"]),



      status:
          _statusFromString(
              data["status"]),



      fotoUrl:
          data["fotoUrl"]?.toString(),



      criadoEm:

          data["criadoEm"] is Timestamp

              ? (data["criadoEm"] as Timestamp)
                  .toDate()

              : null,


    );


  }









  // =====================================================
  // MODEL -> FIRESTORE
  // =====================================================


  Map<String,dynamic> toMap(){


    return {


      "nome":
          nome,


      "email":
          email,


      "telefone":
          telefone,


      "role":
          _roleToString(role),



      "status":
          status.toUpperCase(),



      "fotoUrl":
          fotoUrl,



      "criadoEm":
          criadoEm ??
          FieldValue.serverTimestamp(),


    };


  }









  // =====================================================
  // COPY WITH
  // =====================================================


  UsuarioModel copyWith({


    String? nome,


    String? email,


    String? telefone,


    TipoUsuario? role,


    String? status,


    String? fotoUrl,


    DateTime? criadoEm,


  }) {


    return UsuarioModel(


      id:
          id,


      nome:
          nome ?? this.nome,


      email:
          email ?? this.email,


      telefone:
          telefone ?? this.telefone,


      role:
          role ?? this.role,


      status:
          status ?? this.status,


      fotoUrl:
          fotoUrl ?? this.fotoUrl,


      criadoEm:
          criadoEm ?? this.criadoEm,


    );


  }









  // =====================================================
  // STATUS
  // =====================================================


  static String _statusFromString(
      dynamic value){


    final status =
        value
            ?.toString()
            .toUpperCase()
            .trim();



    if(status == "INATIVO"){

      return "INATIVO";

    }



    return "ATIVO";


  }









  // =====================================================
  // ROLE FIRESTORE -> ENUM
  // =====================================================


  static TipoUsuario _roleFromString(
      dynamic value){


    final role =
        value
            ?.toString()
            .toLowerCase()
            .trim();



    switch(role){


      case "superadmin":

        return TipoUsuario.superadmin;



      case "admin":

        return TipoUsuario.admin;



      default:

        return TipoUsuario.aluno;


    }


  }









  // =====================================================
  // ROLE ENUM -> FIRESTORE
  // =====================================================


  static String _roleToString(
      TipoUsuario role){


    switch(role){


      case TipoUsuario.superadmin:

        return "superadmin";



      case TipoUsuario.admin:

        return "admin";



      case TipoUsuario.aluno:

        return "aluno";


    }


  }



}