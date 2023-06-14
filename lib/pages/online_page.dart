import 'package:flutter/material.dart';

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
              const SizedBox(height: 5),
            ])));
  }
}
