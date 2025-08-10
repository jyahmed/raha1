import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userToken;
  String? _userName;
  String? _userPhone;

  bool get isAuthenticated => _isAuthenticated;
  String? get userToken => _userToken;
  String? get userName => _userName;
  String? get userPhone => _userPhone;

  Future<void> login(String phone, String name) async {
    try {
      // التحقق من صحة رقم الهاتف والاسم
      if (phone.isEmpty || name.isEmpty) {
        throw Exception('يرجى إدخال رقم الهاتف والاسم');
      }

      if (!_isValidPhoneNumber(phone)) {
        throw Exception(
            'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 71، 73، 70، 77، أو 78 ويتكون من 9 أرقام');
      }

      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;
      _userToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
      _userPhone = phone;
      _userName = name;

      // حفظ بيانات المستخدم محلياً
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userToken', _userToken!);
      await prefs.setString('userPhone', _userPhone!);
      await prefs.setString('userName', _userName!);

      notifyListeners();
    } catch (error) {
      rethrow; // إعادة إرسال الخطأ كما هو
    }
  }

  Future<void> register(String name, String phone) async {
    try {
      // التحقق من صحة البيانات
      if (name.isEmpty || phone.isEmpty) {
        throw Exception('يرجى إدخال جميع البيانات المطلوبة');
      }

      if (!_isValidPhoneNumber(phone)) {
        throw Exception(
            'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 71، 73، 70، 77، أو 78 ويتكون من 9 أرقام');
      }

      // محاكاة تأخير الشبكة
      await Future.delayed(const Duration(seconds: 1));

      _isAuthenticated = true;
      _userToken = 'token_${DateTime.now().millisecondsSinceEpoch}';
      _userPhone = phone;
      _userName = name;

      // حفظ بيانات المستخدم محلياً
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', true);
      await prefs.setString('userToken', _userToken!);
      await prefs.setString('userPhone', _userPhone!);
      await prefs.setString('userName', _userName!);

      notifyListeners();
    } catch (error) {
      rethrow; // إعادة إرسال الخطأ كما هو
    }
  }

  bool _isValidPhoneNumber(String phone) {
    // التحقق من صحة رقم الهاتف اليمني
    final cleanPhone = phone.replaceAll(' ', '').replaceAll('-', '');
    final phoneRegex = RegExp(r'^(71|78|73|70|77)[0-9]{7}$');
    return phoneRegex.hasMatch(cleanPhone);
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _userToken = null;
    _userName = null;
    _userPhone = null;

    // حذف بيانات المستخدم المحفوظة محلياً
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('isAuthenticated')) {
      return;
    }

    _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
    _userToken = prefs.getString('userToken');
    _userPhone = prefs.getString('userPhone');
    _userName = prefs.getString('userName');

    if (_isAuthenticated) {
      notifyListeners();
    }
  }
}
