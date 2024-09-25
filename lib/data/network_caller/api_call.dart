import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager/UI/screens/authentication/sign_in_screen.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/data/model/api_response.dart';
import 'package:task_manager/ui/controllers/authentication_controller.dart';

class ApiCall {

  static Future<ApiResponse> getResponse(String url) async {
    try {
      debugPrint(url);
      Response serverResponse = await get(Uri.parse(url),
          headers: {'token': AuthenticationController.accessToken});

      debugPrint(serverResponse.statusCode.toString());
      debugPrint(serverResponse.body);

      if (serverResponse.statusCode == 200) {
        final dynamic serverResponseData = jsonDecode(serverResponse.body);
        return ApiResponse(
            statusCode: serverResponse.statusCode,
            isSuccess: true,
            responseData: serverResponseData,
            errorMessage: null);
      } else if (serverResponse.statusCode == 401) {
        redirectToLogin();
        return ApiResponse(
            statusCode: serverResponse.statusCode,
            isSuccess: false
        );
      }
      else {
        return ApiResponse(
            statusCode: serverResponse.statusCode,
            isSuccess: false
        );
      }
    } catch (e) {
      return ApiResponse(
          statusCode: -1,
          isSuccess: false,
          errorMessage: e.toString()
      );
    }
  }
   static Future<ApiResponse> postResponse(String url,
      Map<String, dynamic>? body) async {
    try {
      debugPrint(url);
      Response serverResponse = await post(Uri.parse(url),
          body: jsonEncode(body),
          headers: {'content-type': 'application/json',
            'token': AuthenticationController.accessToken});

      debugPrint(serverResponse.statusCode.toString());
      debugPrint(serverResponse.body);

      if (serverResponse.statusCode == 200 || serverResponse.statusCode == 201) {
        final dynamic serverResponseData = jsonDecode(serverResponse.body);
        return ApiResponse(
            statusCode: serverResponse.statusCode,
            isSuccess: true,
            responseData: serverResponseData,
            errorMessage: null);
      } else if(serverResponse.statusCode == 401){
        redirectToLogin();
        return ApiResponse(
            statusCode: serverResponse.statusCode,
            isSuccess: false
        );
      }
    else{
         return ApiResponse(
              statusCode: serverResponse.statusCode,
              isSuccess: false);
    }
    } catch (e) {
      return ApiResponse(
        statusCode: -1,
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  static Future<void> redirectToLogin()async{

    await AuthenticationController.clearAllData();
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false
    );
  }


}
