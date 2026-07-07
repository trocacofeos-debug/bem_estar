// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../models/aula_model.dart';
import '../../services/aula_service.dart';
import 'formulario_aula_screen.dart';

class GerenciarAulasScreen extends StatefulWidget {
  const GerenciarAulasScreen({super.key});

  @override
  State<GerenciarAulasScreen> createState() =>
      _GerenciarAulasScreenState();
}

class _GerenciarAulasScreenState extends State<GerenciarAulasScreen> {
  final AulaService _service = AulaService();

  bool _gerando = false;
  bool _resetando = false;

  Future<void> _gerarAulas() async {
    setState(() => _gerando = true);

    try {
      await _service.gerarAulasDoDiaAtual();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aulas do dia geradas com sucesso!"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao gerar aulas: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _gerando = false);
    }
  }

  Future<void> _resetarAulas() async {
    setState(() => _resetando = true);

    try {
      final diaSemana = DateTime.now().weekday;

      await _service.resetarAulasDoDia(diaSemana);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ocupação das aulas resetada!"),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao resetar: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _resetando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        title: const Text("Gerenciar Aulas"),
        centerTitle: true,
        elevation: 0,
      ),

      // =====================================================
      // BOTÕES
      // =====================================================
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // ================= GERAR AULAS =================
          FloatingActionButton(
            heroTag: "gerar",
            backgroundColor: Colors.green,
            onPressed: _gerando ? null : _gerarAulas,
            child: _gerando
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.auto_fix_high),
          ),

          const SizedBox(height: 10),

          // ================= RESET =================
          FloatingActionButton(
            heroTag: "reset",
            backgroundColor: Colors.orange,
            onPressed: _resetando ? null : _resetarAulas,
            child: _resetando
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.restart_alt),
          ),

          const SizedBox(height: 10),

          // ================= ADICIONAR =================
          FloatingActionButton(
            heroTag: "add",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FormularioAulaScreen(),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),

      // =====================================================
      // LISTA
      // =====================================================
      body: StreamBuilder<List<AulaModel>>(
        stream: _service.streamTodasAulas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Erro: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final aulas = snapshot.data!;

          if (aulas.isEmpty) {
            return const Center(
              child: Text("Nenhuma aula cadastrada"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: aulas.length,
            itemBuilder: (context, index) {
              final aula = aulas[index];

              final vagasDisponiveis =
                  aula.vagasTotais - aula.vagasOcupadas;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),

                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: const Icon(
                      Icons.fitness_center,
                      color: Colors.blue,
                    ),
                  ),

                  title: Text(
                    aula.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "${aula.horarioInicio} - ${aula.horarioFim}\n"
                      "Vagas disponíveis: $vagasDisponiveis",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: aula.ativa
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          aula.ativa ? "Ativa" : "Inativa",
                          style: TextStyle(
                            fontSize: 12,
                            color: aula.ativa
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  FormularioAulaScreen(aula: aula),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: Icon(
                          aula.ativa
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () async {
                          await _service.ativarDesativarAula(
                            aula.id,
                            !aula.ativa,
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          await _service.excluirAula(aula.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}