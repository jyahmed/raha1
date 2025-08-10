import 'dart:math';

class LocationService {
  static const double _earthRadius = 6371; // نصف قطر الأرض بالكيلومتر

  // إحداثيات صنعاء كمرجع افتراضي
  static const double defaultLatitude = 15.3694;
  static const double defaultLongitude = 44.1910;

  // محاكاة الحصول على الموقع الحالي
  static Future<Map<String, double>> getCurrentLocation() async {
    // محاكاة تأخير الحصول على الموقع
    await Future.delayed(const Duration(seconds: 2));
    
    // إرجاع موقع وهمي في صنعاء مع تغيير طفيف
    final random = Random();
    return {
      'latitude': defaultLatitude + (random.nextDouble() - 0.5) * 0.1,
      'longitude': defaultLongitude + (random.nextDouble() - 0.5) * 0.1,
    };
  }

  // حساب المسافة بين نقطتين جغرافيتين
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // الحصول على عنوان من الإحداثيات (محاكاة)
  static Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // قائمة بأحياء صنعاء
    final neighborhoods = [
      'حي السبعين',
      'حي الثورة',
      'حي الحصبة',
      'حي شعوب',
      'حي الزبيري',
      'حي الجمهورية',
      'حي الستين',
      'حي الخمسين',
      'حي الأربعين',
      'حي المطار',
    ];
    
    final random = Random();
    final neighborhood = neighborhoods[random.nextInt(neighborhoods.length)];
    
    return '$neighborhood، صنعاء، اليمن';
  }

  // الحصول على الإحداثيات من العنوان (محاكاة)
  static Future<Map<String, double>?> getCoordinatesFromAddress(
    String address,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    
    // محاكاة البحث عن العنوان
    if (address.toLowerCase().contains('صنعاء')) {
      final random = Random();
      return {
        'latitude': defaultLatitude + (random.nextDouble() - 0.5) * 0.2,
        'longitude': defaultLongitude + (random.nextDouble() - 0.5) * 0.2,
      };
    }
    
    return null;
  }

  // فحص ما إذا كان الموقع ضمن منطقة التوصيل
  static bool isWithinDeliveryArea(
    double latitude,
    double longitude,
    double centerLat,
    double centerLon,
    double radiusKm,
  ) {
    final distance = calculateDistance(latitude, longitude, centerLat, centerLon);
    return distance <= radiusKm;
  }

  // الحصول على المتاجر القريبة
  static List<Map<String, dynamic>> getNearbyStores(
    double userLat,
    double userLon,
    List<Map<String, dynamic>> allStores,
  ) {
    // حساب المسافة لكل متجر وترتيبها
    final storesWithDistance = allStores.map((store) {
      final distance = calculateDistance(
        userLat,
        userLon,
        store['latitude'],
        store['longitude'],
      );
      
      return {
        ...store,
        'distance': distance,
        'distanceText': distance < 1 
            ? '${(distance * 1000).round()} متر'
            : '${distance.toStringAsFixed(1)} كم',
      };
    }).toList();

    // ترتيب المتاجر حسب المسافة
    storesWithDistance.sort((a, b) => 
        (a['distance'] as double).compareTo(b['distance'] as double));

    return storesWithDistance;
  }

  // تقدير وقت التوصيل بناءً على المسافة
  static String estimateDeliveryTime(double distanceKm) {
    if (distanceKm < 1) {
      return '15-20 دقيقة';
    } else if (distanceKm < 3) {
      return '20-30 دقيقة';
    } else if (distanceKm < 5) {
      return '30-45 دقيقة';
    } else if (distanceKm < 10) {
      return '45-60 دقيقة';
    } else {
      return 'أكثر من ساعة';
    }
  }

  // حساب رسوم التوصيل بناءً على المسافة
  static double calculateDeliveryFee(double distanceKm) {
    if (distanceKm < 2) {
      return 500.0; // 500 ريال يمني
    } else if (distanceKm < 5) {
      return 750.0;
    } else if (distanceKm < 10) {
      return 1000.0;
    } else {
      return 1500.0;
    }
  }

  // الحصول على بيانات وهمية للمتاجر في صنعاء
  static List<Map<String, dynamic>> getDummyStores() {
    return [
      {
        'id': '1',
        'name': 'مطعم الأصالة اليمنية',
        'category': 'مطاعم',
        'image': 'assets/images/restaurant1.jpg',
        'rating': 4.8,
        'latitude': 15.3694,
        'longitude': 44.1910,
        'address': 'شارع الزبيري، صنعاء',
        'phone': '712345678',
        'isOpen': true,
        'deliveryTime': '25-35 دقيقة',
        'minOrder': 1500.0,
      },
      {
        'id': '2',
        'name': 'مطعم الحديقة',
        'category': 'مطاعم',
        'image': 'assets/images/restaurant2.jpg',
        'rating': 4.6,
        'latitude': 15.3750,
        'longitude': 44.1950,
        'address': 'حي السبعين، صنعاء',
        'phone': '773456789',
        'isOpen': true,
        'deliveryTime': '30-40 دقيقة',
        'minOrder': 2000.0,
      },
      {
        'id': '3',
        'name': 'مطعم البحر الأحمر',
        'category': 'مأكولات بحرية',
        'image': 'assets/images/restaurant3.jpg',
        'rating': 4.7,
        'latitude': 15.3650,
        'longitude': 44.1880,
        'address': 'شارع الستين، صنعاء',
        'phone': '701234567',
        'isOpen': false,
        'deliveryTime': '35-45 دقيقة',
        'minOrder': 2500.0,
      },
      {
        'id': '4',
        'name': 'كافيه الأندلس',
        'category': 'مقاهي',
        'image': 'assets/images/cafe1.jpg',
        'rating': 4.5,
        'latitude': 15.3720,
        'longitude': 44.1920,
        'address': 'شارع الحصبة، صنعاء',
        'phone': '781234567',
        'isOpen': true,
        'deliveryTime': '20-30 دقيقة',
        'minOrder': 1000.0,
      },
      {
        'id': '5',
        'name': 'مطعم الشام',
        'category': 'مطاعم',
        'image': 'assets/images/restaurant4.jpg',
        'rating': 4.4,
        'latitude': 15.3680,
        'longitude': 44.1940,
        'address': 'شارع الثورة، صنعاء',
        'phone': '731234567',
        'isOpen': true,
        'deliveryTime': '25-35 دقيقة',
        'minOrder': 1800.0,
      },
      {
        'id': '6',
        'name': 'مطعم الجبل الأخضر',
        'category': 'مطاعم شعبية',
        'image': 'assets/images/restaurant5.jpg',
        'rating': 4.9,
        'latitude': 15.3710,
        'longitude': 44.1890,
        'address': 'حي الثورة، صنعاء',
        'phone': '771234567',
        'isOpen': true,
        'deliveryTime': '20-30 دقيقة',
        'minOrder': 1200.0,
      },
      {
        'id': '7',
        'name': 'سوبر ماركت الوادي',
        'category': 'سوبر ماركت',
        'image': 'assets/images/supermarket1.jpg',
        'rating': 4.3,
        'latitude': 15.3730,
        'longitude': 44.1960,
        'address': 'شارع الجمهورية، صنعاء',
        'phone': '712345679',
        'isOpen': true,
        'deliveryTime': '40-50 دقيقة',
        'minOrder': 3000.0,
      },
      {
        'id': '8',
        'name': 'صيدلية النخيل',
        'category': 'صيدليات',
        'image': 'assets/images/pharmacy1.jpg',
        'rating': 4.6,
        'latitude': 15.3660,
        'longitude': 44.1900,
        'address': 'شارع الخمسين، صنعاء',
        'phone': '781234568',
        'isOpen': true,
        'deliveryTime': '15-25 دقيقة',
        'minOrder': 500.0,
      },
    ];
  }
}

