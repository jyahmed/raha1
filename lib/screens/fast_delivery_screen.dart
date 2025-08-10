import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_localizations.dart';

class FastDeliveryScreen extends StatelessWidget {
  FastDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.fastDelivery,
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
        itemCount: _fastDeliveryItems.length,
        itemBuilder: (context, index) {
          final item = _fastDeliveryItems[index];
          return _buildFastDeliveryCard(context, item, localizations);
        },
      ),
    );
  }

  final List<Map<String, dynamic>> _fastDeliveryItems = [
    {
      'id': 1,
      'name': 'برجر كينج - فرع الملك فهد',
      'image':
          'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=600&q=60',
      'deliveryTime': '15-20 دقيقة',
      'deliveryFee': '5 ر.س',
      'rating': 4.8,
      'distance': '1.2 كم',
      'category': 'وجبات سريعة',
    },
    {
      'id': 2,
      'name': 'مطعم الدار - فرع العليا',
      'image':
          'https://images.unsplash.com/photo-1513104890138-7c749659a591?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGl6emF8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
      'deliveryTime': '10-15 دقيقة',
      'deliveryFee': '3 ر.س',
      'rating': 4.5,
      'distance': '0.8 كم',
      'category': 'بيتزا',
    },
    {
      'id': 3,
      'name': 'كافيه سنترال - فرع التحلية',
      'image':
          'https://images.unsplash.com/photo-1504753793650-d4a2b783c15e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8Y29mZmVlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=600&q=60',
      'deliveryTime': '5-10 دقائق',
      'deliveryFee': '2 ر.س',
      'rating': 4.7,
      'distance': '0.5 كم',
      'category': 'مشروبات',
    },
    {
      'id': 4,
      'name': 'مطعم البيك - فرع الروضة',
      'image':
          'https://images.unsplash.com/photo-1632778149955-e80f8ceca2e8?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGNoaWNrZW58ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
      'deliveryTime': '12-18 دقيقة',
      'deliveryFee': '4 ر.س',
      'rating': 4.9,
      'distance': '1.0 كم',
      'category': 'دجاج',
    },
    {
      'id': 5,
      'name': 'مطعم الشاورما الذهبية',
      'image':
          'https://images.unsplash.com/photo-1509722747041-616f39b57569?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2FuZHdpY2h8ZW58MHx8MHx8&auto=format&fit=crop&w=600&q=60',
      'deliveryTime': '8-12 دقيقة',
      'deliveryFee': '3 ر.س',
      'rating': 4.3,
      'distance': '0.7 كم',
      'category': 'شاورما',
    },
  ];

  Widget _buildFastDeliveryCard(
    BuildContext context,
    Map<String, dynamic> item,
    AppLocalizations localizations,
  ) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {
          // Navigate to restaurant details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // صورة المطعم
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item['image'],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),

              // معلومات المطعم
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المطعم
                    Text(
                      item['name'],
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // الفئة
                    Text(
                      item['category'],
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // التقييم والمسافة
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          item['rating'].toString(),
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['distance'],
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // وقت التوصيل والرسوم
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.green,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item['deliveryTime'],
                                style: GoogleFonts.cairo(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item['deliveryFee'],
                            style: GoogleFonts.cairo(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // أيقونة السهم
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
