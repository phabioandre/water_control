import 'package:flutter/material.dart';
import 'package:aquacontrol/pages/bewather_page.dart';
import 'package:aquacontrol/pages/online_Page.dart';
import 'package:aquacontrol/pages/signin_page.dart';
import 'package:aquacontrol/services/firebase.dart';
import 'package:aquacontrol/services/thingsboard.dart';
import '../services/beweather.dart';
import '../services/preferencias.dart';
import 'charts_page.dart';

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
    BeWeatherPlataform.login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
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
              icon: const Icon(Icons.sunny),
              tooltip: 'Estação Meterológica',
              onPressed: () async {
                BeWeatherPlataform.recebeDados();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BeWeatherPage()));
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.history,
                //color: Colors.red,
              ),
              tooltip: 'Dados históricos',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ChartPage()));
              },
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
            ), //IconButton //IconButton
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
                  height: 25,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.set_meal,
                        size: 100,
                      ),
                      Text('Viveiro em Tempo Real'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OnLinePage()));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sunny,
                        size: 100,
                      ),
                      Text('Estação Metereológica'),
                    ],
                  ),
                  onPressed: () {
                    BeWeatherPlataform.recebeDados();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BeWeatherPage()));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 100,
                      ),
                      Text('Dados Históricos'),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChartPage()));
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
