// مثال على كيفية استخدام صفحة تفاصيل المطعم الجديدة

import 'package:flutter/material.dart';
import 'models/restaurant.dart';
import 'screens/restaurant_detail_screen.dart';
import 'widgets/enhanced_restaurant_card.dart';

class ExampleUsage extends StatelessWidget {
  const ExampleUsage({super.key});

  @override
  Widget build(BuildContext context) {
    // إنشاء مطعم تجريبي
    final restaurant = Restaurant(
      id: 1,
      name: 'مطعم الدار دار',
      image: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3',
      rating: 4.8,
      deliveryTime: '30-40 دقيقة',
      deliveryFee: 'مجاني',
      categories: ['عربي', 'مشاوي', 'سلطات'],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('مثال على الاستخدام'),
      ),
      body: Column(
        children: [
          // استخدام البطاقة المحسنة للمطعم
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'البطاقة المحسنة للمطعم:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          EnhancedRestaurantCard(restaurant: restaurant),
          
          const SizedBox(height: 20),
          
          // زر للانتقال مباشرة لصفحة التفاصيل
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantDetailScreen(restaurant: restaurant),
                ),
              );
            },
            child: const Text('عرض تفاصيل المطعم'),
          ),
        ],
      ),
    );
  }
}

/*
تعليمات الاستخدام:

1. لاستخدام صفحة تفاصيل المطعم الجديدة:
   - استورد RestaurantDetailScreen
   - مرر كائن Restaurant للصفحة
   - استخدم Navigator.push للانتقال

2. لاستخدام البطاقة المحسنة للمطعم:
   - استورد EnhancedRestaurantCard
   - مرر كائن Restaurant للبطاقة
   - البطاقة تحتوي على onTap للانتقال التلقائي لصفحة التفاصيل

3. الميزات المتوفرة في صفحة التفاصيل:
   - عرض معلومات المطعم مع التقييم
   - أقسام الوجبات مع المفضلة
   - إضافة/إزالة من المفضلة
   - إضافة للسلة مع عداد الكمية
   - شريط السلة السفلي
   - دعم الوضع المظلم والفاتح

4. الألوان المستخدمة (متطابقة مع المشروع):
   - الوضع الفاتح: أزرق فاتح (#3ADFFF5) وأزرق داكن (#153A6B) وأصفر (#FFC72C)
   - الوضع المظلم: أزرق فاتح (#7EE6F3) مع خلفيات داكنة

5. لإضافة الصفحة للتطبيق:
   - أضف المسار في main.dart:
     '/restaurant_detail': (context) => const RestaurantDetailScreen(restaurant: restaurant),
   - أو استخدم Navigator.push مع MaterialPageRoute
*/

