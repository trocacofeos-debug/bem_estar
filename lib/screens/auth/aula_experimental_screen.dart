// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AulaExperimentalScreen extends StatefulWidget {
  const AulaExperimentalScreen({super.key});

  @override
  State<AulaExperimentalScreen> createState() =>
      _AulaExperimentalScreenState();
}

class _AulaExperimentalScreenState extends State<AulaExperimentalScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _loading = false;

  String? _aulaId;
  String? _horarioInicio;
  String? _horarioFim;

  final CollectionReference _aulasRef =
      FirebaseFirestore.instance.collection('aulas');

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;

    if (_aulaId == null || _horarioInicio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Selecione um horário.")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance
          .collection('aulas_experimentais')
          .add({
        'tipo': 'experimental',
        'uid': user?.uid ?? 'anonimo',
        'nome': _nomeController.text.trim(),
        'telefone': _telefoneController.text.trim(),
        'email': _emailController.text.trim(),
        'aulaId': _aulaId,
        'horarioInicio': _horarioInicio,
        'horarioFim': _horarioFim,
        'status': 'pendente',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Agendado"),
          content: const Text(
            "Sua aula experimental foi enviada com sucesso.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Erro: $e"),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF2F3F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text("Aula Experimental"),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [

              const Icon(
                Icons.card_giftcard,
                size: 50,
                color: Colors.green,
              ),

              const SizedBox(height: 10),

              const Text(
                "Escolha seu horário experimental",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Aulas com 5 vagas disponíveis",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                      TextFormField(
                        controller: _nomeController,
                        decoration: _input("Nome", Icons.person),
                        validator: (v) =>
                            v == null || v.isEmpty
                                ? "Informe o nome"
                                : null,
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _telefoneController,
                        decoration: _input("Telefone", Icons.phone),
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _emailController,
                        decoration: _input("E-mail", Icons.email),
                      ),

                      const SizedBox(height: 20),

                      // ================= HORÁRIOS =================
                      StreamBuilder<QuerySnapshot>(
                        stream: _aulasRef.snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }

                          final aulas = snapshot.data!.docs;

                          return DropdownButtonFormField<String>(
                            decoration: _input(
                              "Escolha o horário",
                              Icons.schedule,
                            ),

                            value: _aulaId,

                            items: aulas.map((doc) {
                              final data =
                                  doc.data() as Map<String, dynamic>;

                              final inicio =
                                  data['horarioInicio'] ?? '--';
                              final fim =
                                  data['horarioFim'] ?? '--';

                              // 🔥 FIXO: 5 vagas
                              final int ocupadas =
                                  (data['vagasOcupadas'] ?? 0);

                              const int total = 5;
                              final disponiveis = total - ocupadas;

                              final lotado = disponiveis <= 0;

                              return DropdownMenuItem(
                                value: doc.id,
                                enabled: !lotado,
                                child: Text(
                                  "$inicio - $fim ($disponiveis vagas)"
                                  "${lotado ? " 🔴 Lotado" : ""}",
                                  style: TextStyle(
                                    color: lotado
                                        ? Colors.red
                                        : Colors.black,
                                  ),
                                ),
                              );
                            }).toList(),

                            onChanged: (value) {
                              if (value == null) return;

                              final doc = aulas.firstWhere(
                                (e) => e.id == value,
                                orElse: () => aulas.first,
                              );

                              final data =
                                  doc.data() as Map<String, dynamic>;

                              setState(() {
                                _aulaId = value;
                                _horarioInicio =
                                    data['horarioInicio'];
                                _horarioFim = data['horarioFim'];
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _send,
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Agendar experimental"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}