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

  setShowGuide(String name,bool showState) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool(name, showState);
  }

  Future<bool> getShowGuide(String name)async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool(name) ?? true;
  }

  needBackUp(String prjUUID,bool needBackup) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("backup&&$prjUUID", needBackup);
  }

  Future<bool> shouldBackUp(String prjUUID)async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool("backup&&$prjUUID") ?? false;
  }

  needAuth(String prjUUID,bool needAuth) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setBool("auth&&$prjUUID", needAuth);
  }

  Future<bool> shouldAuth(String prjUUID)async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool("auth&&$prjUUID") ?? false;
  }

  setExportPath(String prjUUID,String path) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("path&&$prjUUID", path);
  }

  Future<String> getExportPath(String prjUUID)async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("path&&$prjUUID") ?? "";
  }

  setUploadLink(String prjUUID,String link) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("link&&$prjUUID", link);
  }

  Future<String> getUploadLink(String prjUUID)async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("link&&$prjUUID") ?? "";
  }

  setAuthToken(String prjUUID,String token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("token&&$prjUUID", token);
  }

  Future<String> getAuthToken(String prjUUID)async{
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("token&&$prjUUID") ?? "";
  }
}
