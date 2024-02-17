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

  setGroupIndex(String grpUUID,String objUUID) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(grpUUID, objUUID);
  }

  Future<String> getGroupIndex(String grpUUID)async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString(grpUUID) ?? "";
  }
}
