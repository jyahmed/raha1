import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:raha_app/widgets/cart_button.dart';

import '../l10n/app_localizations.dart';

class PreviousOrdersScreen extends StatelessWidget {
  const PreviousOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      floatingActionButton: const CartButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.previousOrders,
          style: GoogleFonts.cairo(
            color: Theme.of(context).appBarTheme.foregroundColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).appBarTheme.foregroundColor,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _dummyOrders.length,
        itemBuilder: (context, index) {
          final order = _dummyOrders[index];
          return _buildOrderCard(context, order, localizations);
        },
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    Map<String, dynamic> order,
    AppLocalizations localizations,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getLocalizedStatus(order['status'], localizations),
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${localizations.orderNumber} #${order['id']}',
                  style: GoogleFonts.cairo(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.store,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  order['restaurant'],
                  style: GoogleFonts.cairo(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  order['date'],
                  style: GoogleFonts.cairo(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.shopping_bag,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order['items'].join(', '),
                    style: GoogleFonts.cairo(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _showOrderDetails(context, order, localizations);
                      },
                      icon: const Icon(Icons.visibility, size: 16),
                      label: Text(localizations.viewDetails),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (order['status'] == 'تم التوصيل')
                      TextButton.icon(
                        onPressed: () {
                          _reorderItems(context, order, localizations);
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: Text(localizations.reorder),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                      ),
                  ],
                ),
                Text(
                  '${order['total']} ر.ي',
                  style: GoogleFonts.cairo(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedStatus(String status, AppLocalizations localizations) {
    switch (status) {
      case 'تم التوصيل':
        return localizations.delivered;
      case 'قيد التحضير':
        return localizations.preparing;
      case 'في الطريق':
        return localizations.onTheWay;
      case 'ملغي':
        return localizations.cancelled;
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'تم التوصيل':
        return Colors.green;
      case 'قيد التحضير':
        return Colors.orange;
      case 'في الطريق':
        return Colors.blue;
      case 'ملغي':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.cairo(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(
    BuildContext context,
    Map<String, dynamic> order,
    AppLocalizations localizations,
  ) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.ltr,
        child: AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            '${localizations.orderDetails} #${order['id']}',
            style: GoogleFonts.cairo(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    '${localizations.restaurant}:', order['restaurant']),
                _buildDetailRow('${localizations.date}:', order['date']),
                _buildDetailRow(
                  '${localizations.status}:',
                  _getLocalizedStatus(order['status'], localizations),
                ),
                _buildDetailRow('وقت التوصيل:', order['deliveryTime']),
                _buildDetailRow('العنوان:', order['address']),
                _buildDetailRow('طريقة الدفع:', order['paymentMethod']),
                if (order['driverName'].isNotEmpty) ...[
                  _buildDetailRow('اسم السائق:', order['driverName']),
                  _buildDetailRow('رقم السائق:', order['driverPhone']),
                ],
                const SizedBox(height: 12),
                Text(
                  '${localizations.items}:',
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...order['items']
                    .map<Widget>((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '• $item',
                            style: GoogleFonts.cairo(fontSize: 14),
                          ),
                        ))
                    .toList(),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${localizations.total}:',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${order['total']} ر.ي',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                localizations.close,
                style: GoogleFonts.cairo(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reorderItems(
    BuildContext context,
    Map<String, dynamic> order,
    AppLocalizations localizations,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          localizations.itemsAddedToCart,
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  static final List<Map<String, dynamic>> _dummyOrders = [
    {
      'id': '12345',
      'restaurant': 'مطعم الأصالة اليمنية',
      'date': '2024-08-03 14:30',
      'status': 'تم التوصيل',
      'items': ['مندي لحم', 'سلطة يمنية', 'شاي أحمر', 'خبز تنور'],
      'total': '2850.00',
      'deliveryTime': '35 دقيقة',
      'address': 'شارع الزبيري، صنعاء',
      'paymentMethod': 'نقداً عند التسليم',
      'driverName': 'أحمد محمد',
      'driverPhone': '712345678',
    },
    {
      'id': '12344',
      'restaurant': 'مطعم الحديقة',
      'date': '2024-08-02 19:45',
      'status': 'تم التوصيل',
      'items': ['كبسة دجاج', 'سلطة فتوش', 'عصير مانجو', 'حلى أم علي'],
      'total': '3200.00',
      'deliveryTime': '42 دقيقة',
      'address': 'حي السبعين، صنعاء',
      'paymentMethod': 'بطاقة ائتمان',
      'driverName': 'محمد علي',
      'driverPhone': '773456789',
    },
    {
      'id': '12343',
      'restaurant': 'مطعم البحر الأحمر',
      'date': '2024-08-01 13:20',
      'status': 'ملغي',
      'items': ['سمك مشوي', 'أرز بخاري', 'سلطة طحينة'],
      'total': '2650.00',
      'deliveryTime': 'ملغي',
      'address': 'شارع الستين، صنعاء',
      'paymentMethod': 'نقداً عند التسليم',
      'driverName': '',
      'driverPhone': '',
    },
    {
      'id': '12342',
      'restaurant': 'كافيه الأندلس',
      'date': '2024-07-31 09:15',
      'status': 'تم التوصيل',
      'items': [
        'قهوة عربية',
        'معمول بالتمر',
        'عصير برتقال طازج',
        'كعك بالسمسم'
      ],
      'total': '1850.00',
      'deliveryTime': '25 دقيقة',
      'address': 'شارع الحصبة، صنعاء',
      'paymentMethod': 'محفظة إلكترونية',
      'driverName': 'سالم أحمد',
      'driverPhone': '701234567',
    },
    {
      'id': '12341',
      'restaurant': 'مطعم الشام',
      'date': '2024-07-30 20:30',
      'status': 'تم التوصيل',
      'items': ['شاورما لحم', 'فتة حمص', 'تبولة', 'عيران'],
      'total': '2450.00',
      'deliveryTime': '38 دقيقة',
      'address': 'شارع الثورة، صنعاء',
      'paymentMethod': 'نقداً عند التسليم',
      'driverName': 'عبدالله محمد',
      'driverPhone': '781234567',
    },
    {
      'id': '12340',
      'restaurant': 'مطعم الجبل الأخضر',
      'date': '2024-07-29 16:45',
      'status': 'تم التوصيل',
      'items': ['فحسة يمنية', 'خبز ملوح', 'شاي بالحليب', 'حلاوة طحينية'],
      'total': '1950.00',
      'deliveryTime': '30 دقيقة',
      'address': 'حي الثورة، صنعاء',
      'paymentMethod': 'بطاقة ائتمان',
      'driverName': 'ياسر علي',
      'driverPhone': '771234567',
    },
    {
      'id': '12339',
      'restaurant': 'مطعم الوادي',
      'date': '2024-07-28 12:15',
      'status': 'في الطريق',
      'items': ['زربيان دجاج', 'سلطة خضراء', 'لبن رائب'],
      'total': '2750.00',
      'deliveryTime': '45 دقيقة (متوقع)',
      'address': 'شارع الجمهورية، صنعاء',
      'paymentMethod': 'نقداً عند التسليم',
      'driverName': 'فيصل أحمد',
      'driverPhone': '731234567',
    },
    {
      'id': '12338',
      'restaurant': 'مطعم النخيل',
      'date': '2024-07-27 18:20',
      'status': 'قيد التحضير',
      'items': ['مضغوط لحم', 'شوربة عدس', 'خبز تميس'],
      'total': '3100.00',
      'deliveryTime': '50 دقيقة (متوقع)',
      'address': 'شارع الخمسين، صنعاء',
      'paymentMethod': 'محفظة إلكترونية',
      'driverName': 'سيف محمد',
      'driverPhone': '781234568',
    },
  ];
}
