import 'package:dart_application_free/interfaces/pessoa.dart';

class Cliente extends Pessoa {
  String endereco;
  Cliente({
    required this.endereco,
    required super.id,
    required super.nome,
  });
}
