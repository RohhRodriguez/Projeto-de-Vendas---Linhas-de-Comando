import 'package:uuid/uuid.dart';
import 'interfaces/atendente.dart';
import 'interfaces/cliente.dart';
import 'interfaces/estoque.dart';
import 'interfaces/pedido.dart';
import 'interfaces/produto.dart';

var uuid = Uuid();

class Mock {
  List<Produto> produtos = [];
  List<Estoque> estoques = [];
  List<Atendente> atendentes = [];
  List<Cliente> clientes = [];
  List<Pedido> pedidos = [];

  Mock() {
    produtos = [
      Produto(id: uuid.v4(), nome: 'Produto1', valor: 100),
      Produto(id: uuid.v4(), nome: 'Produto2', valor: 200),
      Produto(id: uuid.v4(), nome: 'Produto3', valor: 300),
      Produto(id: uuid.v4(), nome: 'Produto4', valor: 400)
    ];
    estoques = [
      Estoque(produto: produtos[0], quantidade: 100),
      Estoque(produto: produtos[1], quantidade: 200),
      Estoque(produto: produtos[2], quantidade: 300),
      Estoque(produto: produtos[3], quantidade: 400),
    ];
    atendentes = [
      Atendente(comissao: 10, id: uuid.v4(), nome: 'Mariana'),
      Atendente(comissao: 20, id: uuid.v4(), nome: 'Claudia'),
    ];
    clientes = [
      Cliente(id: uuid.v4(), nome: 'Julia', endereco: 'Rua A, 11'),
      Cliente(id: uuid.v4(), nome: 'Pedro', endereco: 'Rua B, 12')
    ];
    pedidos.add(Pedido(
        id: uuid.v4(),
        cliente: clientes[1],
        atendente: atendentes[0],
        produtos: [produtos[0], produtos[1]],
        quantidades: [30, 40]));
    pedidos.add(Pedido(
        id: uuid.v4(),
        cliente: clientes[1],
        atendente: atendentes[1],
        produtos: [produtos[2], produtos[3]],
        quantidades: [10, 20]));
    pedidos.add(Pedido(
        id: uuid.v4(),
        cliente: clientes[1],
        atendente: atendentes[0],
        produtos: [produtos[2], produtos[3]],
        quantidades: [14, 38]));
    pedidos.add(Pedido(
        id: uuid.v4(),
        cliente: clientes[1],
        atendente: atendentes[1],
        produtos: [produtos[2], produtos[3]],
        quantidades: [27, 36]));
    pedidos.add(Pedido(
        id: uuid.v4(),
        cliente: clientes[0],
        atendente: atendentes[1],
        produtos: [produtos[0], produtos[3]],
        quantidades: [18, 24]));
    pedidos.add(Pedido(
        id: uuid.v4(),
        cliente: clientes[0],
        atendente: atendentes[0],
        produtos: [produtos[2], produtos[3]],
        quantidades: [45, 32]));
  }
}
