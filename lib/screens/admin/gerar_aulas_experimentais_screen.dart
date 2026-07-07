import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/aula_experimental_service.dart';

class PainelExperimentalScreen extends StatefulWidget {
  const PainelExperimentalScreen({super.key});

  @override
  State<PainelExperimentalScreen> createState() =>
      _PainelExperimentalScreenState();
}

class _PainelExperimentalScreenState
    extends State<PainelExperimentalScreen> {
  final AulaExperimentalService _service = AulaExperimentalService();

  DateTime? _dataSelecionada;
  bool _loading = false;

  final List<String> _inicio = [
    "07:00","08:00","09:00","10:00","11:00",
    "14:00","15:00","16:00","17:00","18:00","19:00","20:00",
  ];

  final List<String> _fim = [
    "08:00","09:00","10:00","11:00","12:00",
    "15:00","16:00","17:00","18:00","19:00","20:00","21:00",
  ];

  Future<void> _gerar() async {
    if (_dataSelecionada == null) return;

    setState(() => _loading = true);

    try {
      await _service.gerarAulasAutomaticas(
        horariosInicio: _inicio,
        horariosFim: _fim,
        data: _dataSelecionada!,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Aulas geradas com sucesso"),
          backgroundColor: Colors.green,
        ),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _resetar() async {
    await _service.resetarAulas();

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Aulas removidas"),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _pickDate() async {
    final data = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      initialDate: DateTime.now(),
    );

    if (data != null) {
      setState(() => _dataSelecionada = data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Painel Experimental"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _resetar,
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),

      body: Column(
        children: [

          // ================= CONTROLES =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dataSelecionada == null
                              ? "Selecionar data"
                              : format.format(_dataSelecionada!),
                        ),
                        const Icon(Icons.calendar_today),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.auto_awesome),
                    label: _loading
                        ? const CircularProgressIndicator(
                            color: Colors.white)
                        : const Text("GERAR AULAS"),
                    onPressed: _loading ? null : _gerar,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // ================= AULAS GERADAS =================
          const Text(
            "AULAS GERADAS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: StreamBuilder(
              stream: _service.streamAulasGeradas(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data();

                    return ListTile(
                      leading: const Icon(Icons.fitness_center),
                      title: Text(
                        "${d['horarioInicio']} - ${d['horarioFim']}",
                      ),
                      subtitle: Text(
                        "Vagas: ${d['vagasOcupadas']}/5",
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const Divider(),

          // ================= AGENDAMENTOS =================
          const Text(
            "AGENDAMENTOS EXPERIMENTAIS",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: StreamBuilder(
              stream: _service.streamAgendamentosExperimentais(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final d = docs[i].data();

                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(d['nome'] ?? ''),
                      subtitle: Text(
                        "${d['horarioInicio']} - ${d['horarioFim']}",
                      ),
                      trailing: Text(d['status'] ?? ''),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}