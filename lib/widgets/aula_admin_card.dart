import 'package:flutter/material.dart';
import '../models/aula_model.dart';

class AulaAdminCard extends StatelessWidget {
  final AulaModel aula;
  final VoidCallback onEditar;
  final VoidCallback onAtivarDesativar;
  final VoidCallback onExcluir;

  const AulaAdminCard({
    super.key,
    required this.aula,
    required this.onEditar,
    required this.onAtivarDesativar,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: aula.ativa
              // ignore: deprecated_member_use
              ? Colors.green.withOpacity(0.15)
              // ignore: deprecated_member_use
              : Colors.red.withOpacity(0.10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    aula.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: aula.ativa
                        // ignore: deprecated_member_use
                        ? Colors.green.withOpacity(0.15)
                        // ignore: deprecated_member_use
                        : Colors.red.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    aula.ativa ? 'Ativa' : 'Inativa',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: aula.ativa ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text('${aula.horarioInicio} - ${aula.horarioFim}'),
            const SizedBox(height: 6),
            Text('Instrutor: ${aula.instrutorNome}'),

            const Divider(height: 20),

            /// AÇÕES
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: onEditar,
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar'),
                ),
                TextButton.icon(
                  onPressed: onAtivarDesativar,
                  icon: Icon(
                    aula.ativa
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  label: Text(
                    aula.ativa ? 'Desativar' : 'Ativar',
                  ),
                ),
                IconButton(
                  onPressed: onExcluir,
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}