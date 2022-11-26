import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _authTimer;
  String? userEmail;
  String? _userName;

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get authUserName {
    return _userName;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    var url = Uri.https('identitytoolkit.googleapis.com', urlSegment,
        {'key': 'AIzaSyDy4s8C_RZ1f2GzQWedoKPQqjsK1FNwOtE'});
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      userEmail = email;
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
          'email': userEmail,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String password, String userName) async {
    _userName = userName;
    return _authenticate(email, password, '/v1/accounts:signUp');
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, '/v1/accounts:signInWithPassword');
  }

  Future<void> storeUserName(String userName) async {
    var url = Uri.https('clothes-shop-48bcc-default-rtdb.firebaseio.com',
        '/username/$userId.json', {'auth': token});
    try {
      final response = await http.put(
        url,
        body: json.encode(
          userName,
        ),
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchUserName() async {
    var url = Uri.https('clothes-shop-48bcc-default-rtdb.firebaseio.com',
        '/username/$userId.json', {'auth': token});
    try {
      final response = await http.get(url);
      final extractedUserName = json.decode(response.body);
      _userName = extractedUserName;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    userEmail = userData['email'];
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
