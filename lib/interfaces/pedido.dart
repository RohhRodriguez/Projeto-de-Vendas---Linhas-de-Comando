import 'package:dart_application_free/interfaces/atendente.dart';
import 'package:dart_application_free/interfaces/produto.dart';
import 'cliente.dart';

class Pedido {
  String id;
  Cliente cliente;
  Atendente atendente;
  List<Produto> produtos = [];
  List<int> quantidades = [];
  Pedido({
    required this.id,
    required this.cliente,
    required this.atendente,
    required this.produtos,
    required this.quantidades,
  });
}
