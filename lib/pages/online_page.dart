import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watercontrol/services/preferencias.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'home_page.dart';

double _value = 23.7;

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
          'entityId': '$tokenDispositivoTB',
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
      print(jsonData["data"]['oxigenio'][0][1] + '\n');
      setState(() {
        _value = double.parse(jsonData["data"]['oxigenio'][0][1]);
      });
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
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    criaWebSocket();
    return Scaffold(
        appBar: AppBar(
            title: const Text("Water Control"),
            backgroundColor: Colors.lightBlue),
        // drawer: const Drawer(),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              SfRadialGauge(
                  title: GaugeTitle(
                      text: 'Oxigênio Dissolvido',
                      textStyle: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  enableLoadingAnimation: true,
                  animationDuration: 4500,
                  axes: <RadialAxis>[
                    RadialAxis(
                        showTicks: true,
                        minimum: 0,
                        maximum: 14,
                        radiusFactor: 0.7,
                        ranges: <GaugeRange>[
                          GaugeRange(
                              startValue: 0,
                              endValue: 6,
                              color: Color.fromARGB(174, 247, 41, 41)),
                          GaugeRange(
                              startValue: 6,
                              endValue: 8,
                              color: Colors.lightBlue),
                          GaugeRange(
                              startValue: 8,
                              endValue: 14,
                              color: Color.fromARGB(109, 54, 244, 139))
                        ],
                        pointers: <GaugePointer>[
                          NeedlePointer(
                            value: _value,
                            enableAnimation: true,
                            animationType: AnimationType.easeOutBack,
                            needleLength: 0.9,
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Container(
                                  child: Text(_value.toString() + ' (mg/L)',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold))),
                              angle: 90,
                              positionFactor: 0.5)
                        ]),
                  ]),
            ])));
  }
}
