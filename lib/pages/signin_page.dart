import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:watercontrol/pages/home_page.dart';

import '../services/preferencias.dart';
import '../services/firebase.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPagetState();
}

class _SigninPagetState extends State<SigninPage> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  String texto = '';

  @override
  void initState() {
    super.initState();
    Future.wait([DadosUsuario.isFirebaseConnected()]).then((value) {
      if (value[0]) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.lightBlue, Color.fromARGB(255, 3, 22, 131)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.1, 20, 0),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/aquicultura.png"),
                const SizedBox(
                  height: 10,
                ),
                caixaDeTextoPersonalizada(
                    "Email", Icons.email_sharp, false, _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                caixaDeTextoPersonalizada(
                    "Senha", Icons.lock_outline, true, _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                signInSignOutButton(context, true, () async {
                  if (await FirebaseAutenticacao.login(
                      _emailTextController.text,
                      _passwordTextController.text)) {
                    // Login realizado com Sucesso, salva no SharedPreferences
                    DadosUsuario.setFirebaseConnected(true);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  } else {
                    QuickAlert.show(
                      context: context,
                      confirmBtnText: 'Ok',
                      // backgroundColor: Colors.blue,
                      type: QuickAlertType.error,
                      barrierColor: Colors.blue,
                      title: 'Falha na Autenticação',
                      //text: '${error.toString()}',
                      text:
                          'Verifique dados de usuário/senha. Se problema, persistir entre em contato com Administrador.',
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 340,
    height: 340,
    //color: Color.fromARGB(255, 255, 255, 255),
  );
}

TextField caixaDeTextoPersonalizada(String text, IconData icone,
    bool isPassword, TextEditingController controlador) {
  return TextField(
    controller: controlador,
    obscureText: isPassword,
    enableSuggestions: !isPassword,
    autocorrect: !isPassword,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icone,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType:
        isPassword ? TextInputType.visiblePassword : TextInputType.emailAddress,
  );
}

Container signInSignOutButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(isLogin ? 'LOG IN' : 'SIGN UP',
          style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 16)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.white;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
      ),
    ),
  );
}
