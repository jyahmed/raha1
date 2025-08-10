import 'user.dart';
import 'dart:async';

class Order {
  final String id;
  final String userId;
  final String storeId;
  final String storeName;
  final String storeImage;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double discount;
  final double total;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final Address deliveryAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  final DateTime? preparingAt;
  final DateTime? onWayAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final int? estimatedDeliveryTime; // بالدقائق
  final String? driverId;
  final String? driverName;
  final String? driverPhone;
  final double? driverLatitude;
  final double? driverLongitude;
  final OrderRating? rating;

  Order({
    required this.id,
    required this.userId,
    required this.storeId,
    required this.storeName,
    required this.storeImage,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.discount,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryAddress,
    this.notes,
    required this.createdAt,
    this.confirmedAt,
    this.preparingAt,
    this.onWayAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancellationReason,
    this.estimatedDeliveryTime,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverLatitude,
    this.driverLongitude,
    this.rating,
    required double totalAmount,
    required DateTime dateTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      storeId: json['storeId'],
      storeName: json['storeName'],
      storeImage: json['storeImage'],
      items: (json['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      tax: json['tax'].toDouble(),
      discount: json['discount'].toDouble(),
      total: json['total'].toDouble(),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == json['status'],
      ),
      paymentMethod: PaymentMethod.values.firstWhere(
        (method) => method.name == json['paymentMethod'],
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (status) => status.name == json['paymentStatus'],
      ),
      deliveryAddress: Address.fromJson(json['deliveryAddress']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      confirmedAt: json['confirmedAt'] != null
          ? DateTime.parse(json['confirmedAt'])
          : null,
      preparingAt: json['preparingAt'] != null
          ? DateTime.parse(json['preparingAt'])
          : null,
      onWayAt: json['onWayAt'] != null ? DateTime.parse(json['onWayAt']) : null,
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.parse(json['deliveredAt'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
      cancellationReason: json['cancellationReason'],
      estimatedDeliveryTime: json['estimatedDeliveryTime'],
      driverId: json['driverId'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      driverLatitude: json['driverLatitude']?.toDouble(),
      driverLongitude: json['driverLongitude']?.toDouble(),
      rating:
          json['rating'] != null ? OrderRating.fromJson(json['rating']) : null,
      totalAmount: json['total']?.toDouble() ?? 0.0,
      dateTime: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'storeId': storeId,
      'storeName': storeName,
      'storeImage': storeImage,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'discount': discount,
      'total': total,
      'status': status.name,
      'paymentMethod': paymentMethod.name,
      'paymentStatus': paymentStatus.name,
      'deliveryAddress': deliveryAddress.toJson(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'preparingAt': preparingAt?.toIso8601String(),
      'onWayAt': onWayAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'driverId': driverId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'driverLatitude': driverLatitude,
      'driverLongitude': driverLongitude,
      'rating': rating?.toJson(),
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'في انتظار التأكيد';
      case OrderStatus.confirmed:
        return 'تم التأكيد';
      case OrderStatus.preparing:
        return 'قيد التحضير';
      case OrderStatus.onWay:
        return 'في الطريق';
      case OrderStatus.delivered:
        return 'تم التوصيل';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  bool get canCancel {
    return status == OrderStatus.pending || status == OrderStatus.confirmed;
  }

  bool get canRate {
    return status == OrderStatus.delivered && rating == null;
  }

  bool get isActive {
    return status != OrderStatus.delivered && status != OrderStatus.cancelled;
  }

  Future<Order> copyWith({
    OrderStatus? status,
    DateTime? cancelledAt,
    String? cancellationReason,
    String? id,
    DateTime? confirmedAt,
  }) async {
    await Future.delayed(Duration(milliseconds: 500)); // مثال async

    return Order(
      id: id ?? this.id,
      userId: this.userId,
      storeId: this.storeId,
      storeName: this.storeName,
      storeImage: this.storeImage,
      items: this.items,
      subtotal: this.subtotal,
      deliveryFee: this.deliveryFee,
      tax: this.tax,
      discount: this.discount,
      total: this.total,
      status: status ?? this.status,
      paymentMethod: this.paymentMethod,
      paymentStatus: this.paymentStatus,
      deliveryAddress: this.deliveryAddress,
      notes: this.notes,
      createdAt: this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      preparingAt: this.preparingAt,
      onWayAt: this.onWayAt,
      deliveredAt: this.deliveredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      estimatedDeliveryTime: this.estimatedDeliveryTime,
      driverId: this.driverId,
      driverName: this.driverName,
      driverPhone: this.driverPhone,
      driverLatitude: this.driverLatitude,
      driverLongitude: this.driverLongitude,
      rating: this.rating,
      totalAmount: this.total,
      dateTime: this.createdAt,
    );
  }
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final List<OrderItemOption> options;
  final String? notes;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    this.options = const [],
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      options: (json['options'] as List<dynamic>?)
              ?.map((option) => OrderItemOption.fromJson(option))
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
      'options': options.map((option) => option.toJson()).toList(),
      'notes': notes,
    };
  }

  double get totalPrice => price * quantity;
}

class OrderItemOption {
  final String name;
  final String value;
  final double additionalPrice;

  OrderItemOption({
    required this.name,
    required this.value,
    this.additionalPrice = 0,
  });

  factory OrderItemOption.fromJson(Map<String, dynamic> json) {
    return OrderItemOption(
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

class OrderRating {
  final int storeRating;
  final int driverRating;
  final String? comment;
  final DateTime createdAt;

  OrderRating({
    required this.storeRating,
    required this.driverRating,
    this.comment,
    required this.createdAt,
  });

  factory OrderRating.fromJson(Map<String, dynamic> json) {
    return OrderRating(
      storeRating: json['storeRating'],
      driverRating: json['driverRating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeRating': storeRating,
      'driverRating': driverRating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  onWay,
  delivered,
  cancelled,
}

enum PaymentMethod {
  cash,
  card,
  wallet,
}

enum PaymentStatus {
  pending,
  paid,
  failed,
  refunded,
}
