import 'package:flutter/material.dart';

import '../services/beweather.dart';
import '../services/firebase.dart';
import '../services/preferencias.dart';
import 'online_Page.dart';
import 'signin_page.dart';

class BeWeatherPage extends StatefulWidget {
  const BeWeatherPage({super.key});

  @override
  State<BeWeatherPage> createState() => _BeWeatherPageState();
}

class _BeWeatherPageState extends State<BeWeatherPage> {
  @override
  Widget build(BuildContext context) {
    final tabela = Medidas.tabela;
    setState(() {
      BeWeatherPlataform.recebeDados();
    });
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Aqua Control",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.set_meal,
                  //color: Colors.greenAccent,
                ),
                tooltip: 'Dados em Tempo Real',
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OnLinePage()));
                }), //IconButton
            IconButton(
              icon: const Icon(
                Icons.history,
                //color: Colors.red,
              ),
              tooltip: 'Dados históricos',
              onPressed: () {},
            ), //IconButton
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Realizar Logout',
              onPressed: () async {
                if (await FirebaseAutenticacao.logout()) {
                  DadosUsuario.setFirebaseConnected(false);
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SigninPage()));
                }
              },
            ), //IconButton
          ],
          backgroundColor: Colors.lightBlue),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int medicao) {
            return ListTile(
              leading: Image.asset(
                tabela[medicao].icone,
              ),
              title: Text(tabela[medicao].nome),
              trailing: Text(tabela[medicao].valor),
            );
          },
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const Divider(),
          itemCount: tabela.length),
    );
  }
}
