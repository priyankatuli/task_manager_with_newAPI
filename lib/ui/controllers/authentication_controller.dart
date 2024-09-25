import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/model/user_data_model.dart';


class AuthenticationController{

  static const String _accessTokenKey = 'access_token';
  static const String _userDataKey = 'user_data';

  static String accessToken = '';
  static UserDataModel? userData;

  static Future<void> saveLogInToken(String token) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_accessTokenKey, token);
    accessToken = token;
  }

  static Future<String?> getLogInToken() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(_accessTokenKey);
  }

  static Future<void> saveUserData(UserDataModel user) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));
    userData = user;
  }

  static Future<UserDataModel?> getUserData() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? data = sharedPreferences.getString(_userDataKey);
    if (data==null){
      return null;
    }
    UserDataModel userdata = UserDataModel.fromJson(jsonDecode(data));
    userData = userdata;
    return userdata;
  }

  static Future<void> clearAllData() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  static Future<bool> checkIfUserLoggedInOrNot() async{

    String? tokenData = await getLogInToken();
    if(tokenData == null){
      return false;
    }
    else{
      accessToken = tokenData;
      userData = await getUserData();
      return true;
    }
  }





}