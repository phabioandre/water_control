import 'dart:convert';

import 'preferencias.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class medidaEstacaoMeteorologica {
  String icone;
  String nome;
  String valor;

  medidaEstacaoMeteorologica({
    required this.icone,
    required this.nome,
    required this.valor,
  });
}

class Medidas {
  static String nome = '';
  static List<medidaEstacaoMeteorologica> tabela = [
    medidaEstacaoMeteorologica(
      icone: 'assets/images/temperatura.png',
      nome: 'Temperatura',
      valor: '-',
    ),
    medidaEstacaoMeteorologica(
      icone: 'assets/images/precipitacaoAtm.png',
      nome: 'Precipitação dia',
      valor: '-',
    ),
    medidaEstacaoMeteorologica(
      icone: 'assets/images/umidadeAr.png',
      nome: 'Umidade Relativa do ar',
      valor: '-',
    ),
    medidaEstacaoMeteorologica(
      icone: 'assets/images/radiacaoUV.png',
      nome: 'Radiação UV',
      valor: '-',
    ),
    medidaEstacaoMeteorologica(
      icone: 'assets/images/pressaoAtm.png',
      nome: 'Pressão Atmosférica',
      valor: '-',
    ),
    medidaEstacaoMeteorologica(
      icone: 'assets/images/clock.png',
      nome: 'Horário coleta',
      valor: '-',
    ),
  ];
}

class BeWeatherPlataform {
  static Future<bool> login() async {
    // URL de acesso à plataforma Be Wetaher
    var url = Uri.parse(
        'https://skye-app-api.azurewebsites.net/api/Account/Authenticate');
    // Headers da requisição a ser realizada
    var headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json'
    };
    // Payload da requisição de Autenticação
    final msg = jsonEncode({
      "username": "ufrpe.mctic.iot.turismo@gmail.com",
      "password": "Ufrpe@iot21"
    });

    try {
      var resposta = await http.post(url, body: msg, headers: headers);

      // Caso a requisição de Autenticação tenha sido realizada
      if (resposta.statusCode == 200) {
        // Armazena o token de usuário que foi concedido para a sessão iniciada
        DadosUsuario.setUserBeWeatherToken(jsonDecode(resposta.body)['token']);
        DadosUsuario.setBWConnected(true);
        BeWeatherPlataform.recebeDados();
        return true;
      } else {
        // para qualquer outro resultado de resposta, Autorização não foi concedida
        DadosUsuario.setBWConnected(false);
        return false;
      }
    } catch (e) {
      // Caso ocorra qualquer exceção durante requisição
      DadosUsuario.setBWConnected(false);
      return false;
    }
  }

  static Future<bool> recebeDados() async {
    // recupera token do usuario
    // ignore: prefer_interpolation_to_compose_strings
    var tokenUsuarioBW = 'Bearer ' + await DadosUsuario.getUserBeWeatherToken();

    var url =
        Uri.parse("https://skye-app-api.azurewebsites.net/api/Station/GetAll");

    var headers = {
      'Authorization': tokenUsuarioBW.toString(),
      'accept': 'application/json',
    };

    var resposta = await http.get(url, headers: headers);
    if (resposta.statusCode == 200) {
      var resultado = json.decode(resposta.body);
      // Nome da EStação
      Medidas.nome = resultado["items"][3]["name"];
      // Temperatura
      Medidas.tabela[0].valor =
          '${resultado["items"][3]["dashboardData"]["details"][0]["value"]} °C';
      // Precipitação do dia
      Medidas.tabela[1].valor =
          '${resultado["items"][3]["dashboardData"]["details"][1]["value"]} mm';
      // Umidade do Ar
      Medidas.tabela[2].valor =
          '${resultado["items"][3]["dashboardData"]["details"][3]["value"]} %';
      // Radiação UV
      Medidas.tabela[3].valor = resultado["items"][3]["dashboardData"]
              ["details"][7]["value"]
          .toString();
      // Pressão Atmosférica
      Medidas.tabela[4].valor =
          '${resultado["items"][3]["dashboardData"]["details"][8]["value"]} hPa';
      // Horário de Coleta
      Medidas.tabela[5].valor =
          DateTime.parse(resultado["items"][3]["lastWeatherAt"])
              .toLocal()
              .toString();
      return true;
    }
    return false;
  }
}
