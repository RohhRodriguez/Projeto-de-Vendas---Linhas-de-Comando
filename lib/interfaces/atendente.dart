import 'package:dart_application_free/interfaces/pessoa.dart';

class Atendente extends Pessoa {
  double comissao;
  Atendente({
    required this.comissao,
    required super.id,
    required super.nome,
  });
}
