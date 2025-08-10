import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, required List confirmedOrders});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Order> currentOrders = [
    Order(
      id: '12345',
      restaurantName: 'برجر كينج',
      items: ['بيج ماك', 'بطاطس مقلية', 'كوكا كولا'],
      total: 45.0,
      status: OrderStatus.preparing,
      orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
      estimatedDelivery: DateTime.now().add(const Duration(minutes: 20)),
    ),
    Order(
      id: '12346',
      restaurantName: 'ستاربكس',
      items: ['لاتيه', 'كرواسان'],
      total: 28.0,
      status: OrderStatus.onTheWay,
      orderTime: DateTime.now().subtract(const Duration(minutes: 30)),
      estimatedDelivery: DateTime.now().add(const Duration(minutes: 5)),
    ),
    Order(
      id: '12347',
      restaurantName: 'مطعم الشام',
      items: ['شاورما دجاج', 'فتوش', 'عصير برتقال'],
      total: 32.0,
      status: OrderStatus.confirmed,
      orderTime: DateTime.now().subtract(const Duration(minutes: 5)),
      estimatedDelivery: DateTime.now().add(const Duration(minutes: 35)),
    ),
  ];

  final List<Order> pastOrders = [
    Order(
      id: '12340',
      restaurantName: 'بيتزا هت',
      items: ['بيتزا مارجريتا', 'أجنحة دجاج'],
      total: 65.0,
      status: OrderStatus.delivered,
      orderTime: DateTime.now().subtract(const Duration(days: 1)),
      estimatedDelivery: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Order(
      id: '12341',
      restaurantName: 'كنتاكي',
      items: ['وجبة زنجر', 'بطاطس', 'بيبسي'],
      total: 38.0,
      status: OrderStatus.delivered,
      orderTime: DateTime.now().subtract(const Duration(days: 3)),
      estimatedDelivery: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 58, 223, 245),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // يرجع للصفحة السابقة أو القائمة الرئيسية
          },
        ),
        title: Text(
          'طلباتي',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'الطلبات الحالية',
                style: GoogleFonts.cairo(),
              ),
            ),
            Tab(
              child: Text(
                'الطلبات السابقة',
                style: GoogleFonts.cairo(),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(currentOrders, true),
          _buildOrdersList(pastOrders, false),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Order> orders, bool isCurrent) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                isCurrent ? Icons.receipt_long_outlined : Icons.history,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isCurrent ? 'لا توجد طلبات حالية' : 'لا توجد طلبات سابقة',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              isCurrent
                  ? 'اطلب الآن واستمتع بوجبتك المفضلة'
                  : 'ستظهر طلباتك المكتملة هنا',
              style: GoogleFonts.cairo(
                color: Colors.grey[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, isCurrent);
      },
    );
  }

  Widget _buildOrderCard(Order order, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس الطلب
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طلب #${order.id}',
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),

            const SizedBox(height: 12),

            // اسم المطعم
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order.restaurantName,
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // العناصر
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                order.items.join(' • '),
                style: GoogleFonts.cairo(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // المعلومات السفلية
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وقت الطلب',
                      style: GoogleFonts.cairo(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(order.orderTime),
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'المجموع',
                      style: GoogleFonts.cairo(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.total.toStringAsFixed(0)} ر.س',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (isCurrent && order.status != OrderStatus.delivered) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'الوصول المتوقع: ${DateFormat('HH:mm').format(order.estimatedDelivery)}',
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderTrackingScreen(
                              orderId: order.id,
                              restaurantName: order.restaurantName,
                              totalAmount: order.total,
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.track_changes),
                      label: Text(
                        'تتبع الطلب',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _showOrderDetails(order),
                    icon: Icon(Icons.info_outline),
                    label: Text(
                      'التفاصيل',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (!isCurrent) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _reorderItem(order),
                      icon: Icon(Icons.refresh),
                      label: Text(
                        'إعادة الطلب',
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _rateOrder(order),
                    icon: Icon(Icons.star_outline),
                    label: Text(
                      'تقييم',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case OrderStatus.confirmed:
        color = Colors.blue;
        text = 'مؤكد';
        icon = Icons.check_circle_outline;
        break;
      case OrderStatus.preparing:
        color = Colors.orange;
        text = 'قيد التحضير';
        icon = Icons.restaurant;
        break;
      case OrderStatus.onTheWay:
        color = Colors.purple;
        text = 'في الطريق';
        icon = Icons.delivery_dining;
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        text = 'تم التوصيل';
        icon = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'ملغي';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.cairo(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الطلب #${order.id}', style: GoogleFonts.cairo()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المطعم: ${order.restaurantName}', style: GoogleFonts.cairo()),
            const SizedBox(height: 8),
            Text('العناصر:',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text('• $item', style: GoogleFonts.cairo()),
                )),
            const SizedBox(height: 8),
            Text('المجموع: ${order.total.toStringAsFixed(2)} ر.س',
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إغلاق', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _reorderItem(Order order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إضافة العناصر إلى السلة', style: GoogleFonts.cairo()),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _rateOrder(Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تقييم الطلب', style: GoogleFonts.cairo()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('كيف كانت تجربتك مع ${order.restaurantName}؟',
                style: GoogleFonts.cairo()),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  icon: Icon(Icons.star, color: Colors.amber),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('شكراً لتقييمك!', style: GoogleFonts.cairo()),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('إرسال', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
}

class Order {
  final String id;
  final String restaurantName;
  final List<String> items;
  final double total;
  final OrderStatus status;
  final DateTime orderTime;
  final DateTime estimatedDelivery;

  Order({
    required this.id,
    required this.restaurantName,
    required this.items,
    required this.total,
    required this.status,
    required this.orderTime,
    required this.estimatedDelivery,
  });
}

enum OrderStatus {
  confirmed,
  preparing,
  onTheWay,
  delivered,
  cancelled,
}
