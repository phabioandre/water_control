import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vibration/vibration.dart';
import 'package:aquacontrol/pages/signin_page.dart';
import 'package:aquacontrol/services/preferencias.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../services/beweather.dart';
import 'bewather_page.dart';
import 'charts_page.dart';
import 'home_page.dart';

double _valueOxigenio = 0;
double _valuePh = 0;
double _valueTemperatura = 0;

class OnLinePage extends StatefulWidget {
  const OnLinePage({super.key});

  @override
  State<OnLinePage> createState() => _OnLinePageState();
}

class _OnLinePageState extends State<OnLinePage> {
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  Future criaWebSocket() async {
    late String tokenUsuarioTBNum;

    await DadosUsuario.getUserTBToken()
        .then((value) => tokenUsuarioTBNum = value);

    channel = WebSocketChannel.connect(
      Uri.parse(
          'wss://thingsboard.smartrural.com.br:443/api/ws/plugins/telemetry?token=$tokenUsuarioTBNum'),
    );
    const tokenDispositivoTB = '468d9270-f82e-11ec-bf91-e96cef9e8ef0';
    channel.sink.add(jsonEncode({
      'tsSubCmds': [
        {
          'entityType': "DEVICE",
          'entityId': tokenDispositivoTB,
          'scope': "LATEST_TELEMETRY",
          'timeWindow': '30000',
          'cmdId': '1',
        }
      ],
      'historyCmds': [],
      'attrSubCmds': []
    }));

    /// Listen for all incoming data
    channel.stream.listen((data) {
      var jsonData = json.decode(data);

      if (_valueOxigenio != double.parse(jsonData["data"]['oxigenio'][0][1]) ||
          _valuePh != double.parse(jsonData["data"]['ph'][0][1]) ||
          _valueTemperatura !=
              double.parse(jsonData["data"]['temperatura'][0][1])) {
        setState(() {
          _valueOxigenio = double.parse(jsonData["data"]['oxigenio'][0][1]);
          _valuePh = double.parse(jsonData["data"]['ph'][0][1]);
          _valueTemperatura =
              double.parse(jsonData["data"]['temperatura'][0][1]);
          Vibration.vibrate(duration: 500);
        });
      }
    }, onError: (error) {
      channel.sink.close();
      QuickAlert.show(
          context: context,
          confirmBtnText: 'Ok',
          // backgroundColor: Colors.blue,
          type: QuickAlertType.error,
          barrierDismissible: false,
          barrierColor: Colors.blue,
          title: 'Falha na comunicação',
          //text: '${error.toString()}',
          text:
              'Perda de conexão com o servidor. Verifique sua internet ou entre em contato com o Administrador do serviço.',
          onConfirmBtnTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    criaWebSocket();
    BeWeatherPlataform.recebeDados();
    return Scaffold(
      appBar: AppBar(
          title: const Text("Aqua Control",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.sunny),
              tooltip: 'Estação Meterológica',
              onPressed: () async {
                channel.sink.close();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BeWeatherPage()));
              },
            ), //IconButton
            IconButton(
              icon: const Icon(
                Icons.history,
                //color: Colors.greenAccent,
              ),
              tooltip: 'Dados Históricos',
              onPressed: () {
                channel.sink.close();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const ChartPage()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Realizar Logout',
              onPressed: () {
                channel.sink.close();
                FirebaseAuth.instance.signOut().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SigninPage())));
              },
            ), //IconButton
          ], //<Widget>[]
          backgroundColor: Colors.lightBlue),
      // drawer: const Drawer(),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Oxigênio Dissolvido',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 15, 66, 107)),
              ),
              makeDashboardItem('Oxigênio Dissolvido', _valueOxigenio, 'mg/L',
                  0, 14, 6, 8, 2),
              const Text(
                'Temperatura',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 15, 66, 107)),
              ),
              makeDashboardItem(
                  'Temperatura', _valueTemperatura, '°C', 0, 50, 20, 30, 5),
              const Text(
                'pH',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromARGB(255, 15, 66, 107)),
              ),
              makeDashboardItem('Ph', _valuePh, '', 0, 14, 6, 8, 2),
            ]),
      ),
    );
  }
}

Card makeDashboardItem(
    String titulo,
    double valorMedido,
    String unidadeMedida,
    double vMin,
    double vMax,
    double idealMin,
    double idealMax,
    double intervalo) {
  return Card(
    elevation: 1.0,
    margin: const EdgeInsets.fromLTRB(30, 3, 30, 3),
    child: Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(243, 246, 250, 1)),
      // height: 400,
      child: Align(
        alignment: Alignment.bottomCenter,
        heightFactor: 0.55,
        child: SfRadialGauge(
            //  title: GaugeTitle(
            //      text: titulo,
            //      textStyle: const TextStyle(
            //          fontSize: 10.0, fontWeight: FontWeight.bold)),
            enableLoadingAnimation: true,
            animationDuration: 4500,
            axes: <RadialAxis>[
              RadialAxis(
                  showTicks: true,
                  showLastLabel: true,
                  interval: intervalo,
                  startAngle: 180,
                  endAngle: 0,
                  minimum: vMin,
                  maximum: vMax,
                  labelOffset: 8,
                  radiusFactor: 0.5,
                  canScaleToFit: true,
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: vMin,
                        endValue: idealMin,
                        color: const Color.fromARGB(255, 255, 220, 220)),
                    GaugeRange(
                        startValue: idealMin,
                        endValue: idealMax,
                        color: Colors.lightBlue),
                    GaugeRange(
                        startValue: idealMax,
                        endValue: vMax,
                        color: const Color.fromARGB(255, 220, 255, 220))
                  ],
                  pointers: <GaugePointer>[
                    NeedlePointer(
                      value: valorMedido,
                      enableAnimation: true,
                      animationType: AnimationType.easeOutBack,
                      needleLength: 0.95,
                      needleStartWidth: 1,
                      needleEndWidth: 5,
                      // needleColor: Colors.blue,
                    )
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text('$valorMedido $unidadeMedida',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        angle: 90,
                        positionFactor: 0.5)
                  ]),
            ]),
      ),
    ),
  );
}
