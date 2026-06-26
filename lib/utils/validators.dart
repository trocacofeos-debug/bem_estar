/// Validadores reutilizáveis para campos de formulário (login, cadastro,
/// criação de aulas no painel admin).
class Validators {
  Validators._();

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');

  static final RegExp _horarioRegex =
      RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu e-mail.';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'E-mail inválido.';
    }
    return null;
  }

  static String? senha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Informe sua senha.';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }
    return null;
  }

  static String? confirmarSenha(String? value, String senhaOriginal) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha.';
    }
    if (value != senhaOriginal) {
      return 'As senhas não coincidem.';
    }
    return null;
  }

  static String? nome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome.';
    }
    if (value.trim().length < 2) {
      return 'Nome muito curto.';
    }
    return null;
  }

  static String? obrigatorio(String? value, {String campo = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$campo é obrigatório.';
    }
    return null;
  }

  /// Valida horário no formato "HH:mm".
  static String? horario(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o horário.';
    }
    if (!_horarioRegex.hasMatch(value.trim())) {
      return 'Use o formato HH:mm.';
    }
    return null;
  }

  /// Valida número de vagas (inteiro positivo).
  static String? vagas(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe o número de vagas.';
    }
    final numero = int.tryParse(value.trim());
    if (numero == null || numero <= 0) {
      return 'Informe um número válido maior que zero.';
    }
    return null;
  }

  /// Garante que o horário de fim seja após o horário de início.
  static String? horarioFimDepoisDoInicio(String? inicio, String? fim) {
    if (inicio == null || fim == null) return null;
    final regexCheck = horario(fim);
    if (regexCheck != null) return regexCheck;

    final partesInicio = inicio.split(':');
    final partesFim = fim.split(':');
    final minutosInicio =
        int.parse(partesInicio[0]) * 60 + int.parse(partesInicio[1]);
    final minutosFim = int.parse(partesFim[0]) * 60 + int.parse(partesFim[1]);

    if (minutosFim <= minutosInicio) {
      return 'O horário de fim deve ser após o início.';
    }
    return null;
  }
}