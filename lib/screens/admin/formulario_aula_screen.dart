import 'package:flutter/material.dart';
import '../../models/aula_model.dart';
import '../../services/aula_service.dart';

class FormularioAulaScreen extends StatefulWidget {
  final AulaModel? aula;

  const FormularioAulaScreen({super.key, this.aula});

  bool get isEdicao => aula != null;

  @override
  State<FormularioAulaScreen> createState() =>
      _FormularioAulaScreenState();
}

class _FormularioAulaScreenState extends State<FormularioAulaScreen> {
  final _formKey = GlobalKey<FormState>();
  final AulaService _service = AulaService();

  final TextEditingController _nome = TextEditingController();
  final TextEditingController _inicio = TextEditingController();
  final TextEditingController _fim = TextEditingController();
  final TextEditingController _vagas = TextEditingController();
  final TextEditingController _instrutor = TextEditingController();

  int _diaSemana = 1;
  bool _salvando = false;

  @override
  void initState() {
    super.initState();

    final aula = widget.aula;

    if (aula != null) {
      _nome.text = aula.nome;
      _inicio.text = aula.horarioInicio;
      _fim.text = aula.horarioFim;
      _vagas.text = aula.vagasTotais.toString();
      _instrutor.text = aula.instrutorNome;
      _diaSemana = aula.diaSemana;
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _inicio.dispose();
    _fim.dispose();
    _vagas.dispose();
    _instrutor.dispose();
    super.dispose();
  }

  InputDecoration _dec(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blueGrey),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blue, width: 1.5),
      ),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final aula = AulaModel(
        id: widget.aula?.id ?? '',
        nome: _nome.text.trim(),
        descricao: widget.aula?.descricao ?? "",
        diaSemana: _diaSemana,
        horarioInicio: _inicio.text.trim(),
        horarioFim: _fim.text.trim(),
        vagasTotais: int.parse(_vagas.text),
        vagasOcupadas: widget.aula?.vagasOcupadas ?? 0,
        instrutorId: widget.aula?.instrutorId ?? "",
        instrutorNome: _instrutor.text.trim(),
        cor: widget.aula?.cor ?? "0F6E56",
        ativa: widget.aula?.ativa ?? true,
      );

      if (widget.isEdicao) {
        await _service.atualizarAula(aula);
      } else {
        await _service.criarAula(aula);
      }

      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          widget.isEdicao ? "Editar Aula" : "Nova Aula",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              _cardSection(
                title: "Informações da Aula",
                icon: Icons.fitness_center,
                children: [
                  TextFormField(
                    controller: _nome,
                    decoration: _dec("Nome da aula", Icons.sports_gymnastics),
                    validator: (v) =>
                        v == null || v.isEmpty ? "Obrigatório" : null,
                  ),

                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _instrutor,
                    decoration: _dec("Instrutor", Icons.person),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _cardSection(
                title: "Horário",
                icon: Icons.schedule,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _inicio,
                          decoration: _dec("Início", Icons.access_time),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _fim,
                          decoration:
                              _dec("Fim", Icons.access_time_filled),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _cardSection(
                title: "Capacidade",
                icon: Icons.chair,
                children: [
                  TextFormField(
                    controller: _vagas,
                    keyboardType: TextInputType.number,
                    decoration: _dec("Vagas totais", Icons.people),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _cardSection(
                title: "Dia da semana",
                icon: Icons.calendar_month,
                children: [
                  DropdownButtonFormField<int>(
                    // ignore: deprecated_member_use
                    value: _diaSemana,
                    decoration: _dec("Selecionar dia", Icons.today),
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Segunda")),
                      DropdownMenuItem(value: 2, child: Text("Terça")),
                      DropdownMenuItem(value: 3, child: Text("Quarta")),
                      DropdownMenuItem(value: 4, child: Text("Quinta")),
                      DropdownMenuItem(value: 5, child: Text("Sexta")),
                      DropdownMenuItem(value: 6, child: Text("Sábado")),
                      DropdownMenuItem(value: 7, child: Text("Domingo")),
                    ],
                    onChanged: (v) => setState(() => _diaSemana = v!),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _salvando ? null : _salvar,
                  child: _salvando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.isEdicao ? "Salvar alterações" : "Criar aula",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}