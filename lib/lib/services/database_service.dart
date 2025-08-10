import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order.dart';
import '../models/restaurant.dart';

/// خدمة قاعدة البيانات المحلية
/// هذه الخدمة تستخدم SharedPreferences لحفظ البيانات محلياً
/// يمكن استبدالها بقاعدة بيانات حقيقية (SQLite, Firebase, API) لاحقاً
class DatabaseService {
  static const String _usersKey = 'users';
  static const String _ordersKey = 'orders';
  static const String _restaurantsKey = 'restaurants';
  static const String _currentUserKey = 'current_user';
  static const String _favoritesKey = 'favorites';
  static const String _cartKey = 'cart';

  static DatabaseService? _instance;
  static DatabaseService get instance => _instance ??= DatabaseService._();

  DatabaseService._();

  SharedPreferences? _prefs;

  /// تهيئة قاعدة البيانات
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _initializeDefaultData();
  }

  /// تهيئة البيانات الافتراضية
  Future<void> _initializeDefaultData() async {
    // إنشاء بيانات وهمية إذا لم تكن موجودة
    final users = await getUsers();
    if (users.isEmpty) {
      await _createDummyData();
    }
  }

  /// إنشاء بيانات وهمية للاختبار
  Future<void> _createDummyData() async {
    // إنشاء مستخدمين وهميين
    final dummyUsers = [
      User(
        id: '1',
        phoneNumber: '712345678',
        name: 'أحمد محمد',
        email: 'ahmed@example.com',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLoginAt: DateTime.now(),
        addresses: [
          Address(
            id: '1',
            title: 'المنزل',
            fullAddress: 'صنعاء، شارع الزبيري، بجانب مسجد النور',
            latitude: 15.3694,
            longitude: 44.1910,
            type: AddressType.home,
            isDefault: true,
          ),
        ],
        preferences: UserPreferences(),
      ),
      User(
        id: '2',
        phoneNumber: '773456789',
        name: 'فاطمة علي',
        email: 'fatima@example.com',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastLoginAt: DateTime.now().subtract(const Duration(hours: 2)),
        addresses: [
          Address(
            id: '2',
            title: 'العمل',
            fullAddress: 'صنعاء، شارع الستين، مجمع الأعمال',
            latitude: 15.3548,
            longitude: 44.2066,
            type: AddressType.work,
            isDefault: true,
          ),
        ],
        preferences: UserPreferences(),
      ),
    ];

    for (final user in dummyUsers) {
      await saveUser(user);
    }

    // إنشاء طلبات وهمية
    final dummyOrders = [
      Order(
        id: '1',
        userId: '1',
        storeId: '1',
        storeName: 'مطعم الدار',
        storeImage: 'https://example.com/restaurant1.jpg',
        items: [
          OrderItem(
            id: '1',
            productId: '1',
            productName: 'برجر لحم',
            productImage: 'https://example.com/burger.jpg',
            price: 25.0,
            quantity: 2,
          ),
          OrderItem(
            id: '2',
            productId: '2',
            productName: 'بطاطس مقلية',
            productImage: 'https://example.com/fries.jpg',
            price: 10.0,
            quantity: 1,
          ),
        ],
        subtotal: 60.0,
        deliveryFee: 5.0,
        tax: 3.0,
        discount: 0.0,
        total: 68.0,
        status: OrderStatus.delivered,
        paymentMethod: PaymentMethod.cash,
        paymentStatus: PaymentStatus.paid,
        deliveryAddress: dummyUsers[0].addresses[0],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        confirmedAt: DateTime.now()
            .subtract(const Duration(days: 2, hours: 23, minutes: 55)),
        preparingAt: DateTime.now()
            .subtract(const Duration(days: 2, hours: 23, minutes: 40)),
        onWayAt: DateTime.now()
            .subtract(const Duration(days: 2, hours: 23, minutes: 10)),
        deliveredAt: DateTime.now()
            .subtract(const Duration(days: 2, hours: 22, minutes: 45)),
        estimatedDeliveryTime: 30,
        driverName: 'محمد السائق',
        driverPhone: '771234567',
        totalAmount: 68.0,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Order(
        id: '2',
        userId: '1',
        storeId: '2',
        storeName: 'مطعم البرج',
        storeImage: 'https://example.com/restaurant2.jpg',
        items: [
          OrderItem(
            id: '3',
            productId: '3',
            productName: 'بيتزا مارجريتا',
            productImage: 'https://example.com/pizza.jpg',
            price: 35.0,
            quantity: 1,
          ),
        ],
        subtotal: 35.0,
        deliveryFee: 8.0,
        tax: 2.15,
        discount: 5.0,
        total: 40.15,
        status: OrderStatus.onWay,
        paymentMethod: PaymentMethod.card,
        paymentStatus: PaymentStatus.paid,
        deliveryAddress: dummyUsers[0].addresses[0],
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        confirmedAt: DateTime.now().subtract(const Duration(minutes: 40)),
        preparingAt: DateTime.now().subtract(const Duration(minutes: 25)),
        onWayAt: DateTime.now().subtract(const Duration(minutes: 10)),
        estimatedDeliveryTime: 25,
        driverName: 'علي السائق',
        driverPhone: '773456789',
        driverLatitude: 15.3650,
        driverLongitude: 44.1950,
        totalAmount: 40.15,
        dateTime: DateTime.now().subtract(
          const Duration(minutes: 45),
        ),
      ),
    ];

    for (final order in dummyOrders) {
      await saveOrder(order);
    }
  }

  // ===== عمليات المستخدمين =====

  /// حفظ مستخدم
  Future<void> saveUser(User user) async {
    final users = await getUsers();
    final index = users.indexWhere((u) => u.id == user.id);

    if (index >= 0) {
      users[index] = user;
    } else {
      users.add(user);
    }

    await _saveUsers(users);
  }

  /// الحصول على جميع المستخدمين
  Future<List<User>> getUsers() async {
    final usersJson = _prefs?.getString(_usersKey);
    if (usersJson == null) return [];

    final usersList = jsonDecode(usersJson) as List<dynamic>;
    return usersList.map((json) => User.fromJson(json)).toList();
  }

  /// الحصول على مستخدم بالمعرف
  Future<User?> getUserById(String id) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  /// الحصول على مستخدم برقم الهاتف
  Future<User?> getUserByPhone(String phoneNumber) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.phoneNumber == phoneNumber);
    } catch (e) {
      return null;
    }
  }

  /// حفظ المستخدم الحالي
  Future<void> setCurrentUser(User user) async {
    await _prefs?.setString(_currentUserKey, jsonEncode(user.toJson()));
  }

  /// الحصول على المستخدم الحالي
  Future<User?> getCurrentUser() async {
    final userJson = _prefs?.getString(_currentUserKey);
    if (userJson == null) return null;

    return User.fromJson(jsonDecode(userJson));
  }

  /// تسجيل خروج المستخدم الحالي
  Future<void> clearCurrentUser() async {
    await _prefs?.remove(_currentUserKey);
  }

  /// حفظ قائمة المستخدمين
  Future<void> _saveUsers(List<User> users) async {
    final usersJson = jsonEncode(users.map((user) => user.toJson()).toList());
    await _prefs?.setString(_usersKey, usersJson);
  }

  // ===== عمليات الطلبات =====

  /// حفظ طلب
  Future<void> saveOrder(Order order) async {
    final orders = await getOrders();
    final index = orders.indexWhere((o) => o.id == order.id);

    if (index >= 0) {
      orders[index] = order;
    } else {
      orders.add(order);
    }

    await _saveOrders(orders);
  }

  /// الحصول على جميع الطلبات
  Future<List<Order>> getOrders() async {
    final ordersJson = _prefs?.getString(_ordersKey);
    if (ordersJson == null) return [];

    final ordersList = jsonDecode(ordersJson) as List<dynamic>;
    return ordersList.map((json) => Order.fromJson(json)).toList();
  }

  /// الحصول على طلبات مستخدم معين
  Future<List<Order>> getUserOrders(String userId) async {
    final orders = await getOrders();
    return orders.where((order) => order.userId == userId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// الحصول على طلب بالمعرف
  Future<Order?> getOrderById(String id) async {
    final orders = await getOrders();
    try {
      return orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  /// حذف طلب
  Future<void> deleteOrder(String id) async {
    final orders = await getOrders();
    orders.removeWhere((order) => order.id == id);
    await _saveOrders(orders);
  }

  /// حفظ قائمة الطلبات
  Future<void> _saveOrders(List<Order> orders) async {
    final ordersJson =
        jsonEncode(orders.map((order) => order.toJson()).toList());
    await _prefs?.setString(_ordersKey, ordersJson);
  }

  // ===== عمليات المفضلة =====

  /// إضافة إلى المفضلة
  Future<void> addToFavorites(
      String userId, String itemId, String itemType) async {
    final favorites = await getFavorites(userId);
    final favoriteItem = FavoriteItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      itemId: itemId,
      itemType: itemType,
      addedAt: DateTime.now(),
    );

    // تجنب التكرار
    if (!favorites
        .any((fav) => fav.itemId == itemId && fav.itemType == itemType)) {
      favorites.add(favoriteItem);
      await _saveFavorites(userId, favorites);
    }
  }

  /// إزالة من المفضلة
  Future<void> removeFromFavorites(
      String userId, String itemId, String itemType) async {
    final favorites = await getFavorites(userId);
    favorites
        .removeWhere((fav) => fav.itemId == itemId && fav.itemType == itemType);
    await _saveFavorites(userId, favorites);
  }

  /// الحصول على المفضلة
  Future<List<FavoriteItem>> getFavorites(String userId) async {
    final favoritesJson = _prefs?.getString('${_favoritesKey}_$userId');
    if (favoritesJson == null) return [];

    final favoritesList = jsonDecode(favoritesJson) as List<dynamic>;
    return favoritesList.map((json) => FavoriteItem.fromJson(json)).toList();
  }

  /// التحقق من وجود عنصر في المفضلة
  Future<bool> isFavorite(String userId, String itemId, String itemType) async {
    final favorites = await getFavorites(userId);
    return favorites
        .any((fav) => fav.itemId == itemId && fav.itemType == itemType);
  }

  /// حفظ المفضلة
  Future<void> _saveFavorites(
      String userId, List<FavoriteItem> favorites) async {
    final favoritesJson =
        jsonEncode(favorites.map((fav) => fav.toJson()).toList());
    await _prefs?.setString('${_favoritesKey}_$userId', favoritesJson);
  }

  // ===== عمليات السلة =====

  /// إضافة إلى السلة
  Future<void> addToCart(String userId, CartItem item) async {
    final cartItems = await getCartItems(userId);
    final existingIndex = cartItems.indexWhere(
      (cartItem) => cartItem.productId == item.productId,
    );

    if (existingIndex >= 0) {
      cartItems[existingIndex] = cartItems[existingIndex].copyWith(
        quantity: cartItems[existingIndex].quantity + item.quantity,
      );
    } else {
      cartItems.add(item);
    }

    await _saveCartItems(userId, cartItems);
  }

  /// تحديث كمية في السلة
  Future<void> updateCartItemQuantity(
      String userId, String productId, int quantity) async {
    final cartItems = await getCartItems(userId);
    final index = cartItems.indexWhere((item) => item.productId == productId);

    if (index >= 0) {
      if (quantity <= 0) {
        cartItems.removeAt(index);
      } else {
        cartItems[index] = cartItems[index].copyWith(quantity: quantity);
      }
      await _saveCartItems(userId, cartItems);
    }
  }

  /// إزالة من السلة
  Future<void> removeFromCart(String userId, String productId) async {
    final cartItems = await getCartItems(userId);
    cartItems.removeWhere((item) => item.productId == productId);
    await _saveCartItems(userId, cartItems);
  }

  /// الحصول على عناصر السلة
  Future<List<CartItem>> getCartItems(String userId) async {
    final cartJson = _prefs?.getString('${_cartKey}_$userId');
    if (cartJson == null) return [];

    final cartList = jsonDecode(cartJson) as List<dynamic>;
    return cartList.map((json) => CartItem.fromJson(json)).toList();
  }

  /// مسح السلة
  Future<void> clearCart(String userId) async {
    await _prefs?.remove('${_cartKey}_$userId');
  }

  /// حفظ عناصر السلة
  Future<void> _saveCartItems(String userId, List<CartItem> items) async {
    final cartJson = jsonEncode(items.map((item) => item.toJson()).toList());
    await _prefs?.setString('${_cartKey}_$userId', cartJson);
  }

  // ===== عمليات عامة =====

  /// مسح جميع البيانات
  Future<void> clearAllData() async {
    await _prefs?.clear();
  }

  /// نسخ احتياطي للبيانات
  Future<Map<String, dynamic>> exportData() async {
    return {
      'users': await getUsers(),
      'orders': await getOrders(),
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  /// استيراد البيانات
  Future<void> importData(Map<String, dynamic> data) async {
    if (data['users'] != null) {
      final users = (data['users'] as List<dynamic>)
          .map((json) => User.fromJson(json))
          .toList();
      await _saveUsers(users);
    }

    if (data['orders'] != null) {
      final orders = (data['orders'] as List<dynamic>)
          .map((json) => Order.fromJson(json))
          .toList();
      await _saveOrders(orders);
    }
  }
}

// نماذج مساعدة

class FavoriteItem {
  final String id;
  final String itemId;
  final String itemType; // 'restaurant', 'product', etc.
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.itemId,
    required this.itemType,
    required this.addedAt,
  });

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json['id'],
      itemId: json['itemId'],
      itemType: json['itemType'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'itemType': itemType,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String storeId;
  final String storeName;
  final List<CartItemOption> options;
  final String? notes;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.storeId,
    required this.storeName,
    this.options = const [],
    this.notes,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      options: (json['options'] as List<dynamic>?)
              ?.map((option) => CartItemOption.fromJson(option))
              .toList() ??
          [],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'storeId': storeId,
      'storeName': storeName,
      'options': options.map((option) => option.toJson()).toList(),
      'notes': notes,
    };
  }

  CartItem copyWith({
    String? id,
    String? productId,
    String? productName,
    String? productImage,
    double? price,
    int? quantity,
    String? storeId,
    String? storeName,
    List<CartItemOption>? options,
    String? notes,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      storeId: storeId ?? this.storeId,
      storeName: storeName ?? this.storeName,
      options: options ?? this.options,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => price * quantity;
}

class CartItemOption {
  final String name;
  final String value;
  final double additionalPrice;

  CartItemOption({
    required this.name,
    required this.value,
    this.additionalPrice = 0,
  });

  factory CartItemOption.fromJson(Map<String, dynamic> json) {
    return CartItemOption(
      name: json['name'],
      value: json['value'],
      additionalPrice: json['additionalPrice']?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
      'additionalPrice': additionalPrice,
    };
  }
}
