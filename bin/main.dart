import 'dart:core';
import 'dart:io';
import 'package:dart_application_free/enums.dart';
import 'package:dart_application_free/interfaces/atendente.dart';
import 'package:dart_application_free/mocks.dart';
import 'package:uuid/uuid.dart';
import 'package:dart_application_free/interfaces/cliente.dart';
import 'package:dart_application_free/interfaces/estoque.dart';
import 'package:dart_application_free/interfaces/pedido.dart';
import 'package:dart_application_free/interfaces/produto.dart';

var uuid = Uuid();
void main() {
  App app = App();
  app.menu();
}

class App {
  List<Produto> produtos = [];
  List<Estoque> estoques = [];
  List<Atendente> atendentes = [];
  List<Cliente> clientes = [];
  List<Pedido> pedidos = [];
  Mock mock = Mock();

  App() {
    produtos.addAll(mock.produtos);
    estoques.addAll(mock.estoques);
    clientes.addAll(mock.clientes);
    atendentes.addAll(mock.atendentes);
    pedidos.addAll(mock.pedidos);
  }

  void menu() {
    perguntar(Perguntar.menuPrincipal);
    switch (stdin.readLineSync()!) {
      case '1':
        perguntar(Perguntar.opcoesProduto);
        switch (stdin.readLineSync()!) {
          case '1':
            perguntar(Perguntar.addProduto);
            break;
          case '2':
            addCliente();
            menu();
            break;
          case '3':
            addAtendente();
            menu();
            break;
          default:
            menu();
        }
        break;
      case '2':
        addPedido();
        menu();
        break;
      case '3':
        perguntar(Perguntar.opcoesRelatorio);
        var relatorio = stdin.readLineSync()!;
        switch (relatorio) {
          case '1':
            relatorioVendas();
            break;
          case '2':
            relatorioComissoes();
            break;
          case '3':
            relatorioEstoque();
            break;
          case '4':
            relatorioEntregas();
            break;
          case '5':
            gerarTicketEntrega();
            break;
          default:
            menu();
        }
        break;

      case '5':
        exitCode;
        break;
      default:
        menu();
        break;
    }
  }

///////// ADICIONAR PRODUTOS ////////////
  void addProdutos() {
    try {
      print('nome do Produto:');
      String nome = stdin.readLineSync()!.toString();
      print('valor do Produto:');
      double valor = double.parse(stdin.readLineSync()!);
      print('quantidade do Produto:');
      int quantidade = int.parse(stdin.readLineSync()!);
      produtos.add(Produto(id: uuid.v4(), nome: nome, valor: valor));
      estoques.add(Estoque(produto: Produto(id: uuid.v4(), nome: nome, valor: valor), quantidade: quantidade));
      perguntar(Perguntar.addProduto);
    } catch (e) {
      print('Valor digitado é inválido!\n');
    }
  }

///////// ADICIONAR CLIENTE /////////////
  void addCliente() {
    try {
      print('nome do Cliente:');
      String nomeCliente = stdin.readLineSync()!.toString();
      print('endereço do Cliente:');
      String enderecoCliente = stdin.readLineSync()!.toString();
      clientes.add(Cliente(nome: nomeCliente, id: uuid.v4(), endereco: enderecoCliente));
    } catch (e) {
      msgErro(MsgErro.valorInvalido);
    }
  }

///////// ADICIONAR ATENDENTE /////////////
  void addAtendente() {
    try {
      print('nome do Atendente:');
      String nomeAtendente = stdin.readLineSync()!.toString();
      print('Percentual de comissão(%):');
      double percentualComissao = double.parse(stdin.readLineSync()!);
      atendentes.add(Atendente(comissao: percentualComissao, id: uuid.v4(), nome: nomeAtendente));
    } catch (e) {
      print(' Valor digitado é inválido\n!');
      menu();
    }
  }

///////// ADICIONAR PEDIDO /////////////
  void addPedido() {
    if (clientes.isEmpty) {
      addCliente();
    }
    if (atendentes.isEmpty) {
      addAtendente();
    }
    try {
      printRelatorio(Relatorio.relatorioClientes);
      Cliente clienteSelecionado = clientes[int.parse(stdin.readLineSync()!)];
      print('Cliente Selecionado: ${clienteSelecionado.nome}');
      print('Selecione o atendente:');
      printRelatorio(Relatorio.relatorioAtendentes);
      Atendente atendenteSelecionado = atendentes[int.parse(stdin.readLineSync()!)];
      print('Atendente Selecionado: ${atendenteSelecionado.nome}');
      List<Produto> produtosSelecionados = [];
      List<int> quantidadeProduto = [];
      var addProdutoPedido = '1';
      while (addProdutoPedido == '1') {
        print('Adicione um produto:');
        printRelatorio(Relatorio.relatorioProdutos);
        Produto produtoSelecionado = produtos[int.parse(stdin.readLineSync()!)];
        produtosSelecionados.add(produtoSelecionado);
        print('informe a quantidade desejada');
        int quantidade = int.parse(stdin.readLineSync()!);
        var estoqueEcontrado = estoques.firstWhere((element) => element.produto.nome == produtoSelecionado.nome);
        if (estoqueEcontrado.quantidade >= quantidade) {
          estoqueEcontrado.vender(quantidade);
          quantidadeProduto.add(quantidade);
          print('Deseja adicionar mais um produto?:\n1 - Sim\n2 - Não');
          addProdutoPedido = stdin.readLineSync()!;
        } else {
          print(
              'Quantidade desejada supera quantidade de produtos em estoque => quantidade disponível: ${estoqueEcontrado.quantidade}\n');
        }
      }
      pedidos.add(Pedido(
          id: uuid.v4(),
          cliente: clienteSelecionado,
          produtos: produtosSelecionados,
          quantidades: quantidadeProduto,
          atendente: atendenteSelecionado));
      print('Pedido adicionado com sucesso!\n');
      perguntar(Perguntar.imprimirTicket);
    } catch (e) {
      print('Operação cancelada. Valor digitado é inválido!\n');
      addPedido();
    }
  }

//////// ESTOCAR /////////////
  void estocar() {
    printRelatorio(Relatorio.relatorioEstoques);
    print('Selecione o produto ao qual deseja estocar novas unidades:');
    try {
      int opcaoSelecionada = int.parse(stdin.readLineSync()!);
      print('Informe a quantidade que deseja estocar deste produto:');
      int quantidade = int.parse(stdin.readLineSync()!);
      Estoque estoquesSelecionado = estoques[opcaoSelecionada];
      estoquesSelecionado.estocar(quantidade);
      perguntar(Perguntar.estocar);
    } catch (e) {
      msgErro(MsgErro.valorInvalido);
    }
  }

///////// RELATÓRIOS /////////////
  void relatorioEstoque() {
    formatarRelatorio(Formatacao.titulo, '-', 'RELATÓRIO DE ESTOQUES');
    var totalEstoques = 0.0;
    for (var element in estoques) {
      print(
          '${element.produto.nome} - valor: R\$ ${element.produto.valor} -  qtde: ${element.quantidade} - valor total: R\$ ${element.produto.valor * element.quantidade} - id: ${element.produto.id}');
      totalEstoques += element.produto.valor * element.quantidade;
    }
    formatarRelatorio(Formatacao.separacao, '-', null);
    print('Valor total: R\$ $totalEstoques');
    formatarRelatorio(Formatacao.separacao, '-', null);
    menu();
  }

//////////////////////////////////
  void relatorioVendas() {
    formatarRelatorio(Formatacao.titulo, '-', 'RELATÓRIO DE VENDAS');
    if (pedidos.isEmpty) {
      msgErro(MsgErro.nenhumaVenda);
      return;
    }
    var index = 0;
    var total = 0.0;
    var totalGeral = 0.0;
    for (var element in pedidos) {
      print('cliente: ${element.cliente.nome}\natendente: ${element.atendente.nome}\npedido nº.: ${element.id}');
      var listaProdutos = element.produtos;
      for (var produto in listaProdutos) {
        print(
            'Produtos: ${produto.nome} - qtde: ${element.quantidades[index]} - valor: R\$ ${produto.valor} - total: R\$ ${element.quantidades[index] * produto.valor}');
        var totalProdutos = element.quantidades[index] * produto.valor;
        total += totalProdutos;
        index++;
      }
      print('total de vendas: R\$ $total\n');
      totalGeral += total;
      total = 0;
      index = 0;
    }
    formatarRelatorio(Formatacao.separacao, '-', null);
    print('total de vendas: R\$ $totalGeral');
    formatarRelatorio(Formatacao.separacao, '-', null);
    menu();
  }

//////////////////////////////////////
  void relatorioComissoes() {
    formatarRelatorio(Formatacao.titulo, '-', 'RELATÓRIO DE COMISSÕES');
    var count = 0;
    var totalComissoesGeral = 0.0;
    var totalVendasGeral = 0.0;
    if (pedidos.isEmpty) {
      msgErro(MsgErro.nenhumaVenda);
      return;
    }
    for (var atendente in atendentes) {
      var atendenteSelecionado = atendentes[count];
      print('Atendente: ${atendente.nome} - id: ${atendente.id}\n');
      var index = 0;
      var totalVendasAtendente = 0.0;
      var totalComissoesAtendente = 0.0;
      for (var element in pedidos) {
        if (element.atendente != atendenteSelecionado) {
          continue;
        }
        print('Pedido nº: ${element.id}');
        for (var produto in element.produtos) {
          var unidades = element.quantidades[index];
          print(
              'produto: ${produto.nome} - preço: R\$ ${produto.valor} - qtde: $unidades - valor total: R\$ ${unidades * produto.valor} - %comissão: ${element.atendente.comissao}% - comissão: R\$ ${unidades * produto.valor * element.atendente.comissao / 100}');
          index++;
          var v = unidades * produto.valor;
          var c = unidades * produto.valor * element.atendente.comissao / 100;
          totalVendasAtendente += v;
          totalComissoesAtendente += c;
        }
        index = 0;
        count = 0;
      }
      print('\nTotal vendas: R\$ $totalVendasAtendente - Total comissão: R\$ $totalComissoesAtendente\n');
      formatarRelatorio(Formatacao.separacao, '.', null);
      count++;
      totalComissoesGeral += totalComissoesAtendente;
      totalVendasGeral += totalVendasAtendente;
    }
    count = 0;
    print(
        'Total de pedidos: ${pedidos.length}\nTotal de vendas: R\$ $totalVendasGeral\nTotal de Comissões: R\$ $totalComissoesGeral');
    formatarRelatorio(Formatacao.separacao, '-', null);
    menu();
  }

////////////////////////////////////////
  void gerarTicketEntrega() {
    pedidos.isEmpty
        ? msgErro(MsgErro.nenhumaVenda)
        : print('Informe para qual pedido deseja gerar o ticket para entrega:');
    for (var element in pedidos) {
      print('${pedidos.indexOf(element)} => id do pedido: ${element.id} - nome do cliente: ${element.cliente.nome}');
    }
    try {
      ticketEntrega(pedidos[int.parse(stdin.readLineSync()!)]);
    } catch (e) {
      print('Valor digitado é inválido!');
      gerarTicketEntrega();
    }
  }

  void ticketEntrega(Pedido pedido) {
    formatarRelatorio(Formatacao.titulo, '-', 'INFORMAÇÕES DE ENTREGA');
    var index = 0;
    var totalPedido = 0.0;
    print('id do cliente: ${pedido.cliente.id}');
    for (var element in pedido.produtos) {
      var unidades = pedido.quantidades[index];
      print(
          'Produto: ${element.nome} - qtde: $unidades - valor: R\$ ${element.valor} - total: R\$ ${unidades * element.valor}');
      index++;
      var v = unidades * element.valor;
      totalPedido += v;
    }
    print(
        'total do pedido: R\$ $totalPedido\n\nNOME DO CLIENTE: ${pedido.cliente.nome.toUpperCase()}\nENDEREÇO DE ENTREGA: ${pedido.cliente.endereco.toUpperCase()}\n\nTicket nº.: ${pedidos.last.id}');
    formatarRelatorio(Formatacao.separacao, '-', null);
    index = 0;
    menu();
  }

////////////////////////////////////
  void relatorioEntregas() {
    formatarRelatorio(Formatacao.titulo, '-', 'RELATÓRIO DE ENTREGAS');
    var count = 0;
    var totalVendasGeral = 0.0;
    if (pedidos.isEmpty) {
      msgErro(MsgErro.nenhumaVenda);
      return;
    }
    for (var cliente in clientes) {
      var clienteSelecionado = clientes[count];
      print('Cliente: ${cliente.nome}\nid do cliente: ${cliente.id}');
      var index = 0;
      var totalCliente = 0.0;
      var qtde = 0;
      Map<Produto, int> mapPedido = {};
      for (var pedido in pedidos) {
        if (pedido.cliente != clienteSelecionado) {
          continue;
        }
        for (var produto in pedido.produtos) {
          var unidades = pedido.quantidades[index];
          index++;
          var v = unidades * produto.valor;
          totalCliente += v;
          mapPedido.isEmpty
              ? mapPedido.addAll({produto: unidades})
              : mapPedido.containsKey(produto)
                  ? mapPedido.update(produto, (value) => value += unidades)
                  : mapPedido.addAll({produto: unidades});
        }
        index = 0;
        qtde++;
      }
      mapPedido.forEach((key, value) {
        print(
            'produto: ${key.nome} - quantidade: $value - valor unidade: R\$ ${key.valor} - valor total: R\$ ${key.valor * value}');
      });
      print(
          '\nTotal de pedidos: $qtde\nTotal Comprado: R\$ $totalCliente\nEndereço de entrega: ${clienteSelecionado.endereco}\n');
      formatarRelatorio(Formatacao.separacao, '.', null);
      count++;
      totalVendasGeral += totalCliente;
    }
    count = 0;
    print('Total de pedidos: ${pedidos.length}\nTotal de vendas: R\$ $totalVendasGeral');
    formatarRelatorio(Formatacao.separacao, '-', null);
    menu();
  }

////////////////////////////////////////////////////////////////////////////////
  void printRelatorio(Relatorio nomeRelatorio) {
    switch (nomeRelatorio) {
      case Relatorio.relatorioClientes:
        print('Selecione o cliente desejado');
        for (var element in clientes) {
          print('${clientes.indexOf(element)} => ${element.nome}');
        }
        break;
      case Relatorio.relatorioProdutos:
        if (produtos.isEmpty) {
          for (var element in produtos) {
            print('${produtos.indexOf(element)} => ${element.nome} - R\$ ${element.valor}');
          }
        } else {
          addProdutos();
        }
        break;
      case Relatorio.relatorioAtendentes:
        for (var element in atendentes) {
          print('${atendentes.indexOf(element)} => ${element.nome} - comissão: ${element.comissao}%');
        }
        break;
      case Relatorio.relatorioEstoques:
        print('Relatório de produtos em estoque:');
        for (var element in estoques) {
          print(
              '${estoques.indexOf(element)} => ${element.produto.nome} - valor unitário: R\$ ${element.produto.valor} -  qtde: ${element.quantidade} - valor total: R\$ ${element.produto.valor * element.quantidade} - id: ${element.produto.id}');
        }
        break;
    }
  }

  void formatarRelatorio(Formatacao tipo, String caractere, String? msg) {
    switch (tipo) {
      case Formatacao.separacao:
        print(caractere * 120);
        break;
      case Formatacao.titulo:
        print('${caractere * 120}\n$msg\n${caractere * 120}');
        break;
    }
  }

  void msgErro(MsgErro tipo) {
    switch (tipo) {
      case MsgErro.nenhumaVenda:
        print('Nenhuma venda foi registrada!\n');
        menu();
        break;
      case MsgErro.valorInvalido:
        print('Valor digitado é inválido!\n');
        menu();
        break;
    }
  }

  //substituir por um switch case
  void perguntar(Perguntar nomeMetodo) {
    if (nomeMetodo == Perguntar.addProduto) {
      print(
          'Selecione a opção desejada:\n1 - Cadastrar novo produto\n2 - Estocar unidades de produto já cadastrado\n3 - Voltar');
      switch (stdin.readLineSync()!) {
        case '1':
          addProdutos();
          break;
        case '2':
          estocar();
          break;
        case '3':
          menu();
          break;
        default:
          perguntar(Perguntar.addProduto);
      }
    } else if (nomeMetodo == Perguntar.estocar) {
      print('Deseja estocar mais algum produto?\n1 - Sim\n2 - Não');
      stdin.readLineSync()! == '1' ? estocar() : menu();
    } else if (nomeMetodo == Perguntar.addPedido) {
      print('Deseja adicionar um novo pedido?\n1 - Sim\n2 - Não');
      stdin.readLineSync()! == '1' ? addPedido() : menu();
    } else if (nomeMetodo == Perguntar.imprimirTicket) {
      print('Deseja imprimir o ticket para entrega?\n1 - Sim\n2 - Não');
      stdin.readLineSync()! == '1' ? ticketEntrega(pedidos.last) : perguntar(Perguntar.addPedido);
    } else if (nomeMetodo == Perguntar.menuPrincipal) {
      print(
          'Selecione a operação desejada conforme menu abaixo:\n1 - Cadastrar\n2 - Adicionar Pedido\n3 - Relatórios\n4 - Voltar\n5 - Encerrar');
    } else if (nomeMetodo == Perguntar.opcoesProduto) {
      print(
          'Deseja efetuar um novo cadastro?\n1 - Adicionar Produto\n2 - Adicionar Cliente\n3 - Adicionar Atendente\n4 - Voltar');
    } else if (nomeMetodo == Perguntar.opcoesRelatorio) {
      print(
          'Selecione o relatório desejado:\n1 - Relatório de Vendas\n2 - Relatório de Comissões\n3 - Relatório de Estoque\n4 - Relatório de Entregas\n5 - Imprimir ticket de entrega\n6 - Voltar');
    } else {
      null;
    }
  }
}
