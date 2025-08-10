// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  final String restaurantName;
  final double totalAmount;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
    required this.restaurantName,
    required this.totalAmount,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  int _currentStep = 0;
  Timer? _progressTimer;
  String _estimatedTime = '25-30 دقيقة';
  String _deliveryPersonName = 'أحمد محمد';
  String _deliveryPersonPhone = '0501234567';
  double _deliveryPersonRating = 4.8;

  final List<OrderStep> _orderSteps = [
    OrderStep(
      title: 'تم استلام الطلب',
      subtitle: 'المطعم يحضر طلبك الآن',
      icon: Icons.receipt_long,
      time: '14:30',
      isCompleted: true,
    ),
    OrderStep(
      title: 'جاري التحضير',
      subtitle: 'الطعام قيد التحضير',
      icon: Icons.restaurant,
      time: '14:35',
      isCompleted: true,
    ),
    OrderStep(
      title: 'جاهز للاستلام',
      subtitle: 'السائق في طريقه لاستلام الطلب',
      icon: Icons.check_circle,
      time: '14:45',
      isCompleted: true,
    ),
    OrderStep(
      title: 'في الطريق إليك',
      subtitle: 'السائق في طريقه لتوصيل الطلب',
      icon: Icons.delivery_dining,
      time: '14:50',
      isCompleted: false,
      isActive: true,
    ),
    OrderStep(
      title: 'تم التوصيل',
      subtitle: 'استمتع بوجبتك!',
      icon: Icons.home,
      time: '15:00',
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _progressController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _startProgressSimulation();
  }

  void _startProgressSimulation() {
    _progressTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_currentStep < _orderSteps.length - 1) {
        setState(() {
          _orderSteps[_currentStep].isActive = false;
          _orderSteps[_currentStep].isCompleted = true;
          _currentStep++;
          if (_currentStep < _orderSteps.length) {
            _orderSteps[_currentStep].isActive = true;
          }
        });
        _progressController.forward();
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تتبع الطلب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('تم تحديث حالة الطلب', style: GoogleFonts.cairo()),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // معلومات الطلب
            _buildOrderInfoCard(),
            const SizedBox(height: 20),

            // الوقت المتوقع
            _buildEstimatedTimeCard(),
            const SizedBox(height: 20),

            // خطوات الطلب
            _buildOrderStepsSection(),
            const SizedBox(height: 20),

            // معلومات السائق
            _buildDeliveryPersonCard(),
            const SizedBox(height: 20),

            // خريطة التتبع (محاكاة)
            _buildTrackingMap(),
            const SizedBox(height: 20),

            // أزرار الإجراءات
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'طلب رقم #${widget.orderId}',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'قيد التوصيل',
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.restaurantName,
            style: GoogleFonts.cairo(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'المبلغ الإجمالي: ${widget.totalAmount.toStringAsFixed(2)} ريال',
            style: GoogleFonts.cairo(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedTimeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.access_time,
                    color: Colors.orange,
                    size: 32,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الوقت المتوقع للوصول',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _estimatedTime,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStepsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'حالة الطلب',
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: _orderSteps.asMap().entries.map((entry) {
              int index = entry.key;
              OrderStep step = entry.value;
              bool isLast = index == _orderSteps.length - 1;

              return _buildOrderStepItem(step, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderStepItem(OrderStep step, bool isLast) {
    Color stepColor = step.isCompleted
        ? Colors.green
        : step.isActive
            ? Theme.of(context).primaryColor
            : Colors.grey;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: stepColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: stepColor, width: 2),
              ),
              child: step.isActive
                  ? AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value * 0.8 + 0.2,
                          child: Icon(
                            step.icon,
                            color: stepColor,
                            size: 20,
                          ),
                        );
                      },
                    )
                  : Icon(
                      step.isCompleted ? Icons.check : step.icon,
                      color: stepColor,
                      size: 20,
                    ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: stepColor.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      step.title,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: stepColor,
                      ),
                    ),
                    Text(
                      step.time,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  step.subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryPersonCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'معلومات السائق',
            style: GoogleFonts.cairo(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  _deliveryPersonName.substring(0, 1),
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _deliveryPersonName,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          _deliveryPersonRating.toString(),
                          style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _callDeliveryPerson(),
                    icon: Icon(Icons.phone, color: Colors.green),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.green.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _messageDeliveryPerson(),
                    icon: Icon(Icons.message,
                        color: Theme.of(context).primaryColor),
                    style: IconButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingMap() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey[300],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 48,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'خريطة التتبع المباشر',
                      style: GoogleFonts.cairo(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'موقع السائق محدث كل 30 ثانية',
                      style: GoogleFonts.cairo(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'مباشر',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () => _shareOrderTracking(),
            icon: Icon(Icons.share),
            label: Text(
              'مشاركة تتبع الطلب',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: () => _reportIssue(),
            icon: Icon(Icons.report_problem),
            label: Text(
              'الإبلاغ عن مشكلة',
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _callDeliveryPerson() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('اتصال بالسائق', style: GoogleFonts.cairo()),
        content: Text(
          'هل تريد الاتصال بـ $_deliveryPersonName على الرقم $_deliveryPersonPhone؟',
          style: GoogleFonts.cairo(),
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
                  content: Text('جاري الاتصال...', style: GoogleFonts.cairo()),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text('اتصال', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _messageDeliveryPerson() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('رسالة للسائق', style: GoogleFonts.cairo()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                hintStyle: GoogleFonts.cairo(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: GoogleFonts.cairo(),
              maxLines: 3,
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
                  content: Text('تم إرسال الرسالة', style: GoogleFonts.cairo()),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            child: Text('إرسال', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }

  void _shareOrderTracking() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ رابط تتبع الطلب', style: GoogleFonts.cairo()),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _reportIssue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('الإبلاغ عن مشكلة', style: GoogleFonts.cairo()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('تأخير في التوصيل', style: GoogleFonts.cairo()),
              onTap: () => _submitIssue('تأخير في التوصيل'),
            ),
            ListTile(
              title: Text('مشكلة مع السائق', style: GoogleFonts.cairo()),
              onTap: () => _submitIssue('مشكلة مع السائق'),
            ),
            ListTile(
              title: Text('طلب خاطئ', style: GoogleFonts.cairo()),
              onTap: () => _submitIssue('طلب خاطئ'),
            ),
            ListTile(
              title: Text('أخرى', style: GoogleFonts.cairo()),
              onTap: () => _submitIssue('أخرى'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitIssue(String issueType) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم الإبلاغ عن المشكلة. سنتواصل معك قريباً',
            style: GoogleFonts.cairo()),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

class OrderStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final String time;
  bool isCompleted;
  bool isActive;

  OrderStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
    this.isCompleted = false,
    this.isActive = false,
  });
}
