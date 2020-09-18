import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:selendra_marketplace_app/all_export.dart';

class ApiPostServices {
  String _alertText, _token;

  Future<String> getToken() async {
    SharedPreferences isToken = await SharedPreferences.getInstance();
    _token = isToken.getString('token');
    print(_token);
    return _token;
  }

  Future<void> setToken(String _token) async {
    SharedPreferences isToken = await SharedPreferences.getInstance();
    isToken.setString('token', _token);
  }

  Future<String> signInByEmail(String email, String password, context) async {
    var response = await http.post(ApiUrl.LOG_IN_URL,
        headers: ApiHeader.headers,
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }));
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      _token = responseJson['token'];
      if (_token != null) {
        setToken(_token);
        await ApiGetServices().fetchUserPf(_token);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RootServices()));
      } else {
        try {
          _alertText = responseJson['message'];
          print(_alertText);
        } catch (e) {
          _alertText = responseJson['error']['message'];
          // print(_alertText);
        }
      }
      // Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavigation()));
    } else {
      print(response.body);
    }
    return _alertText;
  }

  Future<String> signInByPhone(String phone, String password, context) async {
    String token;
    var response = await http.post(ApiUrl.LOG_IN_PHONE,
        headers: ApiHeader.headers,
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password,
        }));
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);

      token = responseJson['token'];
      if (token != null) {
        print(token);
        setToken(_token);
      } else {
        try {
          _alertText = responseJson['error']['message'];
        } catch (e) {
          _alertText = responseJson['message'];
        }
      }
    } else {
      print(response.body);
    }
    return _alertText;
  }

  Future<String> forgetPasswordByEmail(String email) async {
    var response = await http.post(ApiUrl.RESET_BY_EMAIL,
        headers: ApiHeader.headers,
        body: jsonEncode(<String, String>{'email': email}));
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      _alertText = responseBody['message'];
    }
    return _alertText;
  }

  Future<String> forgetPasswordByPhone(String phoneNumber) async {
    var response = await http.post(ApiUrl.RESET_BY_PHONE,
        headers: ApiHeader.headers,
        body: jsonEncode(<String, String>{'phone': '+855' + phoneNumber}));
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      _alertText = responseBody['message'];
    }
    return _alertText;
  }

  Future<String> signUpByEmail(String email, String password) async {
    var response = await http.post(ApiUrl.SIGN_UP_EMAIL,
        headers: ApiHeader.headers,
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }));
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      print(response.body);
      _alertText = responseBody['message'];
    } else {
      print(response.body);
    }

    return _alertText;
  }

  Future<String> signUpByPhone(String phone, String password, context) async {
    var response = await http.post(ApiUrl.SIGN_UP_PHONE,
        headers: ApiHeader.headers,
        body: jsonEncode(<String, String>{
          'phone': phone,
          'password': password,
        }));
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print(responseBody);
      print(response.body);
      _alertText = responseBody['message'];
      if (_alertText == 'Successfully registered!') {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OTPScreen(phone, password)));
      } else {
        return _alertText;
      }
    } else {
      print(response.body);
    }
    return _alertText;
  }

  Future<String> setUserPf(
      String firstName, String midName, String lastName, String gender) async {
    await getToken().then((value) async {
      var response = await http.post(ApiUrl.SET_USER_PROFILE,
          headers: <String, String>{
            "accept": "application/json",
            "authorization": "Bearer " + value,
            "Content-Type": "application/json"
          },
          body: jsonEncode(<String, String>{
            "first_name": firstName,
            "mid_name": midName,
            "last_name": lastName,
            "gender": gender,
          }));

      var responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        _alertText = responseBody['message'];
      } else {
        _alertText = responseBody['error']['message'];
      }
    });
    print(_alertText);
    return _alertText;
  }

  Future<String> getWallet(String pin) async {
    getToken().then((value) {
      _token = value;
    });

    var response = await http.post(ApiUrl.GET_WALLET,
        headers: <String, String>{
          "accept": "application/json",
          "authorization": "Bearer " + _token,
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, String>{"pin": pin}));
    var responseBody = json.decode(response.body);
    if (response.statusCode == 200) {
      print(responseBody);
      SharedPreferences isSeed = await SharedPreferences.getInstance();
      String _seed;

      try {
        _alertText = responseBody['message'];
      } catch (e) {
        var wallet = WalletResponse.fromJson(responseBody);
        print(wallet);
        print(wallet.message.seed);
        _seed = responseBody['message']['seed'];
        print(_seed);
        isSeed.setString('seed', _seed);
      }
    } else {
      print(responseBody);
      _alertText = responseBody['error']['message'];
    }
    print(_alertText);
    return _alertText;
  }

  Future<String> verifyByPhone(String phone, String verifyCode) async {
    var response = await http.post(ApiUrl.VERIFY_BY_PHONE,
        headers: ApiHeader.headers,
        body: jsonEncode(<String, String>{
          'phone': phone,
          'verification_code': verifyCode,
        }));

    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      try {
        _alertText = responseBody['error']['message'];
      } catch (e) {}
    }

    return _alertText;
  }

  Future<String> addPhoneNumber(String _token, String _phoneNumber) async {
    var response = await http.post(ApiUrl.ADD_PHONE_NUMBER,
        headers: <String, String>{
          "accept": "application/json",
          "authorization": "Bearer " + _token,
          "Content-Type": "application/json"
        },
        body: jsonEncode(<String, String>{
          "phone": _phoneNumber,
        }));
    if (response.statusCode == 200) {
      var responseBody = json.decode(response.body);
      print(responseBody);
      if (responseBody != null) {
        try {
          _alertText = responseBody['message'];
          if (_alertText == null) {
            _alertText = responseBody['error']['message'];
          }
        } catch (e) {
          _alertText = responseBody['error']['message'];
        }
      }
      print(_alertText);
    }
    return _alertText;
  }

  Future<String> resendCode(String phoneNumber) async {
    var response = await http.post(ApiUrl.RESEND_CODE,
        headers: ApiHeader.headers,
        body: <String, String>{
          'phone': phoneNumber,
        });
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      try {
        _alertText = responseJson['message'];
      } catch (e) {
        _alertText = responseJson['error']['message'];
      }
    }

    return _alertText;
  }

  Future<String> upLoadImage(File _image) async {
    /* Upload image to server by use multi part form*/
    SharedPreferences isToken = await SharedPreferences.getInstance();
    String token, imageUrl;

    token = isToken.getString('token');
    /* Compress image file */
    List<int> compressImage = await FlutterImageCompress.compressWithFile(
      _image.path,
      minHeight: 1300,
      minWidth: 1000,
      quality: 100,
    );
    /* Make request */
    var request = new http.MultipartRequest(
        'POST', Uri.parse('https://s3.zeetomic.com/upload'));
    /* Make Form of Multipart */
    var multipartFile = new http.MultipartFile.fromBytes(
      'file',
      compressImage,
      filename: 'image_picker.jpg',
      contentType: MediaType.parse('image/jpeg'),
    );
    /* Concate Token With Header */
    request.headers.addAll({
      "accept": "application/json",
      "authorization": "Bearer " + token,
      "Content-Type": "application/json"
    });
    request.files.add(multipartFile);
    /* Start send to server */
    http.StreamedResponse response = await request.send();
    /* Getting response */
    response.stream.transform(utf8.decoder).listen((data) {
      print("Image url $data");
      imageUrl = data;
    });

    return imageUrl;
  }
}