import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RelatorioOcupacaoScreen extends StatelessWidget {
  const RelatorioOcupacaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Relatório de ocupação"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("aulas")
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Nenhuma aula cadastrada"),
            );
          }

          final docs = snapshot.data!.docs;

          final aulas = docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            final int total = (data['vagasTotais'] ?? 0) as int;
            final int ocupadas = (data['vagasOcupadas'] ?? 0) as int;

            final safeTotal = total <= 0 ? 1 : total;

            final disponiveis =
                (safeTotal - ocupadas).clamp(0, safeTotal);

            final ocupacao = ocupadas / safeTotal;

            final String hora = (
              data['horarioInicio'] ??
              data['hora'] ??
              data['horario'] ??
              data['inicio'] ??
              'Sem horário'
            ).toString();

            return {
              "hora": hora,
              "total": safeTotal,
              "ocupadas": ocupadas,
              "disponiveis": disponiveis,
              "ocupacao": ocupacao,
            };
          }).toList();

          // =====================================================
          // 🔥 ORDENAR POR HORÁRIO (CORREÇÃO PRINCIPAL)
          // =====================================================
          aulas.sort((a, b) {
            final h1 = a["hora"].toString();
            final h2 = b["hora"].toString();

            if (h1 == "Sem horário") return 1;
            if (h2 == "Sem horário") return -1;

            return h1.compareTo(h2);
          });

          final media = aulas.isEmpty
              ? 0.0
              : aulas
                      .map((e) => e["ocupacao"] as double)
                      .reduce((a, b) => a + b) /
                  aulas.length;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // =====================================================
              // RESUMO
              // =====================================================
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "${(media * 100).toStringAsFixed(0)}%",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const Text("Ocupação média"),
                          ],
                        ),
                      ),

                      Container(width: 1, height: 40, color: Colors.grey),

                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              "${aulas.length}",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text("Aulas ativas"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Ocupação por aula",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // =====================================================
              // LISTA
              // =====================================================
              ...aulas.map((aula) {
                final ocupacao = aula["ocupacao"] as double;
                final hora = aula["hora"].toString();
                final disponiveis = aula["disponiveis"];
                final ocupadas = aula["ocupadas"];
                final total = aula["total"];

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          hora,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text("Ocupadas: $ocupadas / $total"),
                        Text("Disponíveis: $disponiveis"),

                        const SizedBox(height: 10),

                        LinearProgressIndicator(
                          value: ocupacao.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ocupacao >= 1
                                ? Colors.red
                                : ocupacao >= 0.7
                                    ? Colors.orange
                                    : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}