import 'dart:core';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'package:watercontrol/pages/signin_page.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xcel;
import '../services/preferencias.dart';
import 'online_Page.dart';
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
    // fecha websocket
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

  Widget build(BuildContext context) {
    // List<ChartData> chartData = recebeDados();
    //  List<ChartData> chartData = futureChartData as List<ChartData>;

    return Scaffold(
        appBar: AppBar(
            title: const Text("Water Control"),
            actions: <Widget>[
              IconButton(
                icon: Icon(
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
                icon: Icon(
                  Icons.online_prediction,
                  //color: Colors.greenAccent,
                ),
                tooltip: 'Dados em Tempo Real',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OnLinePage()));
                },
              ), //IconButton
              IconButton(
                icon: Icon(Icons.logout),
                tooltip: 'Realizar Logout',
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SigninPage())));
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
                'Viveiro - Oxigênio dissolvido  (mg/L)', 'OD', 0.0, 30.0),
            const SizedBox(
              height: 5,
            ),
            graficoDeLinha(
                chartDataph, 'Viveiro - Nível de ph', 'ph', 0.0, 15.0),
            const SizedBox(
              height: 5,
            ),
            graficoDeLinha(chartDataTemperatura, 'Viveiro - Temperatura (°C)',
                '°C', 0.0, 50.0),
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
            animationDuration: 1000,
            name: grandezaMedida,
            // dataLabelSettings: DataLabelSettings(isVisible: true),
            dataSource: dados,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y)
      ]);
}

Future<List<ChartData>> recebeDados(String serieDeDados) async {
  String? stringTemp = '';

  List<ChartData> listaValores = [];
  var temp = new ChartData(DateTime.now(), 0);

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
    'keys': '$serieDeDados',
    'endTs': '$startTs',
    'startTs': '$endTs',
    'limit': '10000',
    'interval': '300000',
    'agg': 'AVG',
  };

  var url = Uri.parse(
      "https://thingsboard.smartrural.com.br:443/api/plugins/telemetry/DEVICE/$tokenDispositivoTB/values/timeseries");
  url = url.replace(queryParameters: parametros);

  // var url = Uri.parse(
  //     'https://thingsboard.smartrural.com.br:443/api/plugins/telemetry/DEVICE/94446860-295a-11ed-bf91-e96cef9e8ef0/values/timeseries?keys=oxygen&startTs=1686505742764&endTs=1686509342764&limit=100&agg=NONE');
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
    lista.forEach((elemento) {
      // print(elemento);
      var temp = new ChartData(
          DateTime.fromMillisecondsSinceEpoch(elemento['ts']),
          double.parse(elemento['value']));
      listaValores.add(temp);
    });
  }

  return listaValores ?? [];
}

CompartilhaExcel(BuildContext context, dadoOD, dadoPh, dadoTemp) async {
  final xcel.Workbook workbook = xcel.Workbook(3);
  final xcel.Worksheet sheetOD = workbook.worksheets[0];
  final xcel.Worksheet sheetPh = workbook.worksheets[1];
  final xcel.Worksheet sheetTemp = workbook.worksheets[2];

  sheetOD.name = 'OD';
  sheetPh.name = 'Ph';
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
