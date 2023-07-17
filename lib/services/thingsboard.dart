import 'dart:convert';
import 'firebase.dart';
import 'preferencias.dart';
import 'package:http/http.dart' as http;

class ThingsboardPlataform {
  static String username = '';
  static String pass = '';

  static Future<bool> login() async {
    // URL de acesso à plataforma thingsboard
    var url =
        Uri.parse('https://thingsboard.smartrural.com.br:443/api/auth/login');
    // Headers da requisição a ser realizada
    var headers = {
      'Content-Type': 'application/json',
      'accept': 'application/json'
    };
    // Payload da requisição de Autenticação
    username = DBFirestore.getTBUser();

    final msg = jsonEncode({"username": "", "password": ""});

    try {
      var resposta = await http.post(url, body: msg, headers: headers);

      // Caso a requisição de Autenticação tenha sido realizada
      if (resposta.statusCode == 200) {
        // Armazena o token de usuário que foi concedido para a sessão iniciada
        DadosUsuario.setUserTBToken(jsonDecode(resposta.body)['token']);
        DadosUsuario.setTBConnected(true);
        return true;
      } else {
        // para qualquer outro resultado de resposta, Autorização não foi concedida
        DadosUsuario.setTBConnected(false);
        return false;
      }
    } catch (e) {
      // Caso ocorra qualquer exceção durante requisição
      DadosUsuario.setTBConnected(false);
      return false;
    }
  }
}
