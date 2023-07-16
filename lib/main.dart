import 'package:flutter/material.dart';
import 'package:aquacontrol/pages/signin_page.dart';

import 'services/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // iniciliza Firebase
  FirebaseAutenticacao.inicializa();
  // inicializa sharedPreferences
  //final preferenciasUsuario = await SharedPreferences.getInstance();
  // inicializa aplicação
  runApp(const MyApp(
      //preferences: preferenciasUsuario,
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aqua Control',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 3, 22, 131)),
        useMaterial3: true,
      ),
      home: const SigninPage(),
    );
  }
}
