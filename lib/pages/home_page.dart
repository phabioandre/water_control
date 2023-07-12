import 'package:flutter/material.dart';
import 'package:watercontrol/pages/online_Page.dart';
import 'package:watercontrol/pages/signin_page.dart';
import 'package:watercontrol/services/firebase.dart';
import 'package:watercontrol/services/thingsboard.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("Water Control"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.history,
                //color: Colors.red,
              ),
              tooltip: 'Dados históricos',
              onPressed: () {},
            ), //IconButton
            IconButton(
              icon: const Icon(
                Icons.broadcast_on_personal,
                //color: Colors.greenAccent,
              ),
              tooltip: 'Dados em Tempo Real',
              onPressed: () {},
            ), //IconButton
            IconButton(
              icon: Icon(Icons.logout),
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      // ignore: use_build_context_synchronously
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigninPage()));
                    }
                  },
                ),
              ]),
        ),
      ),
    );
  }
}
