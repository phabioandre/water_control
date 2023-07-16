import 'package:shared_preferences/shared_preferences.dart';

class DadosUsuario {
  // ThingsBoard ------------------------------------------------------------
  // seta o valor de token do usuário no Thingsboard
  static Future setUserTBToken(String value) async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    await preferenciasUsuario.setString('userTBToken', value);
  }

  static Future setTBConnected(bool value) async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    await preferenciasUsuario.setBool('isTBConnected', value);
  }

  // lê o valor de token do usuário no Thingsboard
  static Future<String> getUserTBToken() async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    return preferenciasUsuario.getString('userTBToken') ?? '';
  }

  // lê o valor de token do usuário no Thingsboard
  static Future<String> getDeviceTBToken() async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    return preferenciasUsuario.getString('deviceTBToken') ??
        '468d9270-f82e-11ec-bf91-e96cef9e8ef0';
  }

  // lê indicação de conectado do usuário no ThingsBoard
  static Future<bool> isTBConnected() async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    return preferenciasUsuario.getBool('isTBConnected') ?? false;
  }

// Be Weather --------------------------------------------------------------
  // seta o valor de token do usuário no Be Weather
  static Future setUserBeWeatherToken(String value) async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    await preferenciasUsuario.setString('userBeWeatherToken', value);
  }

  static Future setBWConnected(bool value) async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    await preferenciasUsuario.setBool('isBWConnected', value);
  }

  // lê o valor de token do usuário no Be Weather
  static Future<String> getUserBeWeatherToken() async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    return preferenciasUsuario.getString('userBeWeatherToken') ?? '';
  }

// lê indicação de conectado do usuário no Be Weather
  static Future<bool> isBWConnected() async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    return preferenciasUsuario.getBool('isBWConnected') ?? false;
  }

// Firebase  --------------------------------------------------------------
  // seta o valor de token do usuário no Firebase
  static Future setFirebaseConnected(bool value) async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    await preferenciasUsuario.setBool('isFirebaseConnected', value);
  }

// lê indicação de conectado do usuário no Firebase
  static Future<bool> isFirebaseConnected() async {
    var preferenciasUsuario = await SharedPreferences.getInstance();
    return preferenciasUsuario.getBool('isFirebaseConnected') ?? false;
  }
}
