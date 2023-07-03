import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:watercontrol/pages/online_Page.dart';
import 'package:watercontrol/pages/signin_page.dart';
import 'package:watercontrol/services/firebase.dart';
import 'package:watercontrol/services/thingsboard.dart';
import '../services/preferencias.dart';
import 'charts_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    ThingsboardPlataform.login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Water Control"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.history,
                //color: Colors.red,
              ),
              tooltip: 'Dados históricos',
              onPressed: () {},
            ), //IconButton
            IconButton(
              icon: Icon(
                Icons.broadcast_on_personal,
                //color: Colors.greenAccent,
              ),
              tooltip: 'Dados em Tempo Real',
              onPressed: () {},
            ), //IconButton
            IconButton(
              icon: Icon(Icons.logout),
              tooltip: 'Realizar Logout',
              onPressed: () {},
            ), //IconButton
          ],
          backgroundColor: Colors.lightBlue),

      // drawer: const Drawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.history,
                        size: 100,
                      ),
                      Text(' Dados Históricos  '),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChartPage()));
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.broadcast_on_personal,
                        size: 100,
                      ),
                      Text('Dados em Tempo Real'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => OnLinePage()));
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 200),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.logout,
                        size: 100,
                      ),
                      Text('Sair'),
                    ],
                  ),
                  onPressed: () async {
                    if (await FirebaseAutenticacao.logout()) {
                      DadosUsuario.setFirebaseConnected(false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SigninPage()));
                    }
                  },
                ),
              ]),
        ),
      ),
    );
  }
}

/*
Future<bool> loginTB() async {
  // Cria uma instância do sharedPreferences
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();

  // URL de acesso à plataforma thingsboard
  var url =
      Uri.parse('https://thingsboard.smartrural.com.br:443/api/auth/login');
  // Headers da requisição a ser realizada
  var headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json'
  };
  // Payload da requisição de Autenticação
  final msg = jsonEncode(
      {"username": "phabioandre@gmail.com", "password": "TeStE135246"});

  try {
    var resposta = await http.post(url, body: msg, headers: headers);

    // Caso a requisição de Autenticação tenha sido realizada
    if (resposta.statusCode == 200) {
      // Armazena o token de usuário que foi concedido para a sessão iniciada
      await sharedPreference.setString(
          'token', 'Bearer ' + jsonDecode(resposta.body)['token']);
      await sharedPreference.setString(
          'tokenNum', jsonDecode(resposta.body)['token']);
      await sharedPreference.setString('connected', 'true');
      return true;
    } else {
      // para qualquer outro resultado de resposta, Autorização não foi concedida
      await sharedPreference.setString('connected', 'false');
      return false;
    }
  } catch (e) {
    // Caso ocorra qualquer exceção durante requisição
    await sharedPreference.setString('connected', 'false');
    return false;
  }
}
*/