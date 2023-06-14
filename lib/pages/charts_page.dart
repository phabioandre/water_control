import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:watercontrol/pages/home_page.dart';
import 'package:http/http.dart' as http;

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
            backgroundColor: Colors.lightBlue),
        // drawer: const Drawer(),
        body: SingleChildScrollView(
          //width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height,
          child: Column(children: <Widget>[
            graficoDeLinha(chartDataOxigenio,
                'Viveiro - Oxigênio dissolvido  (mg/L)', 'OD'),
            const SizedBox(
              height: 5,
            ),
            graficoDeLinha(chartDataph, 'Viveiro - Nível de ph', 'ph'),
            const SizedBox(
              height: 5,
            ),
            graficoDeLinha(
                chartDataTemperatura, 'Viveiro - Temperatura (°C)', '°C'),
          ]),
        ));
  }
}

Future<bool> verificaToken() async {
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  if (sharedPreference.getString('token') != null) {
    return true;
  } else {
    return false;
  }
}

SfCartesianChart graficoDeLinha(
    List<ChartData> dados, String tituloDoGrafico, String grandezaMedida) {
  return SfCartesianChart(
      title: ChartTitle(text: tituloDoGrafico),
      tooltipBehavior: TooltipBehavior(enable: true),
      zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
      //legend: Legend(isVisible: true),
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries<ChartData, DateTime>>[
        // Renders line chart
        LineSeries<ChartData, DateTime>(
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

/*  List<ChartData> dados = [
    ChartData(DateTime.fromMillisecondsSinceEpoch(1654822118613), 6),
    ChartData(DateTime.fromMillisecondsSinceEpoch(1654822148613), 11),
    ChartData(DateTime.fromMillisecondsSinceEpoch(1654822168613), 9),
    ChartData(DateTime.fromMillisecondsSinceEpoch(1654822188613), 14),
    ChartData(DateTime.fromMillisecondsSinceEpoch(1654822198613), 10),
  ];
*/

  // recupera token do usuario
  SharedPreferences sharedPreference = await SharedPreferences.getInstance();
  var tokenUsuarioTB = await sharedPreference.getString('token');
  final tokenDispositivoTB = '468d9270-f82e-11ec-bf91-e96cef9e8ef0';
  //final tokenDispositivoTB = 'QPaNdUeOLmALlsTakBKD';

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
      print(elemento);
      var temp = new ChartData(
          DateTime.fromMillisecondsSinceEpoch(elemento['ts']),
          double.parse(elemento['value']));
      listaValores.add(temp);
    });
  }

  return listaValores ?? [];
}
