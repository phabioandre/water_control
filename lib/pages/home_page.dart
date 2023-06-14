import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:watercontrol/pages/online_Page.dart';
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
    loginTB().then((value) {
      if (value) {
        print("token encontrado");
      } else {
        //print("token não encontrado");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text("Thingsboard"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChartPage()));
              },
            ),
            ElevatedButton(
              child: Text("Online"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OnLinePage()));
              },
            ),
          ]),
    );
  }
}

Future<bool> loginTB() async {
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  var url =
      Uri.parse('https://thingsboard.smartrural.com.br:443/api/auth/login');

  var headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json'
  };

  final msg = jsonEncode(
      {"username": "phabioandre@gmail.com", "password": "TeStE135246"});

  var resposta = await http.post(url, body: msg, headers: headers);

  if (resposta.statusCode == 200) {
    print('token =' + jsonDecode(resposta.body)['token']);

    await sharedPreference.setString(
        'token', 'Bearer ' + jsonDecode(resposta.body)['token']);
    return true;
  } else {
    print(jsonDecode(resposta.body));
    return false;
  }

/*
  if (sharedPreference.getString('token') != null) {
    return true;
  } else {
    return false;
  }*/
}
