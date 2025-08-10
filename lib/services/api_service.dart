import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/order.dart';
import '../models/restaurant.dart';

/// خدمة API للاتصال بالخادم
/// هذه الخدمة جاهزة للاتصال بـ API حقيقي
/// حالياً تستخدم بيانات وهمية للاختبار
class ApiService {
  static const String _baseUrl = 'https://api.rahadelivery.com/v1';
  static const Duration _timeout = Duration(seconds: 30);

  static ApiService? _instance;
  static ApiService get instance => _instance ??= ApiService._();

  ApiService._();

  String? _authToken;

  /// تعيين رمز المصادقة
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// مسح رمز المصادقة
  void clearAuthToken() {
    _authToken = null;
  }

  /// الحصول على headers الطلب
  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Accept-Language': 'ar',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  /// معالجة الاستجابة
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: _getErrorMessage(response),
      );
    }
  }

  /// الحصول على رسالة الخطأ
  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      return body['message'] ?? body['error'] ?? 'حدث خطأ غير متوقع';
    } catch (e) {
      switch (response.statusCode) {
        case 400:
          return 'طلب غير صحيح';
        case 401:
          return 'غير مصرح لك بالوصول';
        case 403:
          return 'ممنوع الوصول';
        case 404:
          return 'المورد غير موجود';
        case 500:
          return 'خطأ في الخادم';
        default:
          return 'حدث خطأ غير متوقع';
      }
    }
  }

  // ===== خدمات المصادقة =====

  /// تسجيل دخول بالهاتف
  Future<AuthResponse> loginWithPhone(String phoneNumber, String otp) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 2));

    // التحقق من صحة رقم الهاتف اليمني
    if (!_isValidYemeniPhone(phoneNumber)) {
      throw ApiException(
        statusCode: 400,
        message:
            'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 71، 73، 70، 77، أو 78 ويتكون من 9 أرقام',
      );
    }

    // محاكاة التحقق من OTP
    if (otp != '1234') {
      throw ApiException(
        statusCode: 400,
        message: 'رمز التحقق غير صحيح',
      );
    }

    // إرجاع استجابة وهمية
    return AuthResponse(
      token: 'dummy_token_${DateTime.now().millisecondsSinceEpoch}',
      user: User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        phoneNumber: phoneNumber,
        name: 'مستخدم جديد',
        createdAt: DateTime.now(),
        preferences: UserPreferences(),
      ),
    );
  }

  /// إرسال رمز التحقق
  Future<void> sendOtp(String phoneNumber) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 1));

    if (!_isValidYemeniPhone(phoneNumber)) {
      throw ApiException(
        statusCode: 400,
        message:
            'رقم الهاتف غير صحيح. يجب أن يبدأ بـ 71، 73، 70، 77، أو 78 ويتكون من 9 أرقام',
      );
    }

    // في التطبيق الحقيقي، سيتم إرسال OTP عبر SMS
    print('تم إرسال رمز التحقق إلى $phoneNumber: 1234');
  }

  /// التحقق من صحة رقم الهاتف اليمني
  bool _isValidYemeniPhone(String phoneNumber) {
    // إزالة المسافات والرموز
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // التحقق من الطول (9 أرقام)
    if (cleanPhone.length != 9) return false;

    // التحقق من البداية
    final validPrefixes = ['71', '73', '70', '77', '78'];
    return validPrefixes.any((prefix) => cleanPhone.startsWith(prefix));
  }

  /// تسجيل خروج
  Future<void> logout() async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(milliseconds: 500));
    clearAuthToken();
  }

  /// تحديث الملف الشخصي
  Future<User> updateProfile(User user) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 1));
    return user;
  }

  // ===== خدمات المطاعم والمتاجر =====

  /// الحصول على المطاعم القريبة
  Future<List<Restaurant>> getNearbyRestaurants({
    required double latitude,
    required double longitude,
    double radius = 10.0,
    String? category,
  }) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 1));

    // إرجاع بيانات وهمية
    return _getDummyRestaurants();
  }

  /// البحث في المطاعم
  Future<List<Restaurant>> searchRestaurants(String query) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(milliseconds: 800));

    final restaurants = _getDummyRestaurants();
    return restaurants
        .where((restaurant) =>
            restaurant.name.contains(query) ||
            restaurant.categories.any((category) => category.contains(query)))
        .toList();
  }

  /// الحصول على تفاصيل مطعم
  Future<Restaurant> getRestaurantDetails(String restaurantId) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(milliseconds: 500));

    final restaurants = _getDummyRestaurants();
    return restaurants.firstWhere(
      (restaurant) => restaurant.id.toString() == restaurantId,
      orElse: () => throw ApiException(
        statusCode: 404,
        message: 'المطعم غير موجود',
      ),
    );
  }

  // ===== خدمات الطلبات =====

  /// إنشاء طلب جديد
  Future<Order> createOrder(Order order) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 2));

    // إرجاع الطلب مع معرف جديد وحالة محدثة
    return order.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: OrderStatus.confirmed,
      confirmedAt: DateTime.now(),
      cancelledAt: DateTime.now(),
      cancellationReason: '',
    );
  }

  /// الحصول على طلبات المستخدم
  Future<List<Order>> getUserOrders(String userId) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 1));

    // إرجاع بيانات وهمية
    return _getDummyOrders(userId);
  }

  /// الحصول على تفاصيل طلب
  Future<Order> getOrderDetails(String orderId) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(milliseconds: 500));

    final orders = _getDummyOrders('1');
    return orders.firstWhere(
      (order) => order.id == orderId,
      orElse: () => throw ApiException(
        statusCode: 404,
        message: 'الطلب غير موجود',
      ),
    );
  }

  /// إلغاء طلب
  Future<Order> cancelOrder(String orderId, String reason) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 1));

    final order = await getOrderDetails(orderId);

    if (!order.canCancel) {
      throw ApiException(
        statusCode: 400,
        message: 'لا يمكن إلغاء هذا الطلب',
      );
    }

    return order.copyWith(
      status: OrderStatus.cancelled,
      cancelledAt: DateTime.now(),
      cancellationReason: reason,
      id: '',
      confirmedAt: DateTime.now(),
    );
  }

  /// تقييم طلب
  Future<void> rateOrder(String orderId, OrderRating rating) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 1));
  }

  // ===== خدمات الموقع =====

  /// الحصول على العنوان من الإحداثيات
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(seconds: 1));

    // إرجاع عنوان وهمي
    return 'صنعاء، شارع الزبيري، بجانب مسجد النور';
  }

  /// البحث عن عناوين
  Future<List<Address>> searchAddresses(String query) async {
    // محاكاة استدعاء API
    await Future.delayed(const Duration(milliseconds: 800));

    // إرجاع عناوين وهمية
    return [
      Address(
        id: '1',
        title: 'شارع الزبيري',
        fullAddress: 'صنعاء، شارع الزبيري، بجانب مسجد النور',
        latitude: 15.3694,
        longitude: 44.1910,
      ),
      Address(
        id: '2',
        title: 'شارع الستين',
        fullAddress: 'صنعاء، شارع الستين، مجمع الأعمال',
        latitude: 15.3548,
        longitude: 44.2066,
      ),
    ];
  }

  // ===== بيانات وهمية للاختبار =====

  List<Restaurant> _getDummyRestaurants() {
    return [
      Restaurant(
        id: 1,
        name: 'مطعم الدار',
        image:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3',
        rating: 4.5,
        deliveryTime: '30-40 دقيقة',
        deliveryFee: 'مجاني',
        categories: ['عربي', 'شرقي'],
        distance: '0.5 كم',
      ),
      Restaurant(
        id: 2,
        name: 'مطعم البرج',
        image:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?ixlib=rb-4.0.3',
        rating: 4.3,
        deliveryTime: '25-35 دقيقة',
        deliveryFee: '5 ر.ي',
        categories: ['إيطالي', 'بيتزا'],
        distance: '0.8 كم',
      ),
      Restaurant(
        id: 3,
        name: 'مطعم الأصالة',
        image:
            'https://images.unsplash.com/photo-1414235077428-338989a2e8c0?ixlib=rb-4.0.3',
        rating: 4.7,
        deliveryTime: '20-30 دقيقة',
        deliveryFee: 'مجاني',
        categories: ['عربي', 'مشاوي'],
        distance: '1.2 كم',
      ),
    ];
  }

  List<Order> _getDummyOrders(String userId) {
    return [
      Order(
        id: '1',
        userId: userId,
        storeId: '1',
        storeName: 'مطعم الدار',
        storeImage:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3',
        items: [
          OrderItem(
            id: '1',
            productId: '1',
            productName: 'برجر لحم',
            productImage:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?ixlib=rb-4.0.3',
            price: 25.0,
            quantity: 2,
          ),
        ],
        subtotal: 50.0,
        deliveryFee: 5.0,
        tax: 2.75,
        discount: 0.0,
        total: 57.75,
        status: OrderStatus.delivered,
        paymentMethod: PaymentMethod.cash,
        paymentStatus: PaymentStatus.paid,
        deliveryAddress: Address(
          id: '1',
          title: 'المنزل',
          fullAddress: 'صنعاء، شارع الزبيري، بجانب مسجد النور',
          latitude: 15.3694,
          longitude: 44.1910,
          type: AddressType.home,
          isDefault: true,
        ),
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        deliveredAt: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
        estimatedDeliveryTime: 30,
        driverName: 'محمد السائق',
        driverPhone: '771234567',
        totalAmount: 57.75,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}

/// استجابة المصادقة
class AuthResponse {
  final String token;
  final User user;

  AuthResponse({
    required this.token,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

/// استثناء API
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({
    required this.statusCode,
    required this.message,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

/// حالة الشبكة
enum NetworkStatus {
  connected,
  disconnected,
  slow,
}

/// مراقب حالة الشبكة
class NetworkMonitor {
  static NetworkMonitor? _instance;
  static NetworkMonitor get instance => _instance ??= NetworkMonitor._();

  NetworkMonitor._();

  NetworkStatus _status = NetworkStatus.connected;

  NetworkStatus get status => _status;

  /// التحقق من حالة الاتصال
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// اختبار سرعة الاتصال
  Future<NetworkStatus> checkNetworkSpeed() async {
    try {
      final stopwatch = Stopwatch()..start();
      await http.get(Uri.parse('https://www.google.com'));
      stopwatch.stop();

      final responseTime = stopwatch.elapsedMilliseconds;

      if (responseTime < 1000) {
        _status = NetworkStatus.connected;
      } else if (responseTime < 3000) {
        _status = NetworkStatus.slow;
      } else {
        _status = NetworkStatus.disconnected;
      }

      return _status;
    } catch (e) {
      _status = NetworkStatus.disconnected;
      return _status;
    }
  }
}
