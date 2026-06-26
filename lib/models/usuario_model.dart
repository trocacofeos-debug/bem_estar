import 'package:cloud_firestore/cloud_firestore.dart';

enum TipoUsuario { aluno, admin }

class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final TipoUsuario role;
  final String? fotoUrl;
  final DateTime? criadoEm;

  UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.role = TipoUsuario.aluno,
    this.fotoUrl,
    this.criadoEm,
  });

  bool get isAdmin => role == TipoUsuario.admin;

  // =========================
  // FIRESTORE -> MODEL
  // =========================
  factory UsuarioModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return UsuarioModel(
      id: doc.id,
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      telefone: data['telefone'],
      role: _roleFromString(data['role']),
      fotoUrl: data['fotoUrl'],
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate(),
    );
  }

  factory UsuarioModel.fromMap(String id, Map<String, dynamic> data) {
    return UsuarioModel(
      id: id,
      nome: data['nome'] ?? '',
      email: data['email'] ?? '',
      telefone: data['telefone'],
      role: _roleFromString(data['role']),
      fotoUrl: data['fotoUrl'],
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate(),
    );
  }

  // =========================
  // MODEL -> FIRESTORE
  // =========================
  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'role': _roleToString(role),
      'fotoUrl': fotoUrl,
      'criadoEm': criadoEm ?? FieldValue.serverTimestamp(),
    };
  }

  // =========================
  // COPY WITH
  // =========================
  UsuarioModel copyWith({
    String? nome,
    String? email,
    String? telefone,
    TipoUsuario? role,
    String? fotoUrl,
  }) {
    return UsuarioModel(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      role: role ?? this.role,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      criadoEm: criadoEm,
    );
  }

  // =========================
  // ROLE PARSER (FIREBASE -> ENUM)
  // =========================
  static TipoUsuario _roleFromString(dynamic value) {
    final v = value?.toString().toLowerCase();

    switch (v) {
      case 'admin':
        return TipoUsuario.admin;
      case 'aluno':
        return TipoUsuario.aluno;
      default:
        return TipoUsuario.aluno;
    }
  }

  // =========================
  // ROLE SERIALIZER (ENUM -> FIREBASE)
  // =========================
  static String _roleToString(TipoUsuario role) {
    switch (role) {
      case TipoUsuario.admin:
        return 'admin';
      case TipoUsuario.aluno:
        return 'aluno';
    }
  }
}