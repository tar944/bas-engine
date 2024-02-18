import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  late SharedPreferences prefs;

  setToken(String token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String> getToken()async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? "";
  }

  setMainAddress(String address) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('mainAddress', address);
  }

  Future<String> getMainAddress()async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString('mainAddress') ?? "";
  }
}
