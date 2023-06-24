import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class OnLinePage extends StatefulWidget {
  const OnLinePage({super.key});

  @override
  State<OnLinePage> createState() => _OnLinePageState();
}

class _OnLinePageState extends State<OnLinePage> {
  @override
  Widget build(BuildContext context) {
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
              SfRadialGauge(axes: <RadialAxis>[
                RadialAxis(
                    showTicks: true,
                    minimum: 0,
                    maximum: 50,
                    radiusFactor: 0.7,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 20,
                          color: const Color.fromARGB(111, 64, 195, 255)),
                      GaugeRange(
                          startValue: 20,
                          endValue: 30,
                          color: Colors.lightBlue),
                      GaugeRange(
                          startValue: 30,
                          endValue: 50,
                          color: const Color.fromARGB(110, 244, 67, 54))
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: 28,
                        enableAnimation: true,
                        animationType: AnimationType.easeOutBack,
                        needleLength: 0.9,
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              child: Text('OD (mg/L)',
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
