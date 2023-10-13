import 'dart:io';

enum EOperacao { soma, subtracao, multiplicacao, divisao }

void main() {
  menu();
}

abstract class Operacao {
  double operando1;
  double operando2;
  Operacao({
    required this.operando1,
    required this.operando2,
  });

  double operar();
}

menu() {
  print('Informe o primeiro número:');
  double number1 = double.parse(stdin.readLineSync()!);
  print('Informe a operação desejada:\n1 - Soma\n2 - Subtracao\n3 - Multiplicacão\n4 - Divisão');
  String operador = stdin.readLineSync()!;
  print('Informe o segundo número:');
  double number2 = double.parse(stdin.readLineSync()!);

  late Operacao operacao;

  switch (operador) {
    case '1':
      operacao = Somar(operando1: number1, operando2: number2);
      break;
    case '2':
      operacao = Subtrair(operando1: number1, operando2: number2);
      break;
    case '3':
      operacao = Multiplicar(operando1: number1, operando2: number2);
      break;
    case '4':
      operacao = Dividir(operando1: number1, operando2: number2);
      break;
  }

  double result = operacao.operar();
  print('O resultado da operação é: $result');
  menu();
}

class Somar extends Operacao {
  Somar({required super.operando1, required super.operando2});

  @override
  double operar() {
    var result = operando1 + operando2;
    return result;
  }
}

class Subtrair extends Operacao {
  Subtrair({required super.operando1, required super.operando2});

  @override
  double operar() {
    var result = operando1 - operando2;
    return result;
  }
}

class Dividir extends Operacao {
  Dividir({required super.operando1, required super.operando2});

  @override
  double operar() {
    var result = operando1 / operando2;
    return result;
  }
}

class Multiplicar extends Operacao {
  Multiplicar({required super.operando1, required super.operando2});

  @override
  double operar() {
    var result = operando1 * operando2;
    return result;
  }
}
