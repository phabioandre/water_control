import 'dart:core';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:aquacontrol/pages/signin_page.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import '../services/preferencias.dart';
import 'home_page.dart';
import 'package:share/share.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class ChartData {
  ChartData(this.x, this.y);
  DateTime x;
  double y;
}

class _ChartPageState extends State<ChartPage> {
  @override
  void dispose() {
    super.dispose();
  }

  List<ChartData> chartDataOxigenio = [];
  List<ChartData> chartDataph = [];
  List<ChartData> chartDataTemperatura = [];

  _ChartPageState() {
    recebeDados('oxigenio').then((val) => setState(() {
          chartDataOxigenio = val;
        }));
    recebeDados('ph').then((val) => setState(() {
          chartDataph = val;
        }));
    recebeDados('temperatura').then((val) => setState(() {
          chartDataTemperatura = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Aqua Control",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.share,
                  //color: Colors.red,
                ),
                tooltip: 'Compartilhar dados em Excel',
                onPressed: () {
                  CompartilhaExcel(context, chartDataOxigenio, chartDataph,
                      chartDataTemperatura);
                },
              ), //IconButton

              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Realizar Logout',
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SigninPage())));
                },
              ), //IconButton
            ], //<Widget>[]
            backgroundColor: Colors.lightBlue),
        // drawer: const Drawer(),
        body: SingleChildScrollView(
          //width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(children: <Widget>[
            graficoDeLinha(chartDataOxigenio,
                'Viveiro - Oxigênio dissolvido  (mg/L)', 'OD', 0.0, 14.0),
            const SizedBox(
              height: 5,
            ),
            graficoDeLinha(chartDataTemperatura, 'Viveiro - Temperatura (°C)',
                '°C', 0.0, 50.0),
            const SizedBox(
              height: 5,
            ),
            graficoDeLinha(chartDataph, 'Viveiro - pH', 'pH', 0.0, 14.0),
          ]),
        ));
  }
}

SfCartesianChart graficoDeLinha(List<ChartData> dados, String tituloDoGrafico,
    String grandezaMedida, valorMin, valorMax) {
  return SfCartesianChart(
      title: ChartTitle(text: tituloDoGrafico),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
      //legend: Legend(isVisible: true),
      primaryXAxis: DateTimeAxis(),
      primaryYAxis: NumericAxis(minimum: valorMin, maximum: valorMax),
      series: <ChartSeries<ChartData, DateTime>>[
        // Renders line chart
        LineSeries<ChartData, DateTime>(
            animationDuration: 9000,
            name: grandezaMedida,
            // dataLabelSettings: DataLabelSettings(isVisible: true),
            dataSource: dados,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y)
      ]);
}

Future<List<ChartData>> recebeDados(String serieDeDados) async {
  List<ChartData> listaValores = [];

  // recupera token do usuario
  // ignore: prefer_interpolation_to_compose_strings
  var tokenUsuarioTB = 'Bearer ' + await DadosUsuario.getUserTBToken();
  var tokenDispositivoTB = await DadosUsuario.getDeviceTBToken();

  int inicio = DateTime.now()
      .millisecondsSinceEpoch; // - Duration(hours: 3).inMilliseconds;
  int termino = inicio - const Duration(days: 1).inMilliseconds;

  String startTs = inicio.toString();
  String endTs = termino.toString();

  final parametros = {
    'keys': serieDeDados,
    'endTs': startTs,
    'startTs': endTs,
    'limit': '10000',
    'interval': '300000',
    'agg': 'AVG',
  };

  var url = Uri.parse(
      "https://thingsboard.smartrural.com.br:443/api/plugins/telemetry/DEVICE/$tokenDispositivoTB/values/timeseries");
  url = url.replace(queryParameters: parametros);

  var headers = {
    'X-Authorization': tokenUsuarioTB.toString(),
    'accept': 'application/json',
    'Content-Type': 'application/json',
  };

  var resposta = await http.get(url, headers: headers);
  if (resposta.statusCode == 200) {
    // recebeu com sucesso
    var listaPontos = json.decode(resposta.body);

    var lista = (listaPontos[serieDeDados]) as List;
    for (int i = 0; i < lista.length; i++) {
      var elemento = lista[i];
      // print(elemento);
      var temp = ChartData(DateTime.fromMillisecondsSinceEpoch(elemento['ts']),
          double.parse(elemento['value']));
      listaValores.add(temp);
    }
  }

  return listaValores;
}

// ignore: non_constant_identifier_names
CompartilhaExcel(BuildContext context, dadoOD, dadoPh, dadoTemp) async {
  final xcel.Workbook workbook = xcel.Workbook(3);
  final xcel.Worksheet sheetOD = workbook.worksheets[0];
  final xcel.Worksheet sheetPh = workbook.worksheets[1];
  final xcel.Worksheet sheetTemp = workbook.worksheets[2];

  sheetOD.name = 'OD';
  sheetPh.name = 'pH';
  sheetTemp.name = 'Temperatura';

  int i = 1;
  sheetOD.getRangeByIndex(i, 1).setText("Timestamp");
  sheetOD.getRangeByIndex(i, 2).setText("Valor");
  dadoOD.forEach((elemento) {
    i++;
    sheetOD.getRangeByIndex(i, 1).setDateTime(elemento.x);
    sheetOD.getRangeByIndex(i, 2).setNumber(elemento.y);
  });

  i = 1;
  sheetPh.getRangeByIndex(i, 1).setText("Timestamp");
  sheetPh.getRangeByIndex(i, 2).setText("Valor");
  dadoPh.forEach((elemento) {
    i++;
    sheetPh.getRangeByIndex(i, 1).setDateTime(elemento.x);
    sheetPh.getRangeByIndex(i, 2).setNumber(elemento.y);
  });

  i = 1;
  sheetTemp.getRangeByIndex(i, 1).setText("Timestamp");
  sheetTemp.getRangeByIndex(i, 2).setText("Valor");
  dadoTemp.forEach((elemento) {
    i++;
    sheetTemp.getRangeByIndex(i, 1).setDateTime(elemento.x);
    sheetTemp.getRangeByIndex(i, 2).setNumber(elemento.y);
  });

  DateTime now = DateTime.now();
  String dataArquivo = DateFormat('yyyyMMMdd_kk-mm').format(now);

  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;

  final List<int> bytes = workbook.saveAsStream();
  File file = File('$tempPath/WC_$dataArquivo.xlsx');
  file.writeAsBytesSync(bytes);
  workbook.dispose();
  Share.shareFiles(['$tempPath/WC_$dataArquivo.xlsx'], text: 'Medições');
}
