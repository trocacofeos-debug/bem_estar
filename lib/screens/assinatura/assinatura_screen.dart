import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AssinaturaScreen extends StatelessWidget {
  const AssinaturaScreen({super.key});

  Future<void> abrirLinkAsaas() async {
    final Uri url = Uri.parse(
      "https://www.asaas.com/c/wi0yfv0i6dwyz7du",
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> abrirWhatsApp() async {
    const numero = "552196468118"; // 55 + DDD + número
    const mensagem =
        "Olá! Preciso de ajuda com minha assinatura.";

    final Uri url = Uri.parse(
      "https://wa.me/$numero?text=${Uri.encodeComponent(mensagem)}",
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Assinatura"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_open_rounded,
                    size: 60,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Sua assinatura está disponível",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Clique abaixo para acessar o pagamento de forma segura.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: abrirLinkAsaas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        "Pagar Agora",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton.icon(
                    onPressed: abrirWhatsApp,
                    icon: const Icon(Icons.support_agent),
                    label: const Text("Precisa de ajuda?"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}