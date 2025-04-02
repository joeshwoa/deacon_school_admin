
import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesServices{
  static SharedPreferences? sharedPreferences;
  static init()async{
    sharedPreferences= await SharedPreferences.getInstance();
  }
  static Future<bool> setData({
    required String key,
    required dynamic value,
  })async{
    if(value is bool)return await sharedPreferences!.setBool(key, value);
    if(value is int)return await sharedPreferences!.setInt(key, value);
    if(value is String)return await sharedPreferences!.setString(key, value);
    return await sharedPreferences!.setDouble(key, value);
  }
  static Future<bool> setListData({
    required String key,
    required List<String> value,
  })async{
    return await sharedPreferences!.setStringList(key, value);
  }
  static Future<bool> setDataInList({required String key,required dynamic value, bool unique = false}) async {
    List list = SharedPreferencesServices.getData(key: key);
    List<String> stringList = [];
    for (var element in list) {
      stringList.add(element.toString());
    }

    if(unique){
      if(!stringList.contains(value.toString())) {
        stringList.add(value.toString());
      } else {
        return false;
      }
    } else {
      stringList.add(value.toString());
    }
    return await sharedPreferences!.setStringList(key, stringList);
  }

  static dynamic getData({required String key}){
    return sharedPreferences!.get(key);
  }
  static Future<bool> removeData({required String key})async{
    return await sharedPreferences!.remove(key);
  }

}

